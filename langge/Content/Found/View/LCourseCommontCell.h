//
//  LCourseCommontCell.h
//  langge
//
//  Created by samlee on 2019/4/16.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCourseCommentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCourseCommontCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property(nonatomic,strong)LCourseCommentModel *courseComment;
@end

NS_ASSUME_NONNULL_END
