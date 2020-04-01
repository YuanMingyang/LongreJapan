//
//  LMeCenterViewController.m
//  langge
//
//  Created by samlee on 2019/4/2.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LMeCenterViewController.h"
#import "LStudyToolCell.h"
#import "LUserInfoViewController.h"
#import "LCollectionListController.h"
#import "LListAlertView.h"
#import "WPAlertControl.h"
#import "LSystemMegListController.h"
#import "LSetViewController.h"
#import "LRankingViewController.h"
#import "LErrorQuestionViewController.h"
#import "LAdviceViewController.h"
#import "LSearchWordViewController.h"
#import "LSetStudyTargetController.h"
#import "LConsultingViewController.h"

@interface LMeCenterViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@property (weak, nonatomic) IBOutlet UITableViewCell *cell1;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell2;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell3;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell4;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell5;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell6;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell7;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell8;




@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UIView *bjView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (IBAction)searchBtnClick:(id)sender;
- (IBAction)rankingBtnClick:(id)sender;
- (IBAction)reluctantBtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UILabel *feedBackNumLabel;


@property(nonatomic,strong)NSMutableArray *studyToolArray;

@end

@implementation LMeCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self loadStudyTool];
    self.tableView.backgroundView.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataUserInfo) name:@"updataUserInfo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataMobile) name:@"updataMobile" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatusChange) name:@"loginStatusChange" object:nil];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
}
-(void)loadData{
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
}
-(void)loginStatusChange{
    [self.tableView reloadData];
}

-(void)updataMobile{
    self.mobileLabel.text = [[SingleTon getInstance].user.user_mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
}
-(void)loadStudyTool{
    [[APIManager getInstance] getStudyToolWithCallback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            self.studyToolArray = result;
            [self.collectionView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:result];
        }
    }];
}
-(void)updataUserInfo{
    if ([SingleTon getInstance].user) {
        self.avatarImageView.image = [XSTools base64ToImageWith:[SingleTon getInstance].user.user_img_src];
        self.nicknameLabel.text = [SingleTon getInstance].user.nick_name;
        self.mobileLabel.text = [[SingleTon getInstance].user.user_mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        NSString *feedBackNum = [NSString stringWithFormat:@"%@",[SingleTon getInstance].user.feedback_number];
        if ([feedBackNum isEqualToString:@"0"]) {
            self.feedBackNumLabel.hidden = YES;
        }else{
            self.feedBackNumLabel.hidden = NO;
            self.feedBackNumLabel.text = feedBackNum;
        }
    }else{
        self.avatarImageView.image = [UIImage imageNamed:@"icon07"];
        self.nicknameLabel.text = @"未登录";
        self.mobileLabel.text = @"";
        self.feedBackNumLabel.hidden = YES;
    }
}

-(void)setUI{
    [self updataUserInfo];
    self.shouldNavigationBarHidden = YES;
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = barItem;
    barItem.title = @"";
    [self.bjView modifyWithcornerRadius:15 borderColor:nil borderWidth:0];
    self.topConstraint.constant = StatusHeight*-1;
    
    [self.avatarImageView modifyWithcornerRadius:35 borderColor:nil borderWidth:0];
    self.avatarImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarBtnClick)];
    [self.avatarImageView addGestureRecognizer:tap];
    
    [self.feedBackNumLabel modifyWithcornerRadius:7 borderColor:nil borderWidth:0];
    
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(ScreenWidth/4, 80);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.collectionViewLayout = layout;

    [self.colorView.layer addSublayer:[XSTools getColorLayerWithStartColor:RGB(251, 124, 118) endColor:RGB(255, 182, 171) frame:CGRectMake(0, 0, ScreenWidth, 265)]];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([SingleTon getInstance].isLogin) {
        return 8;
    }else{
        return 7;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([SingleTon getInstance].isLogin) {
        if (indexPath.row == 0) {
            return 50;
        }else if (indexPath.row == 1){
            return 50;
        }else if (indexPath.row == 2){
            return 50;
        }else if (indexPath.row == 3){
            return 50;
        }else if (indexPath.row == 4){
            return 50;
        }else if (indexPath.row == 5){
            return 50;
        }else if (indexPath.row == 6){
            return 50;
        }else{
            return 131;
        }
    }else{
        if (indexPath.row == 0) {
            return 50;
        }else if (indexPath.row == 1){
            return 50;
        }else if (indexPath.row == 2){
            return 50;
        }else if (indexPath.row == 3){
            return 50;
        }else if (indexPath.row == 4){
            return 50;
        }else if (indexPath.row == 5){
            return 50;
        }else{
            return 131;
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([SingleTon getInstance].isLogin) {
        if (indexPath.row == 0) {
            return self.cell1;
        }else if (indexPath.row == 1){
            return self.cell2;
        }else if (indexPath.row == 2){
            return self.cell3;
        }else if (indexPath.row == 3){
            return self.cell4;
        }else if (indexPath.row == 4){
            return self.cell5;
        }else if (indexPath.row == 5){
            return self.cell6;
        }else if (indexPath.row == 6){
            return self.cell7;
        }else{
            return self.cell8;
        }
    }else{
        if (indexPath.row == 0) {
            return self.cell1;
        }else if (indexPath.row == 1){
            return self.cell3;
        }else if (indexPath.row == 2){
            return self.cell4;
        }else if (indexPath.row == 3){
            return self.cell5;
        }else if (indexPath.row == 4){
            return self.cell6;
        }else if (indexPath.row == 5){
            return self.cell7;
        }else{
            return self.cell8;
        }
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([SingleTon getInstance].isLogin) {
        if (indexPath.row == 0) {
            //我的收藏
            [self clickCollection];
        }else if (indexPath.row == 1){
            //自动发音数
            [self clickPronunciation];
        }else if (indexPath.row == 2){
            //设置学习目标
            [self clickStudyTarget];
        }else if (indexPath.row == 3){
            //系统消息
            [self clickSystemMsg];
        }else if (indexPath.row == 4){
            //客服中心
            [self clickKefu];
        }else if (indexPath.row == 5){
            //我要吐槽
            [self clickAdvice];
        }else if (indexPath.row == 6){
            //设置中心
            [self clickSet];
        }else if (indexPath.row == 7){
            
        }
    }else{
        if (indexPath.row == 0) {
            //我的收藏
            [self clickCollection];
        }else if (indexPath.row == 1){
            //设置学习目标
            [self clickStudyTarget];
        }else if (indexPath.row == 2){
            //系统消息
            [self clickSystemMsg];
        }else if (indexPath.row == 3){
            //客服中心
            [self clickKefu];
        }else if (indexPath.row == 4){
            //我要吐槽
            [self clickAdvice];
        }else if (indexPath.row == 5){
            //设置中心
            [self clickSet];
        }else if (indexPath.row == 6){
            
        }else if (indexPath.row == 7){
            
        }
    }
}
-(void)clickKefu{
    LConsultingViewController *vc = [[LConsultingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)clickStudyTarget{
    if (![SingleTon getInstance].isLogin) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        [self.navigationController presentViewController:sb.instantiateInitialViewController animated:YES completion:nil];
        return;
    }
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Word" bundle:nil];
    LSetStudyTargetController *vc = [sb instantiateViewControllerWithIdentifier:@"LSetStudyTargetController"];
    vc.isFromMe = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)clickAdvice{
    
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    LAdviceViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LAdviceViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)clickCollection{
    if (![SingleTon getInstance].isLogin) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        [self.navigationController presentViewController:sb.instantiateInitialViewController animated:YES completion:nil];
        return;
    }
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    LCollectionListController *vc = [sb instantiateViewControllerWithIdentifier:@"LCollectionListController"];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)clickPronunciation{
    if (![SingleTon getInstance].isLogin) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        [self.navigationController presentViewController:sb.instantiateInitialViewController animated:YES completion:nil];
        return;
    }
    
    LListAlertView *alert = [[NSBundle mainBundle] loadNibNamed:@"LListAlertView" owner:nil options:nil].firstObject;
    CGFloat height = 0;
    if (KIsiPhoneX) {
        height = 34;
    }
    alert.frame = CGRectMake(0, 0, ScreenWidth, 200+height);
    __weak typeof(self)weakSelf = self;
    
    alert.clickBlock = ^(NSInteger index) {
        if (index==0) {
            [self updataAuto_play_frequencyWith:@"1"];
        }else if(index == 1){
            [self updataAuto_play_frequencyWith:@"2"];
        }else{
            [self updataAuto_play_frequencyWith:@"3"];
        }
        
        [WPAlertControl alertHiddenForRootControl:weakSelf completion:nil];
    };
    [alert configWith:@"请选择发音次数" items:@[@"一次",@"两次",@"三次"]];
    [WPAlertControl alertForView:alert begin:WPAlertBeginBottem end:WPAlertEndBottem animateType:WPAlertAnimateBounce constant:0 animageBeginInterval:0.3 animageEndInterval:0.3 maskColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] pan:YES rootControl:self mackClick:nil animateStatus:nil];
}

-(void)updataAuto_play_frequencyWith:(NSString *)auto_play_frequency{
    NSDictionary *dic = @{@"auto_play_frequency":auto_play_frequency,
                          @"user_token":[[SingleTon getInstance] getUser_tocken]
                          };
    [SVProgressHUD showWithStatus:@"提交中"];
    [[APIManager getInstance] saveUserInfoWithParam:dic.mutableCopy callback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
        }else{
            [SVProgressHUD showErrorWithStatus:result];
        }
    }];
}

