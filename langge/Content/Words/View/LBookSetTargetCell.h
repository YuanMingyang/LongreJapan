//
//  LBookSetTargetCell.h
//  langge
//
//  Created by samlee on 2019/5/12.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBookModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LBookSetTargetCellDelegate <NSObject>

-(void)deleteBookWith:(LBookModel *)book;

@end

@interface LBookSetTargetCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bookImageView;
@property (weak, nonatomic) IBOutlet UIImageView *selectIcon;
@property(nonatomic,strong)LBookModel *book;

@property(nonatomic,assign)id<LBookSetTargetCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
