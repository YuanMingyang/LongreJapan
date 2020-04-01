//
//  LListCell.h
//  langge
//
//  Created by samlee on 2019/4/2.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LNewsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lookCountLabel;



@property(nonatomic,strong)LNewsModel *news;
@end

NS_ASSUME_NONNULL_END
