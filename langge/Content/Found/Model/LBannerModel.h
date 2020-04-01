//
//  LBannerModel.h
//  langge
//
//  Created by samlee on 2019/4/18.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LBannerModel : JSONModel
@property(nonatomic,strong)NSString <Optional>*img_src;
@property(nonatomic,strong)NSString <Optional>*link_src;
@end

NS_ASSUME_NONNULL_END
