//
//  LPrizeView.h
//  langge
//
//  Created by samlee on 2019/4/30.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPrizeView : UIView
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIButton *receiveBtn;
@property(nonatomic,strong)NSDictionary *prize_data;

@property(nonatomic,strong)void(^receive)();
@end

NS_ASSUME_NONNULL_END
