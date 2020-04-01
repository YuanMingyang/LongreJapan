//
//  LNewTopView.m
//  langge
//
//  Created by samlee on 2019/7/9.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LNewTopView.h"
@interface LNewTopView ()
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIImageView *leftIcon;
@property(nonatomic,strong)UILabel *dateLabel;
@property(nonatomic,strong)UILabel *lookCountLabel;
@property(nonatomic,strong)UIImageView *rightIcon;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UILabel *descLabel;
@end

@implementation LNewTopView

-(instancetype)init{
    if (self = [super init]) {
        [self setUI];
    }
    return self;
}

-(void)setUI{
    self.backgroundColor = [UIColor whiteColor];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.titleLabel.textColor = RGB(51, 51, 51);
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.top.equalTo(self).offset(15);
        make.height.mas_equalTo(45);
        make.right.equalTo(self).offset(0);
    }];
    
    self.leftIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon22"]];
    [self addSubview:self.leftIcon];
    [self.leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(24);
    }];
    
    self.dateLabel = [[UILabel alloc] init];
    self.dateLabel.font = [UIFont systemFontOfSize:11];
    self.dateLabel.textColor = RGB(153, 153, 153);
    [self addSubview:self.dateLabel];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftIcon.mas_right).offset(5);
        make.top.equalTo(self.leftIcon);
        make.bottom.equalTo(self.leftIcon);
    }];
    
    self.lookCountLabel = [[UILabel alloc] init];
    self.lookCountLabel.font = [UIFont systemFontOfSize:11];
    self.lookCountLabel.textColor = RGB(153, 153, 153);
    [self addSubview:self.lookCountLabel];
    [self.lookCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(0);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(60);
    }];
    
    self.rightIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon21"]];
    [self addSubview:self.rightIcon];
    [self.rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.lookCountLabel.mas_left).offset(-5);
        make.top.equalTo(self.lookCountLabel);
        make.bottom.equalTo(self.lookCountLabel);
        make.width.mas_equalTo(24);
    }];
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftIcon.mas_bottom).offset(10);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.height.mas_equalTo((ScreenWidth-40)*181/345);
    }];
    
    self.descLabel = [[UILabel alloc] init];
    self.descLabel.font = [UIFont systemFontOfSize:13];
    self.descLabel.textColor = RGB(151, 151, 151);
    self.descLabel.numberOfLines = 0;
    [self addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.top.equalTo(self.imageView.mas_bottom).offset(10);
        make.height.mas_equalTo(35);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB(242, 242, 242);
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self.descLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(8);
    }];
    
}

-(void)setNews:(LNewsModel *)news{
    _news = news;
    self.titleLabel.text = news.title;
    self.dateLabel.text = [XSTools time_timestampToString:news.create_time];
    self.lookCountLabel.text = news.look_count;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:news.cover_img_src] placeholderImage:[UIImage imageNamed:@"defalut_img"]];
    self.descLabel.text = news.desc;
}

@end
