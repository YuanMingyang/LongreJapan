//
//  LSignCell.h
//  langge
//
//  Created by samlee on 2019/4/24.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSignModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSignCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *bjView;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *isSignIcon;
@property (weak, nonatomic) IBOutlet UILabel *reciteNumLabel;


@property(nonatomic,strong)LSignModel *sign;
@end

NS_ASSUME_NONNULL_END
