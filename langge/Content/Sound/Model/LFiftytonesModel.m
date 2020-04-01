//
//  LFiftytonesModel.m
//  langge
//
//  Created by samlee on 2019/5/21.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LFiftytonesModel.h"

@implementation LFiftytonesModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self._id = value;
    }
}
@end
