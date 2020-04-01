//
//  LPromotAlertView.m
//  langge
//
//  Created by samlee on 2019/4/21.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LPromotAlertView.h"

@implementation LPromotAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)closeBtnClick:(UIButton *)sender {
    [self removeFromSuperview];
}
@end
