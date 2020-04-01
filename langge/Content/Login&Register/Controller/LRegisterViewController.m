//
//  LRegisterViewController.m
//  langge
//
//  Created by samlee on 2019/3/20.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LRegisterViewController.h"
#import "UILabel+YBAttributeTextTapAction.h"
#import "LResetViewController.h"
#import "LAddInfoViewController.h"
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"
#import "WechatAuthSDK.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "sdkCall.h"
#import "LBindPhoneViewController.h"
#import "LClauseViewController.h"

@interface LRegisterViewController ()<WXApiManagerDelegate,WechatAuthAPIDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@property (weak, nonatomic) IBOutlet UITextField *mobileTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
- (IBAction)backBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UILabel *btnStatusLabel;
- (IBAction)getCodeBtnClick:(UIButton *)sender;
- (IBAction)registerBtnClick:(UIButton *)sender;
- (IBAction)otherBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UILabel *protocolLabel;
@property (weak, nonatomic) IBOutlet UIButton *sinaBtn;
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;
@property (weak, nonatomic) IBOutlet UIButton *qqBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property(nonatomic,strong)NSTimer *authTimer;
@property(nonatomic,assign)int codeSeconds;
    
@property(nonatomic,strong)NSString *qq_open_id;

@end

@implementation LRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessed) name:kLoginSuccessed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfoSuccessed:) name:kGetUserInfoResponse object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WeiBoAuthSuccess:) name:@"WeiBoAuthSuccess" object:nil];
    [self setUI];
}

-(void)setUI{
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = barItem;
    barItem.title = @"";
    
    
    self.widthConstraint.constant = ScreenWidth;
    self.heightConstraint.constant = ScreenHeight-20;
    [self.btnStatusLabel modifyWithcornerRadius:20 borderColor:RGB(251, 124, 118) borderWidth:1];
    [self.registerBtn modifyWithcornerRadius:20 borderColor:nil borderWidth:0];
    self.registerBtn.enabled = NO;
    self.registerBtn.backgroundColor = RGB(153, 153,153);
    [self.mobileTF addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingChanged];
    [self.codeTF addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.mobileTF.delegate = self;
    self.codeTF.delegate = self;
    
    if (self.isRegister) {
        [self.registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        self.titleLabel.hidden = YES;
        self.protocolLabel.hidden = NO;
        self.sinaBtn.hidden = NO;
        self.wechatBtn.hidden = NO;
        self.qqBtn.hidden = NO;
        NSString *showText = @"注册代表同意 用户协议 和 隐私条款 ";
        self.protocolLabel.attributedText = [XSTools getAttributeWith:@[@"用户协议",@"隐私条款"] string:showText orginFont:12 orginColor:[UIColor darkGrayColor] attributeFont:12 attributeColor:RGB(251, 124, 118)];
        __weak typeof(self)weakSelf = self;
        [self.protocolLabel yb_addAttributeTapActionWithStrings:@[@"用户协议",@"隐私条款"] tapClicked:^(UILabel *label, NSString *string, NSRange range, NSInteger index) {
            if (index == 0) {
                [weakSelf openClauseWithType:@"1"];
            }else if (index == 1){
                [weakSelf openClauseWithType:@"2"];
            }
        }];
    }else{
        [self.registerBtn setTitle:@"下一步" forState:UIControlStateNormal];
        self.titleLabel.hidden = NO;
        self.sinaBtn.hidden = YES;
        self.wechatBtn.hidden = YES;
        self.qqBtn.hidden = YES;
        self.protocolLabel.hidden = YES;
    }
}

-(void)openClauseWithType:(NSString *)type{
    [SVProgressHUD showWithStatus:@"加载中"];
    [[APIManager getInstance] get_clauseWithType:type callback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            [SVProgressHUD dismiss];
            LClauseViewController *vc = [[LClauseViewController alloc] init];
            vc.htmlStr = result;
            if ([type isEqualToString:@"1"]) {
                vc.title = @"日语助手用户协议";
            }else{
                vc.title = @"日语助手隐私条款";
            }
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:result];
        }
    }];
}

-(void)textField1TextChange:(UITextField *)textField{
    if (self.mobileTF.text.length>0&&self.codeTF.text.length>0) {
        self.registerBtn.enabled = YES;
        self.registerBtn.backgroundColor = RGB(255, 184,73);
    }else{
        self.registerBtn.enabled = NO;
        self.registerBtn.backgroundColor = RGB(153, 153,153);
    }
}


- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)getCodeBtnClick:(UIButton *)sender {
    if (![XSTools checkMobileWith:self.mobileTF.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确手机号"];
        return;
    }
    [SVProgressHUD showWithStatus:@"发送中"];
    [[APIManager getInstance] getMobileAuthWithMobile:self.mobileTF.text callback:^(BOOL success, id  _Nonnull resule) {
        if (success) {
            sender.enabled = NO;
            self.codeSeconds = 0;
            self.authTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdown) userInfo:nil repeats:YES];
            [SVProgressHUD showSuccessWithStatus:@"验证码发送成功"];
        }else{
            [SVProgressHUD showErrorWithStatus:resule];
        }
    }];
    
    
}

-(void)countdown{
    self.codeSeconds++;
    self.btnStatusLabel.text = [NSString stringWithFormat:@"重新发送%ds",60-self.codeSeconds];
    if (self.codeSeconds == 60) {
        self.btnStatusLabel.text = @"获取验证码";
        self.codeSeconds = 0;
        self.getCodeBtn.enabled = YES;
        [self.authTimer invalidate];
        self.authTimer = nil;
    }
}

- (IBAction)registerBtnClick:(UIButton *)sender {
    if (![XSTools checkMobileWith:self.mobileTF.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }
    if (self.codeTF.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        return;
    }
    
    if (self.isRegister) {
        [SVProgressHUD showWithStatus:@"注册中"];
        __weak typeof(self)weakSelf = self;
        [[APIManager getInstance] CustomerLoginWithMobile:self.mobileTF.text sms_code:self.codeTF.text open_id:nil open_name:nil type_open:@"" callback:^(BOOL success, id  _Nonnull result) {
            if (success) {
                [SVProgressHUD dismiss];
                if ([result[@"type"] isEqualToString:@"1"]) {
                    [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
                }else{
                    LAddInfoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LAddInfoViewController"];
                    vc.shouldNavigationBarHidden = YES;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
                
            }else{
                [SVProgressHUD showErrorWithStatus:result];
            }
        }];
    }else{
        LResetViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LResetViewController"];
        vc.shouldNavigationBarHidden = YES;
        vc.mobile = self.mobileTF.text;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)otherBtnClick:(UIButton *)sender {
    if (sender.tag == 101) {
        NSLog(@"微博登录");
        if (![WeiboSDK isWeiboAppInstalled]) {
            [SVProgressHUD showErrorWithStatus:@"您还没安装微博客户端"];
            return;
        }
        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
        request.redirectURI = kRedirectURI;
        request.scope = @"all";
        [WeiboSDK sendRequest:request];
    }else if (sender.tag == 102){
        NSLog(@"微信登录");
        [WXApiManager sharedManager].delegate = self;
        [WXApiRequestHandler sendAuthRequestScope: @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact"
                                            State:@"xxx"
                                           OpenID:@"0c806938e2413ce73eef92cc3"
                                 InViewController:self];
    }else if (sender.tag == 103){
        NSLog(@"QQ登录");
        NSArray *premissions = @[kOPEN_PERMISSION_GET_USER_INFO,
                                 kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                                 kOPEN_PERMISSION_ADD_ALBUM,
                                 kOPEN_PERMISSION_ADD_ONE_BLOG,
                                 kOPEN_PERMISSION_ADD_SHARE,
                                 kOPEN_PERMISSION_ADD_TOPIC,
                                 kOPEN_PERMISSION_CHECK_PAGE_FANS,
                                 kOPEN_PERMISSION_GET_INFO,
                                 kOPEN_PERMISSION_GET_OTHER_INFO,
                                 kOPEN_PERMISSION_LIST_ALBUM,
                                 kOPEN_PERMISSION_UPLOAD_PIC,
                                 kOPEN_PERMISSION_GET_VIP_INFO,
                                 kOPEN_PERMISSION_GET_VIP_RICH_INFO];
        TencentOAuth * oauth = [[sdkCall getinstance] oauth];
        oauth.authMode = kAuthModeClientSideToken;
        [oauth authorize:premissions inSafari:NO];
    }
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.mobileTF) {
        if (range.location >= 11) {
            return NO;
        }else{
            return YES;
        }
    }else if (textField == self.codeTF){
        if (range.location >= 6) {
            return NO;
        }else{
            return YES;
        }
    }else{
        return YES;
    }
}


#pragma mark -- WXApiManagerDelegate

- (void)managerDidRecvAuthResponse:(SendAuthResp *)response {
    [self getWXAccess_tokenWithCode:response.code];
}


#pragma mark -- TencentSessionDelegate
-(void)loginSuccessed{
    NSLog(@"loginSuccessed");
    TencentOAuth *auth = [sdkCall getinstance].oauth;
    self.qq_open_id = auth.openId;
    [SVProgressHUD showWithStatus:@"登录中"];
    [auth getUserInfo];
}
-(void)loginFailed{
    NSLog(@"loginFailed");
}
-(void)loginCannelled{
    NSLog(@"loginCannelled");
}
-(void)didGetUnionID{
    NSLog(@"didGetUnionID");
}
-(void)logoutSuccessed{
    NSLog(@"logoutSuccessed");
}
-(void)getUserInfoSuccessed:(NSNotification *)sender{
    NSLog(@"getUserInfoSuccessed");
    APIResponse *resp = sender.userInfo[@"kResponse"];
    __weak typeof(self)weakSelf = self;
    [[APIManager getInstance] CustomerLoginWithMobile:nil sms_code:nil open_id:self.qq_open_id open_name:resp.jsonResponse[@"nickname"] type_open:@"qq" callback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            [SVProgressHUD dismiss];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }else{
            if ([[NSString stringWithFormat:@"%@",result[@"returnCode"]] isEqualToString:@"10007-1"]) {
                [SVProgressHUD dismiss];
                LBindPhoneViewController *vc = [weakSelf.storyboard instantiateViewControllerWithIdentifier:@"LBindPhoneViewController"];
                vc.open_id = self.qq_open_id;
                vc.type_open = @"qq";
                vc.open_name = resp.jsonResponse[@"nickname"];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:result[@"errorMsg"]];
            }
        }
    }];
}
/** 获取微信token */
-(void)getWXAccess_tokenWithCode:(NSString *)code{
    __weak typeof(self)weakSelf = self;
    [[APIManager getInstance] getWXAccessTokenWithCode:code callback:^(BOOL success, id  _Nonnull resule) {
        if (success) {
            [SVProgressHUD showWithStatus:@"登录中"];
            [weakSelf getWXUserInfoWithData:resule];
            
        }else{
            [SVProgressHUD showErrorWithStatus:resule];
        }
    }];
}
    
    /** 获取微信信息 */
