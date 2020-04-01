//
//  LFoundViewController.m
//  langge
//
//  Created by samlee on 2019/4/12.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LFoundViewController.h"
#import "LWordHeaderView.h"
#import "LListCell.h"
#import "LPageViewController.h"
#import "LNewDetailViewController.h"
#import "LSearchViewController.h"
#import "WPAlertControl.h"
#import "LEveryDayAlertView.h"
#import "LCourseListViewController.h"
#import "LPageController.h"
#import "WXApiRequestHandler.h"
#import "wxApiManager.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import "LSignViewController.h"
#import "LCourseDetailViewController.h"
#import "ZWAMRPlayer.h"
#import "ZWMP3Player.h"
#import "ZWTalkingRecordView.h"
#import "AudioManager.h"
#import "LCourseDetailController.h"
#import "LClauseViewController.h"
#import "LGameViewController.h"
#import "LCommonTableHeaderView.h"

@interface LFoundViewController ()<UITableViewDelegate,UITableViewDataSource,LWordHeaderViewDelegate,ZWTalkingRecordViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)LWordHeaderView *headerView;
@property(nonatomic,strong)UIView *topView;

@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)NSDictionary *fxData;
@property(nonatomic,assign)int page;

/** 录制音频相关 */
@property (weak,   nonatomic) ZWTalkingRecordView *recordView;
@property (strong, nonatomic) ZWMP3Player * audioMP3Player;
@property(nonatomic,strong)NSString *audioPath;
@end

@implementation LFoundViewController
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    self.topView.hidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    self.topView.hidden = YES;
    [[AudioManager shareManager] pause];
    if (self.audioMP3Player) {
        [self.audioMP3Player stopPlaying];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];

}
-(void)setUI{
    self.dataSource = [NSMutableArray array];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = barItem;
    barItem.title = @"";
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth-30, 30)];
    [self.topView modifyWithcornerRadius:15 borderColor:nil borderWidth:0];
    self.topView.backgroundColor = RGB(246, 246, 246);
    UIImageView *searchImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_gray"]];
    [self.topView addSubview:searchImage];
    [searchImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView).offset(10);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
        make.centerY.equalTo(self.topView);
    }];
    UIButton *searchBtn = [[UIButton alloc] init];
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:searchBtn];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView);
        make.top.equalTo(self.topView);
        make.right.equalTo(self.topView);
        make.bottom.equalTo(self.topView);
    }];
    
    [self.navigationController.navigationBar addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ScreenWidth-40);
        make.height.mas_equalTo(30);
        make.centerX.equalTo(self.navigationController.navigationBar);
        make.centerY.equalTo(self.navigationController.navigationBar);
    }];
    
    self.headerView = [[NSBundle mainBundle] loadNibNamed:@"LWordHeaderView" owner:nil options:nil].firstObject;
    self.headerView.delegate= self;
    
    UIView * header = [[UIView alloc]init];
    header.backgroundColor = [UIColor whiteColor];
    header.frame = CGRectMake(0, 0, ScreenWidth, 660);
    self.headerView.frame = CGRectMake(0, 0, ScreenWidth, 660);
    [header addSubview:self.headerView];
    self.tableView.tableHeaderView = header;
    [self.tableView registerNib:[UINib nibWithNibName:@"LListCell" bundle:nil] forCellReuseIdentifier:@"LListCell"];
    [self.tableView  registerNib:[UINib nibWithNibName:@"LCommonTableHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"LCommonTableHeaderView"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundView.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    
    ZWTalkingRecordView * recordView = [[ZWTalkingRecordView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 160) / 2, 100, 160, 160) delegate:self WithAudio:ZWAudioMP3];
    [self.view addSubview:recordView];
    self.recordView = recordView;
}
-(void)loadNewData{
    self.page = 1;
    [self loadData];
}
-(void)loadMoreData{
    self.page++;
    [self loadData];
}
-(void)loadData{
    __weak typeof(self)weakSelf = self;
    [[APIManager getInstance] getfxDataWithPage:[NSString stringWithFormat:@"%d",self.page] callback:^(BOOL success, id  _Nonnull result) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (!success) {
            [SVProgressHUD showErrorWithStatus:result];
            return ;
        }
        if (self.page==1) {
            weakSelf.headerView.dataDic = result;
            weakSelf.fxData = result;
            [self.dataSource removeAllObjects];
        }else{
            NSArray *newsData = result[@"newsData"];
            if (newsData.count<10) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        [self.dataSource addObjectsFromArray:result[@"newsData"]];
        [self.tableView reloadData];
    }];
}
#pragma mark -- UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 127;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LListCell"];
    cell.news = self.dataSource[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    LCommonTableHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LCommonTableHeaderView"];
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LNewsModel *news = self.dataSource[indexPath.row];
    [SVProgressHUD showWithStatus:@"加载中"];
    __weak typeof(self)weakSelf = self;
    [[APIManager getInstance] getNewsInfoWith:news._id callback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            [SVProgressHUD dismiss];
            
            LNewDetailViewController *vc = [[LNewDetailViewController alloc] init];
            vc.news = result;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:result];
        }
    }];
    
}

