//
//  LNewTypeCell.m
//  langge
//
//  Created by samlee on 2019/4/14.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LNewTypeCell.h"

@implementation LNewTypeCell
-(void)awakeFromNib{
    [super awakeFromNib];
    [self.titleLabel modifyWithcornerRadius:16 borderColor:nil borderWidth:0];
}

-(void)setMenu:(LNewMenuModel *)menu{
    _menu = menu;
    self.titleLabel.text = menu.title;
    if ([menu.is_like isEqualToString:@"1"]) {
        self.titleLabel.backgroundColor = RGB(251, 124, 118);
    }else{
        self.titleLabel.backgroundColor = RGB(221, 221, 221);
    }
}
@end
