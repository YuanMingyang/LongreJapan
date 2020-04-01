//
//  LSelectCityViewController.h
//  langge
//
//  Created by samlee on 2019/4/17.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSelectCityViewController : UIViewController
@property(nonatomic,strong)void(^resultBlock)(NSString *cityName);
@end

NS_ASSUME_NONNULL_END
