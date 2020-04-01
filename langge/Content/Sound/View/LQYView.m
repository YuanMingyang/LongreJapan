//
//  LQYView.m
//  langge
//
//  Created by samlee on 2019/3/24.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LQYView.h"
#import "LCheckPointItemView.h"
@interface LQYView ()
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)NSMutableArray *itemArray;
@end
@implementation LQYView

-(void)awakeFromNib{
    [super awakeFromNib];
}

-(instancetype)init{
    if (self = [super init]) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line1"]];
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
        make.left.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-26);
    }];
    
    LCheckPointItemView *item2 = [[LCheckPointItemView alloc] initWithTitle:@"か行" count:0];
    [self addSubview:item2];
    [item2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(62);
        make.height.mas_equalTo(62);
        make.left.equalTo(self).offset(85);
        make.bottom.equalTo(self).offset(-46);
    }];
    
    LCheckPointItemView *item3 = [[LCheckPointItemView alloc] initWithTitle:@"か行" count:0];
    [self addSubview:item3];
    [item3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(62);
        make.height.mas_equalTo(62);
        make.left.equalTo(self).offset(163);
        make.bottom.equalTo(self).offset(-70);
    }];
    
    LCheckPointItemView *item4 = [[LCheckPointItemView alloc] initWithTitle:@"か行" count:0];
    [self addSubview:item4];
    [item4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(62);
        make.height.mas_equalTo(62);
        make.left.equalTo(self).offset(233);
        make.bottom.equalTo(self).offset(-110);
    }];
    
    LCheckPointItemView *item5 = [[LCheckPointItemView alloc] initWithTitle:@"か行" count:0];
    [self addSubview:item5];
    [item5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(62);
        make.height.mas_equalTo(62);
        make.left.equalTo(self).offset(225);
        make.bottom.equalTo(self).offset(-180);
    }];
    
    LCheckPointItemView *item6 = [[LCheckPointItemView alloc] initWithTitle:@"か行" count:0];
    [self addSubview:item6];
    [item6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(62);
        make.height.mas_equalTo(62);
        make.left.equalTo(self).offset(155);
        make.bottom.equalTo(self).offset(-194);
    }];
    
    LCheckPointItemView *item7 = [[LCheckPointItemView alloc] initWithTitle:@"か行" count:0];
    [self addSubview:item7];
    [item7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(62);
        make.height.mas_equalTo(62);
        make.left.equalTo(self).offset(85);
        make.bottom.equalTo(self).offset(-219);
    }];
    
    LCheckPointItemView *item8 = [[LCheckPointItemView alloc] initWithTitle:@"か行" count:0];
    [self addSubview:item8];
    [item8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(62);
        make.height.mas_equalTo(62);
        make.left.equalTo(self).offset(16);
        make.bottom.equalTo(self).offset(-257);
    }];
    
    LCheckPointItemView *item9 = [[LCheckPointItemView alloc] initWithTitle:@"か行" count:0];
    [self addSubview:item9];
    [item9 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(62);
        make.height.mas_equalTo(62);
        make.left.equalTo(self).offset(28);
        make.bottom.equalTo(self).offset(-327);
    }];
    
    LCheckPointItemView *item10 = [[LCheckPointItemView alloc] initWithTitle:@"か行" count:0];
    [self addSubview:item10];
    [item10 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(62);
        make.height.mas_equalTo(62);
        make.left.equalTo(self).offset(97);
        make.bottom.equalTo(self).offset(-361);
    }];
    
    LCheckPointItemView *item11 = [[LCheckPointItemView alloc] initWithTitle:@"か行" count:0];
    [self addSubview:item11];
    [item11 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(62);
        make.height.mas_equalTo(62);
        make.left.equalTo(self).offset(167);
        make.bottom.equalTo(self).offset(-398);
    }];
    
    LCheckPointItemView *item12 = [[LCheckPointItemView alloc] initWithTitle:@"か行" count:0];
    [self addSubview:item12];
    [item12 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(62);
        make.height.mas_equalTo(62);
        make.left.equalTo(self).offset(248);
        make.bottom.equalTo(self).offset(-430);
    }];
}

@end
