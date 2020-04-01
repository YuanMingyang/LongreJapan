//
//  LFeedBackImageCell.h
//  langge
//
//  Created by samlee on 2019/5/2.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LFeedBackImageCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;

@property(nonatomic,strong)NSString *img_src;
@end

NS_ASSUME_NONNULL_END
