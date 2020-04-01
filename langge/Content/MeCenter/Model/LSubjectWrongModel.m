//
//  LSubjectWrongModel.m
//  langge
//
//  Created by samlee on 2019/5/17.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LSubjectWrongModel.h"

@implementation LSubjectWrongModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self._id = value;
    }
}
@end
