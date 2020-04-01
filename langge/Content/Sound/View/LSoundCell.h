//
//  LSoundCell.h
//  langge
//
//  Created by samlee on 2019/3/24.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSoundCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;


@property(nonatomic,strong)NSDictionary *game;
@end

NS_ASSUME_NONNULL_END
