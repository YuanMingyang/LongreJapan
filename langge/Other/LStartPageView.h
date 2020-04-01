//
//  LStartPageView.h
//  langge
//
//  Created by yang on 2019/12/14.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LStartPageView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *jumpBtn;
- (IBAction)jumpBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
- (IBAction)closeBtnClick:(UIButton *)sender;

@property(nonatomic,strong)void(^jumpBlock)(NSString *urlStr);
@property(nonatomic,strong)void(^closeBlock)();

@property(nonatomic,strong)NSDictionary *data;
@end

NS_ASSUME_NONNULL_END
