//
//  LCourseClassHourModel.h
//  langge
//
//  Created by samlee on 2019/4/27.
//  Copyright © 2019 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCourseClassHourModel : NSObject
@property(nonatomic,strong)NSString <Optional>*_id;
@property(nonatomic,strong)NSString <Optional>*title;
@property(nonatomic,strong)NSString <Optional>*cover_img_src;
@property(nonatomic,strong)NSString <Optional>*duration;
@property(nonatomic,strong)NSString <Optional>*video_src;
@property(nonatomic,strong)NSString <Optional>*is_preview;

@property(nonatomic,strong)NSString <Optional>*is_select;
@end

NS_ASSUME_NONNULL_END
