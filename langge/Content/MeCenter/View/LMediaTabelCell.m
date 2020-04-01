//
//  LMediaTabelCell.m
//  langge
//
//  Created by samlee on 2019/5/16.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LMediaTabelCell.h"

@implementation LMediaTabelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setMedal:(LMedalModel *)medal{
    _medal = medal;
    self.nameLabel.text = medal.name;
    self.levelLanel.text = [NSString stringWithFormat:@"%@关",medal.level];
    self.wordCountLabel.text = [NSString stringWithFormat:@"%@个",medal.word_count];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
