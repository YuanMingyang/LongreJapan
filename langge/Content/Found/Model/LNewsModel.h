//
//  LNewsModel.h
//  langge
//
//  Created by samlee on 2019/4/18.
//  Copyright © 2019 yang. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LNewsModel : NSObject
@property(nonatomic,strong)NSString <Optional>*_id;
@property(nonatomic,strong)NSString <Optional>*title;
@property(nonatomic,strong)NSString <Optional>*desc;
@property(nonatomic,strong)NSString <Optional>*cover_img_src;
@property(nonatomic,strong)NSString <Optional>*look_count;
@property(nonatomic,strong)NSString <Optional>*create_time;
@property(nonatomic,strong)NSString <Optional>*content;
@property(nonatomic,strong)NSString <Optional>*creator;
@property(nonatomic,strong)NSNumber <Optional>*is_collection;
@property(nonatomic,strong)NSString <Optional>*share_link;

/** 获取大家都在搜的时候用一下 */
@property(nonatomic,strong)NSString <Optional>*type;

@end

NS_ASSUME_NONNULL_END
