//
//  UIView+Modify.m
//  开普拓
//
//  Created by A589 on 2016/12/14.
//  Copyright © 2016年 A589. All rights reserved.
//

#import "UIView+Modify.h"

@implementation UIView (Modify)
-(void)modifyWithcornerRadius:(CGFloat)cornerRadius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth{
    if (cornerRadius) {
        self.layer.cornerRadius = cornerRadius;
    }
    if (borderColor) {
        self.layer.borderColor = borderColor.CGColor;
    }
    if (borderWidth) {
        self.layer.borderWidth = borderWidth;
    }
    self.layer.masksToBounds = YES;
}
@end
