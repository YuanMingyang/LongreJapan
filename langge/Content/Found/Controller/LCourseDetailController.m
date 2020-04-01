//
//  LCourseDetailController.m
//  langge
//
//  Created by samlee on 2019/7/23.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LCourseDetailController.h"
#import "LVideoView.h"
#import "LCourseListView.h"
#import "LCourseInfoView.h"
#import "LCourseCommentView.h"
#import "JXCategoryTitleView.h"
#import "JXCategoryIndicatorLineView.h"
#import "GKPageScrollView.h"
#import "LConsultingViewController.h"
#import "LCommonShareView.h"
#import "WPAlertControl.h"
#import "WXApiRequestHandler.h"
#import "wxApiManager.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import "LReceiveCourseAlertView.h"
#import "LClauseViewController.h"
#define ADAPTATIONRATIO     ScreenWidth / 750.0f

@interface LCourseDetailController ()<GKPageScrollViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;
@property (weak, nonatomic) IBOutlet UIButton *consultingBtn;

- (IBAction)consultingBtnClick:(id)sender;
- (IBAction)phoneBtnClick:(id)sender;
- (IBAction)collectionBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *collectionIcon;


@property (nonatomic, strong) GKPageScrollView      *pageScrollView;
@property (nonatomic, strong) UIView                *pageView;
@property (nonatomic, strong) JXCategoryTitleView   *segmentView;
@property (nonatomic, strong) UIScrollView          *contentScrollView;
@property (nonatomic, strong) NSMutableArray        *listViews;


@property(nonatomic,strong)LVideoView *headerView;
@property(nonatomic,strong)LCourseListView *courseListView;
@property(nonatomic,strong)LCourseInfoView *courseInfoView;
@property(nonatomic,strong)LCourseCommentView *courseCommentView;

@property(nonatomic,strong)LCourseClassHourModel *selectClassHour;

@end

@implementation LCourseDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUI];
}

