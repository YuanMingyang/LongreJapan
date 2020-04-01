//
//  LFeedBackCell.m
//  langge
//
//  Created by samlee on 2019/5/2.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LFeedBackCell.h"

@implementation LFeedBackCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.isReplyLabel modifyWithcornerRadius:3 borderColor:nil borderWidth:0];
}

-(void)setFeedBack:(LFeedBackModel *)feedBack{
    _feedBack = feedBack;
    self.user_suggestLabel.text = feedBack.user_suggest;
    self.dateLabel.text = [XSTools time_timestampToString:feedBack.create_time];
    NSString *is_reply = [NSString stringWithFormat:@"%@",feedBack.is_reply];
    if ([is_reply isEqualToString:@"0"]) {
        self.isReplyLabel.hidden = YES;
    }else{
        self.isReplyLabel.hidden = NO;
    }
}

@end
