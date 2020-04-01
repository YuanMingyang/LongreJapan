//
//  LAddImageCell.m
//  langge
//
//  Created by samlee on 2019/4/21.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LAddImageCell.h"

@implementation LAddImageCell
-(void)setImageModel:(LAddImageModel *)imageModel{
    _imageModel = imageModel;
    if (!imageModel.mainImage) {
        //没有image,是最后一个
        self.mainImageView.hidden = YES;
        if (imageModel.imageNum == 1) {
            //证明是还没图片
            self.firstView.hidden = NO;
            self.noFirstView.hidden = YES;
        }else{
            self.firstView.hidden = YES;
            self.noFirstView.hidden = NO;
        }
    }else{
        self.mainImageView.image = imageModel.mainImage;
        self.mainImageView.hidden = NO;
        self.firstView.hidden = YES;
        if (imageModel.currentIndex == imageModel.imageNum-1) {
            self.noFirstView.hidden = NO;
        }else{
            self.noFirstView.hidden = YES;
        }
    }
}
@end
