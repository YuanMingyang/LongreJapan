//
//  LCourseClassHourModel.m
//  langge
//
//  Created by samlee on 2019/4/27.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LCourseClassHourModel.h"

@implementation LCourseClassHourModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self._id = value;
        
    }
}
@end
