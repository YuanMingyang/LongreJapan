//
//  LCourseCommentView.h
//  langge
//
//  Created by samlee on 2019/7/23.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCourseDetailModel.h"
#import "GKPageScrollView.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCourseCommentView : UITableView <GKPageListViewDelegate>
@property(nonatomic,strong)NSString *course_id;
@property(nonatomic,strong)LCourseDetailModel *courseDetail;
@end

NS_ASSUME_NONNULL_END
