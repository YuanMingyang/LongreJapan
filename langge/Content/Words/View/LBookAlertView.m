//
//  LBookAlertView.m
//  langge
//
//  Created by samlee on 2019/4/12.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LBookAlertView.h"

@implementation LBookAlertView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.setTargetBtn modifyWithcornerRadius:25 borderColor:nil borderWidth:0];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
}
-(void)tap{
    self.selectDelect(2);
}
-(void)setBook:(LBookModel *)book{
    _book = book;
    [self.bookImageView sd_setImageWithURL:[NSURL URLWithString:book.cover_img_src] placeholderImage:[UIImage imageNamed:@"defalut_img"]];
    self.titleLabel.text = book.title;
    self.countLabel.text = [NSString stringWithFormat:@"共%@词",book.word_total];
    self.introduceLabel.text = book.describe;
    
}

- (IBAction)setTargetBtnClick:(id)sender {
    self.selectDelect(1);
}

- (IBAction)cancelBtnClick:(id)sender {
    self.selectDelect(2);
}

- (IBAction)startConfirmBtnClick:(id)sender {
    self.selectDelect(3);
}
@end