-(void)setUI{
    if ([self.courseDetail.is_collection isEqualToString:@"1"]) {
        self.collectionBtn.selected = YES;
        self.collectionIcon.image = [UIImage imageNamed:@"collection_select"];
    }else{
        self.collectionBtn.selected = NO;
        self.collectionIcon.image = [UIImage imageNamed:@"collection"];
    }
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = barItem;
    barItem.title = @"";
    self.title = @"课程目录";
    
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [shareBtn setImage:[UIImage imageNamed:@"icon27"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    
    
    if (self.courseDetail.course_class_hour_list.count>0) {
        self.selectClassHour = self.courseDetail.course_class_hour_list.firstObject;
        self.selectClassHour.is_select = @"1";
    }
    
    [self.view addSubview:self.pageScrollView];
    self.pageScrollView.backgroundColor = [UIColor whiteColor];
    [self.pageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).offset(StatusHeight+NaviHeight);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    [self.pageScrollView reloadData];
    
    if ([self.courseDetail.course_info.is_agio isEqualToString:@"1"]) {
        if ([self.courseDetail.course_info.pri_price floatValue]==0.0) {
            [self.consultingBtn setTitle:@"免费领取" forState:UIControlStateNormal];
        }else{
            [self.consultingBtn setTitle:@"立即咨询" forState:UIControlStateNormal];
        }
    }else{
        [self.consultingBtn setTitle:@"立即咨询" forState:UIControlStateNormal];
    }
    
}

#pragma mark - GKPageScrollViewDelegate
- (UIView *)headerViewInPageScrollView:(GKPageScrollView *)pageScrollView {
    return self.headerView;
}

- (UIView *)pageViewInPageScrollView:(GKPageScrollView *)pageScrollView {
    return self.pageView;
}

- (NSArray<id<GKPageListViewDelegate>> *)listViewsInPageScrollView:(GKPageScrollView *)pageScrollView {
    return self.listViews;
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.pageScrollView horizonScrollViewWillBeginScroll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.pageScrollView horizonScrollViewDidEndedScroll];
}


#pragma mark -- LVideoViewDelegate
-(void)videoScreenBtnClick{
    self.navigationController.navigationBarHidden = !self.navigationController.navigationBarHidden;
}

/** 懒加载 */
- (IBAction)consultingBtnClick:(id)sender {
    if (![SingleTon getInstance].isLogin) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        [self.navigationController presentViewController:sb.instantiateInitialViewController animated:YES completion:nil];
        return;
    }
    
    
    
    if ([self.courseDetail.course_info.is_agio isEqualToString:@"1"]) {
        if ([self.courseDetail.course_info.pri_price floatValue]==0.0) {
            //领取，然后弹出  领取成功
            [SVProgressHUD showWithStatus:@"正在领取"];
            //我们老师会尽快联系您，帮您开课，请保持手机畅通。
            [[APIManager getInstance] receiveActionWithCid:self.course_id title:self.courseDetail.course_info.title type:nil  callback:^(BOOL success, id  _Nonnull data) {
                if (success) {
                    [SVProgressHUD dismiss];
                    __weak typeof(self)weakSelf = self;
                    LReceiveCourseAlertView *alert = [[NSBundle mainBundle] loadNibNamed:@"LReceiveCourseAlertView" owner:nil options:nil].firstObject;
                    alert.frame = [UIScreen mainScreen].bounds;
                    alert.closeBlock = ^{
                        [WPAlertControl alertHiddenForRootControl:weakSelf completion:nil];
                    };
                    alert.openWechatBlock = ^{
                        NSURL *url = [NSURL URLWithString:@"weixin://scanqrcode"];
                        if ([[UIApplication sharedApplication] canOpenURL:url]) {
                            [[UIApplication sharedApplication] openURL:url];
                        }
                        [WPAlertControl alertHiddenForRootControl:weakSelf completion:nil];
                    };
                    [WPAlertControl alertForView:alert begin:WPAlertBeginCenter end:WPAlertEndCenter animateType:WPAlertAnimateBounce constant:0 animageBeginInterval:0.3 animageEndInterval:0.3 maskColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] pan:YES rootControl:self mackClick:nil animateStatus:nil];

                }else{
                    
                    [SVProgressHUD showErrorWithStatus:data];
                }
            }];

            //我知道了
        }else{
            LConsultingViewController *vc = [[LConsultingViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        LConsultingViewController *vc = [[LConsultingViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}

- (IBAction)phoneBtnClick:(id)sender {
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"4009938812"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (IBAction)collectionBtnClick:(UIButton *)sender {
    if (![SingleTon getInstance].isLogin) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        [self.navigationController presentViewController:sb.instantiateInitialViewController animated:YES completion:nil];
        return;
    }
    
    self.collectionBtn.selected = !self.collectionBtn.selected;
    if (self.collectionBtn.selected) {
        self.collectionIcon.image = [UIImage imageNamed:@"collection_select"];
    }else{
        self.collectionIcon.image = [UIImage imageNamed:@"collection"];
    }
    self.collectionBtn.userInteractionEnabled = NO;
    [[APIManager getInstance] collectionActiveWithType:@"1" cid:self.course_id callback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            [SVProgressHUD showSuccessWithStatus:result];
        }else{
            [SVProgressHUD showErrorWithStatus:result];
            self.collectionBtn.selected = !self.collectionBtn.selected;
            if (self.collectionBtn.selected) {
                self.collectionIcon.image = [UIImage imageNamed:@"collection_select"];
            }else{
                self.collectionIcon.image = [UIImage imageNamed:@"collection"];
            }
        }
        self.collectionBtn.userInteractionEnabled = YES;
    }];
}

-(void)shareBtnClick{
    LCommonShareView *share = [[NSBundle mainBundle] loadNibNamed:@"LCommonShareView" owner:nil options:nil].firstObject;
    CGFloat height = 0;
    if (KIsiPhoneX) {
        height = 24;
    }
    share.frame = CGRectMake(0, 0, ScreenWidth, 150+height);
    __weak typeof(self)weakSelf = self;
    share.selectResult = ^(NSInteger type) {
        if (type == 0) {
            
        }else if (type == 1){
            NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.course.cover_img_src]];
            UIImage *image = [UIImage imageWithData:data];
            
            [WXApiRequestHandler sendLinkURL:self.courseDetail.share_link TagName:nil Title:self.courseDetail.course_info.title Description:self.courseDetail.course_info.describe ThumbImage:image InScene:WXSceneSession];
            [SingleTon getInstance].isShare = YES;
            
        }else if (type == 2){
            NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.course.cover_img_src]];
            UIImage *image = [UIImage imageWithData:data];
            
            [WXApiRequestHandler sendLinkURL:self.courseDetail.share_link TagName:nil Title:self.courseDetail.course_info.title Description:self.courseDetail.course_info.describe ThumbImage:image InScene:WXSceneTimeline];
            [SingleTon getInstance].isShare = YES;
            
        }else if (type == 3){
            QQApiNewsObject *obj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:self.courseDetail.share_link] title:self.courseDetail.course_info.title description:self.courseDetail.course_info.describe previewImageURL:[NSURL URLWithString:self.course.cover_img_src]];
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:obj];
            QQApiSendResultCode sent = [QQApiInterface sendReq:req];
            [SingleTon getInstance].isShare = YES;
            
        }else if (type == 4){
            QQApiNewsObject *obj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:self.courseDetail.share_link] title:self.courseDetail.course_info.title description:self.courseDetail.course_info.describe previewImageURL:[NSURL URLWithString:self.course.cover_img_src]];
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:obj];
            QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
            [SingleTon getInstance].isShare = YES;
        }else if (type == 5){
            WBWebpageObject *webpage = [WBWebpageObject object];
            webpage.objectID = @"identifier1";
            webpage.title = self.courseDetail.course_info.describe;
            webpage.description = self.courseDetail.course_info.describe;
            webpage.thumbnailData = UIImagePNGRepresentation([UIImage imageNamed:@"icon"]);
            webpage.webpageUrl = self.courseDetail.share_link;
            WBMessageObject *message = [WBMessageObject message];
            message.mediaObject = webpage;
            WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
            authRequest.redirectURI = kRedirectURI;
            authRequest.scope = @"all";
            WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:nil];
            [WeiboSDK sendRequest:request];
        }
        
        [WPAlertControl alertHiddenForRootControl:weakSelf completion:nil];
    };
    
    [WPAlertControl alertForView:share begin:WPAlertBeginBottem end:WPAlertEndBottem animateType:WPAlertAnimateBounce constant:0 animageBeginInterval:0.3 animageEndInterval:0.3 maskColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] pan:YES rootControl:self mackClick:nil animateStatus:nil];
}

