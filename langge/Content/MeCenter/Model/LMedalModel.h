//
//  LMedalModel.h
//  langge
//
//  Created by samlee on 2019/5/16.
//  Copyright © 2019 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMedalModel : NSObject
@property(nonatomic,strong)NSString <Optional>*name;
@property(nonatomic,strong)NSString <Optional>*level;
@property(nonatomic,strong)NSString <Optional>*word_count;
@property(nonatomic,strong)NSString <Optional>*img;
@property(nonatomic,strong)NSString <Optional>*is_reach;
@end

NS_ASSUME_NONNULL_END
