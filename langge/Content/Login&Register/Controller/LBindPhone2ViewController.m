//
//  LBindPhone2ViewController.m
//  langge
//
//  Created by samlee on 2019/3/22.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LBindPhone2ViewController.h"
#import "UIRoundButton.h"
#import "LAddInfoViewController.h"

@interface LBindPhone2ViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIRoundButton *submitBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
- (IBAction)submitBtnClick:(id)sender;

@end

@implementation LBindPhone2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
    self.title = @"绑定手机";
    self.submitBtn.enabled = NO;
    self.submitBtn.backgroundColor = RGB(153, 153,153);
    [self.phoneTF addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingChanged];
    self.phoneLabel.text = [@"+86  " stringByAppendingString:[self.mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"]];
    
    self.phoneTF.delegate = self;
}

-(void)textField1TextChange:(UITextField *)textField{
    if (self.phoneTF.text.length>0) {
        self.submitBtn.enabled = YES;
        self.submitBtn.backgroundColor = RGB(255, 184,73);
    }else{
        self.submitBtn.enabled = NO;
        self.submitBtn.backgroundColor = RGB(153, 153,153);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.location>=6) {
        return NO;
    }else{
        return YES;
    }
}

- (IBAction)submitBtnClick:(id)sender {
    if (self.phoneTF.text.length==0) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        return;
    }
    [SVProgressHUD showWithStatus:@"提交中"];
    __weak typeof(self)weakSelf = self;
    [[APIManager getInstance] CustomerLoginWithMobile:self.mobile sms_code:self.phoneTF.text open_id:self.open_id open_name:self.open_name type_open:self.type_open callback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            [SVProgressHUD dismiss];
            if ([result[@"type"] isEqualToString:@"1"]) {
                [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
            }else{
                LAddInfoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LAddInfoViewController"];
                vc.shouldNavigationBarHidden = YES;
                if (self.open_name) {
                    vc.open_nick_name = self.open_name;
                }
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:result];
        }
    }];
}
@end
