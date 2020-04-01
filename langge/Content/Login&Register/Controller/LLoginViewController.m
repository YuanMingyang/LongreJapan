//
//  LLoginViewController.m
//  langge
//
//  Created by samlee on 2019/3/20.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LLoginViewController.h"
#import "LRegisterViewController.h"
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"
#import "WechatAuthSDK.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "sdkCall.h"
#import "LAddInfoViewController.h"
#import "LBindPhoneViewController.h"

@interface LLoginViewController ()<WXApiManagerDelegate,WechatAuthAPIDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@property (weak, nonatomic) IBOutlet UIButton *codeLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *passwordLoginBtn;
@property (weak, nonatomic) IBOutlet UIView *codeLoginView;
@property (weak, nonatomic) IBOutlet UITextField *code_mobileTF;
@property (weak, nonatomic) IBOutlet UITextField *code_codeTF;
@property (weak, nonatomic) IBOutlet UILabel *btnStatusLabel;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;

@property (weak, nonatomic) IBOutlet UIView *passwordLoginView;
@property (weak, nonatomic) IBOutlet UITextField *password_mobileTF;
@property (weak, nonatomic) IBOutlet UITextField *password_passwordTF;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineCenterConstraint;
- (IBAction)backBtnClick:(UIButton *)sender;
- (IBAction)codeBtnClick:(UIButton *)sender;
- (IBAction)passwordBtnClick:(UIButton *)sender;
- (IBAction)hidenPasswordBtnClick:(UIButton *)sender;
- (IBAction)loginBtnClick:(UIButton *)sender;

- (IBAction)otherLoginBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordBtn;

- (IBAction)forgetPassworldBtnClick:(id)sender;
- (IBAction)getCodeBtnClick:(UIButton *)sender;

@property(nonatomic,strong)NSTimer *authTimer;
@property(nonatomic,assign)int codeSeconds;
@property(nonatomic,assign)BOOL isCodeLogin;//当前是不是验证码登录
    
    @property(nonatomic,strong)NSString *qq_open_id;
@end

@implementation LLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
    self.widthConstraint.constant = ScreenWidth;
    self.heightConstraint.constant = ScreenHeight-20;
    self.isCodeLogin = YES;
    self.forgetPasswordBtn.hidden = YES;
    self.loginBtn.backgroundColor = RGB(153, 153, 153);
    self.loginBtn.enabled = NO;
    [self.passwordLoginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.loginBtn modifyWithcornerRadius:20 borderColor:nil borderWidth:0];
    [self.btnStatusLabel modifyWithcornerRadius:20 borderColor:RGB(251, 124, 118) borderWidth:1];
    [self.code_mobileTF addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingChanged];
    [self.code_codeTF addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingChanged];
    [self.password_mobileTF addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingChanged];
    [self.password_passwordTF addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.code_mobileTF.delegate = self;
    self.password_passwordTF.delegate = self;
    self.password_mobileTF.delegate = self;
    self.code_codeTF.delegate = self;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessed) name:kLoginSuccessed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFailed) name:kLoginFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginCannelled) name:kLoginCancelled object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetUnionID) name:kGetUnionID object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSuccessed) name:kLogoutSuccessed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfoSuccessed:) name:kGetUserInfoResponse object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WeiBoAuthSuccess:) name:@"WeiBoAuthSuccess" object:nil];
    
    
    //为了初始化以下sdk
    [sdkCall getinstance];
}

-(void)textField1TextChange:(UITextField *)sender{
    if (self.isCodeLogin) {
        if (self.code_mobileTF.text.length>0&&self.code_codeTF.text.length>0) {
            self.loginBtn.enabled = YES;
            self.loginBtn.backgroundColor = RGB(255, 184,73);
        }else{
            self.loginBtn.backgroundColor = RGB(153, 153, 153);
            self.loginBtn.enabled = NO;
        }
    }else{
        if (self.password_mobileTF.text.length>0&&self.password_passwordTF.text.length>0) {
            self.loginBtn.enabled = YES;
            self.loginBtn.backgroundColor = RGB(255, 184,73);
        }else{
            self.loginBtn.backgroundColor = RGB(153, 153, 153);
            self.loginBtn.enabled = NO;
        }
    }
}

