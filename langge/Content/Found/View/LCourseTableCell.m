//
//  LCourseTableCell.m
//  langge
//
//  Created by samlee on 2019/4/14.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LCourseTableCell.h"

@implementation LCourseTableCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setCourse:(LCourseModel *)course{
    if (![course isKindOfClass:[LCourseModel class]]) {
        return;
    }
    _course = course;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:course.cover_img_src] placeholderImage:[UIImage imageNamed:@"defalut_img"]];
    self.titleLabel.text = course.title;
    self.hournumLabel.text = [NSString stringWithFormat:@"总课时数:%@",course.class_hour_num];
    self.priceLabel.text = course.price;
    self.byersNumLabel.text = [NSString stringWithFormat:@"%@人学习",course.buyers_num];
}

@end
