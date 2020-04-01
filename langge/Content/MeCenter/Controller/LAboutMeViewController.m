//
//  LAboutMeViewController.m
//  langge
//
//  Created by yang on 2019/12/14.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LAboutMeViewController.h"
#import "UILabel+YBAttributeTextTapAction.h"
#import "LClauseViewController.h"

@interface LAboutMeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *versionlabel;
@property (weak, nonatomic) IBOutlet UILabel *protocolLabel;

@end

@implementation LAboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = barItem;
    barItem.title = @"";
    self.versionlabel.text = [NSString stringWithFormat:@"V%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    NSString *showText = @"登录即代表您已经阅读并同意《用户协议》和《隐私条款》";
    self.protocolLabel.attributedText = [XSTools getAttributeWith:@[@"《用户协议》",@"《隐私条款》"] string:showText orginFont:15 orginColor:[UIColor darkGrayColor] attributeFont:15 attributeColor:RGB(251, 124, 118)];
    __weak typeof(self)weakSelf = self;
    [self.protocolLabel yb_addAttributeTapActionWithStrings:@[@"《用户协议》",@"《隐私条款》"] tapClicked:^(UILabel *label, NSString *string, NSRange range, NSInteger index) {
        if (index == 0) {
            [weakSelf openClauseWithType:@"1"];
        }else if (index == 1){
            [weakSelf openClauseWithType:@"2"];
        }
    }];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
