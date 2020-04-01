//
//  LAddBookCell.m
//  langge
//
//  Created by samlee on 2019/4/12.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LAddBookCell.h"

@implementation LAddBookCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.leftAllSelectView modifyWithcornerRadius:25 borderColor:nil borderWidth:0];
    [self.centerAllSelectView modifyWithcornerRadius:25 borderColor:nil borderWidth:0];
    [self.rightAllSelectView modifyWithcornerRadius:25 borderColor:nil borderWidth:0];
    self.leftAllSelectView.transform = CGAffineTransformMakeRotation(M_PI_4*-1);
    self.centerAllSelectView.transform = CGAffineTransformMakeRotation(M_PI_4*-1);
    self.rightAllSelectView.transform = CGAffineTransformMakeRotation(M_PI_4*-1);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)setBookArray:(NSMutableArray *)bookArray{
    _bookArray = bookArray;
    self.leftView.hidden = YES;
    self.centerView.hidden = YES;
    self.rightView.hidden = YES;
    if (bookArray.count>=1) {
        self.leftView.hidden = NO;
        LBookModel *leftBook = bookArray.firstObject;
        self.leftTitleLabel.text = leftBook.title;
        [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:leftBook.cover_img_src] placeholderImage:[UIImage imageNamed:@"defalut_img"]];
        if ([leftBook.is_add isEqualToString:@"1"]) {
            self.leftAllSelectView.hidden = NO;
        }else{
            self.leftAllSelectView.hidden = YES;
        }
    }
    
    if (bookArray.count>=2) {
        self.centerView.hidden = NO;
        LBookModel *centerBook = bookArray[1];
        self.centerTitleLabel.text = centerBook.title;
        [self.centerImageView sd_setImageWithURL:[NSURL URLWithString:centerBook.cover_img_src] placeholderImage:[UIImage imageNamed:@"defalut_img"]];
        if ([centerBook.is_add isEqualToString:@"1"]) {
            self.centerAllSelectView.hidden = NO;
        }else{
            self.centerAllSelectView.hidden = YES;
        }
    }
    
    if (bookArray.count>=3) {
        self.rightView.hidden = NO;
        LBookModel *rightBook = bookArray[2];
        self.rightTitleLabel.text = rightBook.title;
        [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:rightBook.cover_img_src] placeholderImage:[UIImage imageNamed:@"defalut_img"]];
        if ([rightBook.is_add isEqualToString:@"1"]) {
            self.rightAllSelectView.hidden = NO;
        }else{
            self.rightAllSelectView.hidden = YES;
        }
    }
}

- (IBAction)leftBtnClick:(UIButton *)sender {
    [self.delegate seleckBookWith:self.bookArray[sender.tag-100]];
}
- (IBAction)centerBtnClick:(UIButton *)sender {
    [self.delegate seleckBookWith:self.bookArray[sender.tag-100]];
}
- (IBAction)rightBtnClick:(UIButton *)sender {
    [self.delegate seleckBookWith:self.bookArray[sender.tag-100]];
}
@end
