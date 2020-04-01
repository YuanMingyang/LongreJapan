//
//  LHotNewCell.m
//  langge
//
//  Created by samlee on 2019/4/14.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LHotNewCell.h"

@implementation LHotNewCell
-(void)setNews:(LNewsModel *)news{
    _news = news;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:news.cover_img_src] placeholderImage:[UIImage imageNamed:@"defalut_img"]];
    self.titleLabel.text = news.title;
    self.lookNumLabel.text = news.look_count;
    self.dateLabel.text = [XSTools time_timestampToString:news.create_time];
}
@end
