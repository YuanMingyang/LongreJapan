//
//  LGameViewController.m
//  langge
//
//  Created by samlee on 2019/5/17.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LGameViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "LSoundStudyViewController.h"
#import "LTestResultAlertView.h"
#import "WXApiRequestHandler.h"
#import "wxApiManager.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import "WPAlertControl.h"
#import "LWordLevelAlertView.h"
#import "LLevelSuccessAlertView.h"
#import "LReviewFinishViewController.h"
#import "LWrongTopicEndAlert.h"
#import "LLevelFailAlertView.h"
#import "LLevelFailAlertViewController.h"
#import "LLevelStudyViewController.h"
#import "LThreeEndAlertView.h"
#import "LErrorQuestionViewController.h"
#import "LWordViewController.h"
#import "LTResultShareAlertView.h"
#import "LTResultDialogAlertView.h"

@interface LGameViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *webView;
@property (nonatomic ,strong) JSContext* context;
@end

@implementation LGameViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self.webView reload];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    
    
}
-(void)setUI{
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = barItem;
    barItem.title = @"";
    
    self.webView = [[UIWebView alloc] init];
    self.webView.scrollView.bounces = YES;
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.scrollView.bounces = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    self.webView.delegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
}


#pragma mark -- UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *requestString = [[request URL] absoluteString];
    NSLog(@"requestString:%@",requestString);
    if ([requestString isEqualToString:@"jsbridge:wrongTopicEmptyAlert"]) {
        [self wrongTopicEmptyAlert];
        return NO;
    }else if ([requestString isEqualToString:@"jsbridge:iosfuncload"]){
        int top = StatusHeight;
        int bottom = 0;
        if (KIsiPhoneX) {
            bottom = 34;
        }
        NSString * sendStr = [NSString stringWithFormat:@"iosfuncload(%d,%d)",top,bottom];
        [self.webView stringByEvaluatingJavaScriptFromString:sendStr];
        return NO;

    }
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    // 拿取js的运行环境
    self.context  = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    // 拿取js文件中的某个方法
    __weak typeof(self)weakSelf = self;
    self.context[@"clickItem"] = ^(NSString * jsString){
        dispatch_async(dispatch_get_main_queue(), ^{
             [weakSelf clickItem:jsString ifFromTest:NO];
        });
       
    };
    
    self.context[@"showAlert"] =  ^(NSString * jsString){
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf showAlertWith:jsString];
        });
        
    };
    self.context[@"back"] =  ^(NSString * jsString){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (jsString.length == 0) {
                
                if (weakSelf.isFromTest) {
                    for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
                        if ([vc isKindOfClass:[LGameViewController class]]) {
                            [weakSelf.navigationController popToViewController:vc animated:YES];
                            break;
                        }
                    }
                }else{
                    if (weakSelf.isFromErrorQuestion) {
                        for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
                            if ([vc isKindOfClass:[LErrorQuestionViewController class]]) {
                                [weakSelf.navigationController popToViewController:vc animated:YES];
                                break;
                            }
                        }
                    }else{
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }
                    
                    
                }
                
            }else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:jsString preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if (weakSelf.isFromTest) {
                        for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
                            if ([vc isKindOfClass:[LGameViewController class]]) {
                                [weakSelf.navigationController popToViewController:vc animated:YES];
                                break;
                            }
                        }
                    }else{
                        if (weakSelf.isFromErrorQuestion) {
                            for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
                                if ([vc isKindOfClass:[LErrorQuestionViewController class]]) {
                                    [weakSelf.navigationController popToViewController:vc animated:YES];
                                    break;
                                }
                            }
                        }else{
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                        }
                    }
                }];
                [alert addAction:cancel];
                [alert addAction:sure];
                [weakSelf.navigationController presentViewController:alert animated:YES completion:nil];
            }
        });
        
        
    };
    self.context[@"clickWordLevel"] =  ^(NSString * jsString){
        //点击关卡弹框
        NSDictionary *dic = [XSTools jsonStrToDictionaryWith:jsString];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf clickWordLevelWith:dic];
        });
    };
    self.context[@"wrongTopicEmptyAlert"] =  ^(NSString * jsString){
        //暂无错题  回到上一页(app页)
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf wrongTopicEmptyAlert];
        });
    };
    
    self.context[@"wrongTopicEndAlert"] =  ^(NSString * jsString){
        //错题本测试结束  弹框
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf wrongTopicEndAlerttWith:jsString];
        });
    };
    
    self.context[@"wrongReviewEndAlert"] =  ^(NSString * jsString){
        //错题本 复习页  复习结束弹框
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf wrongReviewEndAlertWith:jsString];
        });
    };
    
    self.context[@"WordshowAlert"] =  ^(NSString * jsString){
        //关卡结束弹框
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf WordshowAlertWith:[XSTools jsonStrToDictionaryWith:jsString].mutableCopy];
        });
        
    };
    
    self.context[@"showToast"] =  ^(id jsString,id js2){
        //关卡结束弹框
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[NSString stringWithFormat:@"%@",jsString] isEqualToString:@"0"]) {
                [SVProgressHUD showErrorWithStatus:js2];
            }
        });
        
    };
    
    
    self.context[@"threeEndAlert"] =  ^(id jsString){
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf threeEndAlertWith:jsString];
        });
        //return @"20";
        
    };
    
    
    self.context[@"ttlResultDialog"] =  ^(id jsString){
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf ttlResultDialogAlertWith:jsString];
        });
    };
    
    
    
}


