//
//  LSignAlertView.h
//  langge
//
//  Created by samlee on 2019/4/24.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSignAlertView : UIView

@property(nonatomic,strong)void(^actionClick)(int type);//type1:完成签到，刷新列表
                                                        //    2:关闭
                                                        //    3:关闭并跳转到奖品中心

@property (weak, nonatomic) IBOutlet UILabel *weakLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
- (IBAction)signBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *lucyView;
- (IBAction)closeBtnClick:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UIImageView *corverImageView;


@property (weak, nonatomic) IBOutlet UIView *drawLuckView;
- (IBAction)drawLuckBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *haveSignImageView;

@property (weak, nonatomic) IBOutlet UIView *scratchView;
@end

NS_ASSUME_NONNULL_END
