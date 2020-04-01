//
//  LBookSetTargetCell.m
//  langge
//
//  Created by samlee on 2019/5/12.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LBookSetTargetCell.h"

@implementation LBookSetTargetCell
-(void)awakeFromNib{
    [super awakeFromNib];
    self.userInteractionEnabled = YES;
    
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress)];
    press.minimumPressDuration = 2;
    [self addGestureRecognizer:press];
    
}
-(void)longPress{
    [self.delegate deleteBookWith:self.book];
}
-(void)setBook:(LBookModel *)book{
    _book = book;
    [self.bookImageView sd_setImageWithURL:[NSURL URLWithString:book.cover_img_src] placeholderImage:[UIImage imageNamed:@"defalut_img"]];
    if ([book.isSelect isEqualToString:@"1"]) {
        self.selectIcon.hidden = NO;
    }else{
        self.selectIcon.hidden = YES;
    }
}
@end
