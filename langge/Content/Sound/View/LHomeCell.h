//
//  LHomeCell.h
//  langge
//
//  Created by samlee on 2019/3/25.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LHomeCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIProgressView *listeningProgressView;
@property (weak, nonatomic) IBOutlet UIProgressView *hiraganaProgressView;
@property (weak, nonatomic) IBOutlet UIProgressView *katakanaProgressView;


@property(nonatomic,strong)NSDictionary *playsubject;
@property(nonatomic,assign)NSInteger index;

@end

NS_ASSUME_NONNULL_END