#pragma mark -- LWordHeaderViewDelegate
-(void)btnClickWithType:(int)type{
    if (type == 1) {
        if (![SingleTon getInstance].isLogin) {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            [self.navigationController presentViewController:sb.instantiateInitialViewController animated:YES completion:nil];
            return;
        }
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Found" bundle:nil];
        LSignViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LSignViewController"];
        vc.shouldNavigationBarHidden = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (type == 2){
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Found" bundle:nil];
        LCourseListViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LCourseListViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (type == 3){
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Found" bundle:nil];
        LPageController *vc = [sb instantiateViewControllerWithIdentifier:@"LPageController"];
        vc.shouldNavigationBarHidden = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (type == 4){
        LEveryDayAlertView *alert = [[NSBundle mainBundle] loadNibNamed:@"LEveryDayAlertView" owner:nil options:nil].firstObject;
        alert.frame = [UIScreen mainScreen].bounds;
        NSArray *daily_sentence_list = self.fxData[@"daily_sentence_list"];
        alert.daily = daily_sentence_list.firstObject;
        __weak typeof(self)weakSelf = self;
        __weak typeof(alert)weakAlert = alert;
        alert.selectClickBlock = ^(NSInteger type) {
            UIImage *viewImage = [XSTools screenShotView:weakAlert.bjImageView];
            if (type == 1) {
               [WXApiRequestHandler sendImageData:UIImagePNGRepresentation(viewImage) TagName:nil MessageExt:nil Action:nil ThumbImage:nil InScene:WXSceneSession];
                [SingleTon getInstance].isShare = YES;
                
            }else if (type == 2){
                [WXApiRequestHandler sendImageData:UIImagePNGRepresentation(viewImage) TagName:nil MessageExt:nil Action:nil ThumbImage:nil InScene:WXSceneTimeline];
                [SingleTon getInstance].isShare = YES;

            }else if (type == 3){
                QQApiImageObject *obj = [QQApiImageObject objectWithData:UIImagePNGRepresentation(viewImage) previewImageData:UIImagePNGRepresentation(viewImage) title:@"" description:@""];
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:obj];
                QQApiSendResultCode sent = [QQApiInterface sendReq:req];
                [SingleTon getInstance].isShare = YES;

            }else if (type == 4){
                QQApiImageObject *obj = [QQApiImageObject objectWithData:UIImagePNGRepresentation(viewImage) previewImageData:UIImagePNGRepresentation(viewImage) title:@"" description:@""];
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:obj];
                QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
                [SingleTon getInstance].isShare = YES;
            }else if (type == 5){
                WBImageObject *imageOBJ = [WBImageObject object];
                imageOBJ.imageData = UIImagePNGRepresentation(viewImage);
                WBMessageObject *message = [WBMessageObject message];
                message.imageObject = imageOBJ;
                WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
                authRequest.redirectURI = kRedirectURI;
                authRequest.scope = @"all";
                WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:nil];
                [WeiboSDK sendRequest:request];
            }
            
            [WPAlertControl alertHiddenForRootControl:weakSelf completion:nil];
        };
        [WPAlertControl alertForView:alert begin:WPAlertBeginCenter end:WPAlertEndCenter animateType:WPAlertAnimateBounce constant:0 animageBeginInterval:0.3 animageEndInterval:0.3 maskColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] pan:YES rootControl:self mackClick:nil animateStatus:nil];
    }else if (type == 5){
        if (![SingleTon getInstance].isLogin) {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            [self.navigationController presentViewController:sb.instantiateInitialViewController animated:YES completion:nil];
            return;
        }
        [SVProgressHUD showWithStatus:@""];
        [[APIManager getInstance] receiveActionWithCid:nil title:nil type:@"2" callback:^(BOOL success, id  _Nonnull data) {
            if (success) {
                [SVProgressHUD dismiss];
                LClauseViewController *vc = [LClauseViewController new];
                vc.urlStr = [NSString stringWithFormat:@"%@?user_token=%@",self.fxData[@"stripData"][@"stripImgLink"],[[SingleTon getInstance] getUser_tocken]];
                vc.title = @"日语水平自测";
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:data];
            }
        }];
        
    }
}
-(void)bannerClickWith:(LBannerModel *)bannner{
    LNewDetailViewController *vc = [[LNewDetailViewController alloc] init];
    vc.banner = bannner;
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)playWordAudioClick{
    if (self.audioMP3Player) {
        [self.audioMP3Player stopPlaying];
    }
}
-(void)courseClickWith:(LCourseModel *)course{
    [SVProgressHUD showWithStatus:@"加载中"];
    __weak typeof(self)wealSelf = self;
    [[APIManager getInstance] getCourseInfoWithcourseId:course._id class_hour_page:nil comment_page:nil callback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            [SVProgressHUD dismiss];
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Found" bundle:nil];
            LCourseDetailController *vc = [sb instantiateViewControllerWithIdentifier:@"LCourseDetailController"];
            
            vc.course_id = course._id;
            vc.course = course;
            vc.courseDetail = result;
            [wealSelf.navigationController pushViewController:vc animated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:result];
        }
    }];
}

