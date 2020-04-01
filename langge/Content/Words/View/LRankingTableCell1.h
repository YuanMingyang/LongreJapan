//
//  LRankingTableCell.h
//  langge
//
//  Created by samlee on 2019/6/23.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LRankingModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LRankingTableCell1 : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *rankingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@property(nonatomic,strong)LRankingModel *ranking;
@property(nonatomic,assign)NSInteger  index;
@end

NS_ASSUME_NONNULL_END
