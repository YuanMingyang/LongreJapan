//
//  LSignModel.h
//  langge
//
//  Created by samlee on 2019/4/23.
//  Copyright © 2019 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSignModel : NSObject
@property(nonatomic,strong)NSString *date;
@property(nonatomic,assign)BOOL is_sign;
@property(nonatomic,strong)NSString *recite_num;
@property(nonatomic,assign)BOOL is_continuity;
@property(nonatomic,assign)BOOL isHavaLast;  //前一天是否签到
@property(nonatomic,assign)BOOL isHaveNext;  //后一天是否签到
@property(nonatomic,assign)BOOL isFill;      //是否是填充的空日期
@end

NS_ASSUME_NONNULL_END
