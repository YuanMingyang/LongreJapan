//
//  LTResultShareAlertView.m
//  langge
//
//  Created by yang on 2019/10/8.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LTResultShareAlertView.h"

@implementation LTResultShareAlertView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.tipLabel modifyWithcornerRadius:13 borderColor:nil borderWidth:0];
    [self.contentView modifyWithcornerRadius:15 borderColor:nil borderWidth:0];
    self.bjView.hidden = YES;
}

-(void)setResultData:(NSDictionary *)resultData{
    _resultData = resultData;
    NSString *imageName = [NSString stringWithFormat:@"star%@",resultData[@"star"]];
    self.starImageView.image = [UIImage imageNamed:imageName];
    self.scoreLabel.text = resultData[@"score"];
    self.tipLabel.text = resultData[@"tip"];
    [self.qrcodeImageView sd_setImageWithURL:[NSURL URLWithString:resultData[@"qrcode_src"]] placeholderImage:[UIImage imageNamed:@"defalut_img"]];
}


- (IBAction)shareBtnClick:(UIButton *)sender {
    self.shareBlock(sender.tag);
}
- (IBAction)closeBtnClick:(UIButton *)sender {
    self.closeBlock();
}
@end
