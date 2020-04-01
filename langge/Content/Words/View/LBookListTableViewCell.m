//
//  LBookListTableViewCell.m
//  langge
//
//  Created by samlee on 2019/4/12.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LBookListTableViewCell.h"

@implementation LBookListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.reviewBtn modifyWithcornerRadius:15 borderColor:RGB(255, 184, 73) borderWidth:1];
    [self.startBtn modifyWithcornerRadius:15 borderColor:nil borderWidth:0];
}

-(void)setBook:(LBookModel *)book{
    _book = book;
    [self.bookImageView sd_setImageWithURL:[NSURL URLWithString:book.cover_img_src] placeholderImage:[UIImage imageNamed:@"defalut_img"]];
    self.titleLabel.text = book.title;
    self.wordLabel.text = [NSString stringWithFormat:@"%@/%@",book.word_number,book.word_all];
    self.starLabel.text = [NSString stringWithFormat:@"%@/%@",book.stars_number,book.stars_all];
    NSString * today_word_surplus = [NSString stringWithFormat:@"%@",book.today_word_surplus];
    if ([today_word_surplus isEqualToString:@"-1"]) {
        self.remainingLabel.text = @"";
        self.remainingIcon.hidden = YES;
    }else if ([today_word_surplus isEqualToString:@"0"]){
        self.remainingLabel.text = @"学习计划已完成";
        self.remainingIcon.hidden = NO;
    }else{
        self.remainingLabel.text = [NSString stringWithFormat:@"今日剩余%@词",today_word_surplus];
        self.remainingIcon.hidden = NO;
    }
}

- (IBAction)reviewBtnClick:(id)sender {
    [self.delegate clickReveiw:self.book];
}

- (IBAction)startBtnClick:(id)sender {
    [self.delegate clickStart:self.book];
}
@end
