//
//  UIRoundButton.m
//  jtbj
//
//  Created by Yang on 2018/6/5.
//  Copyright © 2018年 Yang. All rights reserved.
//

#import "UIRoundButton.h"

@implementation UIRoundButton

-(void)awakeFromNib{
    [super awakeFromNib];
    self.layer.cornerRadius = self.connerRound;
    self.layer.masksToBounds = YES;
}

@end
