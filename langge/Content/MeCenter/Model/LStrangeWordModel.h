//
//  LStrangeWordModel.h
//  langge
//
//  Created by samlee on 2019/5/15.
//  Copyright © 2019 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LWordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LStrangeWordModel : NSObject
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)LWordModel *data;
@end

NS_ASSUME_NONNULL_END
