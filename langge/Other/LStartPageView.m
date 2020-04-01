//
//  LStartPageView.m
//  langge
//
//  Created by yang on 2019/12/14.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LStartPageView.h"

@interface LStartPageView ()
@property(nonatomic,strong)NSTimer *timer;

@end
@implementation LStartPageView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.jumpBtn modifyWithcornerRadius:20 borderColor:nil borderWidth:0];
    [self.closeBtn modifyWithcornerRadius:10 borderColor:[UIColor whiteColor] borderWidth:1];
    
}
-(void)tap{
    [self.timer invalidate];
    self.timer = nil;
    self.jumpBlock(self.data[@"button_link"]);
}

-(void)setData:(NSDictionary *)data{
    _data = data;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:data[@"img_src"]]];
    //[self.jumpBtn setTitle:data[@"button_name"] forState:UIControlStateNormal];
    self.imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.imageView addGestureRecognizer:tap];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(dismissaaa) userInfo:nil repeats:NO];
}

-(void)dismissaaa{
    [self.timer invalidate];
    self.timer = nil;
    self.closeBlock();
}
- (IBAction)jumpBtnClick:(UIButton *)sender {
    [self.timer invalidate];
    self.timer = nil;
    self.jumpBlock(self.data[@"button_link"]);

    
}
- (IBAction)closeBtnClick:(UIButton *)sender {
    [self.timer invalidate];
    self.timer = nil;
    self.closeBlock();
}
@end