-(GKPageScrollView *)pageScrollView{
    if (!_pageScrollView) {
        _pageScrollView = [[GKPageScrollView alloc] initWithDelegate:self];
        _pageScrollView.ceilPointHeight = 0;
        _pageScrollView.isAllowListRefresh = YES;
    }
    return _pageScrollView;
}

-(LVideoView *)headerView{
    if (!_headerView) {
        _headerView = [[LVideoView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 152+ScreenWidth*211/375)];
        _headerView.selectClassHour = self.selectClassHour;
        _headerView.courseDetail = self.courseDetail;
        _headerView.course = self.course;
        
    }
    return _headerView;
}


- (UIView *)pageView {
    if (!_pageView) {
        _pageView = [UIView new];
        _pageView.backgroundColor = [UIColor whiteColor];
        [_pageView addSubview:self.segmentView];
        [_pageView addSubview:self.contentScrollView];
    }
    return _pageView;
}

- (JXCategoryTitleView *)segmentView {
    if (!_segmentView) {
        _segmentView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
        _segmentView.titles = @[@"课程目录", @"课程信息",@"学员评论"];
        _segmentView.backgroundColor = [UIColor whiteColor];
        _segmentView.titleFont = [UIFont systemFontOfSize:15.0f];
        _segmentView.titleSelectedFont = [UIFont boldSystemFontOfSize:15.0f];
        _segmentView.titleColor = [UIColor blackColor];
        _segmentView.titleSelectedColor = RGB(251, 124, 118);
        
        JXCategoryIndicatorLineView *lineView = [JXCategoryIndicatorLineView new];
        lineView.indicatorLineWidth = ADAPTATIONRATIO * 50.0f;
        lineView.indicatorLineViewHeight = ADAPTATIONRATIO * 4.0f;
        lineView.indicatorLineViewColor = RGB(251, 124, 118);
        lineView.indicatorLineViewCornerRadius = 0;
        lineView.lineStyle = JXCategoryIndicatorLineStyle_Normal;
        lineView.verticalMargin = ADAPTATIONRATIO * 1.0f;
        _segmentView.indicators = @[lineView];
        
        _segmentView.contentScrollView = self.contentScrollView;
        
        UIView *btmLineView = [UIView new];
        btmLineView.backgroundColor = [UIColor grayColor];
        [_segmentView addSubview:btmLineView];
        [btmLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.segmentView);
            make.height.mas_equalTo(ADAPTATIONRATIO * 1.0f);
        }];
    }
    return _segmentView;
}


