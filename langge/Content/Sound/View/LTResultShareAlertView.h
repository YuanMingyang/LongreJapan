//
//  LTResultShareAlertView.h
//  langge
//
//  Created by yang on 2019/10/8.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LTResultShareAlertView : UIView

@property(nonatomic,strong)void(^closeBlock)();
@property(nonatomic,strong)void(^shareBlock)(NSInteger type);

@property (weak, nonatomic) IBOutlet UIImageView *starImageView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIImageView *qrcodeImageView;
- (IBAction)shareBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *bjView;
@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
- (IBAction)closeBtnClick:(UIButton *)sender;

@property(nonatomic,strong)NSDictionary *resultData;
@end

NS_ASSUME_NONNULL_END