-(void)clickSystemMsg{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    LSystemMegListController *VC = [sb instantiateViewControllerWithIdentifier:@"LSystemMegListController"];
    [self.navigationController pushViewController:VC animated:YES];
}
-(void)clickSet{
    
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    LSetViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LSetViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -- UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSLog(@"-----%lu",[SingleTon getInstance].user.tools_list.count);
    return self.studyToolArray.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LStudyToolCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LStudyToolCell" forIndexPath:indexPath];

    cell.studyTool = self.studyToolArray[indexPath.row];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    LStudyToolModel *studyTool = self.studyToolArray[indexPath.row];
    NSURL *url = [NSURL URLWithString:studyTool.link];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}


#pragma mark -- action

-(void)avatarBtnClick{
    if ([SingleTon getInstance].isLogin) {
        UIStoryboard *SB = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
        [self.navigationController pushViewController:SB.instantiateInitialViewController animated:YES];
    }else{
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        [self.navigationController presentViewController:sb.instantiateInitialViewController animated:YES completion:nil];
    }
}

- (IBAction)searchBtnClick:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    LSearchWordViewController * vc = [sb instantiateViewControllerWithIdentifier:@"LSearchWordViewController"];
    vc.shouldNavigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)rankingBtnClick:(id)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    LRankingViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LRankingViewController"];
    vc.shouldNavigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)reluctantBtnClick:(id)sender {
    if (![SingleTon getInstance].isLogin) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        [self.navigationController presentViewController:sb.instantiateInitialViewController animated:YES completion:nil];
        return;
    }
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    LErrorQuestionViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LErrorQuestionViewController"];
    vc.shouldNavigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)switchClick:(id)sender {
}
@end
