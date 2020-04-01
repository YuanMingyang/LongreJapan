//
//  LSelectTextCell.m
//  langge
//
//  Created by samlee on 2019/3/26.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LSelectTextCell.h"

@implementation LSelectTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.titleLabel modifyWithcornerRadius:10 borderColor:nil borderWidth:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
