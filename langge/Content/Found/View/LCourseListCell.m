//
//  LCourseListCell.m
//  langge
//
//  Created by samlee on 2019/4/16.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LCourseListCell.h"

@implementation LCourseListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.pointLabel modifyWithcornerRadius:3 borderColor:nil borderWidth:0];
}

-(void)setClassHour:(LCourseClassHourModel *)classHour{
    _classHour = classHour;
    self.titleLabel.text = classHour.title;
    if ([classHour.is_preview isEqualToString:@"1"]) {
        self.testLabel.hidden = NO;
        self.liveIcon.hidden = YES;
    }else{
        self.testLabel.hidden = YES;
        self.liveIcon.hidden = NO;
    }
    if ([classHour.is_select isEqualToString:@"1"]) {
        self.titleLabel.textColor = RGB(251, 124, 118);
        self.pointLabel.backgroundColor = RGB(251, 124, 118);
        [self.pointLabel modifyWithcornerRadius:3 borderColor:nil borderWidth:0];
        self.liveIcon.image = [UIImage imageNamed:@"live_icon_select"];
    }else{
        self.titleLabel.textColor = RGB(102, 102, 102);
        self.pointLabel.backgroundColor = [UIColor whiteColor];
        [self.pointLabel modifyWithcornerRadius:3 borderColor:RGB(102, 102, 102) borderWidth:0.5];
        self.liveIcon.image = [UIImage imageNamed:@"live_icon_normal"];
    }
    
    
}

@end
