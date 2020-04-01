//
//  SectionModel.h
//  血友病
//
//  Created by A589 on 2017/4/21.
//  Copyright © 2017年 A589. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SectionModel : NSObject
@property(nonatomic,strong)NSString *header;
@property(nonatomic,strong)NSMutableArray *cityArray;

+(instancetype)getSectionWithHeader:(NSString *)header;
@end
