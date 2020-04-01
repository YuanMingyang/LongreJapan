//
//  LResetViewController.m
//  langge
//
//  Created by samlee on 2019/3/20.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LResetViewController.h"

@interface LResetViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@property (weak, nonatomic) IBOutlet UITextField *firstPasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *secondPasswordTF;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
- (IBAction)submitBtnClick:(UIButton *)sender;
- (IBAction)backBtnClick:(UIButton *)sender;
- (IBAction)hidenPasswordBtnClick:(UIButton *)sender;

@end

@implementation LResetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
    self.heightConstraint.constant = ScreenHeight-20;
    self.widthConstraint.constant = ScreenWidth;
    self.submitBtn.enabled = NO;
    self.submitBtn.backgroundColor = RGB(153, 153,153);
    [self.firstPasswordTF addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingChanged];
    [self.secondPasswordTF addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.firstPasswordTF.delegate = self;
    self.secondPasswordTF.delegate = self;
}
-(void)textField1TextChange:(UITextField *)textField{
    if (self.firstPasswordTF.text.length>0&&self.secondPasswordTF.text.length>0) {
        self.submitBtn.enabled = YES;
        self.submitBtn.backgroundColor = RGB(255, 184,73);
    }else{
        self.submitBtn.enabled = NO;
        self.submitBtn.backgroundColor = RGB(153, 153,153);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.location >= 20) {
        return NO;
    }else{
        return YES;
    }
}


- (IBAction)submitBtnClick:(UIButton *)sender {
    if (self.firstPasswordTF.text.length<6||self.firstPasswordTF.text.length>20) {
        [SVProgressHUD showErrorWithStatus:@"请输入长度6-20字符的新密码"];
        return;
    }
    if (self.secondPasswordTF.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请重复输入密码"];
        return;
    }
    if (![self.firstPasswordTF.text isEqualToString:self.secondPasswordTF.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次输入密码不一致"];
        return;
    }
    [SVProgressHUD showWithStatus:@"提交中"];
    [[APIManager getInstance] restUserPasswordWithMobile:self.mobile userPassword:self.firstPasswordTF.text callback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            [SVProgressHUD dismiss];
            [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:result];
        }
    }];
}

- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)hidenPasswordBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.tag == 101) {
        self.firstPasswordTF.secureTextEntry = !self.firstPasswordTF.secureTextEntry;
    }else if (sender.tag == 102){
        self.secondPasswordTF.secureTextEntry = !self.secondPasswordTF.secureTextEntry;
    }
}
@end
