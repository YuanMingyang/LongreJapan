//
//  LAddInfoViewController.m
//  langge
//
//  Created by samlee on 2019/3/21.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LAddInfoViewController.h"
#import "UILabel+YBAttributeTextTapAction.h"
#import "LListAlertView.h"
#import "WPAlertControl.h"
#import "LClauseViewController.h"
@interface LAddInfoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UITextField *nicknameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UILabel *protocolLabel;
- (IBAction)changeAvatarBtnClick:(UIButton *)sender;
- (IBAction)submitBtnClick:(UIButton *)sender;
- (IBAction)hidenPasswordBtnClick:(UIButton *)sender;
- (IBAction)backBtnClick:(UIButton *)sender;

@property(nonatomic,strong)UIImage *selectImage;
@end

@implementation LAddInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self setUI];
}

-(void)setUI{
    
    if (self.open_nick_name) {
        self.nicknameTF.text = self.open_nick_name;
    }
    
    self.heightConstraint.constant = ScreenHeight-20;
    self.widthConstraint.constant = ScreenWidth;
    [self.submitBtn modifyWithcornerRadius:20 borderColor:nil borderWidth:0];
    [self.avatarImageView modifyWithcornerRadius:45 borderColor:nil borderWidth:0];
    [self.nicknameTF addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTF addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingChanged];
    [self.emailTF addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingChanged];
    self.passwordTF.delegate = self;
    self.submitBtn.enabled = NO;
    self.submitBtn.backgroundColor = RGB(153, 153,153);
    NSString *showText = @"注册代表同意 用户协议 和 隐私条款 ";
    self.protocolLabel.attributedText = [XSTools getAttributeWith:@[@"用户协议",@"隐私条款"] string:showText orginFont:12 orginColor:[UIColor darkGrayColor] attributeFont:12 attributeColor:RGB(251, 124, 118)];
    __weak typeof(self)weakSelf = self;
    [self.protocolLabel yb_addAttributeTapActionWithStrings:@[@"用户协议",@"隐私条款"] tapClicked:^(UILabel *label, NSString *string, NSRange range, NSInteger index) {
        if (index == 0) {
            NSLog(@"点击了用户协议");
            [weakSelf openClauseWithType:@"1"];
        }else if (index == 1){
            NSLog(@"点击了隐私条款");
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

-(void)textField1TextChange:(UITextField *)textField{
    if (self.nicknameTF.text.length>0&&self.passwordTF.text.length>0) {
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

#pragma mark -- action

- (IBAction)changeAvatarBtnClick:(UIButton *)sender{
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择" preferredStyle:UIAlertControllerStyleActionSheet];
//    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//    imagePicker.delegate = self;
//    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//        [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
//    }];
//    UIAlertAction *library = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
//    }];
//    [alert addAction:camera];
//    [alert addAction:library];
//    [self.navigationController presentViewController:alert animated:YES completion:nil];
    
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    
    LListAlertView *alert = [[NSBundle mainBundle] loadNibNamed:@"LListAlertView" owner:nil options:nil].firstObject;
    CGFloat height = 0;
    if (KIsiPhoneX) {
        height = 34;
    }
    alert.frame = CGRectMake(0, 0, ScreenWidth, 150+height);
    __weak typeof(self)weakSelf = self;
    alert.clickBlock = ^(NSInteger index) {
        
        if (index==0) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }else{
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController presentViewController:imagePicker animated:YES completion:nil];
        });
        [WPAlertControl alertHiddenForRootControl:weakSelf completion:nil];
    };
    [alert configWith:@"请选择照片来源" items:@[@"打开相机",@"从手机相册获取"]];
    [WPAlertControl alertForView:alert begin:WPAlertBeginBottem end:WPAlertEndBottem animateType:WPAlertAnimateBounce constant:0 animageBeginInterval:0.3 animageEndInterval:0.3 maskColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] pan:YES rootControl:self mackClick:nil animateStatus:nil];
}

- (IBAction)submitBtnClick:(UIButton *)sender {
    if (self.nicknameTF.text.length<2||self.nicknameTF.text.length>8) {
        [SVProgressHUD showErrorWithStatus:@"请输入长度2-8字符的昵称"];
        return;
    }
    if (self.passwordTF.text.length<6||self.nicknameTF.text.length>20) {
        [SVProgressHUD showErrorWithStatus:@"请输入长度6-20字符的密码"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"user_token"] = [[SingleTon getInstance] getUser_tocken];
    
    dic[@"nick_name"] = self.nicknameTF.text;
    dic[@"user_password"] = self.passwordTF.text;
    if (self.emailTF.text.length>0) {
        if ([XSTools checkEmailWith:self.emailTF.text]) {
            dic[@"user_email"] = self.emailTF.text;
        }else{
            [SVProgressHUD showErrorWithStatus:@"邮箱格式不正确"];
            return;
        }
    }
    if (self.selectImage) {
        dic[@"user_img_src"] = [XSTools imageToBase64With:self.avatarImageView.image];
    }
    [SVProgressHUD showWithStatus:@"提交中"];
    [[APIManager getInstance] saveUserInfoWithParam:dic callback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            [SVProgressHUD showSuccessWithStatus:@"注册成功"];
            //设置成功了刷新一下user
            [[APIManager getInstance] getUserInfoWithCallback:^(BOOL success, id  _Nonnull result) {
                if (success) {
                    
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                }else{
                    [SVProgressHUD showErrorWithStatus:result];
                }
            }];
        }else{
            [SVProgressHUD showErrorWithStatus:result];
        }
    }];
}

- (IBAction)hidenPasswordBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.passwordTF.secureTextEntry = !self.passwordTF.secureTextEntry;
}

- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -- UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    UIImage *newImage = [info objectForKey:UIImagePickerControllerEditedImage];
    self.avatarImageView.image = newImage;
    self.selectImage = newImage;
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
