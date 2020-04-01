//
//  LFeedBackModel.h
//  langge
//
//  Created by samlee on 2019/5/2.
//  Copyright © 2019 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LFeedBackModel : NSObject
@property(nonatomic,strong)NSString <Optional>*_id;
@property(nonatomic,strong)NSString <Optional>*user_suggest;
@property(nonatomic,strong)NSString <Optional>*create_time;
@property(nonatomic,strong)NSString <Optional>*is_reply;
@property(nonatomic,strong)NSString <Optional>*admin_back;
@property(nonatomic,strong)NSString <Optional>*img1;
@property(nonatomic,strong)NSString <Optional>*img2;
@property(nonatomic,strong)NSString <Optional>*img3;
@property(nonatomic,strong)NSString <Optional>*img4;
@property(nonatomic,strong)NSString <Optional>*back_time;
@end

NS_ASSUME_NONNULL_END
