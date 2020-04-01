//
//  LSetViewController.m
//  langge
//
//  Created by samlee on 2019/4/2.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LSetViewController.h"
#import "LAccountManagermentController.h"
#import "LAboutMeViewController.h"
#import "LMsgSetViewController.h"
#import "JPUSHService.h"

@interface LSetViewController ()

- (IBAction)logoutBtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *cacheLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation LSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = barItem;
    barItem.title = @"";
    self.title = @"设置中心";
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    NSUInteger bytesCache = [[SDImageCache sharedImageCache] getSize];
    //换算成 MB (注意iOS中的字节之间的换算是1000不是1024)
    float MBCache = bytesCache/1000/1000;
    self.cacheLabel.text = [NSString stringWithFormat:@"%.2fMB",MBCache];

    self.versionLabel.text = [NSString stringWithFormat:@"V%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        [self accountManagermentClick];
    }else if (indexPath.row == 1){
        //给老实好评
        NSString *str = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa /wa/viewContentsUserReviews?type=Purple+Software&id=1460215256";
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:str]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }else{
            NSString *str = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=1460215256";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
        }

    }else if (indexPath.row == 2){
        __weak typeof(self)weakSelf = self;
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showSuccessWithStatus:@"清理成功"];
                weakSelf.cacheLabel.text = @"0.00MB";
            });
        }];
        
    }else if (indexPath.row == 3){
        //消息设置
        LMsgSetViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LMsgSetViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 4){
        //关于我们
        LAboutMeViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LAboutMeViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 5){
        
    }
}

-(void)accountManagermentClick{
    if (![SingleTon getInstance].isLogin) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        [self.navigationController presentViewController:sb.instantiateInitialViewController animated:YES completion:nil];
        return;
    }
    
    
    LAccountManagermentController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LAccountManagermentController"];
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)logoutBtnClick:(id)sender {
    
    if (![SingleTon getInstance].isLogin) {
        [SVProgressHUD showErrorWithStatus:@"您还没有登录"];
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"要注销登录吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    __weak typeof(self)weakSelf = self;
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"退出账号" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            NSLog(@"rescode: %ld, \ntags: %@, \nalias: %@\n", (long)iResCode, @"tag" , iAlias);
        } seq:0];
        [[SingleTon getInstance] setUser_Tocken:@""];
        [SingleTon getInstance].user = nil;
        [SingleTon getInstance].isLogin = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginStatusChange" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updataUserInfo" object:nil];
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        [self.navigationController presentViewController:sb.instantiateInitialViewController animated:NO completion:^{
            [weakSelf.tabBarController setSelectedIndex:0];
            [weakSelf.navigationController popViewControllerAnimated:NO];
        }];
    }];
    [alert addAction:sure];
    [alert addAction:cancel];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
    
    
    
}


@end
