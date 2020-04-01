//
//  LGameViewController.h
//  langge
//
//  Created by samlee on 2019/5/17.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LGameViewController : UIViewController
@property(nonatomic,strong)NSString *urlStr;
@property(nonatomic,assign)BOOL isFromTest;
@property(nonatomic,assign)BOOL isFromErrorQuestion;

@property(nonatomic,assign)BOOL isFromStartPage;
@end

NS_ASSUME_NONNULL_END
