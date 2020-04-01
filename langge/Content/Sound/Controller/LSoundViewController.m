//
//  LSoundViewController.m
//  langge
//
//  Created by samlee on 2019/3/22.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LSoundViewController.h"
#import "LSoundCell.h"
#import "RadarChart.h"
#import "LCheckPointViewController.h"
#import "IntroduceView.h"
#import "LHomeCell.h"
#import "LGameViewController.h"
#import "MJRefresh.h"
#import "LLevelStudyViewController.h"
#import "LStartPageView.h"
#import "AppDelegate.h"
#import "LPrivacyPolicyView.h"
#import "WPAlertControl.h"
#import "LClauseViewController.h"

@interface LSoundViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,IntroduceViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *roundView3;
@property (weak, nonatomic) IBOutlet UIView *roundView2;
@property (weak, nonatomic) IBOutlet UIView *roundView1;
@property (weak, nonatomic) IBOutlet UILabel *knowledgeLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@property (weak, nonatomic) IBOutlet UIView *radarView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *centerCollectionView;

@property (nonatomic, strong) RadarDataSet * radarDataSet;
@property(nonatomic,strong)RadarChart * radarChart;
@property(nonatomic,strong)RadarData * radarData;
- (IBAction)startStudyBtnClick:(UIButton *)sender;


@property(nonatomic,strong)NSDictionary *data;
@property(nonatomic,strong)NSDictionary *situation;
@property(nonatomic,strong)NSArray *playsubject;
@property(nonatomic,strong)NSArray *game;

@property(nonatomic,strong)LStartPageView *startPageView; //开屏页
@property(nonatomic,strong)LPrivacyPolicyView *privacyView;//隐私政策

@end

@implementation LSoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shouldNavigationBarHidden = YES;
    [self showStartPage];
    if ([SingleTon getInstance].authTocken) {
        NSString *user_tocken = [[SingleTon getInstance] getUser_tocken];
        if (user_tocken&&user_tocken.length>0) {
            [SingleTon getInstance].isLogin = YES;
            [self getUserInfo];
        }else{
            [self loadData];
        }
        [self loadStartPage];
    }else{
        [self auth];
    }
    [self setUI];
        
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatusChange) name:@"loginStatusChange" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"updataFiftytonesIndex" object:nil];
    
    
    
}

-(void)loadStartPage{
    [SVProgressHUD show];
    [[APIManager getInstance] getStartPageWithCallback:^(BOOL success, id  _Nonnull data) {
        [SVProgressHUD dismiss];
        if (success) {
            self.startPageView.data = data;
        }else{
            //哈哈哈哈哈
            [self.startPageView removeFromSuperview];
            [self showPrivacyPolicy];
        }
    }];
}

-(void)getUserInfo{
    [SVProgressHUD showWithStatus:@""];
    [[APIManager getInstance] getUserInfoWithCallback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            [SVProgressHUD dismiss];
            [self loadData];
        }else{
            [SVProgressHUD showErrorWithStatus:result];
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            [self.navigationController presentViewController:sb.instantiateInitialViewController animated:NO completion:nil];
        }
    }];
}


-(void)showPrivacyPolicy{
    NSString *isShowPrivacyPolicy = [[NSUserDefaults standardUserDefaults] valueForKey:@"isShowPrivacyPolicy"];
    if (isShowPrivacyPolicy&&isShowPrivacyPolicy.length>0) {
        return;
    }
    [[APIManager getInstance] addIDFA];
    self.privacyView = [[NSBundle mainBundle] loadNibNamed:@"LPrivacyPolicyView" owner:nil options:nil].firstObject;
    self.privacyView.frame = [UIScreen mainScreen].bounds;
    __weak typeof(self)weakSelf = self;
    self.privacyView.readBlock = ^(NSInteger type) {
        [weakSelf openClauseWithType:[NSString stringWithFormat:@"%lu",type]];
        weakSelf.privacyView.hidden = YES;
    };
    self.privacyView.closeBlock = ^{
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"isShowPrivacyPolicy"];
        [weakSelf.privacyView removeFromSuperview];
    };
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:self.privacyView];

}
-(void)showStartPage{
    self.startPageView = [[NSBundle mainBundle] loadNibNamed:@"LStartPageView" owner:nil options:nil].firstObject;
    __weak typeof(self)weakSelf = self;
    self.startPageView.jumpBlock = ^(NSString * _Nonnull urlStr) {
        NSLog(@"%@",[NSThread currentThread]);
        LClauseViewController *vc = [[LClauseViewController alloc] init];
        vc.isFromStartPage  = YES;
        vc.urlStr = urlStr;
        vc.closeBlock = ^{
            [weakSelf showPrivacyPolicy];
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
        [weakSelf.startPageView removeFromSuperview];
    };
    self.startPageView.closeBlock = ^{
        [weakSelf.startPageView removeFromSuperview];
        [weakSelf showPrivacyPolicy];
    };
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:self.startPageView];
    [self.startPageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(delegate.window);
        make.top.equalTo(delegate.window);
        make.right.equalTo(delegate.window);
        make.bottom.equalTo(delegate.window);
    }];
    
}

