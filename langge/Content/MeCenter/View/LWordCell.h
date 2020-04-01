//
//  LWordCell.h
//  langge
//
//  Created by samlee on 2019/7/19.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LWordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;


@property(nonatomic,strong)LWordModel *word;
@end

NS_ASSUME_NONNULL_END
