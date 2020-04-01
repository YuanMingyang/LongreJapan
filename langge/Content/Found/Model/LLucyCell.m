//
//  LLucyCell.m
//  langge
//
//  Created by samlee on 2019/4/24.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LLucyCell.h"

@implementation LLucyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.isLookIcon modifyWithcornerRadius:5 borderColor:nil borderWidth:0];
}

-(void)setLucy:(LLucyModel *)lucy{
    _lucy = lucy;
    if ([lucy.is_look isEqualToString:@"1"]) {
        self.isLookIcon.hidden = YES;
    }else{
        self.isLookIcon.hidden = NO;
    }
    self.titleLabel.text = lucy.btitle;
    self.lucyLabel.text = [NSString stringWithFormat:@"中奖日期:%@",lucy.start_time];
    self.dateLabel.text = [NSString stringWithFormat:@"有效期至%@-%@止",lucy.start_time,lucy.end_time];
}

@end
