//
//  LRankingModel.h
//  langge
//
//  Created by samlee on 2019/5/16.
//  Copyright © 2019 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LRankingModel : NSObject
@property(nonatomic,strong)NSString <Optional>*nick_name;
@property(nonatomic,strong)NSString <Optional>*user_img_src;
@property(nonatomic,strong)NSString <Optional>*total;
@property(nonatomic,strong)NSString <Optional>*ranking;
@property(nonatomic,strong)NSString <Optional>*userId;
@end

NS_ASSUME_NONNULL_END
