//
//  LPainterAlertView.h
//  langge
//
//  Created by samlee on 2019/5/22.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PainterView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPainterAlertView : UIView
@property (weak, nonatomic) IBOutlet UIView *bjView;
@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;
@property (weak, nonatomic) IBOutlet UIButton *showGifBtn;
- (IBAction)showGifBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *clearPainterBtn;
- (IBAction)clearPainterBtnClick:(UIButton *)sender;

- (IBAction)closeBtnClick:(UIButton *)sender;
@property(nonatomic,strong)PainterView *painterView;

@property(nonatomic,strong)NSString *gifUrl;
@end

NS_ASSUME_NONNULL_END
