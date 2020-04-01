//
//  LSystemMsgCell.h
//  langge
//
//  Created by samlee on 2019/4/2.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSystemMsgModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSystemMsgCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property(nonatomic,strong) LSystemMsgModel *systemMsg;

@end

NS_ASSUME_NONNULL_END
