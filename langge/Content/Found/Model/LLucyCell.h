//
//  LLucyCell.h
//  langge
//
//  Created by samlee on 2019/4/24.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLucyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLucyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *isLookIcon;
@property (weak, nonatomic) IBOutlet UILabel *lucyLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property(nonatomic,strong)LLucyModel *lucy;
@end

NS_ASSUME_NONNULL_END