#pragma mark -- action

-(void)ttlResultDialogAlertWith:(NSString *)jsString{
    NSDictionary *data = [XSTools jsonStrToDictionaryWith:jsString];
    NSNumber *type = data[@"type"];
    __weak typeof(self)weakSelf = self;
    if ([type isEqualToNumber:@(1)]) {
        LTResultDialogAlertView *alert = [[NSBundle mainBundle] loadNibNamed:@"LTResultDialogAlertView" owner:nil options:nil].firstObject;
        alert.frame = [UIScreen mainScreen].bounds;
        alert.resultData = data;
        alert.closeBlock = ^{
            [WPAlertControl alertHiddenForRootControl:weakSelf completion:nil];
        };
        [WPAlertControl alertForView:alert begin:WPAlertBeginCenter end:WPAlertEndCenter animateType:WPAlertAnimateBounce constant:0 animageBeginInterval:0.3 animageEndInterval:0.3 maskColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] pan:YES rootControl:self mackClick:nil animateStatus:nil];
    }else{
        LTResultShareAlertView *alert = [[NSBundle mainBundle] loadNibNamed:@"LTResultShareAlertView" owner:nil options:nil].firstObject;
        alert.frame = [UIScreen mainScreen].bounds;
        alert.resultData = data;
        alert.closeBlock = ^{
            [WPAlertControl alertHiddenForRootControl:weakSelf completion:nil];
        };
        __weak typeof(alert)weakAlert = alert;
        alert.shareBlock = ^(NSInteger type) {
            weakAlert.bjView.hidden = NO;
            UIImage *viewImage = [XSTools screenShotView:weakAlert.shareView];
            if (type == 101) {
                [WXApiRequestHandler sendImageData:UIImagePNGRepresentation(viewImage) TagName:nil MessageExt:nil Action:nil ThumbImage:nil InScene:WXSceneSession];
                [SingleTon getInstance].isShare = YES;
                
            }else if (type == 102){
                [WXApiRequestHandler sendImageData:UIImagePNGRepresentation(viewImage) TagName:nil MessageExt:nil Action:nil ThumbImage:nil InScene:WXSceneTimeline];
                [SingleTon getInstance].isShare = YES;
                
            }else if (type == 103){
                QQApiImageObject *obj = [QQApiImageObject objectWithData:UIImagePNGRepresentation(viewImage) previewImageData:UIImagePNGRepresentation(viewImage) title:@"" description:@""];
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:obj];
                QQApiSendResultCode sent = [QQApiInterface sendReq:req];
                [SingleTon getInstance].isShare = YES;
                
            }else if (type == 104){
                QQApiImageObject *obj = [QQApiImageObject objectWithData:UIImagePNGRepresentation(viewImage) previewImageData:UIImagePNGRepresentation(viewImage) title:@"" description:@""];
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:obj];
                QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
                [SingleTon getInstance].isShare = YES;
            }else if (type == 105){
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
            weakAlert.bjView.hidden = YES;
            [WPAlertControl alertHiddenForRootControl:weakSelf completion:nil];
        };
        [WPAlertControl alertForView:alert begin:WPAlertBeginCenter end:WPAlertEndCenter animateType:WPAlertAnimateBounce constant:0 animageBeginInterval:0.3 animageEndInterval:0.3 maskColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] pan:YES rootControl:self mackClick:nil animateStatus:nil];
    }
}

