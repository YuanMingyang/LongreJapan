//
//  LAddImageModel.h
//  langge
//
//  Created by samlee on 2019/4/21.
//  Copyright © 2019 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LAddImageModel : NSObject
@property(nonatomic,strong)UIImage *mainImage;
@property(nonatomic,assign)NSInteger currentIndex;
@property(nonatomic,assign)NSInteger imageNum;

-(instancetype)initWith:(UIImage *)mainImage currentIndex:(NSInteger)currentIndex imageNum:(NSInteger)imageNum;
@end

NS_ASSUME_NONNULL_END
