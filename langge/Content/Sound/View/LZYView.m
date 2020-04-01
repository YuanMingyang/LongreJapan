//
//  LZYView.m
//  langge
//
//  Created by samlee on 2019/3/25.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LZYView.h"
#import "LCheckPointItemView.h"
@interface LZYView ()
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)NSMutableArray *itemArray;
@end
@implementation LZYView

-(instancetype)init{
    if (self = [super init]) {
        [self setUI];
    }
    return self;
}
-(void)setUI{
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line2"]];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(80);
        make.top.equalTo(self);
        make.right.equalTo(self).offset(-80);
        make.bottom.equalTo(self);
    }];
    
    LCheckPointItemView *item1 = [[LCheckPointItemView alloc] initWithTitle:@"か行" count:0];
    [self addSubview:item1];
    [item1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(62);
        make.height.mas_equalTo(62);
        make.left.equalTo(self).offset(89);
        make.bottom.equalTo(self).offset(-20);
    }];
    
    LCheckPointItemView *item2 = [[LCheckPointItemView alloc] initWithTitle:@"か行" count:0];
    [self addSubview:item2];
    [item2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(62);
        make.height.mas_equalTo(62);
        make.left.equalTo(self).offset(169);
        make.bottom.equalTo(self).offset(-99);
    }];
    
    LCheckPointItemView *item3 = [[LCheckPointItemView alloc] initWithTitle:@"か行" count:0];
    [self addSubview:item3];
    [item3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(62);
        make.height.mas_equalTo(62);
        make.left.equalTo(self).offset(211);
        make.bottom.equalTo(self).offset(-210);
    }];
    
    LCheckPointItemView *item4 = [[LCheckPointItemView alloc] initWithTitle:@"か行" count:0];
    [self addSubview:item4];
    [item4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(62);
        make.height.mas_equalTo(62);
        make.left.equalTo(self).offset(119);
        make.bottom.equalTo(self).offset(-278);
    }];
    
    LCheckPointItemView *item5 = [[LCheckPointItemView alloc] initWithTitle:@"か行" count:0];
    [self addSubview:item5];
    [item5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(62);
        make.height.mas_equalTo(62);
        make.left.equalTo(self).offset(53);
        make.bottom.equalTo(self).offset(-368);
    }];
    
    LCheckPointItemView *item6 = [[LCheckPointItemView alloc] initWithTitle:@"か行" count:0];
    [self addSubview:item6];
    [item6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(62);
        make.height.mas_equalTo(62);
        make.left.equalTo(self).offset(178);
        make.bottom.equalTo(self).offset(-443);
    }];
}

@end