-(void)threeEndAlertWith:(NSString *)jsString{
    NSDictionary *data = [XSTools jsonStrToDictionaryWith:jsString];
    LThreeEndAlertView *alert = [[NSBundle mainBundle] loadNibNamed:@"LThreeEndAlertView" owner:nil options:nil].firstObject;
    alert.frame = [UIScreen mainScreen].bounds;
    alert.qrcode_src = data[@"qrcode_src"];
    __weak typeof(self)weakSelf = self;
    __weak typeof(alert)weakAlert = alert;

    alert.SelectBlock = ^(NSInteger type) {
        weakAlert.bottomView.hidden = NO;
        UIImage *viewImage = [XSTools screenShotView:weakAlert.imageView];
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
        weakAlert.bottomView.hidden = YES;
        [WPAlertControl alertHiddenForRootControl:weakSelf completion:nil];
    };
    
    alert.closeBlock = ^{
        [WPAlertControl alertHiddenForRootControl:weakSelf completion:nil];
    };
    [WPAlertControl alertForView:alert begin:WPAlertBeginCenter end:WPAlertEndCenter animateType:WPAlertAnimateBounce constant:0 animageBeginInterval:0.3 animageEndInterval:0.3 maskColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] pan:YES rootControl:self mackClick:nil animateStatus:nil];
}

-(void)wrongTopicEndAlerttWith:(NSString *)jsString{
    LWrongTopicEndAlert *alert = [[NSBundle mainBundle] loadNibNamed:@"LWrongTopicEndAlert" owner:nil options:nil].firstObject;
    alert.frame = [UIScreen mainScreen].bounds;
    __weak typeof(self)weakSelf = self;
    alert.closeBlock = ^{
        [WPAlertControl alertHiddenForRootControl:weakSelf completion:nil];
    };
    [WPAlertControl alertForView:alert begin:WPAlertBeginCenter end:WPAlertEndCenter animateType:WPAlertAnimateBounce constant:0 animageBeginInterval:0.3 animageEndInterval:0.3 maskColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] pan:YES rootControl:self mackClick:nil animateStatus:nil];
}

