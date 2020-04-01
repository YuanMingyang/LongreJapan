//
//  LCommonShareView.h
//  langge
//
//  Created by samlee on 2019/4/22.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LNewsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCommonShareView : UIView

//0:取消 1:微信 2:朋友圈 3:qq  4:qq空间 5:微博
@property(nonatomic,strong)void(^selectResult)(NSInteger type);
- (IBAction)selectBtnClick:(UIButton *)sender;
@property(nonatomic,strong)LNewsModel *news;
@end

NS_ASSUME_NONNULL_END
