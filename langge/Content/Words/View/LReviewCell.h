//
//  LReviewCell.h
//  langge
//
//  Created by samlee on 2019/4/17.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LReviewCell : UICollectionViewCell
@property(nonatomic,assign)CGFloat naviHight;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
- (IBAction)playBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *centerCollectionView;
- (IBAction)submitBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *strokrCollectionView;

@end

NS_ASSUME_NONNULL_END
