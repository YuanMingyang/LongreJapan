//
//  LWordCell.m
//  langge
//
//  Created by samlee on 2019/7/19.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LWordCell.h"

@implementation LWordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setWord:(LWordModel *)word{
    _word = word;
    self.titleLabel.text = word.ja_word;
    self.detailLabel.text = [NSString stringWithFormat:@"中文:%@；日语:%@",word.cn_explanation,word.ja_word];
}

@end
