//
//  LFeedBackModel.m
//  langge
//
//  Created by samlee on 2019/5/2.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LFeedBackModel.h"

@implementation LFeedBackModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self._id = value;
    }
}
@end
