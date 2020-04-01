//
//  LTResultDialogAlertView.m
//  langge
//
//  Created by yang on 2019/10/8.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LTResultDialogAlertView.h"

@implementation LTResultDialogAlertView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.bjImageView modifyWithcornerRadius:15 borderColor:nil borderWidth:0];
    [self.tipLabel modifyWithcornerRadius:13 borderColor:nil borderWidth:0];
}

- (IBAction)closeBtnClick:(UIButton *)sender {
    self.closeBlock();
}

-(void)setResultData:(NSDictionary *)resultData{
    _resultData = resultData;
    NSString *imageName = [NSString stringWithFormat:@"star%@",resultData[@"star"]];
    self.starImageView.image = [UIImage imageNamed:imageName];
    self.scoreLabel.text = resultData[@"score"];
    self.tipLabel.text = resultData[@"tip"];
    
}
@end
