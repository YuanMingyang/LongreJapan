//
//  LPrivacyPolicyView.m
//  langge
//
//  Created by yang on 2019/12/14.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LPrivacyPolicyView.h"
#import "UILabel+YBAttributeTextTapAction.h"

@interface LPrivacyPolicyView ()
@property(nonatomic,strong)NSTimer *timer;
@end

@implementation LPrivacyPolicyView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.contentView modifyWithcornerRadius:5 borderColor:nil borderWidth:0];
    [self.alertView modifyWithcornerRadius:5 borderColor:nil borderWidth:0];
    self.alertView.hidden = YES;
    
    NSString *showText = @"欢迎您使用日语助手！日语助手是由朗阁教育研发和运营的在线教育平台，我们通过《用户协议》和《隐私条款》帮助您了解我们收集、使用、储存和共享个人信息的情况，以及您享有的相关权利。\n\n您可通过阅读《用户协议》和《隐私条款》了解详细信息。\n\n如您同意,请点击‘’同意‘’开始接受我们的服务。";
    self.contentLabel.attributedText = [XSTools getAttributeWith:@[@"《用户协议》",@"《隐私条款》"] string:showText orginFont:14 orginColor:[UIColor darkGrayColor] attributeFont:14 attributeColor:RGB(251, 124, 118)];
    __weak typeof(self)weakSelf = self;
    [self.contentLabel yb_addAttributeTapActionWithStrings:@[@"用户协议",@"隐私条款"] tapClicked:^(UILabel *label, NSString *string, NSRange range, NSInteger index) {
        if (index == 0) {
            weakSelf.readBlock(1);
        }else if (index == 1){
            weakSelf.readBlock(2);
        }
    }];
}

- (IBAction)cancelBtnClick:(UIButton *)sender {
    if (self.alertView.hidden==NO) {
        return;
    }
    self.alertView.hidden = NO;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(hidenAlert) userInfo:nil repeats:NO];
}
-(void)hidenAlert{
    self.alertView.hidden = YES;
}

- (IBAction)sureBtnClick:(UIButton *)sender {
    self.closeBlock();
}
@end
