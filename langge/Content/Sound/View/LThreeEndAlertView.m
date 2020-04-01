//
//  LThreeEndAlertView.m
//  langge
//
//  Created by samlee on 2019/7/16.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LThreeEndAlertView.h"

@implementation LThreeEndAlertView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.bottomView.hidden = YES;
}

-(void)setQrcode_src:(NSString *)qrcode_src{
    _qrcode_src = qrcode_src;
    [self.qrCodeImageView sd_setImageWithURL:[NSURL URLWithString:qrcode_src] placeholderImage:[UIImage imageNamed:@"defalut_img"]];
}

- (IBAction)shareBtnClick:(UIButton *)sender {
    self.SelectBlock(sender.tag-100);
}

- (IBAction)closeBtnClick:(UIButton *)sender {
    self.closeBlock();
}
@end
