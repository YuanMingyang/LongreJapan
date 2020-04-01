//
//  LSubmitViewController.h
//  langge
//
//  Created by samlee on 2019/4/1.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSubmitViewController : UIViewController
@property(nonatomic,strong)void(^resultBlock)(NSString *result);
@property(nonatomic,strong)NSString *nickname;
@property(nonatomic,strong)NSString *titleStr;
@end

NS_ASSUME_NONNULL_END
