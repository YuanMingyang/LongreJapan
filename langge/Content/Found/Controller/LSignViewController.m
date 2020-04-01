//
//  LSignViewController.m
//  langge
//
//  Created by samlee on 2019/4/23.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LSignViewController.h"
#import "LSignModel.h"
#import "NSDate+GFCalendar.h"
#import "LSignCell.h"
#import "LSignAlertView.h"
#import "WPAlertControl.h"
#import "LLucyViewController.h"

@interface LSignViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
- (IBAction)backBtnClick:(UIButton *)sender;
- (IBAction)giftBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *giftModifyView;

@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeLabel;
@property (weak, nonatomic) IBOutlet UIButton *signBtn;
- (IBAction)signBtnClick:(UIButton *)sender;
- (IBAction)lastMonBtnClick:(UIButton *)sender;
- (IBAction)nextMonBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *currentDateLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property(nonatomic,strong)NSDictionary *signData;//当月签到状况
@property(nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation LSignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    [self loadData];
}
-(void)loadData{
    [SVProgressHUD showWithStatus:@"加载中"];
    [[APIManager getInstance] getSignListWith:self.currentDateLabel.text callback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            [SVProgressHUD dismiss];
            [self getDateArrayWith:result];
        }else{
            [SVProgressHUD showErrorWithStatus:result];
        }
    }];
}

-(void)getDateArrayWith:(NSDictionary *)data{
    
    //UI相关
    if ([data[@"today_is_sign"] boolValue]) {
        self.signBtn.backgroundColor  =[UIColor whiteColor];
        self.signBtn.selected = YES;
    }else{
        self.signBtn.backgroundColor  =RGB(255, 184, 73);
        self.signBtn.selected = NO;
    }
    if ([data[@"prize_soon_expire"] boolValue]) {
        self.giftModifyView.hidden = NO;
    }else{
        self.giftModifyView.hidden = YES;
    }
    NSInteger sign_total = [data[@"sign_total"] integerValue];
    self.twoLabel.text = [NSString stringWithFormat:@"%lu",sign_total/10];
    self.threeLabel.text = [NSString stringWithFormat:@"%lu",sign_total%10];
    //日历相关
    [self.dataSource removeAllObjects];
    NSArray *sign_list = data[@"sign_list"];
    for (int i = 0; i<sign_list.count; i++) {
        NSDictionary *dic = sign_list[i];
        LSignModel *sign = [LSignModel new];
        sign.date = dic[@"date"];
        sign.is_sign = [dic[@"is_sign"] boolValue];
        sign.recite_num = [NSString stringWithFormat:@"%@",dic[@"recite_num"]];
        sign.is_continuity = [dic[@"is_continuity"] boolValue];
        if (i==0) {
            sign.isHavaLast = NO;
        }else{
            NSDictionary *lastDic = sign_list[i-1];
            if ([lastDic[@"is_sign"] boolValue]) {
                sign.isHavaLast = YES;
            }else{
                sign.isHavaLast = NO;
            }
        }
        
        if (i==sign_list.count-1) {
            sign.isHaveNext = NO;
        }else{
            NSDictionary *nextDic = sign_list[i+1];
            if ([nextDic[@"is_sign"] boolValue]) {
                sign.isHaveNext = YES;
            }else{
                sign.isHaveNext = NO;
            }
        }
        [self.dataSource addObject:sign];
        [self.collectionView reloadData];
    }
    
    NSInteger week = [[XSTools getDateWithDateString:self.currentDateLabel.text] firstWeekDayInMonth];
    for (int i = 0; i<week; i++) {
        LSignModel *model = [LSignModel new];
        model.isFill = YES;
        [self.dataSource insertObject:model atIndex:0];
    }
}

-(void)setUI{
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = barItem;
    barItem.title = @"";
    [self.twoLabel modifyWithcornerRadius:5 borderColor:nil borderWidth:0];
    [self.threeLabel modifyWithcornerRadius:5 borderColor:nil borderWidth:0];
    [self.signBtn modifyWithcornerRadius:15 borderColor:nil borderWidth:0];
    self.dataSource = [NSMutableArray array];
    self.currentDateLabel.text = [[XSTools getCurrentDateStr] substringToIndex:7];
    self.topConstraint.constant = NaviHeight+StatusHeight;
    self.widthConstraint.constant = ScreenWidth;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((ScreenWidth-30)/7, 40);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.delegate= self;
    self.collectionView.dataSource = self;
}

#pragma mark -- UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LSignCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LSignCell" forIndexPath:indexPath];
    cell.sign = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark -- Action

- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)giftBtnClick:(UIButton *)sender {
    LLucyViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LLucyViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)signBtnClick:(UIButton *)sender {
    if (self.signBtn.selected) {
        return;
    }
    LSignAlertView *alert = [[NSBundle mainBundle] loadNibNamed:@"LSignAlertView" owner:nil options:nil].firstObject;
    alert.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    __weak typeof(self)weakSelf = self;
    alert.actionClick = ^(int type) {
        if (type == 1) {
            weakSelf.currentDateLabel.text = [[XSTools getCurrentDateStr] substringToIndex:7];
            [weakSelf loadData];
        }else if (type == 2){
            
        }else if (type == 3){
            LLucyViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LLucyViewController"];
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        }
    };
    [[UIApplication sharedApplication].delegate.window addSubview:alert];
    
}

- (IBAction)lastMonBtnClick:(UIButton *)sender {
    NSDate *currentDate = [XSTools getDateWithDateString:self.currentDateLabel.text];
    NSDate *lastDate = [currentDate previousMonthDate];
    self.currentDateLabel.text = [XSTools getDateStringWith:lastDate];
    [self loadData];
}

- (IBAction)nextMonBtnClick:(UIButton *)sender {
    NSDate *currentDate = [XSTools getDateWithDateString:self.currentDateLabel.text];
    NSDate *lastDate = [currentDate nextMonthDate];
    self.currentDateLabel.text = [XSTools getDateStringWith:lastDate];
    [self loadData];
}
@end
