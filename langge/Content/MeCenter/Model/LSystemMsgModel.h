//
//  LSystemMsgModel.h
//  langge
//
//  Created by samlee on 2019/5/2.
//  Copyright © 2019 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSystemMsgModel : NSObject
@property(nonatomic,strong)NSString <Optional>*_id;
@property(nonatomic,strong)NSString <Optional>*title;
@property(nonatomic,strong)NSString <Optional>*content;
@property(nonatomic,strong)NSString <Optional>*type;
@property(nonatomic,strong)NSString <Optional>*create_time;
@property(nonatomic,strong)NSString <Optional>*sender;

@end

NS_ASSUME_NONNULL_END
