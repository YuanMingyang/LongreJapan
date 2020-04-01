//
//  LNewDetailViewController.m
//  langge
//
//  Created by samlee on 2019/4/14.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LNewDetailViewController.h"
#import "LCommonShareView.h"
#import "WPAlertControl.h"
#import "WXApiRequestHandler.h"
#import "wxApiManager.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import "LNewTopView.h"

@interface LNewDetailViewController ()<WXApiManagerDelegate>

@property (strong, nonatomic)UIWebView *webView;


@property(nonatomic,strong)UIButton *collection;
@property(nonatomic,strong)UIButton *share;
@end

@implementation LNewDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    self.title = @"最新情报";
    [self updataWebView];
}

-(void)setUI{
    self.webView  = [[UIWebView alloc] init];
    [self.view addSubview:self.webView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-30);
    }];
    
    [WXApiManager sharedManager].delegate = self;
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.scrollView.bounces = NO;
    
    
    if (self.news) {
        CGFloat height = (ScreenWidth-40)*181/345 +157;
        self.webView.scrollView.contentInset = UIEdgeInsetsMake(height, 0, 0, 0);
        LNewTopView *topView = [[LNewTopView alloc] init];
        topView.news = self.news;
        
        topView.frame = CGRectMake(0, height*-1, ScreenWidth-54, height);
        [self.webView.scrollView addSubview:topView];
    }


    

    
    
    
    self.collection = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [self.collection setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
    [self.collection setImage:[UIImage imageNamed:@"collection_select"] forState:UIControlStateSelected];
    [self.collection addTarget:self action:@selector(collectionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.share = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [self.share addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.share setImage:[UIImage imageNamed:@"icon27"] forState:UIControlStateNormal];
    UIBarButtonItem *collectionItem = [[UIBarButtonItem alloc] initWithCustomView:self.collection];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:self.share];
    self.navigationItem.rightBarButtonItems = @[collectionItem,shareItem];
    
    
}

-(void)updataWebView{
    if (self.banner) {
        self.collection.hidden = YES;
        self.share.hidden = YES;
        NSString *url;
        if ([SingleTon getInstance].isLogin) {
            if ([self.banner.link_src rangeOfString:@"?"].location!=NSNotFound) {
                url = [NSString stringWithFormat:@"%@&user_token=%@",self.banner.link_src,[[SingleTon getInstance] getUser_tocken]];
            }else{
                url = [NSString stringWithFormat:@"%@?user_token=%@",self.banner.link_src,[[SingleTon getInstance] getUser_tocken]];
            }
        }else{
            url = self.banner.link_src;
        }
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }
    
    if (self.news) {
        self.collection.hidden = NO;
        self.share.hidden = NO;
        [self.webView loadHTMLString:self.news.content baseURL:[NSURL URLWithString:API_Root]];
        if ([self.news.is_collection isEqualToNumber:@(1)]) {
            self.collection.selected = YES;
        }else{
            self.collection.selected = NO;
        }
    }
}

#pragma mark -- action
-(void)collectionBtnClick{
    if (![SingleTon getInstance].isLogin) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        [self.navigationController presentViewController:sb.instantiateInitialViewController animated:YES completion:nil];
        return;
    }
    
    
    self.collection.selected = !self.collection.selected;
    self.collection.userInteractionEnabled = NO;
    [[APIManager getInstance] collectionActiveWithType:@"2" cid:self.news._id callback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            [SVProgressHUD showSuccessWithStatus:result];
        }else{
            self.collection.selected = !self.collection.selected;
            [SVProgressHUD showErrorWithStatus:result];
        }
        self.collection.userInteractionEnabled = YES;
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
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.news.cover_img_src]];
        UIImage *image = [UIImage imageWithData:data];
        if (type == 0) {
            
        }else if (type == 1){
            [WXApiRequestHandler sendLinkURL:self.news.share_link TagName:nil Title:self.news.title Description:self.news.desc ThumbImage:image InScene:WXSceneSession];
            [SingleTon getInstance].isShare = YES;

        }else if (type == 2){
            [WXApiRequestHandler sendLinkURL:self.news.share_link TagName:nil Title:self.news.title Description:self.news.desc ThumbImage:image InScene:WXSceneTimeline];
            [SingleTon getInstance].isShare = YES;

        }else if (type == 3){
            QQApiNewsObject *obj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:self.news.share_link] title:self.news.title description:self.news.desc previewImageURL:[NSURL URLWithString:self.news.cover_img_src]];
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:obj];
            QQApiSendResultCode sent = [QQApiInterface sendReq:req];
            [SingleTon getInstance].isShare = YES;

        }else if (type == 4){
            QQApiNewsObject *obj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:self.news.share_link] title:self.news.title description:self.news.desc previewImageURL:[NSURL URLWithString:self.news.cover_img_src]];
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:obj];
            QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
            [SingleTon getInstance].isShare = YES;

        }else if (type == 5){
            WBWebpageObject *webpage = [WBWebpageObject object];
            webpage.objectID = @"identifier1";
            webpage.title = weakSelf.news.desc;
            webpage.description = weakSelf.news.desc;
            webpage.thumbnailData = UIImagePNGRepresentation([UIImage imageNamed:@"icon"]);
            webpage.webpageUrl = weakSelf.news.share_link;
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


//#pragma maek -- wxApiManagerDelegate
//- (void)managerDidRecvGetMessageReq:(GetMessageFromWXReq *)request{
//    NSLog(@"managerDidRecvGetMessageReq");
//}
//
//- (void)managerDidRecvShowMessageReq:(ShowMessageFromWXReq *)request{
//    NSLog(@"managerDidRecvShowMessageReq");
//}
//
//- (void)managerDidRecvLaunchFromWXReq:(LaunchFromWXReq *)request{
//    NSLog(@"managerDidRecvLaunchFromWXReq");
//}
//
//- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response{
//    NSLog(@"managerDidRecvMessageResponse");
//}
//
//- (void)managerDidRecvAuthResponse:(SendAuthResp *)response{
//    NSLog(@"managerDidRecvMessageResponse");
//}
//
//- (void)managerDidRecvAddCardResponse:(AddCardToWXCardPackageResp *)response{
//    NSLog(@"managerDidRecvAddCardResponse");
//}
//
//- (void)managerDidRecvChooseCardResponse:(WXChooseCardResp *)response{
//    NSLog(@"managerDidRecvChooseCardResponse");
//}
//
//- (void)managerDidRecvChooseInvoiceResponse:(WXChooseInvoiceResp *)response{
//    NSLog(@"managerDidRecvChooseInvoiceResponse");
//}
//
//- (void)managerDidRecvSubscribeMsgResponse:(WXSubscribeMsgResp *)response{
//    NSLog(@"managerDidRecvSubscribeMsgResponse");
//}
//
//- (void)managerDidRecvLaunchMiniProgram:(WXLaunchMiniProgramResp *)response{
//    NSLog(@"managerDidRecvLaunchMiniProgram");
//}
//
//- (void)managerDidRecvInvoiceAuthInsertResponse:(WXInvoiceAuthInsertResp *)response{
//    NSLog(@"managerDidRecvInvoiceAuthInsertResponse");
//}
//
//- (void)managerDidRecvNonTaxpayResponse:(WXNontaxPayResp *)response{
//    NSLog(@"managerDidRecvNonTaxpayResponse");
//}
//
//- (void)managerDidRecvPayInsuranceResponse:(WXPayInsuranceResp *)response{
//    NSLog(@"managerDidRecvPayInsuranceResponse");
//}
@end
