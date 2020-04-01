//
//  LAfterLoginController.m
//  langge
//
//  Created by samlee on 2019/3/20.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LAfterLoginController.h"
#import "LLoginViewController.h"
#import "LRegisterViewController.h"
#import "LBindPhoneViewController.h"
#import "LAddInfoViewController.h"

@interface LAfterLoginController ()
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)loginBtnClick:(UIButton *)sender;
- (IBAction)registerBtnClick:(UIButton *)sender;
- (IBAction)notLoginBtnClick:(UIButton *)sender;

@end

@implementation LAfterLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shouldNavigationBarHidden = YES;
    
    
    
    [self setUI];
}

-(void)setUI{
    [self.loginBtn modifyWithcornerRadius:20 borderColor:[UIColor whiteColor] borderWidth:0.5];
    [self.registerBtn modifyWithcornerRadius:20 borderColor:nil borderWidth:0];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = barItem;
    barItem.title = @"";
}


#pragma mark -- action

- (IBAction)loginBtnClick:(UIButton *)sender {
    LLoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LLoginViewController"];
    vc.shouldNavigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)registerBtnClick:(UIButton *)sender {
    LRegisterViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LRegisterViewController"];
    vc.isRegister = YES;
    vc.shouldNavigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)notLoginBtnClick:(UIButton *)sender {
    
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}
@end
