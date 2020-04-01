//
//  LCourseTableCell.h
//  langge
//
//  Created by samlee on 2019/4/14.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCourseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCourseTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *hournumLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *byersNumLabel;

@property(nonatomic,strong)LCourseModel *course;
@end

NS_ASSUME_NONNULL_END
