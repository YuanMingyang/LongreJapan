//
//  LBookAlertView.h
//  langge
//
//  Created by samlee on 2019/4/12.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBookModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LBookAlertView : UIView
@property(nonatomic,strong)void(^selectDelect)(int status); //1:定制学习目标
                                                            //2:我再想想
                                                            //3:直接开始闯关

@property (weak, nonatomic) IBOutlet UIImageView *bookImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;
@property (weak, nonatomic) IBOutlet UIButton *setTargetBtn;

- (IBAction)setTargetBtnClick:(id)sender;
- (IBAction)cancelBtnClick:(id)sender;
- (IBAction)startConfirmBtnClick:(id)sender;

@property(nonatomic,strong)LBookModel *book;

@end

NS_ASSUME_NONNULL_END
