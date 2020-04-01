//
//  LFiftytonesModel.h
//  langge
//
//  Created by samlee on 2019/5/21.
//  Copyright © 2019 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LFiftytonesModel : NSObject
@property(nonatomic,strong)NSString <Optional>*_id;
@property(nonatomic,strong)NSString <Optional>*hiragana;
@property(nonatomic,strong)NSString <Optional>*katakana;
@property(nonatomic,strong)NSString <Optional>*rome;
@property(nonatomic,strong)NSString <Optional>*audio_link;
@property(nonatomic,strong)NSString <Optional>*describe;
@property(nonatomic,strong)NSString <Optional>*hiragana_gif;
@property(nonatomic,strong)NSString <Optional>*katakana_gif;
@end

NS_ASSUME_NONNULL_END
