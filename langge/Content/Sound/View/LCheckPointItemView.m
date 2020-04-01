//
//  LCheckPointItemView.m
//  langge
//
//  Created by samlee on 2019/3/24.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LCheckPointItemView.h"
@interface LCheckPointItemView ()
@property(nonatomic,strong)NSString *_title;
@property(nonatomic,assign)int count;

@property(nonatomic,strong)UIImageView *bjImageView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIButton *selectBtn;

@end

@implementation LCheckPointItemView
-(instancetype)initWithTitle:(NSString *)title count:(int)count{
    if (self = [super init]) {
        __title = title;
        _count = count;
        [self initUI];
    }
    return self;
}
-(void)initUI{
    self.bjImageView = [[UIImageView alloc] init];
    NSString *imageName = [NSString stringWithFormat:@"star%d",_count];
    self.bjImageView.image = [UIImage imageNamed:imageName];
    self.bjImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.bjImageView];
    [self.bjImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];

    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    self.titleLabel.textColor = RGB(251, 124, 118);
    self.titleLabel.text = __title;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    self.selectBtn = [[UIButton alloc] init];
    [self.selectBtn setTitle:@"" forState:UIControlStateNormal];
    [self.selectBtn addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.selectBtn];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
}
-(void)selectItem:(UIButton *)sender{
    [self.delegate selectItemWith:@""];
}
@end
