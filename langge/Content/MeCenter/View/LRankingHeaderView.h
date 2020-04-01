//
//  LRankingHeaderView.h
//  langge
//
//  Created by samlee on 2019/4/18.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LRankingModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LRankingHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *firstBJ;
@property (weak, nonatomic) IBOutlet UIImageView *secondBJ;
@property (weak, nonatomic) IBOutlet UIImageView *thirdBJ;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightSpace;

@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UILabel *fitstNickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstTotalLabel;

@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) IBOutlet UILabel *secondNickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondTotalLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImageView;
@property (weak, nonatomic) IBOutlet UILabel *thirdNickNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *thirdTotalLabel;

@property(nonatomic,strong)LRankingModel *firstRanking;
@property(nonatomic,strong)LRankingModel *secondRanking;
@property(nonatomic,strong)LRankingModel *thirdRanking;
@end

NS_ASSUME_NONNULL_END
