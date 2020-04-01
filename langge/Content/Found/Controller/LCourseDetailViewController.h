//
//  LCourseDetailViewController.h
//  langge
//
//  Created by samlee on 2019/4/15.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCourseDetailModel.h"
#import "LCourseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCourseDetailViewController : UIViewController
@property(nonatomic,strong)NSString *course_id;
@property(nonatomic,strong)LCourseDetailModel *courseDetail;
@property(nonatomic,strong)LCourseModel *course;
@end

NS_ASSUME_NONNULL_END
