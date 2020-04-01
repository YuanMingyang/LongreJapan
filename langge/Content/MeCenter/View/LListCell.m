//
//  LListCell.m
//  langge
//
//  Created by samlee on 2019/4/2.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LListCell.h"

@implementation LListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
-(void)setNews:(LNewsModel *)news{
    if (![news isKindOfClass:[LNewsModel class]]) {
        return;
    }
    _news = news;
    self.titleLabel.text = news.title;
    self.descLabel.text = news.desc;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:news.cover_img_src] placeholderImage:[UIImage imageNamed:@"defalut_img"]];
    self.lookCountLabel.text = news.look_count;
    self.createTimeLabel.text = [XSTools time_timestampToString:news.create_time];
}

@end
