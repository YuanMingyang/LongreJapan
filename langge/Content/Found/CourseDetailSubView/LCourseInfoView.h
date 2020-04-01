//
//  LCourseInfoView.h
//  langge
//
//  Created by samlee on 2019/7/23.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCourseDetailModel.h"
#import "GKPageScrollView.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCourseInfoView : UIWebView <GKPageListViewDelegate>
@property(nonatomic,strong)LCourseDetailModel *courseDetail;
@end

NS_ASSUME_NONNULL_END
