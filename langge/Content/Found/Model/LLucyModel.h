//
//  LLucyModel.h
//  langge
//
//  Created by samlee on 2019/4/24.
//  Copyright © 2019 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLucyModel : NSObject
@property(nonatomic,strong)NSString <Optional>*bid;
@property(nonatomic,strong)NSString <Optional>*btitle;
@property(nonatomic,strong)NSString <Optional>*start_time;
@property(nonatomic,strong)NSString <Optional>*end_time;
@property(nonatomic,strong)NSString <Optional>*is_look;
@property(nonatomic,strong)NSString <Optional>*is_expire;
@property(nonatomic,strong)NSString <Optional>*link;
@property(nonatomic,strong)NSString <Optional>*explain;
@property(nonatomic,strong)NSString <Optional>*title;
@property(nonatomic,strong)NSString <Optional>*state;
@end

NS_ASSUME_NONNULL_END
