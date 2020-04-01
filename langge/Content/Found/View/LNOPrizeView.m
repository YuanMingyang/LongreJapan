//
//  LNOPrizeView.m
//  langge
//
//  Created by samlee on 2019/4/30.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LNOPrizeView.h"

@implementation LNOPrizeView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}
-(void)setUI{
    self.backgroundColor = [UIColor whiteColor];
    self.headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_prize"]];
    [self addSubview:self.headerImageView];
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(11);
        make.width.mas_equalTo(84);
        make.height.mas_equalTo(87);
        make.centerX.equalTo(self);
    }];
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"哈哈哈哈哈";
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = RGB(102, 102, 102);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.top.equalTo(self.headerImageView.mas_bottom);
    }];
}
@end
