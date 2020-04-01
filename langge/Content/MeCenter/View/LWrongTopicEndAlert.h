//
//  LWrongTopicEndAlert.h
//  langge
//
//  Created by samlee on 2019/6/23.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LWrongTopicEndAlert : UIView

@property(nonatomic,strong)void(^closeBlock)();
- (IBAction)closeBtnClick:(id)sender;

@end

NS_ASSUME_NONNULL_END
