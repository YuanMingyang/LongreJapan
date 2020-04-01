//
//  LNewDetailViewController.h
//  langge
//
//  Created by samlee on 2019/4/14.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBannerModel.h"
#import "LNewsModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface LNewDetailViewController : UIViewController
@property(nonatomic,strong)LBannerModel *banner;
@property(nonatomic,strong)LNewsModel *news;
@end

NS_ASSUME_NONNULL_END
