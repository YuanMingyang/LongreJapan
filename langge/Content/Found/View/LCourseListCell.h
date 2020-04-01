//
//  LCourseListCell.h
//  langge
//
//  Created by samlee on 2019/4/16.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCourseClassHourModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCourseListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *pointLabel;
@property (weak, nonatomic) IBOutlet UIImageView *liveIcon;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *testLabel;
@property(nonatomic,strong)LCourseClassHourModel *classHour;
@end

NS_ASSUME_NONNULL_END
