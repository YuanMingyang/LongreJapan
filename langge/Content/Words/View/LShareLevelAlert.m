//
//  LShareLevelAlert.m
//  langge
//
//  Created by samlee on 2019/6/23.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LShareLevelAlert.h"

@implementation LShareLevelAlert


-(void)awakeFromNib{
    [super awakeFromNib];
    self.bjView.hidden = YES;
    [self.shareView modifyWithcornerRadius:15 borderColor:nil borderWidth:0];
    [self.avatarImageView modifyWithcornerRadius:45 borderColor:nil borderWidth:0];
}

-(void)setData:(NSDictionary *)data{
    _data = data;
    self.avatarImageView.image = [XSTools base64ToImageWith:data[@"shareData"][@"user_img_src"]];
    [self.QRImageView sd_setImageWithURL:[NSURL URLWithString:data[@"shareData"][@"qrcode_src"]] placeholderImage:[UIImage imageNamed:@"defalut_img"]];
    [self.medalImageView sd_setImageWithURL:[NSURL URLWithString:[SingleTon getInstance].user.user_medal[@"img"]] placeholderImage:[UIImage imageNamed:@"defalut_img"]];
    self.nicknameLabel.text = data[@"shareData"][@"nick_name"];
    self.levelLabel.text = [NSString stringWithFormat:@"朗阁日语词汇第%@关顺利通过",data[@"level"]];
    self.rankingLabel.text = data[@"shareData"][@"areaMessage"];
}

- (IBAction)shareBtnClick:(UIButton *)sender {
    self.selectBlock(sender.tag-100);
}

- (IBAction)closeBtnClick:(UIButton *)sender {
    self.selectBlock(0);
}
@end
