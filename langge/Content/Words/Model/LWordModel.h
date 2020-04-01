//
//  LWordModel.h
//  langge
//
//  Created by samlee on 2019/6/23.
//  Copyright © 2019 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LWordModel : NSObject
@property(nonatomic,strong)NSString <Optional>*kana;
@property(nonatomic,strong)NSString <Optional>*ja_word;
@property(nonatomic,strong)NSString <Optional>*pos;
@property(nonatomic,strong)NSString <Optional>*cn_explanation;
@property(nonatomic,strong)NSString <Optional>*content;
@property(nonatomic,strong)NSString <Optional>*isStrange;
@property(nonatomic,strong)NSString <Optional>*audio_src;
@property(nonatomic,strong)NSString <Optional>*rome;
@property(nonatomic,strong)NSString <Optional>*tone;
@property(nonatomic,strong)NSString <Optional> *ID;
@property(nonatomic,strong)NSString <Optional>*ja_sentence;
@property(nonatomic,strong)NSString <Optional>*cn_sentence;
@property(nonatomic,strong)NSString <Optional>*sentence_audio_src;
@property(nonatomic,strong)NSString <Optional>*ja_explain;
@property(nonatomic,strong)NSString <Optional>*cn_explain;

@end

NS_ASSUME_NONNULL_END
