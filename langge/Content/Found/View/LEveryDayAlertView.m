//
//  LEveryDayAlertView.m
//  langge
//
//  Created by samlee on 2019/4/14.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LEveryDayAlertView.h"

@implementation LEveryDayAlertView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.heightConstraint.constant = (ScreenHeight-600)/2;
    [self.bjImageView modifyWithcornerRadius:15 borderColor:nil borderWidth:0];
    [[APIManager getInstance] getQRCodeWithCallback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            [self.qrImageView sd_setImageWithURL:[NSURL URLWithString:result] placeholderImage:[UIImage imageNamed:@"defalut_img"]];
            self.qrImageView.image = [XSTools base64ToImageWith:result];
        }else{
            [SVProgressHUD showErrorWithStatus:result];
        }
    }];
}
-(void)setDaily:(LDailySentenceModel *)daily{
    _daily = daily;//2019-10-19
    self.comfromLabel.text = [NSString stringWithFormat:@"《%@》",daily.come_from];
    self.japanLabel.text = daily.ja_string;
    self.chinaLabel.text = daily.cn_string;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:daily.cover_img_src] placeholderImage:[UIImage imageNamed:@"defalut_img"]];
    NSString *currentDate = [XSTools getCurrentDateStr];
    self.dayLabel.text = [currentDate substringFromIndex:8];
    self.dateLabel.text= [[currentDate substringToIndex:7] stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    self.weakLabel.text = [XSTools getweekDayStringWithDate:[NSDate date]];
}
- (IBAction)shareBtnClick:(UIButton *)sender {
    self.selectClickBlock(sender.tag-100);
}

- (IBAction)closeBtnClick:(UIButton *)sender {
    self.selectClickBlock(6);
}
@end
