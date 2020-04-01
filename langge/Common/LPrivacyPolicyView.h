//
//  LPrivacyPolicyView.h
//  langge
//
//  Created by yang on 2019/12/14.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPrivacyPolicyView : UIView

@property(nonatomic,strong)void(^readBlock)(NSInteger type);
@property(nonatomic,strong)void(^closeBlock)();
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
- (IBAction)cancelBtnClick:(UIButton *)sender;
- (IBAction)sureBtnClick:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
