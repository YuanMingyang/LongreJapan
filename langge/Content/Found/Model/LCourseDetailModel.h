//
//  LCourseDetailModel.h
//  langge
//
//  Created by samlee on 2019/4/27.
//  Copyright © 2019 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCourseModel.h"
#import "LCourseCommentModel.h"
#import "LCourseClassHourModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCourseDetailModel : NSObject
@property(nonatomic,strong)NSString <Optional>*is_collection;
@property(nonatomic,strong)NSString <Optional>*share_link;
@property(nonatomic,strong)LCourseModel <Optional>*course_info;
@property(nonatomic,strong)NSMutableArray <Optional>*course_class_hour_list;
@property(nonatomic,strong)NSMutableArray <Optional>*course_comment_list;
@end

NS_ASSUME_NONNULL_END
