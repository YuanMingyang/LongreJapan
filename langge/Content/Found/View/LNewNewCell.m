//
//  LNewNewCell.m
//  langge
//
//  Created by samlee on 2019/4/14.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LNewNewCell.h"

@implementation LNewNewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setNews:(LNewsModel *)news{
    _news = news;
    self.titleLabel.text = news.title;
    [self.headerIamgeView sd_setImageWithURL:[NSURL URLWithString:news.cover_img_src] placeholderImage:[UIImage imageNamed:@"defalut_img"]];
    self.look_countLabel.text = news.look_count;
    self.createTimeLabel.text = [XSTools time_timestampToString:news.create_time];
}

@end
