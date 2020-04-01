//
//  LMediaTabelCell.h
//  langge
//
//  Created by samlee on 2019/5/16.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMedalModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LMediaTabelCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *wordCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLanel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property(nonatomic,strong)LMedalModel *medal;
@end

NS_ASSUME_NONNULL_END
