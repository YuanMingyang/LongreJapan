//
//  LFeedBackCell.h
//  langge
//
//  Created by samlee on 2019/5/2.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFeedBackModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LFeedBackCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *user_suggestLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *isReplyLabel;

@property (nonatomic,strong) LFeedBackModel *feedBack;
@end

NS_ASSUME_NONNULL_END
