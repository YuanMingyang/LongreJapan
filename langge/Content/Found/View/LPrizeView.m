//
//  LPrizeView.m
//  langge
//
//  Created by samlee on 2019/4/30.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LPrizeView.h"
@interface LPrizeView()

@end

@implementation LPrizeView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}
-(void)setUI{
    self.backgroundColor = [UIColor whiteColor];
    [self modifyWithcornerRadius:15 borderColor:RGB(153, 153, 153) borderWidth:1];
    self.receiveBtn = [[UIButton alloc] init];
    self.receiveBtn.backgroundColor = RGB(255, 184, 73);
    [self.receiveBtn setTitle:@"立即领取" forState:UIControlStateNormal];
    self.receiveBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.receiveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.receiveBtn modifyWithcornerRadius:20 borderColor:nil borderWidth:0];
    [self.receiveBtn addTarget:self action:@selector(receiveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.receiveBtn];
    [self.receiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(35);
        make.right.equalTo(self).offset(-35);
        make.bottom.equalTo(self).offset(-15);
        make.height.mas_equalTo(40);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    self.titleLabel.textColor = RGB(51, 51, 51);
    self.titleLabel.text = @"日语N5听力高频词汇PDF1份";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self.receiveBtn.mas_top);
    }];
}
-(void)receiveBtnClick{
    self.receive();
}

-(void)setPrize_data:(NSDictionary *)prize_data{
    _prize_data = prize_data;
    self.titleLabel.text = prize_data[@"title"];
}
@end
