//
//  LSystemMsgCell.m
//  langge
//
//  Created by samlee on 2019/4/2.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LSystemMsgCell.h"

@implementation LSystemMsgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.avatarImageView modifyWithcornerRadius:22 borderColor:nil borderWidth:0];
}

-(void)setSystemMsg:(LSystemMsgModel *)systemMsg{
    _systemMsg = systemMsg;
    self.titleLabel.text = systemMsg.sender;
    self.dateLabel.text = [XSTools time_timestampToString:systemMsg.create_time];
    self.countLabel.text = systemMsg.title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