//打开
-(void)openClauseWithType:(NSString *)type{
    [SVProgressHUD showWithStatus:@"加载中"];
    [[APIManager getInstance] get_clauseWithType:type callback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            [SVProgressHUD dismiss];
            LClauseViewController *vc = [[LClauseViewController alloc] init];
            vc.htmlStr = result;
            vc.isFromStartPage = YES;
            if ([type isEqualToString:@"1"]) {
                vc.title = @"日语助手用户协议";
            }else{
                vc.title = @"日语助手隐私条款";
            }
            __weak typeof(self)weakSelf = self;
            vc.closeBlock = ^{
                weakSelf.privacyView.hidden = NO;
            };
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:result];
        }
    }];
}



-(void)loginStatusChange{
    [self loadData];
}

-(void)auth{
    [SVProgressHUD showWithStatus:@"加载中"];
    __weak typeof(self)weakSelf = self;
    [[APIManager getInstance] getAuthWith:^(BOOL success, id  _Nonnull resule) {
        if (success) {
            NSString *user_tocken = [[SingleTon getInstance] getUser_tocken];
            if (user_tocken&&user_tocken.length>0) {
                [SingleTon getInstance].isLogin = YES;
                [weakSelf getUserInfo];
                [weakSelf loadStartPage];
            }else{
                [weakSelf loadData];
            }
            [weakSelf loadStartPage];
        }else{
            [SVProgressHUD showErrorWithStatus:resule];
        }
    }];
}

-(void)loadData{
    NSLog(@"-----%@",API_FiftytonesIndex);
    __weak typeof(self)weakSelf = self;
    [[APIManager getInstance] fiftytonesIndexWithCallback:^(BOOL success, id  _Nonnull result) {
        [self.scrollView.mj_header endRefreshing];
        if (success) {
            weakSelf.data = result;
            weakSelf.situation = result[@"situation"];
            weakSelf.playsubject  = result[@"playsubject"];
            weakSelf.game = result[@"game"];
            [weakSelf updataUI];
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD showErrorWithStatus:result];
        }
    }];
}

-(void)updataUI{
    NSNumber * number1 = @([self.situation[@"qingyin"] intValue]);
    NSNumber * number2 = @([self.situation[@"zhuoyin"] intValue]);
    NSNumber * number3 = @([self.situation[@"niuyin"] intValue]);
    NSNumber * number4 = @([self.situation[@"changyin"] intValue]);
    NSNumber * number5 = @([self.situation[@"cuyin"] intValue]);
    self.radarData.datas = @[number1, number2, number3, number4, number5];
    [self.radarChart removeFromSuperview];
    self.radarChart = [[RadarChart alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 200)];
    self.radarChart.radarData = _radarDataSet;
    [self.radarChart drawRadarChart];
    [self.radarView addSubview:self.radarChart];

    self.knowledgeLabel.text = self.data[@"knowledge"];
    [self.centerCollectionView reloadData];
    
    [self.collectionView reloadData];
}

