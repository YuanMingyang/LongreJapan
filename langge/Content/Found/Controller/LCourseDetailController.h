//
//  LCourseDetailController.h
//  langge
//
//  Created by samlee on 2019/7/23.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCourseDetailModel.h"
#import "LCourseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCourseDetailController : UIViewController
@property(nonatomic,strong)NSString *course_id;
@property(nonatomic,strong)LCourseDetailModel *courseDetail;
@property(nonatomic,strong)LCourseModel *course;
@end

NS_ASSUME_NONNULL_END