-(void)wrongReviewEndAlertWith:(NSString *)jsString{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    LReviewFinishViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LReviewFinishViewController"];
    vc.shouldNavigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)WordshowAlertWith:(NSMutableDictionary *)data{
    NSLog(@"1111111111:%@",[NSThread currentThread]);
    if ([data[@"star"] isEqualToString:@"0"]) {
        LLevelSuccessAlertView *alert = [[NSBundle mainBundle] loadNibNamed:@"LLevelSuccessAlertView" owner:nil options:nil].firstObject;
        alert.frame = [UIScreen mainScreen].bounds;
        __weak typeof(self)weakSelf = self;
        alert.selectTyle = ^(NSInteger type) {
            if (type == 1) {
                [weakSelf.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
            }else if (type == 2){
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Word" bundle:nil];
                LLevelStudyViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LLevelStudyViewController"];
                vc.shouldNavigationBarHidden = YES;
                vc.data = data;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
            [WPAlertControl alertHiddenForRootControl:weakSelf completion:nil];
        };
        [WPAlertControl alertForView:alert begin:WPAlertBeginCenter end:WPAlertEndCenter animateType:WPAlertAnimateBounce constant:0 animageBeginInterval:0.3 animageEndInterval:0.3 maskColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] pan:YES rootControl:self mackClick:nil animateStatus:nil];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updataWordList" object:nil];
        
        LLevelFailAlertViewController *vc = [[LLevelFailAlertViewController alloc] initWithNibName:@"LLevelFailAlertViewController" bundle:nil];
        vc.data = data;
        vc.shouldNavigationBarHidden = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

-(void)clickWordLevelWith:(NSDictionary *)data{
//    NSDictionary *dic = @{
//                          @"bid":@"1",
//                          @"level":@"1",
//                          @"star":@"3",
//                          @"grade":@"92",
//                          @"describe":@"23题正确/2题错误",
//                          @"GameType":@"1-1",
//                          @"prize":@{},
//                          @"shareData":@{
//                                  @"nick_name":@"袁明洋",
//                                  @"user_img_src":@"",
//                                  @"ranking":@"1000+",
//                @"qrcode_src":@"https://japanapp.iopfun.cn/server/upload/qrcode/QRcode_2.png",
//                                  @"shareLink":@"https://japanapp.iopfun.cn/Down"
//                                  }
//                          };
//    NSLog(@"%@",[XSTools dataTOjsonString:dic]);
//    LLevelFailAlertViewController *vc = [[LLevelFailAlertViewController alloc] initWithNibName:@"LLevelFailAlertViewController" bundle:nil];
//    vc.data = dic;
//    vc.shouldNavigationBarHidden = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//    return;
    
    
    LWordLevelAlertView *alert = [[NSBundle mainBundle] loadNibNamed:@"LWordLevelAlertView" owner:nil options:nil].firstObject;
    alert.frame = [UIScreen mainScreen].bounds;
    alert.levelData = data;
    __weak typeof(self)weakSelf = self;
    alert.selectBlock = ^(NSInteger type, NSDictionary * _Nonnull levelData) {
        if (type == 1) {
            LGameViewController *vc = [[LGameViewController alloc] init];
            vc.urlStr = [NSString stringWithFormat:@"%@Studyplangame/wordTopic?user_token=%@&bid=%@&level=%@&isPrize=%@",API_Root,[[SingleTon getInstance] getUser_tocken],data[@"bid"],data[@"level"],data[@"isPrize"]];
            vc.shouldNavigationBarHidden = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else if (type == 2){
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Word" bundle:nil];
            LLevelStudyViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LLevelStudyViewController"];
            vc.shouldNavigationBarHidden = YES;
            vc.data = data;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        [WPAlertControl alertHiddenForRootControl:weakSelf completion:nil];
    };
    
    [WPAlertControl alertForView:alert begin:WPAlertBeginCenter end:WPAlertEndCenter animateType:WPAlertAnimateBounce constant:0 animageBeginInterval:0.3 animageEndInterval:0.3 maskColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] pan:YES rootControl:self mackClick:nil animateStatus:nil];
}

-(void)wrongTopicEmptyAlert{
    [SVProgressHUD showInfoWithStatus:@"暂无错题"];
    BOOL isback = NO;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[LErrorQuestionViewController class]]) {
            isback = YES;
            [self.navigationController popToViewController:vc animated:YES];
            
            break;
        }
    }
    if (!isback) {
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[LWordViewController class]]) {
                isback = YES;
                [self.navigationController popToViewController:vc animated:YES];
                
                break;
            }
        }
    }
}

