//
//  LBindPhoneViewController.m
//  langge
//
//  Created by samlee on 2019/3/22.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LBindPhoneViewController.h"
#import "UIRoundButton.h"
#import "LBindPhone2ViewController.h"

@interface LBindPhoneViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
- (IBAction)submitBtnClick:(UIRoundButton *)sender;
@property (weak, nonatomic) IBOutlet UIRoundButton *submitBtn;

@end

@implementation LBindPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    
}

-(void)setUI{
    self.title = @"绑定手机";
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = barItem;
    barItem.title = @"";
    self.submitBtn.enabled = NO;
    self.submitBtn.backgroundColor = RGB(153, 153,153);
    [self.phoneTF addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingChanged];
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
    if (range.location>=11) {
        return NO;
    }else{
        return YES;
    }
}


- (IBAction)submitBtnClick:(UIRoundButton *)sender {
    if (![XSTools checkMobileWith:self.phoneTF.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }
    [SVProgressHUD showWithStatus:@"验证码发送中"];
    __weak typeof(self)weakSelf = self;
    [[APIManager getInstance] getMobileAuthWithMobile:self.phoneTF.text callback:^(BOOL success, id  _Nonnull resule) {
        if (success) {
            [SVProgressHUD dismiss];
            LBindPhone2ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LBindPhone2ViewController"];
            vc.open_id = self.open_id;
            vc.type_open = self.type_open;
            vc.mobile = self.phoneTF.text;
            vc.open_name = self.open_name;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:resule];
        }
    }];
}
@end
