//
//  LStudyToolCell.m
//  langge
//
//  Created by samlee on 2019/4/2.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LStudyToolCell.h"

@implementation LStudyToolCell


-(void)setStudyTool:(LStudyToolModel *)studyTool{
    _studyTool = studyTool;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:studyTool.img_src] placeholderImage:[UIImage imageNamed:@"defalut_img"]];
    self.titleLabel.text = studyTool.name;
    
}
@end
