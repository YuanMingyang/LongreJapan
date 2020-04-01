//
//  LBookDeleteAlertView.m
//  langge
//
//  Created by samlee on 2019/4/16.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LBookDeleteAlertView.h"

@implementation LBookDeleteAlertView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self modifyWithcornerRadius:15 borderColor:nil borderWidth:0];
}

- (IBAction)deleteBtnClick:(UIButton *)sender {
    self.selectBlock(YES);
}

- (IBAction)cancelBtnClick:(UIButton *)sender {
    self.selectBlock(NO);
}

-(void)setBook:(LBookModel *)book{
    _book = book;
    self.titleLabel.text = [NSString stringWithFormat:@"您确定要删除《%@》吗",book.title];
}
@end
