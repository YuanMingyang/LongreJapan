//
//  SectionModel.m
//  血友病
//
//  Created by A589 on 2017/4/21.
//  Copyright © 2017年 A589. All rights reserved.
//

#import "SectionModel.h"

@implementation SectionModel
+(instancetype)getSectionWithHeader:(NSString *)header{
    SectionModel *section = [SectionModel new];
    section.header = header;
    return section;
}
@end
