//
//  LSubmitViewController.m
//  langge
//
//  Created by samlee on 2019/4/1.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LSubmitViewController.h"

@interface LSubmitViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property(nonatomic,assign)NSUInteger count;
@end

@implementation LSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"right"] style:UIBarButtonItemStylePlain target:self action:@selector(submitBtnClick)];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick)];
    self.navigationItem.rightBarButtonItem = right;
    self.navigationItem.leftBarButtonItem = left;
    
    [self.textField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    self.textField.delegate = self;

    
    self.title = self.titleStr;
    if (self.nickname) {
        self.textField.text = self.nickname;
    }
    self.count = 12 - self.textField.text.length;
    self.countLabel.text = [NSString stringWithFormat:@"%lu/12",(unsigned long)self.count];
}


#pragma mark 
-(void)textFieldTextChange:(UITextField *)textField{
    self.count = 12 - self.textField.text.length;
    self.countLabel.text = [NSString stringWithFormat:@"%lu/12",(unsigned long)self.count];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (self.count>0) {
        return YES;
    }else{
        return NO;
    }
}
#pragma mark -- action

-(void)submitBtnClick{
    if (self.textField.text.length==0) {
        [SVProgressHUD showErrorWithStatus:@"请输入"];
        return;
    }
    self.resultBlock(self.textField.text);
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)backBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