-(void)setUI{
    
    self.topConstraint.constant = StatusHeight*-1;
    
    self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = barItem;
    barItem.title = @"";
    
    self.shouldNavigationBarHidden = YES;
    self.widthConstraint.constant = ScreenWidth;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"LSoundCell" bundle:nil] forCellWithReuseIdentifier:@"LSoundCell"];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat imageRealWidth = (ScreenWidth-20)/2-20;
    CGFloat imageRealHeight = imageRealWidth*131/165;
    layout.itemSize  = CGSizeMake((ScreenWidth-20)/2, imageRealHeight+10);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView.collectionViewLayout = layout;
    [self.roundView1 modifyWithcornerRadius:15 borderColor:nil borderWidth:0];
    [self.roundView2 modifyWithcornerRadius:15 borderColor:nil borderWidth:0];
    [self.roundView3 modifyWithcornerRadius:15 borderColor:nil borderWidth:0];
    
    self.centerCollectionView.delegate = self;
    self.centerCollectionView.dataSource = self;
    [self.centerCollectionView registerNib:[UINib nibWithNibName:@"LHomeCell" bundle:nil] forCellWithReuseIdentifier:@"LHomeCell"];
    UICollectionViewFlowLayout *layout2 = [[UICollectionViewFlowLayout alloc] init];
    layout2.itemSize = CGSizeMake(ScreenWidth-30, 158);
    layout2.minimumLineSpacing = 0;
    layout2.minimumInteritemSpacing = 0;
    layout2.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.centerCollectionView.collectionViewLayout = layout2;
    self.centerCollectionView.pagingEnabled = YES;
    
    
    self.radarDataSet = [[RadarDataSet alloc] init];
    self.radarDataSet.indicatorSet = @[RardarIndicatorMake(@"清音", 10), RardarIndicatorMake(@"濁音", 10),
                                   RardarIndicatorMake(@"拗音", 10), RardarIndicatorMake(@"长音", 10),
                                   RardarIndicatorMake(@"促音", 10)];
    NSNumber * number1 = @(0);
    NSNumber * number2 = @(0);
    NSNumber * number3 = @(0);
    NSNumber * number4 = @(0);
    NSNumber * number5 = @(0);
    self.radarData = [[RadarData alloc] init];
    self.radarData.datas = @[number1, number2, number3, number4, number5];
    self.radarData.strockColor = [[UIColor whiteColor] colorWithAlphaComponent:.5f];
    self.radarData.lineWidth = .5f;
    self.radarData.shapeRadius = 1.5f;
    self.radarData.shapeLineWidth = .5f;
    self.radarData.fillColor = [UIColor colorWithRed:255/255.0 green:239/255.0 blue:130/255.0 alpha:1];
    self.radarData.shapeFillColor = [UIColor whiteColor];
    _radarDataSet.titleFont = [UIFont systemFontOfSize:17];
    _radarDataSet.strockColor = [UIColor whiteColor];
    _radarDataSet.stringColor = [UIColor whiteColor];
    _radarDataSet.lineWidth = .5f;
    _radarDataSet.radius = 70;
    _radarDataSet.borderWidth = 1.0f;
    _radarDataSet.splitCount = 5;
    _radarDataSet.isCirlre = NO;
    _radarDataSet.radarSet = @[self.radarData];
    self.radarChart = [[RadarChart alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 200)];
    self.radarChart.radarData = _radarDataSet;
    [self.radarChart drawRadarChart];
    [self.radarView addSubview:self.radarChart];
    
}

#pragma mark -- UITableViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == self.collectionView) {
        return self.game.count;
    }else{
        return 5;
    }
}

- (UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (collectionView == self.collectionView) {
        LSoundCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LSoundCell" forIndexPath:indexPath];
        cell.game = self.game[indexPath.row];
        return cell;
    }else{
        LHomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LHomeCell" forIndexPath:indexPath];
        if (self.playsubject&&self.playsubject.count>0) {
            cell.playsubject = self.playsubject[indexPath.row];
        }else{
            cell.playsubject = nil;
            cell.index = indexPath.row;
        }
        
        return cell;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == self.collectionView) {
        if ([SingleTon getInstance].isLogin) {
            NSDictionary *game = self.game[indexPath.row];
            LGameViewController *vc = [LGameViewController new];
            if ([game[@"link"] rangeOfString:@"?class"].location != NSNotFound) {
                vc.urlStr = [NSString stringWithFormat:@"%@&user_token=%@",game[@"link"],[[SingleTon getInstance] getUser_tocken]];
            }else{
                vc.urlStr = [NSString stringWithFormat:@"%@?user_token=%@",game[@"link"],[[SingleTon getInstance] getUser_tocken]];
            }
            
            vc.shouldNavigationBarHidden = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            [self.navigationController presentViewController:sb.instantiateInitialViewController animated:YES completion:nil];
        }
    }
}


- (IBAction)startStudyBtnClick:(UIButton *)sender {
    NSString *isFirstStudy = [[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstStudy"];
    if (isFirstStudy&&isFirstStudy.length>0) {
        LGameViewController *vc = [LGameViewController new];
        if ([SingleTon getInstance].isLogin) {
            vc.urlStr = [NSString stringWithFormat:@"%@Fiftytones/fiftytonesList?class=1&user_token=%@",API_Root,[[SingleTon getInstance] getUser_tocken]];
        }else{
            vc.urlStr = [NSString stringWithFormat:@"%@Fiftytones/fiftytonesList?class=1",API_Root];
        }
        vc.shouldNavigationBarHidden = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    
    IntroduceView *introduce = [[IntroduceView alloc] init];
    introduce.delegate = self;
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:introduce];
    [introduce mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(window);
        make.top.equalTo(window);
        make.right.equalTo(window);
        make.bottom.equalTo(window);
    }];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isFirstStudy"];
}


#pragma mark -- IntroduceViewDelegate
-(void)startStudy{
    LGameViewController *vc = [LGameViewController new];
    vc.urlStr = [NSString stringWithFormat:@"%@Fiftytones/fiftytonesList?class=1",API_Root];
    vc.shouldNavigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}
@end
