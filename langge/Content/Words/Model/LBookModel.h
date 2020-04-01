//
//  LBookModel.h
//  langge
//
//  Created by samlee on 2019/5/11.
//  Copyright © 2019 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTargetModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LBookModel : NSObject
@property(nonatomic,strong)NSString <Optional>*_id;
@property(nonatomic,strong)NSString <Optional>*bookId;
@property(nonatomic,strong)NSString <Optional>*userId;
@property(nonatomic,strong)NSString <Optional>*title;
@property(nonatomic,strong)NSString <Optional>*cover_img_src;
@property(nonatomic,strong)NSString <Optional>*stars_number;
@property(nonatomic,strong)NSString <Optional>*stars_all;
@property(nonatomic,strong)NSString <Optional>*word_all;
@property(nonatomic,strong)NSString <Optional>*word_number;
@property(nonatomic,strong)NSString <Optional>*is_add;
@property(nonatomic,strong)NSString <Optional>*today_word_surplus;
@property(nonatomic,strong)NSString <Optional>*word_total;
@property(nonatomic,strong)NSString <Optional>*describe;
@property(nonatomic,strong)LTargetModel <Optional>*target;


@property(nonatomic,strong)NSString <Optional>*isSelect;
@end

NS_ASSUME_NONNULL_END
