//
//  LBindingPhoneViewController.m
//  langge
//
//  Created by samlee on 2019/4/3.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LBindingPhoneViewController.h"
#import "UIRoundButton.h"

@interface LBindingPhoneViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@property (weak, nonatomic) IBOutlet UILabel *statuslabel;
@property (weak, nonatomic) IBOutlet UIRoundButton *submitBtn;

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
- (IBAction)getCodeBtnClick:(id)sender;
- (IBAction)submitBtnClick:(UIRoundButton *)sender;
@property(nonatomic,strong)NSTimer *authTimer;
@property(nonatomic,assign)int codeSeconds;
@end

@implementation LBindingPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}

-(void)setUI{
    self.title = @"绑定新手机";
    self.widthConstraint.constant = ScreenWidth;
    self.heightConstraint.constant = ScreenHeight-StatusHeight-NaviHeight;
    [self.getCodeBtn modifyWithcornerRadius:15 borderColor:RGB(251, 124, 118) borderWidth:1];
    self.phoneTF.delegate = self;
    self.codeTF.delegate = self;
    [self.phoneTF addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingChanged];
    [self.codeTF addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingChanged];
    self.submitBtn.enabled = NO;
    self.submitBtn.backgroundColor = RGB(153, 153,153);
}

-(void)textField1TextChange:(UITextField *)textField{
    if (self.phoneTF.text.length>0&&self.codeTF.text.length>0) {
        self.submitBtn.enabled = YES;
        self.submitBtn.backgroundColor = RGB(255, 184,73);
    }else{
        self.submitBtn.enabled = NO;
        self.submitBtn.backgroundColor = RGB(153, 153,153);
    }
}


- (IBAction)getCodeBtnClick:(UIButton *)sender {
    if (![XSTools checkMobileWith:self.phoneTF.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确手机号"];
        return;
    }
    [SVProgressHUD showWithStatus:@"发送中"];
    [[APIManager getInstance] getMobileAuthWithMobile:self.phoneTF.text callback:^(BOOL success, id  _Nonnull resule) {
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


#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.phoneTF) {
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



- (IBAction)submitBtnClick:(UIRoundButton *)sender {
    [SVProgressHUD showWithStatus:@"绑定中"];
    __weak typeof(self)weakSelf = self;
    [[APIManager getInstance] validateVerifyCodeWithMobile:self.phoneTF.text sms_code:self.codeTF.text callback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            [[APIManager getInstance] bindingWithMark:@"user_mobile" value:weakSelf.phoneTF.text type:@"1" name:@"" callback:^(BOOL success, id  _Nonnull result) {
                if (success) {
                    [SVProgressHUD showSuccessWithStatus:result];
                    [SingleTon getInstance].user.user_mobile = weakSelf.phoneTF.text;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updataMobile" object:nil];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }else{
                    [SVProgressHUD showErrorWithStatus:result];
                }
            }];
        }else{
            [SVProgressHUD showErrorWithStatus:result];
        }
    }];
}

-(void)countdown{
    self.codeSeconds++;
    self.statuslabel.text = [NSString stringWithFormat:@"重新发送%ds",60-self.codeSeconds];
    if (self.codeSeconds == 60) {
        self.statuslabel.text = @"获取验证码";
        self.codeSeconds = 0;
        self.getCodeBtn.enabled = YES;
        [self.authTimer invalidate];
        self.authTimer = nil;
    }
}
@end
