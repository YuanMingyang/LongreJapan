//
//  LThreeEndAlertView.h
//  langge
//
//  Created by samlee on 2019/7/16.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LThreeEndAlertView : UIView

//type-- 1:微信 2:朋友圈  3:QQ  4:QQ空间
@property(nonatomic,strong)void(^SelectBlock)(NSInteger type);
@property(nonatomic,strong)void(^closeBlock)();
@property (weak, nonatomic) IBOutlet UIView *imageView;

@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImageView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
- (IBAction)shareBtnClick:(UIButton *)sender;
- (IBAction)closeBtnClick:(UIButton *)sender;


@property(nonatomic,strong)NSString *qrcode_src;
@end

NS_ASSUME_NONNULL_END
