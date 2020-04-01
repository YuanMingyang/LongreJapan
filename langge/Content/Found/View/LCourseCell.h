    //
//  LCourseCell.h
//  langge
//
//  Created by samlee on 2019/4/13.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCourseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCourseCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@property(nonatomic,strong)LCourseModel *course;
@end

NS_ASSUME_NONNULL_END