-(void)clickItem:(NSString *)jsonString ifFromTest:(BOOL)isFromtTest{
    
    if (![SingleTon getInstance].isLogin) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没有登录,确认登录吗?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            [self.navigationController presentViewController:sb.instantiateInitialViewController animated:YES completion:nil];
        }];
        [alert addAction:cancel];
        [alert addAction:sure];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
        return;
       
    }
    
    
    __weak typeof(self)weakSelf = self;
    NSDictionary *dic = [XSTools jsonStrToDictionaryWith:jsonString];
    NSString *thisClass = dic[@"thisClass"];
    NSString *row = dic[@"row"];
    if ([row isEqualToString:@"all"]||[thisClass isEqualToString:@"4"]||[thisClass isEqualToString:@"5"]) {
        LGameViewController *vc = [[LGameViewController alloc] init];
        vc.isFromTest = isFromtTest;
        NSString *str = @"";
        if ([SingleTon getInstance].isLogin) {
            str = [NSString stringWithFormat:@"%@Fiftytones/fiftytonesTopic?user_token=%@&type=%@&row=%@",API_Root,[[SingleTon getInstance] getUser_tocken],thisClass,row];
        }else{
            str = [NSString stringWithFormat:@"%@Fiftytones/fiftytonesTopic?type=%@&row=%@",API_Root,thisClass,row];
        }
        vc.urlStr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        vc.shouldNavigationBarHidden = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    [SVProgressHUD showWithStatus:@"加载中"];
    [[APIManager getInstance] fiftytonesDetailsWithType:dic[@"thisClass"] row:dic[@"row"] callback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            [SVProgressHUD dismiss];
            LSoundStudyViewController *vc = [[LSoundStudyViewController alloc] initWithNibName:@"LSoundStudyViewController" bundle:nil];
            vc.dataSource = result;
            vc.type = dic[@"thisClass"];
            vc.row = dic[@"row"];
            vc.hidesBottomBarWhenPushed = YES;
            vc.title = dic[@"row"];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:result];
        }
    }];
}

-(void)showAlertWith:(NSString *)jsonStr{
    //更新首页数据
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updataFiftytonesIndex" object:nil];
    NSDictionary *dic = [XSTools jsonStrToDictionaryWith:jsonStr];
    LTestResultAlertView *alert = [[NSBundle mainBundle] loadNibNamed:@"LTestResultAlertView" owner:nil options:nil].firstObject;
    alert.frame = [UIScreen mainScreen].bounds;
    alert.resultData = [XSTools jsonStrToDictionaryWith:jsonStr];
    __weak typeof(self)weakSelf = self;
    __weak typeof(alert)weakAlert = alert;
    alert.shareClick = ^(NSInteger type) {
        weakAlert.iconView.hidden = NO;
        weakAlert.closeBtn.hidden = YES;
        UIImage *viewImage = [XSTools screenShotView:weakAlert.colorView];
        
        weakAlert.iconView.hidden = YES;
        weakAlert.closeBtn.hidden = NO;
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
        
    };
    
    alert.selectClick = ^(NSInteger type) {
        if (type==1) {
            NSString *thisClass = @"";
            NSString *row = @"";
            
            if (dic[@"type"]) {
                thisClass = dic[@"type"];
            }
            if (dic[@"nextRow"]) {
                row = dic[@"nextRow"];
            }
            if ([row isEqualToString:@"over"]) {
                for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[LGameViewController class]]) {
                        [weakSelf.navigationController popToViewController:vc animated:YES];
                        break;
                    }
                }
            }else{
                NSDictionary *clickItemDic = @{
                                               @"thisClass":thisClass,
                                               @"row":row
                                               };
                [weakSelf clickItem:[XSTools dataTOjsonString:clickItemDic] ifFromTest:YES];
            }
            
            
        }else if (type == 2){
            [weakSelf.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:weakSelf.urlStr]]];
        }
        [WPAlertControl alertHiddenForRootControl:weakSelf completion:nil];
    };
    [WPAlertControl alertForView:alert begin:WPAlertBeginCenter end:WPAlertEndCenter animateType:WPAlertAnimateBounce constant:0 animageBeginInterval:0.3 animageEndInterval:0.3 maskColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] pan:YES rootControl:self mackClick:nil animateStatus:nil];
}

-(UIImage *)getImageWith:(LTestResultAlertView *)alert{
    alert.iconView.hidden = NO;
    alert.closeBtn.hidden = YES;
    return [XSTools screenShotView:alert];
}


-(void)dealloc{
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}
@end
