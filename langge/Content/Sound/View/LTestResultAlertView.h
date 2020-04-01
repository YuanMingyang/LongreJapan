//
//  LTestResultAlertView.h
//  langge
//
//  Created by samlee on 2019/5/23.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LTestResultAlertView : UIView

//1:微信 2:朋友圈  3:qq  4:qq空间
@property(nonatomic,strong)void(^shareClick)(NSInteger type);
//1:继续学习  2:再测一次
@property(nonatomic,strong)void(^selectClick)(NSInteger type);

@property (weak, nonatomic) IBOutlet UIView *haha;

@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UIImageView *starImageView;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *continueStudyBtn;
@property (weak, nonatomic) IBOutlet UIView *iconView;
@property (weak, nonatomic) IBOutlet UIImageView *appIconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImageView;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
- (IBAction)closeBtnClick:(UIButton *)sender;

- (IBAction)continueStudyBtnClick:(UIButton *)sender;
- (IBAction)testAgainBtnClick:(UIButton *)sender;

- (IBAction)shareBtnClick:(UIButton *)sender;

@property(nonatomic,strong)NSDictionary *resultData;
@end

NS_ASSUME_NONNULL_END
