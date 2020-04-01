//
//  IntroduceView.m
//  langge
//
//  Created by samlee on 2019/3/25.
//  Copyright © 2019 yang. All rights reserved.
//

#import "IntroduceView.h"

@interface IntroduceView ()
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UIButton *passBtn;
@property(nonatomic,strong)UIButton *nextBtn;
@property(nonatomic,assign)int index;
@end

@implementation IntroduceView
-(instancetype)init{
    if (self = [super init]) {
        [self setUI];
    }
    return self;
}

-(void)setUI{
    self.index = 1;
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.bounces = NO;
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"index%d",self.index]];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.scrollView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.top.equalTo(self.scrollView);
        make.right.equalTo(self.scrollView);
        make.bottom.equalTo(self.scrollView);
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(ScreenWidth*3850/750);
    }];
    
    self.passBtn = [[UIButton alloc] init];
    [self.passBtn setTitleColor:RGB(251, 124, 118) forState:UIControlStateNormal];
    [self.passBtn setTitle:@"跳过" forState:UIControlStateNormal];
    self.passBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.passBtn modifyWithcornerRadius:10 borderColor:RGB(251, 124, 118) borderWidth:1];
    [self.passBtn addTarget:self action:@selector(passBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.passBtn];
    [self.passBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(40);
        make.right.equalTo(self.scrollView).offset(-20);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(20);
    }];
    
    self.nextBtn = [[UIButton alloc] init];
    [self.nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.nextBtn setTitle:@"下一页" forState:UIControlStateNormal];
    self.nextBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    self.nextBtn.backgroundColor =RGB(255, 184, 73);
    [self.nextBtn modifyWithcornerRadius:20 borderColor:nil borderWidth:0];
    [self.nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.nextBtn];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView).offset(20);
        make.right.equalTo(self.scrollView).offset(-20);
        make.height.mas_equalTo(40);
        make.bottom.equalTo(self.scrollView).offset(-30);
    }];
}



#pragma mark -- action
-(void)passBtnClick:(UIButton *)sender{
    [self.delegate startStudy];
    [self removeFromSuperview];
}

-(void)nextBtnClick:(UIButton *)sender{
    self.index++;
    if (self.index == 2) {
        self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"index%d",self.index]];
        self.scrollView.contentOffset = CGPointMake(0, 0);
        [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollView);
            make.top.equalTo(self.scrollView);
            make.right.equalTo(self.scrollView);
            make.bottom.equalTo(self.scrollView);
            make.width.mas_equalTo(ScreenWidth);
            make.height.mas_equalTo(ScreenWidth*1800/750);
        }];
    }else if (self.index == 3){
        self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"index%d",self.index]];
        self.scrollView.contentOffset = CGPointMake(0, 0);
        [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollView);
            make.top.equalTo(self.scrollView);
            make.right.equalTo(self.scrollView);
            make.bottom.equalTo(self.scrollView);
            make.width.mas_equalTo(ScreenWidth);
            make.height.mas_equalTo(ScreenWidth*1800/750);
        }];
        [sender setTitle:@"开始学习" forState:UIControlStateNormal];
    }else if (self.index == 4){
        [self.delegate startStudy];
        [self removeFromSuperview];
    }
}
@end
