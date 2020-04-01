//
//  LClauseViewController.h
//  langge
//
//  Created by samlee on 2019/5/19.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LClauseViewController : UIViewController
@property(nonatomic,strong)NSString *htmlStr;
@property(nonatomic,strong)NSString *urlStr;
@property(nonatomic,strong)void(^closeBlock)();
@property(nonatomic,assign)BOOL isFromStartPage;
@end

NS_ASSUME_NONNULL_END
