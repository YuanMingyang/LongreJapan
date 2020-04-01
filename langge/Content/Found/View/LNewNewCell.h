//
//  LNewNewCell.h
//  langge
//
//  Created by samlee on 2019/4/14.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LNewsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LNewNewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerIamgeView;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *look_countLabel;

@property(nonatomic,strong)LNewsModel *news;
@end

NS_ASSUME_NONNULL_END
