//
//  LWordModel.m
//  langge
//
//  Created by samlee on 2019/6/23.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LWordModel.h"

@implementation LWordModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}
@end
