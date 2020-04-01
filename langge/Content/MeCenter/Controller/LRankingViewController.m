//
//  LRankingViewController.m
//  langge
//
//  Created by samlee on 2019/4/18.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LRankingViewController.h"
#import "LRankingHeaderView.h"
#import "LRankingTableCell.h"
#import "LSelectCityViewController.h"
#import "LRankingModel.h"


@interface LRankingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *bjView;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
- (IBAction)leftBtnClick:(id)sender;
- (IBAction)rightBtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *selectView;
- (IBAction)backBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)UILabel *lineLabel;
@property(nonatomic,assign)int type;
@property(nonatomic,strong)LRankingHeaderView *headerView;

@property(nonatomic,strong)LRankingModel *myRanking;
@property(nonatomic,strong)NSMutableArray *allRanking;
@end

@implementation LRankingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self loadData];
}
-(void)setUI{
    [self.bjView.layer addSublayer:[XSTools getColorLayerWithStartColor:RGB(255, 182, 171) endColor:RGB(251, 124, 118) frame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)]];
    
    self.topViewHeightConstraint.constant = NaviHeight+StatusHeight;
    self.leftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    self.type = 1;
    self.lineLabel = [[UILabel alloc] init];
    self.lineLabel.backgroundColor = [UIColor whiteColor];
    [self.selectView addSubview:self.lineLabel];
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(2);
        make.bottom.equalTo(self.selectView);
        make.centerX.equalTo(self.leftBtn);
    }];
    self.headerView = [[NSBundle mainBundle] loadNibNamed:@"LRankingHeaderView" owner:nil options:nil].firstObject;
    
    UIView * header = [[UIView alloc]init];
    header.backgroundColor = [UIColor clearColor];
    header.frame = CGRectMake(0, 0, ScreenWidth-30, 293);
    self.headerView.frame = CGRectMake(0, 0, ScreenWidth-30, 293);
    [header addSubview:self.headerView];
    self.tableView.tableHeaderView = header;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundView.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
}

-(void)loadData{
    if (self.type == 1) {
        [self loadDataWithCity:nil];
    }else{
        if ([SingleTon getInstance].user.city&&[SingleTon getInstance].user.city.length>0) {
            [self loadDataWithCity:[SingleTon getInstance].user.city];
        }else{
            LSelectCityViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LSelectCityViewController"];
            __weak typeof(self)weakSelf = self;
            vc.resultBlock = ^(NSString * _Nonnull cityName) {
                [weakSelf loadDataWithCity:cityName];
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                dic[@"user_token"] = [[SingleTon getInstance] getUser_tocken];
                dic[@"city"] = cityName;
                [[APIManager getInstance] saveUserInfoWithParam:dic callback:^(BOOL success, id  _Nonnull result) {
                    
                }];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
-(void)loadDataWithCity:(NSString *)city{
    [SVProgressHUD showWithStatus:@"加载中"];
    [[APIManager getInstance] rankingListWithCity:city callback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            self.myRanking = result[@"my"];
            self.allRanking = result[@"all"];
            [self updataUI];
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD showErrorWithStatus:result];
        }
    }];
}

-(void)updataUI{
    if (self.allRanking.count>0) {
        self.headerView.firstRanking = self.allRanking.firstObject;
        [self.allRanking removeObjectAtIndex:0];
    }
    if (self.allRanking.count>0) {
        self.headerView.secondRanking = self.allRanking.firstObject;
        [self.allRanking removeObjectAtIndex:0];
    }else{
        self.headerView.secondRanking = nil;
    }
    if (self.allRanking.count>0) {
        self.headerView.thirdRanking = self.allRanking.firstObject;
        [self.allRanking removeObjectAtIndex:0];
    }else{
        self.headerView.thirdRanking = nil;
    }
    if (self.myRanking) {
        [self.allRanking insertObject:self.myRanking atIndex:0];
    }
    [self.tableView reloadData];
}
#pragma mark -- UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allRanking.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LRankingTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LRankingTableCell"];
    cell.ranking = self.allRanking[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark -- action

- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)leftBtnClick:(id)sender {
    if (self.type == 1) {
        return;
    }
    self.type = 1;
    [self.lineLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
    }];
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(2);
        make.bottom.equalTo(self.selectView);
        make.centerX.equalTo(self.leftBtn);
    }];
    self.leftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self loadData];
}

- (IBAction)rightBtnClick:(id)sender {
    if (![SingleTon getInstance].isLogin) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        [self.navigationController presentViewController:sb.instantiateInitialViewController animated:YES completion:nil];
        return;
    }
    
    if (self.type == 2) {
        return;
    }
    self.type = 2;
    [self.lineLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
    }];
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(2);
        make.bottom.equalTo(self.selectView);
        make.centerX.equalTo(self.rightBtn);
    }];
    self.rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    self.leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self loadData];
}
@end
