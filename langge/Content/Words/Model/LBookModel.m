//
//  LBookModel.m
//  langge
//
//  Created by samlee on 2019/5/11.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LBookModel.h"

@implementation LBookModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self._id = value;
    }
}
@end
