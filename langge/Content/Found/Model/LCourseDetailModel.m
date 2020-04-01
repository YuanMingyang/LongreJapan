//
//  LCourseDetailModel.m
//  langge
//
//  Created by samlee on 2019/4/27.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LCourseDetailModel.h"

@implementation LCourseDetailModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"courseinfo"]) {
        LCourseModel *course = [LCourseModel new];
        [course setValuesForKeysWithDictionary:value];
        self.course_info = course;
    }else if ([key isEqualToString:@"class_hour_list"]){
        NSArray *hour_list = (NSArray *)value;
        NSMutableArray *mutableArray = [NSMutableArray array];
        for (NSDictionary *dic in hour_list) {
            LCourseClassHourModel *classHour = [LCourseClassHourModel new];
            [classHour setValuesForKeysWithDictionary:dic];
            [mutableArray addObject:classHour];
        }
        self.course_class_hour_list = mutableArray;
    }else if ([key isEqualToString:@"comment_list"]){
        NSArray *commeng_list = (NSArray *)value;
        NSMutableArray *mutableArray = [NSMutableArray array];
        for (NSDictionary *dic in commeng_list) {
            LCourseCommentModel *comment = [LCourseCommentModel new];
            [comment setValuesForKeysWithDictionary:dic];
            [mutableArray addObject:comment];
        }
        self.course_comment_list = mutableArray;
    }
}
@end
