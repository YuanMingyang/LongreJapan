//
//  LAddNewTypeViewController.h
//  langge
//
//  Created by samlee on 2019/4/14.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@interface LAddNewTypeViewController : UIViewController

@property(nonatomic,strong)void(^resultBlock)();

@property(nonatomic,strong)NSMutableArray *allMenuArr;
@end

NS_ASSUME_NONNULL_END
