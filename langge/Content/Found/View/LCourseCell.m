//
//  LCourseCell.m
//  langge
//
//  Created by samlee on 2019/4/13.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LCourseCell.h"

@implementation LCourseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.headerImageView modifyWithcornerRadius:15 borderColor:nil borderWidth:0];
}
-(void)setCourse:(LCourseModel *)course{
    _course = course;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:course.cover_img_src] placeholderImage:[UIImage imageNamed:@"defalut_img"]];
}
@end
