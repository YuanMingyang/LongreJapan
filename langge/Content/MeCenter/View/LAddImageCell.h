//
//  LAddImageCell.h
//  langge
//
//  Created by samlee on 2019/4/21.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LAddImageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LAddImageCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIImageView *noFirstView;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;

@property(nonatomic,strong)LAddImageModel *imageModel;
@end

NS_ASSUME_NONNULL_END
