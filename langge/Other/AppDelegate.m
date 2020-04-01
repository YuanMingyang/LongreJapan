//
//  AppDelegate.m
//  langge
//
//  Created by samlee on 2019/3/20.
//  Copyright © 2019 yang. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApiManager.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "sdkCall.h"
#import "JPUSHService.h"
#import <AVFoundation/AVFoundation.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()<JPUSHRegisterDelegate,WeiboSDKDelegate>
@property(nonatomic,strong)NSTimer *authTimer;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [SVProgressHUD setMinimumDismissTimeInterval:3];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    
    ///NavigationBar backgroundcolor【背景色】
    [[UINavigationBar appearance] setBarTintColor:RGB(250, 250, 250)];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName :[UIColor blackColor]};
    
    
    [WXApi startLogByLevel:WXLogLevelNormal logBlock:^(NSString *log) {
        NSLog(@"log : %@", log);
    }];
    [WXApi registerApp:WECHAT_APP_ID enableMTA:YES];
    //向微信注册支持的文件类型
    UInt64 typeFlag = MMAPP_SUPPORT_TEXT | MMAPP_SUPPORT_PICTURE | MMAPP_SUPPORT_LOCATION | MMAPP_SUPPORT_VIDEO |MMAPP_SUPPORT_AUDIO | MMAPP_SUPPORT_WEBPAGE | MMAPP_SUPPORT_DOC | MMAPP_SUPPORT_DOCX | MMAPP_SUPPORT_PPT | MMAPP_SUPPORT_PPTX | MMAPP_SUPPORT_XLS | MMAPP_SUPPORT_XLSX | MMAPP_SUPPORT_PDF;
    
    [WXApi registerAppSupportContentFlag:typeFlag];
    [sdkCall getinstance];

    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    } else {
        
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {

    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions appKey:J_PUSH_KEY
                          channel:nil
                 apsForProduction:false
            advertisingIdentifier:nil];
    
    
    
    [WeiboSDK enableDebugMode:YES];
    BOOL success = [WeiboSDK registerApp:WB_APPKEY];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if ([url.absoluteString rangeOfString:WECHAT_APP_ID].location!=NSNotFound) {
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    if ([url.absoluteString rangeOfString:QQ_APP_ID].location!=NSNotFound) {
         return [TencentOAuth HandleOpenURL:url];
    }
    
    if ([url.absoluteString rangeOfString:WB_APPKEY].location!=NSNotFound) {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([url.absoluteString rangeOfString:WECHAT_APP_ID].location!=NSNotFound) {
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    if ([url.absoluteString rangeOfString:QQ_APP_ID].location!=NSNotFound) {
        return [TencentOAuth HandleOpenURL:url];
    }
    if ([url.absoluteString rangeOfString:WB_APPKEY].location!=NSNotFound) {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {

}


- (void)applicationDidEnterBackground:(UIApplication *)application {

}


- (void)applicationWillEnterForeground:(UIApplication *)application {

}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    //[[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    
    if ([SingleTon getInstance].isShare) {
        [SVProgressHUD showSuccessWithStatus:@"分享成功"];
        [SingleTon getInstance].isShare = NO;
        
    }
    
    [self.authTimer invalidate];
    [[APIManager getInstance] getAuthWith:^(BOOL success, id  _Nonnull resule) {
        if (success) {
            NSLog(@"-----%@",resule);
        }else{
            NSLog(@"-----%@",resule);
        }
    }];
    self.authTimer = nil;
    self.authTimer=[NSTimer scheduledTimerWithTimeInterval:7200 target:self selector:@selector(getAuth) userInfo:nil repeats:YES];
}

-(void)getAuth{
    [[APIManager getInstance] getAuthWith:^(BOOL success, id  _Nonnull resule) {
        if (success) {
            NSLog(@"-----%@",resule);
        }else{
            NSLog(@"-----%@",resule);
        }
    }];
}

- (void)applicationWillTerminate:(UIApplication *)application {

}


#pragma mark- JPUSHRegisterDelegate

// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(nullable UNNotification *)notification NS_AVAILABLE_IOS(12.0){
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //从通知界面直接进入应用
    }else{
        //从通知设置界面进入应用
    }
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger options))completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
}


#pragma mark -- WeiboSDKDelegate

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class]) {
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"分享成功"];
        }
    }else if ([response isKindOfClass:WBAuthorizeResponse.class]){
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WeiBoAuthSuccess" object:response.userInfo];
        }else if (response.statusCode == WeiboSDKResponseStatusCodeAuthDeny){
            [SVProgressHUD showErrorWithStatus:@"微博授权失败"];
        }
    }
}

@end