#pragma mark -- Action
- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)codeBtnClick:(UIButton *)sender {
    if (self.isCodeLogin) {
        return;
    }
    
    if (self.code_mobileTF.text.length>0&&self.code_codeTF.text.length>0) {
        self.loginBtn.enabled = YES;
        self.loginBtn.backgroundColor = RGB(255, 184,73);
    }else{
        self.loginBtn.backgroundColor = RGB(153, 153, 153);
        self.loginBtn.enabled = NO;
    }
    
    [sender setTitleColor:RGB(251, 124, 118) forState:UIControlStateNormal];
    self.codeLoginView.hidden = NO;
    [self.passwordLoginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.passwordLoginView.hidden = YES;
    self.lineCenterConstraint.constant = -60;
    self.isCodeLogin = YES;
    self.forgetPasswordBtn.hidden = YES;
    
}

- (IBAction)passwordBtnClick:(UIButton *)sender {
    if (!self.isCodeLogin) {
        return;
    }
    if (self.password_mobileTF.text.length>0&&self.password_passwordTF.text.length>0) {
        self.loginBtn.enabled = YES;
        self.loginBtn.backgroundColor = RGB(255, 184,73);
    }else{
        self.loginBtn.backgroundColor = RGB(153, 153, 153);
        self.loginBtn.enabled = NO;
    }
    [sender setTitleColor:RGB(251, 124, 118) forState:UIControlStateNormal];
    self.passwordLoginView.hidden = NO;
    [self.codeLoginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal] ;
    self.codeLoginView.hidden = YES;
    self.lineCenterConstraint.constant = 60;
    self.isCodeLogin = NO;
    self.forgetPasswordBtn.hidden = NO;
}

- (IBAction)hidenPasswordBtnClick:(UIButton *)sender {
    if (!sender.selected) {
        self.password_passwordTF.secureTextEntry = NO;
    }else{
        self.password_passwordTF.secureTextEntry = YES;
    }
    sender.selected = !sender.selected;
}

- (IBAction)loginBtnClick:(UIButton *)sender {
    if (self.isCodeLogin) {
        if (![XSTools checkMobileWith:self.code_mobileTF.text]) {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
            return;
        }
        if (self.code_codeTF.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
            return;
        }
        [self codeLogin];
        
    }else{
        if (self.password_mobileTF.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入账号"];
            return;
        }
        if (self.password_passwordTF.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入密码"];
            return;
        }
        [self passWordLogin];
    }
}

-(void)codeLogin{
    __weak typeof(self)weakSelf = self;
    [SVProgressHUD showWithStatus:@"登录中"];
    [[APIManager getInstance] CustomerLoginWithMobile:self.code_mobileTF.text sms_code:self.code_codeTF.text open_id:nil open_name:nil type_open:@"手机验证码" callback:^(BOOL success, id  _Nonnull result) {
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
}
-(void)passWordLogin{
    __weak typeof(self)weakSelf = self;
    [SVProgressHUD showWithStatus:@"登录中"];
    [[APIManager getInstance] simpleLoginWithUserAccount:self.password_mobileTF.text userPass:self.password_passwordTF.text callback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            [SVProgressHUD dismiss];
            [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
        }else{
            [SVProgressHUD showErrorWithStatus:result];
        }
    }];
}

-(void)pushAddInfo{
    LAddInfoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LAddInfoViewController"];
    vc.shouldNavigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)otherLoginBtnClick:(UIButton *)sender {
    if (sender.tag == 101) {
        NSLog(@"微博登录");
        if (![WeiboSDK isWeiboAppInstalled]) {
            [SVProgressHUD showErrorWithStatus:@"您还没安装微博客户端"];
            return;
        }
        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
        request.redirectURI = kRedirectURI;
        request.scope = @"all";
        request.userInfo = @{@"SSO_From": @"LLoginViewController",
                             @"Other_Info_1": [NSNumber numberWithInt:123],
                             @"Other_Info_2": @[@"obj1", @"obj2"],
                             @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
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

- (IBAction)forgetPassworldBtnClick:(id)sender {
    LRegisterViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"LRegisterViewController"];
    VC.isRegister = NO;
    VC.shouldNavigationBarHidden = YES;
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)getCodeBtnClick:(UIButton *)sender {
    if (![XSTools checkMobileWith:self.code_mobileTF.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确手机号"];
        return;
    }
    [SVProgressHUD showWithStatus:@"发送中"];
    [[APIManager getInstance] getMobileAuthWithMobile:self.code_mobileTF.text callback:^(BOOL success, id  _Nonnull resule) {
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



#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.code_mobileTF) {
        if (range.location >= 11) {
            return NO;
        }else{
            return YES;
        }
    }else if (textField == self.password_passwordTF){
        if (range.location >= 20) {
            return NO;
        }else{
            return YES;
        }
    }else if (textField == self.password_mobileTF){
        if (range.location >= 11) {
            return NO;
        }else{
            return YES;
        }
    }else if (textField == self.code_codeTF){
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
    NSLog(@"%@----%@",resp.jsonResponse[@"nickname"],resp.message);
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
            NSString *open_name = result[@"nickname"];
            [SVProgressHUD showWithStatus:@"登录中"];
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
                        vc.open_name = open_name;
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
    __weak typeof(self)weakSelf = self;
    [SVProgressHUD showWithStatus:@"登录中"];
    [[APIManager getInstance] getWBUserWithAccess_token:sender.object[@"access_token"] uid:[NSString stringWithFormat:@"%@",sender.object[@"uid"]] callback:^(BOOL success, id  _Nonnull data) {
        if (success) {
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
        }else{
            [SVProgressHUD showErrorWithStatus:data];
        }
    }];
    
    
    
}
@end
