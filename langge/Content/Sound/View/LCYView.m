//
//  LCYView.m
//  langge
//
//  Created by samlee on 2019/3/25.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LCYView.h"
#import "LCheckPointItemView.h"
@interface LCYView ()
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)NSMutableArray *itemArray;
@end
@implementation LCYView

-(instancetype)init{
    if (self = [super init]) {
        [self setUI];
    }
    return self;
}
-(void)setUI{
    LCheckPointItemView *item1 = [[LCheckPointItemView alloc] initWithTitle:@"か行" count:0];
    [self addSubview:item1];
    [item1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(113);
        make.height.mas_equalTo(113);
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(100);
    }];
    
    LCheckPointItemView *item2 = [[LCheckPointItemView alloc] initWithTitle:@"か行" count:0];
    [self addSubview:item2];
    [item2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(113);
        make.height.mas_equalTo(113);
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-100);
    }];
}

@end
