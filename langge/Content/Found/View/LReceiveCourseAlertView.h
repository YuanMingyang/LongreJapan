//
//  LReceiveCourseAlertView.h
//  langge
//
//  Created by yang on 2019/12/23.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LReceiveCourseAlertView : UIView
@property(nonatomic,strong)void(^closeBlock)();
@property(nonatomic,strong)void(^openWechatBlock)();
@property (weak, nonatomic) IBOutlet UIView *contentView;

- (IBAction)closeBtnClick:(UIButton *)sender;

- (IBAction)submitBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *codeImageView;

@end

NS_ASSUME_NONNULL_END
