//
//  LMedalCell.m
//  langge
//
//  Created by samlee on 2019/5/16.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LMedalCell.h"

@implementation LMedalCell
-(void)setMedal:(LMedalModel *)medal{
    _medal = medal;
    self.titlelabel.text = medal.name;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:medal.img] placeholderImage:[UIImage imageNamed:@"defalut_img"]];
    if ([medal.is_reach isEqualToString:@"1"]) {
        self.titlelabel.textColor = RGB(51, 51, 51);
    }else{
        self.titlelabel.textColor = RGB(153, 153, 153);
    }
}
@end