-(void)getWXUserInfoWithData:(NSDictionary *)data{
    __weak typeof(self)weakSelf = self;
    [[APIManager getInstance] getWXUserinfoWithToken:data[@"access_token"] openID:data[@"openid"] callback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            NSString *nickname = result[@"nickname"];
            [[APIManager getInstance] CustomerLoginWithMobile:nil sms_code:nil open_id:data[@"openid"] open_name:result[@"nickname"] type_open:@"weixin" callback:^(BOOL success, id  _Nonnull result) {
                if (success) {
                    [SVProgressHUD dismiss];
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                }else{
                    if ([[NSString stringWithFormat:@"%@",result[@"returnCode"]] isEqualToString:@"10007-1"]) {
                        [SVProgressHUD dismiss];
                        LBindPhoneViewController *vc = [weakSelf.storyboard instantiateViewControllerWithIdentifier:@"LBindPhoneViewController"];
                        vc.open_id = data[@"openid"];
                        vc.type_open = @"weixin";
                        vc.open_name = nickname;
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    }else{
                        [SVProgressHUD showErrorWithStatus:result[@"errorMsg"]];
                    }
                }
            }];
        }else{
            [SVProgressHUD showErrorWithStatus:result];
        }
    }];
}

#pragma mark -- weibo
-(void)WeiBoAuthSuccess:(NSNotification *)sender{
    [SVProgressHUD showWithStatus:@"登录中"];
    __weak typeof(self)weakSelf = self;
    [[APIManager getInstance] getWBUserWithAccess_token:sender.object[@"access_token"] uid:[NSString stringWithFormat:@"%@",sender.object[@"uid"]] callback:^(BOOL success, id  _Nonnull data) {
        [[APIManager getInstance] CustomerLoginWithMobile:nil sms_code:nil open_id:[NSString stringWithFormat:@"%@",data[@"id"]] open_name:data[@"name"] type_open:@"sina" callback:^(BOOL success, id  _Nonnull result) {
            if (success) {
                [SVProgressHUD dismiss];
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }else{
                if ([[NSString stringWithFormat:@"%@",result[@"returnCode"]] isEqualToString:@"10007-1"]) {
                    [SVProgressHUD dismiss];
                    LBindPhoneViewController *vc = [weakSelf.storyboard instantiateViewControllerWithIdentifier:@"LBindPhoneViewController"];
                    vc.open_id = [NSString stringWithFormat:@"%@",data[@"id"]];
                    vc.type_open = @"sina";
                    vc.open_name = data[@"name"];
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }else{
                    [SVProgressHUD showErrorWithStatus:result[@"errorMsg"]];
                }
            }
        }];
    }];
    
    
}
@end