-(void)createVideoBtnStatusChangeWithType:(int)type{
    if (type==1) {
        [self actionBarZWTalkStateChanged:ZWTalkStateTalking];
    }else if (type == 2){
        [self actionBarZWTalkStateChanged:ZWTalkStateTalking];
    }else if (type == 3){
        [self actionBarZWTalkStateChanged:ZWTalkStateCanceling];
    }else if (type == 4){
        [self actionBarTalkFinished];
    }else if (type == 5){
        [self actionBarZWTalkStateChanged:ZWTalkStateNone];
    }
}

-(void)playMyVideoClick{
    self.audioMP3Player = [[ZWMP3Player alloc] initWithDelegate:self];
    [self.audioMP3Player  playAtPath:self.audioPath];
}


- (void)actionBarZWTalkStateChanged:(ZWTalkState)sts {
    if (sts == ZWTalkStateTalking) {
        self.recordView.hidden = NO;
    } else if (sts == ZWTalkStateCanceling) {
        self.recordView.hidden = NO;
    } else {
        self.recordView.hidden = YES;
        [_recordView recordCancel];
    }
    self.recordView.state = sts;
}

- (void)actionBarTalkFinished {
    self.recordView.hidden = YES;
    [self.recordView recordEnd];
}


#pragma mark - TalkingRecordViewDelegate
- (void)recordView:(ZWTalkingRecordView *)sender didFinish:(NSString*)path duration:(NSTimeInterval)du WithAudio:(ZWAudio)Audio{
    _recordView.hidden = YES;
    self.audioPath = path;
}

#pragma mark -- action
-(void)searchBtnClick{
    NSLog(@"searchBtnClick");
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Found" bundle:nil];
    LSearchViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LSearchViewController"];
    vc.shouldNavigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