- (UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        CGFloat scrollW = ScreenWidth;
        CGFloat scrollH = ScreenHeight - NaviHeight - StatusHeight - ADAPTATIONRATIO * 100.0f-44;
        if (KIsiPhoneX) {
            scrollH = ScreenHeight - NaviHeight - StatusHeight - ADAPTATIONRATIO * 100.0f-68;
        }
        _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, ADAPTATIONRATIO * 100.0f, scrollW, scrollH)];
        _contentScrollView.backgroundColor = [UIColor  whiteColor];
        _contentScrollView.delegate = self;
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.bounces = NO;
        self.courseListView = [[LCourseListView alloc] initWithFrame:CGRectMake(0, 0, scrollW, scrollH)];
        __weak typeof(self)weakSelf = self;
        self.courseListView.selectClassHour = ^(LCourseClassHourModel * _Nonnull classHour) {

            if ([classHour.is_preview isEqualToString:@"1"]) {
                //[weakSelf.headerView playVideoWith:classHour];
                weakSelf.headerView.selectClassHour = classHour;
                return;
            }else{
                LConsultingViewController *vc = [[LConsultingViewController alloc] init];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
            
        };
        self.courseListView.course_id = self.course_id;
        self.courseListView.courseDetail = self.courseDetail;
        [self.listViews addObject:self.courseListView];
        [_contentScrollView addSubview:self.courseListView];
        
        self.courseInfoView  = [[LCourseInfoView alloc] initWithFrame:CGRectMake(scrollW, 0, scrollW, scrollH)];
        self.courseInfoView.backgroundColor = [UIColor whiteColor];
        self.courseInfoView.courseDetail = self.courseDetail;
    
        [self.listViews addObject:self.courseInfoView];
        [_contentScrollView addSubview:self.courseInfoView];

        self.courseCommentView = [[LCourseCommentView alloc] initWithFrame:CGRectMake(scrollW*2, 0, scrollW, scrollH)];
        self.courseCommentView.course_id = self.course_id;
        self.courseCommentView.courseDetail = self.courseDetail;
        [self.listViews addObject:self.courseCommentView];
        [_contentScrollView addSubview:self.courseCommentView];
        _contentScrollView.contentSize = CGSizeMake(3 * scrollW, 0);
    }
    return _contentScrollView;
}

- (NSMutableArray *)listViews {
    if (!_listViews) {
        _listViews = [NSMutableArray new];
    }
    return _listViews;
}



- (UIStatusBarStyle)preferredStatusBarStyle {
    
    if (_headerView) {
        if (self.headerView.player.isFullScreen) {
            return UIStatusBarStyleLightContent;
        }
    }
    return UIStatusBarStyleDefault;
}
- (BOOL)prefersStatusBarHidden {
    /// 如果只是支持iOS9+ 那直接return NO即可，这里为了适配iOS8
    if (_headerView) {
        return self.headerView.player.isStatusBarHidden;
    }
    return NO;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

- (BOOL)shouldAutorotate {
    return self.headerView.player.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (_headerView) {
        if (self.headerView.player.isFullScreen) {
            return UIInterfaceOrientationMaskLandscape;
        }
    }
    return UIInterfaceOrientationMaskPortrait;
}
-(void)dealloc{
    
    NSLog(@"LCourseDetailController");
}

@end
