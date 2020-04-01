//
//  LLevelSuccessAlertView.h
//  langge
//
//  Created by samlee on 2019/6/16.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLevelSuccessAlertView : UIView

@property(nonatomic,strong)void(^selectTyle)(NSInteger type);//1:重新闯关2:先复习一下0:关闭

@property (weak, nonatomic) IBOutlet UIView *bjView;
- (IBAction)levelAgainBtnClick:(id)sender;
- (IBAction)reviewBtnClick:(id)sender;
- (IBAction)closeBtnClick:(id)sender;

@end

NS_ASSUME_NONNULL_END
