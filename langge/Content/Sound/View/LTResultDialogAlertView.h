//
//  LTResultDialogAlertView.h
//  langge
//
//  Created by yang on 2019/10/8.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LTResultDialogAlertView : UIView
@property(nonatomic,strong)void(^closeBlock)();


@property (weak, nonatomic) IBOutlet UIImageView *starImageView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIView *bjImageView;
- (IBAction)closeBtnClick:(UIButton *)sender;


@property(nonatomic,strong)NSDictionary *resultData;
@end

NS_ASSUME_NONNULL_END
