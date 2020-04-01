//
//  LFeedBackImageCell.m
//  langge
//
//  Created by samlee on 2019/5/2.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LFeedBackImageCell.h"

@implementation LFeedBackImageCell
-(void)setImg_src:(NSString *)img_src{
    _img_src = img_src;
    self.mainImageView.image = [XSTools base64ToImageWith:img_src];
}
@end
