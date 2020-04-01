//
//  LCourseCommentModel.h
//  langge
//
//  Created by samlee on 2019/4/27.
//  Copyright © 2019 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCourseCommentModel : NSObject
@property(nonatomic,strong)NSString <Optional>*cId;
@property(nonatomic,strong)NSString <Optional>*userId;
@property(nonatomic,strong)NSString <Optional>*content;
@property(nonatomic,strong)NSString <Optional>*create_time;
@property(nonatomic,strong)NSString <Optional>*userinfo;
@end

NS_ASSUME_NONNULL_END
