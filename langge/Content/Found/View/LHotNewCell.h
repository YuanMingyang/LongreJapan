//
//  LHotNewCell.h
//  langge
//
//  Created by samlee on 2019/4/14.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LNewsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LHotNewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *lookNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;



@property(nonatomic,strong)LNewsModel *news;
@end

NS_ASSUME_NONNULL_END
