//
//  LDailySentenceModel.h
//  langge
//
//  Created by samlee on 2019/4/18.
//  Copyright © 2019 yang. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LDailySentenceModel : JSONModel
@property(nonatomic,strong)NSString <Optional>*_id;
@property(nonatomic,strong)NSString <Optional>*cn_string;
@property(nonatomic,strong)NSString <Optional>*ja_string;
@property(nonatomic,strong)NSString <Optional>*audio_src;
@property(nonatomic,strong)NSString <Optional>*create_time;
@property(nonatomic,strong)NSString <Optional>*cover_img_src;
@property(nonatomic,strong)NSString <Optional>*come_from;

@end

NS_ASSUME_NONNULL_END
