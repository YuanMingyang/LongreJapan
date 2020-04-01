//
//  LAddImageModel.m
//  langge
//
//  Created by samlee on 2019/4/21.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LAddImageModel.h"

@implementation LAddImageModel
-(instancetype)initWith:(UIImage *)mainImage currentIndex:(NSInteger)currentIndex imageNum:(NSInteger)imageNum{
    if (self = [super init]) {
        self.mainImage = mainImage;
        self.currentIndex = currentIndex;
        self.imageNum = imageNum;
    }
    return self;
}
@end
