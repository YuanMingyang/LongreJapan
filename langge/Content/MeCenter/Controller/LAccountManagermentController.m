//
//  LAccountManagermentController.m
//  langge
//
//  Created by samlee on 2019/4/2.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LAccountManagermentController.h"
#import "LBindingPhoneViewController.h"
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"
#import "WechatAuthSDK.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "sdkCall.h"

@interface LAccountManagermentController ()<WXApiManagerDelegate,WechatAuthAPIDelegate>
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *wechatLabel;
@property (weak, nonatomic) IBOutlet UILabel *qqLabel;
@property (weak, nonatomic) IBOutlet UILabel *sinaLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;
@property (weak, nonatomic) IBOutlet UIButton *qqBtn;
@property (weak, nonatomic) IBOutlet UIButton *sinaBtn;
- (IBAction)phoneBtnClick:(id)sender;
- (IBAction)wechatBtnClick:(id)sender;
- (IBAction)qqBtnClick:(id)sender;
- (IBAction)sinaBtnClick:(id)sender;

@property(nonatomic,strong)NSString *qq_open_id;

@end

@implementation LAccountManagermentController

- (void)viewDidLoad {
    [super viewDidLoad];
    [sdkCall getinstance];
    [self setUI];
}
-(void)setUI{
    
    
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = barItem;
    barItem.title = @"";
    self.title = @"账号管理";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessed) name:kLoginSuccessed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfoSuccessed:) name:kGetUserInfoResponse object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataMobile) name:@"updataMobile" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WeiBoAuthSuccess:) name:@"WeiBoAuthSuccess" object:nil];
    
    [self.qqBtn modifyWithcornerRadius:13 borderColor:nil borderWidth:0];
    [self.sinaBtn modifyWithcornerRadius:13 borderColor:nil borderWidth:0];
    
    self.phoneLabel.text =[SingleTon getInstance].user.user_mobile;
    [self.phoneBtn modifyWithcornerRadius:13 borderColor:RGB(255, 184, 73) borderWidth:1];
    [self.phoneBtn setTitle:@"更换" forState:UIControlStateNormal];
    
    if ([SingleTon getInstance].user.weixin_open_id&&[SingleTon getInstance].user.weixin_open_id.length>0) {
        [self.wechatBtn modifyWithcornerRadius:13 borderColor:RGB(255, 184, 73) borderWidth:1];
        [self.wechatBtn setTitle:@"解绑" forState:UIControlStateNormal];
        self.wechatLabel.text = [SingleTon getInstance].user.weixin_open_name;
        self.wechatBtn.backgroundColor = [UIColor whiteColor];
        [self.wechatBtn setTitleColor:RGB(255, 184, 73) forState:UIControlStateNormal];
    }else{
        [self.wechatBtn modifyWithcornerRadius:13 borderColor:nil borderWidth:0];
        [self.wechatBtn setTitle:@"绑定" forState:UIControlStateNormal];
        [self.wechatBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.wechatLabel.text = [SingleTon getInstance].user.weixin_open_name;
        self.wechatBtn.backgroundColor = RGB(255, 184, 73);
    }
    
    if ([SingleTon getInstance].user.qq_open_id&&[SingleTon getInstance].user.qq_open_id.length>0) {
        [self.qqBtn modifyWithcornerRadius:13 borderColor:RGB(255, 184, 73) borderWidth:1];
        [self.qqBtn setTitle:@"解绑" forState:UIControlStateNormal];
        self.qqBtn.backgroundColor = [UIColor whiteColor];
        
        self.qqLabel.text = [SingleTon getInstance].user.qq_open_name;
        [self.qqBtn setTitleColor:RGB(255, 184, 73) forState:UIControlStateNormal];
    }else{
        [self.qqBtn modifyWithcornerRadius:13 borderColor:nil borderWidth:0];
        [self.qqBtn setTitle:@"绑定" forState:UIControlStateNormal];
        self.qqBtn.backgroundColor = RGB(255, 184, 73);
        self.qqLabel.text = [SingleTon getInstance].user.qq_open_name;
        [self.qqBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    if ([SingleTon getInstance].user.sina_open_id&&[SingleTon getInstance].user.sina_open_name.length>0) {
        [self.sinaBtn modifyWithcornerRadius:13 borderColor:RGB(255, 184, 73) borderWidth:1];
        [self.sinaBtn setTitle:@"解绑" forState:UIControlStateNormal];
        self.sinaBtn.backgroundColor = [UIColor whiteColor];
        
        self.sinaLabel.text = [SingleTon getInstance].user.sina_open_name;
        [self.sinaBtn setTitleColor:RGB(255, 184, 73) forState:UIControlStateNormal];
    }else{
        [self.sinaBtn modifyWithcornerRadius:13 borderColor:nil borderWidth:0];
        [self.sinaBtn setTitle:@"绑定" forState:UIControlStateNormal];
        self.sinaBtn.backgroundColor = RGB(255, 184, 73);
        self.sinaLabel.text = [SingleTon getInstance].user.sina_open_name;
        [self.sinaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

-(void)updataMobile{
    self.phoneLabel.text = [SingleTon getInstance].user.user_mobile;
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


- (IBAction)phoneBtnClick:(id)sender {
    LBindingPhoneViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"LBindingPhoneViewController"];
    
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)wechatBtnClick:(id)sender {
    if ([SingleTon getInstance].user.weixin_open_id&&[SingleTon getInstance].user.weixin_open_id.length>0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"真的要解绑吗?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        __weak typeof(self)wealSelf = self;
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"解绑" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [[APIManager getInstance] bindingWithMark:@"weixin_open_id" value:[SingleTon getInstance].user.weixin_open_id  type:@"2" name:[SingleTon getInstance].user.weixin_open_name callback:^(BOOL success, id  _Nonnull result) {
                if (success) {
                    [SingleTon getInstance].user.weixin_open_id = @"";
                    [wealSelf.wechatBtn modifyWithcornerRadius:13 borderColor:nil borderWidth:0];
                    [wealSelf.wechatBtn setTitle:@"绑定" forState:UIControlStateNormal];
                    wealSelf.wechatBtn.backgroundColor = RGB(255, 184, 73);
                    [wealSelf.wechatBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    wealSelf.wechatLabel.text = @"";
                    [SVProgressHUD showSuccessWithStatus:result];
                }else{
                    [SVProgressHUD showErrorWithStatus:result];
                }
            }];
        }];
        [alert addAction:cancel];
        [alert addAction:sure];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
        
        
        
    }else{
        
        
        
        [WXApiManager sharedManager].delegate = self;
        [WXApiRequestHandler sendAuthRequestScope: @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact"
                                            State:@"xxx"
                                           OpenID:@"0c806938e2413ce73eef92cc3"
                                 InViewController:self];
        
    }
}

- (IBAction)qqBtnClick:(id)sender {
    if ([SingleTon getInstance].user.qq_open_id&& [SingleTon getInstance].user.qq_open_id.length>0) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"真的要解绑吗?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        __weak typeof(self)weakSelf = self;
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"解绑" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [[APIManager getInstance] bindingWithMark:@"qq_open_id" value:[SingleTon getInstance].user.qq_open_id type:@"2" name:[SingleTon getInstance].user.qq_open_name callback:^(BOOL success, id  _Nonnull result) {
                if (success) {
                    [SingleTon getInstance].user.qq_open_id = @"";
                    [weakSelf.qqBtn modifyWithcornerRadius:13 borderColor:nil borderWidth:0];
                    [weakSelf.qqBtn setTitle:@"绑定" forState:UIControlStateNormal];
                    weakSelf.qqBtn.backgroundColor = RGB(255, 184, 73);
                    weakSelf.qqLabel.text = @"";
                    [weakSelf.qqBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [SVProgressHUD showSuccessWithStatus:result];
                }else{
                    [SVProgressHUD showErrorWithStatus:result];
                }
            }];
        }];
        [alert addAction:cancel];
        [alert addAction:sure];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
        
        
        
    }else{
        
        
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

- (IBAction)sinaBtnClick:(id)sender {
    if ([SingleTon getInstance].user.sina_open_id&&[SingleTon getInstance].user.sina_open_id.length>0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"真的要解绑吗?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        __weak typeof(self)wealSelf = self;
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"解绑" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [[APIManager getInstance] bindingWithMark:@"sina_open_id" value:[SingleTon getInstance].user.sina_open_id  type:@"2" name:[SingleTon getInstance].user.sina_open_name callback:^(BOOL success, id  _Nonnull result) {
                if (success) {
                    [SingleTon getInstance].user.sina_open_id = @"";
                    [wealSelf.sinaBtn modifyWithcornerRadius:13 borderColor:nil borderWidth:0];
                    [wealSelf.sinaBtn setTitle:@"绑定" forState:UIControlStateNormal];
                    wealSelf.sinaBtn.backgroundColor = RGB(255, 184, 73);
                    [wealSelf.sinaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    wealSelf.sinaLabel.text = @"";
                    [SVProgressHUD showSuccessWithStatus:result];
                }else{
                    [SVProgressHUD showErrorWithStatus:result];
                }
            }];
        }];
        [alert addAction:cancel];
        [alert addAction:sure];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
        
        
        
    }else{
        if (![WeiboSDK isWeiboAppInstalled]) {
            [SVProgressHUD showErrorWithStatus:@"您还没安装微博客户端"];
            return;
        }
        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
        request.redirectURI = kRedirectURI;
        request.scope = @"all";
        [WeiboSDK sendRequest:request];
        
    }
}




#pragma mark -- WXApiManagerDelegate

- (void)managerDidRecvAuthResponse:(SendAuthResp *)response {
    
    [self getWXAccess_tokenWithCode:response.code];
}

/** 获取微信token */
-(void)getWXAccess_tokenWithCode:(NSString *)code{
    __weak typeof(self)weakSelf = self;
    [SVProgressHUD showWithStatus:@"加载中"];
    [[APIManager getInstance] getWXAccessTokenWithCode:code callback:^(BOOL success, id  _Nonnull resule) {
        if (success) {
            //resule[@"openid"]
            [self getWXUserInfoWithData:resule];
        }else{
            [SVProgressHUD showErrorWithStatus:resule];
        }
    }];
}


/** 获取微信信息 */
-(void)getWXUserInfoWithData:(NSDictionary *)data{
    __weak typeof(self)weakSelf = self;
    [[APIManager getInstance] getWXUserinfoWithToken:data[@"access_token"] openID:data[@"openid"] callback:^(BOOL success, id  _Nonnull result) {
        NSString *nickname = result[@"nickname"];
        if (success) {
            [SVProgressHUD showWithStatus:@"绑定中"];
            [[APIManager getInstance] bindingWithMark:@"weixin_open_id" value:data[@"openid"] type:@"1" name:result[@"nickname"] callback:^(BOOL success, id  _Nonnull result) {
                if (success) {
                    [SingleTon getInstance].user.weixin_open_id = data[@"openid"];
                    [SingleTon getInstance].user.weixin_open_name = nickname;
                    [weakSelf.wechatBtn modifyWithcornerRadius:13 borderColor:RGB(255, 184, 73) borderWidth:1];
                    [weakSelf.wechatBtn setTitle:@"解绑" forState:UIControlStateNormal];
                    weakSelf.wechatBtn.backgroundColor = [UIColor whiteColor];
                    [weakSelf.wechatBtn setTitleColor:RGB(255, 184, 73) forState:UIControlStateNormal];
                    weakSelf.wechatLabel.text = nickname;
                    [SVProgressHUD showSuccessWithStatus:result];
                }else{
                    [SVProgressHUD showErrorWithStatus:result];
                }
            }];
        }else{
            [SVProgressHUD showErrorWithStatus:result];
        }
    }];
}


#pragma mark -- TencentSessionDelegate
-(void)loginSuccessed{
    NSLog(@"loginSuccessed");
    TencentOAuth *auth = [sdkCall getinstance].oauth;
    self.qq_open_id = auth.openId;
    [SVProgressHUD showWithStatus:@"登录中"];
    
    [auth getUserInfo];
    
    
    
}

-(void)getUserInfoSuccessed:(NSNotification *)sender{
    NSLog(@"getUserInfoSuccessed");
    APIResponse *resp = sender.userInfo[@"kResponse"];
    __weak typeof(self)weakSelf = self;
    [[APIManager getInstance] bindingWithMark:@"qq_open_id" value:self.qq_open_id type:@"1" name:resp.jsonResponse[@"nickname"] callback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            [SingleTon getInstance].user.qq_open_id = self.qq_open_id;
            [SingleTon getInstance].user.qq_open_name = resp.jsonResponse[@"nickname"];
            [weakSelf.qqBtn modifyWithcornerRadius:13 borderColor:RGB(255, 184, 73) borderWidth:1];
            [weakSelf.qqBtn setTitle:@"解绑" forState:UIControlStateNormal];
            weakSelf.qqBtn.backgroundColor = [UIColor whiteColor];
            [weakSelf.qqBtn setTitleColor:RGB(255, 184, 73) forState:UIControlStateNormal];
            weakSelf.qqLabel.text = resp.jsonResponse[@"nickname"];
            [SVProgressHUD showSuccessWithStatus:result];
        }else{
            [SVProgressHUD showErrorWithStatus:result];
        }
    }];
    
}

#pragma mark -- weibo
-(void)WeiBoAuthSuccess:(NSNotification *)sender{
    __weak typeof(self)weakSelf = self;
    
    [[APIManager getInstance] getWBUserWithAccess_token:sender.object[@"access_token"] uid:[NSString stringWithFormat:@"%@",sender.object[@"uid"]] callback:^(BOOL success, id  _Nonnull data) {
        [[APIManager getInstance] bindingWithMark:@"sina_open_id" value:[NSString stringWithFormat:@"%@",data[@"id"]] type:@"1" name:data[@"name"] callback:^(BOOL success, id  _Nonnull result) {
            if (success) {
                [SingleTon getInstance].user.sina_open_id = [NSString stringWithFormat:@"%@",data[@"id"]];
                [SingleTon getInstance].user.sina_open_name = data[@"name"];
                [weakSelf.sinaBtn modifyWithcornerRadius:13 borderColor:RGB(255, 184, 73) borderWidth:1];
                [weakSelf.sinaBtn setTitle:@"解绑" forState:UIControlStateNormal];
                weakSelf.sinaBtn.backgroundColor = [UIColor whiteColor];
                [weakSelf.sinaBtn setTitleColor:RGB(255, 184, 73) forState:UIControlStateNormal];
                weakSelf.sinaLabel.text = data[@"name"];
                [SVProgressHUD showSuccessWithStatus:result];
            }else{
                [SVProgressHUD showErrorWithStatus:result];
            }
        }];
    }];
    
    
    
}
@end
