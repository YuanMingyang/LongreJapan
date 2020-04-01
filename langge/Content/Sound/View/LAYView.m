//
//  LAYView.m
//  langge
//
//  Created by samlee on 2019/3/25.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LAYView.h"
#import "LCheckPointItemView.h"
@interface LAYView ()
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)NSMutableArray *itemArray;
@end

@implementation LAYView

-(instancetype)init{
    if (self = [super init]) {
        [self setUI];
    }
    return self;
}
-(void)setUI{
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line3"]];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(40);
        make.top.equalTo(self);
        make.right.equalTo(self).offset(-40);
        make.bottom.equalTo(self);
    }];
    
    LCheckPointItemView *item1 = [[LCheckPointItemView alloc] initWithTitle:@"か行" count:0];
    [self addSubview:item1];
    [item1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(62);
        make.height.mas_equalTo(62);
        make.left.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(-32);
    }];
    
    LCheckPointItemView *item2 = [[LCheckPointItemView alloc] initWithTitle:@"か行" count:0];
    [self addSubview:item2];
    [item2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(62);
        make.height.mas_equalTo(62);
        make.left.equalTo(self).offset(71);
        make.bottom.equalTo(self).offset(-47);
    }];
    
    LCheckPointItemView *item3 = [[LCheckPointItemView alloc] initWithTitle:@"か行" count:0];
    [self addSubview:item3];
    [item3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(62);
        make.height.mas_equalTo(62);
        make.left.equalTo(self).offset(141);
        make.bottom.equalTo(self).offset(-72);
    }];
    
    LCheckPointItemView *item4 = [[LCheckPointItemView alloc] initWithTitle:@"か行" count:0];
    [self addSubview:item4];
    [item4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(62);
        make.height.mas_equalTo(62);
        make.left.equalTo(self).offset(211);
        make.bottom.equalTo(self).offset(-96);
    }];
    
    LCheckPointItemView *item5 = [[LCheckPointItemView alloc] initWithTitle:@"か行" count:0];
    [self addSubview:item5];
    [item5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(62);
        make.height.mas_equalTo(62);
        make.left.equalTo(self).offset(242);
        make.bottom.equalTo(self).offset(-159);
    }];
    
    LCheckPointItemView *item6 = [[LCheckPointItemView alloc] initWithTitle:@"か行" count:0];
    [self addSubview:item6];
    [item6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(62);
        make.height.mas_equalTo(62);
        make.left.equalTo(self).offset(179);
        make.bottom.equalTo(self).offset(-169);
    }];
    
    LCheckPointItemView *item7 = [[LCheckPointItemView alloc] initWithTitle:@"か行" count:0];
    [self addSubview:item7];
    [item7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(62);
        make.height.mas_equalTo(62);
        make.left.equalTo(self).offset(109);
        make.bottom.equalTo(self).offset(-201);
    }];
    
    LCheckPointItemView *item8 = [[LCheckPointItemView alloc] initWithTitle:@"か行" count:0];
    [self addSubview:item8];
    [item8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(62);
        make.height.mas_equalTo(62);
        make.left.equalTo(self).offset(49);
        make.bottom.equalTo(self).offset(-228);
    }];
    
    LCheckPointItemView *item9 = [[LCheckPointItemView alloc] initWithTitle:@"か行" count:0];
    [self addSubview:item9];
    [item9 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(62);
        make.height.mas_equalTo(62);
        make.left.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(-278);
    }];
    
    LCheckPointItemView *item10 = [[LCheckPointItemView alloc] initWithTitle:@"か行" count:0];
    [self addSubview:item10];
    [item10 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(62);
        make.height.mas_equalTo(62);
        make.left.equalTo(self).offset(49);
        make.bottom.equalTo(self).offset(-335);
    }];
    
    LCheckPointItemView *item11 = [[LCheckPointItemView alloc] initWithTitle:@"か行" count:0];
    [self addSubview:item11];
    [item11 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(62);
        make.height.mas_equalTo(62);
        make.left.equalTo(self).offset(119);
        make.bottom.equalTo(self).offset(-368);
    }];
    
    LCheckPointItemView *item12 = [[LCheckPointItemView alloc] initWithTitle:@"か行" count:0];
    [self addSubview:item12];
    [item12 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(62);
        make.height.mas_equalTo(62);
        make.left.equalTo(self).offset(185);
        make.bottom.equalTo(self).offset(-398);
    }];
    
    LCheckPointItemView *item13 = [[LCheckPointItemView alloc] initWithTitle:@"か行" count:0];
    [self addSubview:item13];
    [item13 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(62);
        make.height.mas_equalTo(62);
        make.left.equalTo(self).offset(248);
        make.bottom.equalTo(self).offset(-430);
    }];
}

@end
