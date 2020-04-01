//
//  LAddBookViewController.h
//  langge
//
//  Created by samlee on 2019/4/12.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LAddBookViewController : UIViewController
@property(nonatomic,strong)void(^reloadDataBlock)();
@end

NS_ASSUME_NONNULL_END
