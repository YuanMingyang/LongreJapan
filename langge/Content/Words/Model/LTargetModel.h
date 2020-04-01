//
//  LTargetModel.h
//  langge
//
//  Created by samlee on 2019/5/14.
//  Copyright © 2019 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LTargetModel : NSObject
@property(nonatomic,strong)NSString <Optional>*level;
@property(nonatomic,strong)NSString <Optional>*word_number;
@property(nonatomic,strong)NSString <Optional>*completion_times;
@property(nonatomic,strong)NSString <Optional>*is_plan;
@property(nonatomic,strong)NSString <Optional>*status;
@end

NS_ASSUME_NONNULL_END
