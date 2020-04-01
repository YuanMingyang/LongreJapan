//
//  LSignCell.m
//  langge
//
//  Created by samlee on 2019/4/24.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LSignCell.h"

@implementation LSignCell

-(void)awakeFromNib{
    [super awakeFromNib];
    //self.contentView.backgroundColor = [UIColor greenColor];
    [self.isSignIcon modifyWithcornerRadius:2.5 borderColor:nil borderWidth:0];
    [self.dayLabel modifyWithcornerRadius:13 borderColor:nil borderWidth:0];
}

-(void)setSign:(LSignModel *)sign{
    _sign = sign;
    if (sign.isFill) {
        self.bjView.hidden = YES;
        self.isSignIcon.hidden = YES;
        self.dayLabel.hidden = YES;
        self.reciteNumLabel.hidden = YES;
        
    }else{
        self.bjView.hidden = NO;
        self.isSignIcon.hidden = NO;
        self.dayLabel.hidden = NO;
        self.reciteNumLabel.hidden = NO;
    }
    
    if (sign.is_sign) {
        self.isSignIcon.hidden = NO;
    }else{
        self.isSignIcon.hidden = YES;
    }
    
    if (sign.recite_num&&[sign.recite_num integerValue]>0) {
        self.reciteNumLabel.hidden = NO;
        self.reciteNumLabel.text = [NSString stringWithFormat:@"%@",sign.recite_num];
    }else{
        self.reciteNumLabel.hidden = YES;
    }
    
    if (!sign.is_continuity) {
        self.bjView.hidden = YES;
    }else{
        self.bjView.hidden = NO;
        if (sign.isHavaLast&&sign.isHaveNext) {
            
        }else{
            if (!sign.isHavaLast) {
                self.bjView.layer.mask = [self createMaskLaterWith:self.bjView direction:1];
            }
            if (!sign.isHaveNext) {
                self.bjView.layer.mask = [self createMaskLaterWith:self.bjView direction:2];
            }
        }
    }
    
    if ([sign.date isEqualToString:[XSTools getCurrentDateStr]]) {
        NSLog(@"%@======%@",sign.date,[XSTools getCurrentDateStr]);
        self.dayLabel.text = @"今";
        self.dayLabel.backgroundColor = RGB(251, 124, 118);
        self.dayLabel.textColor = [UIColor whiteColor];
    }else{
        self.dayLabel.text = [sign.date substringFromIndex:8];
        self.dayLabel.backgroundColor = [UIColor clearColor];
        self.dayLabel.textColor = RGB(51, 51, 15);
    }
}




//direction  1:左边圆   2:右边圆   //
-(CAShapeLayer *)createMaskLaterWith:(UIView *)view direction:(NSInteger)direction{
    CGSize size = view.bounds.size;
    CGFloat sizeWidth = (ScreenWidth-30)/7;
    UIBezierPath *path = [UIBezierPath bezierPath];
    if (direction == 1) {
        [path moveToPoint:CGPointMake(size.height/2, 0)];
        [path addLineToPoint:CGPointMake(sizeWidth, 0)];
        [path addLineToPoint:CGPointMake(sizeWidth, size.height)];
        [path addLineToPoint:CGPointMake(size.height/2, size.height)];
        [path addArcWithCenter:CGPointMake(size.height/2, size.height/2) radius:size.height/2 startAngle:M_PI_2 endAngle:M_PI_2+M_PI clockwise:YES];
        [path closePath];
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = path.CGPath;
        return layer;
    }else{
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(sizeWidth-size.height/2, 0)];
        [path addArcWithCenter:CGPointMake(sizeWidth-size.height/2, size.height/2) radius:size.height/2 startAngle:M_PI_2*-1 endAngle:M_PI_2 clockwise:YES];
        [path addLineToPoint:CGPointMake(0, size.height)];
        [path closePath];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = path.CGPath;
        return layer;
    }
}
@end
