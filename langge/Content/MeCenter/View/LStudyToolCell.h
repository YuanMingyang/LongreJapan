//
//  LStudyToolCell.h
//  langge
//
//  Created by samlee on 2019/4/2.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LStudyToolModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LStudyToolCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@property(nonatomic,strong)LStudyToolModel *studyTool;
@end

NS_ASSUME_NONNULL_END
