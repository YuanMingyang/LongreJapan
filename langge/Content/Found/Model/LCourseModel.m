//
//  LCourseModel.m
//  langge
//
//  Created by samlee on 2019/4/18.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LCourseModel.h"

@implementation LCourseModel
//+ (JSONKeyMapper *)keyMapper {
//    LCourseModel *this;
//    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
//                                                                  @"id" : @keypath(this, _id)
//                                                                  }];
//}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self._id = value;
    }
}
@end
