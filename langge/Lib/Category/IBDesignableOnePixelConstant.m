//
//  IBDesignableOnePixelConstant.m
//  talkmed
//
//  Created by shun on 16/8/5.
//  Copyright © 2016年 edoctor. All rights reserved.
//

#import "IBDesignableOnePixelConstant.h"

@implementation IBDesignableOnePixelConstant

- (void)setOnePixelConstant:(NSInteger)onePixelConstant
{
    _onePixelConstant = onePixelConstant;
    self.constant = onePixelConstant * 1.0 / [UIScreen mainScreen].scale;
}


@end
