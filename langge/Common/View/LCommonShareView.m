//
//  LCommonShareView.m
//  langge
//
//  Created by samlee on 2019/4/22.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LCommonShareView.h"


@interface LCommonShareView ()

@end
@implementation LCommonShareView

-(void)awakeFromNib{
    [super awakeFromNib];
    
}

- (IBAction)selectBtnClick:(UIButton *)sender {
    self.selectResult(sender.tag-100);
    
    //self.selectResult(0);
}



@end
