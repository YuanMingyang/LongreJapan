//
//  LStrokeSmallCell.m
//  langge
//
//  Created by samlee on 2019/4/17.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LStrokeSmallCell.h"

@implementation LStrokeSmallCell
-(void)awakeFromNib{
    [super awakeFromNib];
    [self.titleLabel modifyWithcornerRadius:0 borderColor:RGB(242, 242, 242) borderWidth:0.5];
}
@end
