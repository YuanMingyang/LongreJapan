//
//  LBookDeleteAlertView.h
//  langge
//
//  Created by samlee on 2019/4/16.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBookModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LBookDeleteAlertView : UIView
@property(nonatomic,strong)void(^selectBlock)(BOOL result);

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
- (IBAction)deleteBtnClick:(UIButton *)sender;
- (IBAction)cancelBtnClick:(UIButton *)sender;

@property(nonatomic,strong)LBookModel *book;
@end

NS_ASSUME_NONNULL_END
