//
//  LPainterAlertView.m
//  langge
//
//  Created by samlee on 2019/5/22.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LPainterAlertView.h"
#import <UIImage+GIF.h>

@implementation LPainterAlertView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.showGifBtn modifyWithcornerRadius:15 borderColor:RGB(251, 124, 118) borderWidth:1];
    [self.clearPainterBtn modifyWithcornerRadius:15 borderColor:RGB(251, 124, 118) borderWidth:1];
    [self.bjView modifyWithcornerRadius:15 borderColor:nil borderWidth:0];
    self.gifImageView.hidden = YES;
    [self addPainterView];
}
-(void)addPainterView{
    if (self.painterView) {
        [self.painterView removeFromSuperview];
    }
    self.painterView = [[PainterView alloc] init];
    self.painterView.paintColor = RGB(255, 184, 73);
    self.painterView.paintWidth = 8;
    [self.bjView addSubview:self.painterView];
    [self.painterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.gifImageView);
        make.top.equalTo(self.gifImageView);
        make.right.equalTo(self.gifImageView);
        make.bottom.equalTo(self.gifImageView);
    }];
}
-(void)setGifUrl:(NSString *)gifUrl{
    _gifUrl = gifUrl;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:gifUrl]];
    UIImage *image = [UIImage sd_animatedGIFWithData:data];
    self.gifImageView.image = image;
}
- (IBAction)showGifBtnClick:(UIButton *)sender {
    self.gifImageView.hidden = !self.gifImageView.hidden;
    if (self.gifImageView.hidden) {
        [sender setTitle:@"显示提示" forState:UIControlStateNormal];
    }else{
        [sender setTitle:@"隐藏提示" forState:UIControlStateNormal];
    }
}

- (IBAction)clearPainterBtnClick:(UIButton *)sender {
    [self addPainterView];
}

- (IBAction)closeBtnClick:(UIButton *)sender {
    [self removeFromSuperview];
}
@end
