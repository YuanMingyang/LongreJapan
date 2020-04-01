//
//  LStudyCell.h
//  langge
//
//  Created by samlee on 2019/3/26.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFiftytonesModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface LStudyCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *hiraganaLabel;
@property (weak, nonatomic) IBOutlet UILabel *katakanaLabel;
@property (weak, nonatomic) IBOutlet UILabel *romeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;

@property (weak, nonatomic) IBOutlet UILabel *rulesLabel;

- (IBAction)showGifBtnClick:(UIButton *)sender;

@property(nonatomic,strong)LFiftytonesModel *model;
@end

NS_ASSUME_NONNULL_END
