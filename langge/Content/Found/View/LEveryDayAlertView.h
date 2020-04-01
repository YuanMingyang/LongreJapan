//
//  LEveryDayAlertView.h
//  langge
//
//  Created by samlee on 2019/4/14.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LDailySentenceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LEveryDayAlertView : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *comfromLabel;
@property (weak, nonatomic) IBOutlet UILabel *japanLabel;
@property (weak, nonatomic) IBOutlet UILabel *chinaLabel;
- (IBAction)shareBtnClick:(UIButton *)sender;
- (IBAction)closeBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *qrImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *weakLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UIView *bjImageView;


@property(nonatomic,strong)LDailySentenceModel *daily;
//1.关闭   2.微信  3.qq  4.qq空间  5.微博  6.朋友圈
@property(nonatomic,strong)void(^selectClickBlock)(NSInteger type);
@end

NS_ASSUME_NONNULL_END
