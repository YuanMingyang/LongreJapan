//
//  LDateAlertView.h
//  langge
//
//  Created by samlee on 2019/4/1.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LDateAlertView : UIView

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property(nonatomic,strong)void(^submitBlock)(NSString* dateStr);
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)closeBtnClick:(id)sender;
- (IBAction)submitBtnClick:(id)sender;

@end

NS_ASSUME_NONNULL_END
