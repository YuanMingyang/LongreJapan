//
//  LStudyCell.m
//  langge
//
//  Created by samlee on 2019/3/26.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LStudyCell.h"
#import <UIImage+GIF.h>

@implementation LStudyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}


-(void)setModel:(LFiftytonesModel *)model{
    _model = model;
    NSLog(@"%@",model.audio_link);
    self.hiraganaLabel.text = model.hiragana;
    self.katakanaLabel.text = model.katakana;
    self.romeLabel.text = model.rome;
    self.rulesLabel.text = model.describe;
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.hiragana_gif]];
    UIImage *image = [UIImage sd_animatedGIFWithData:data];
    self.gifImageView.image = image;
}

- (IBAction)showGifBtnClick:(UIButton *)sender {
    if (sender.tag==101) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.hiragana_gif]];
        UIImage *image = [UIImage sd_animatedGIFWithData:data];
        self.gifImageView.image = image;
    }else{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.katakana_gif]];
        UIImage *image = [UIImage sd_animatedGIFWithData:data];
        self.gifImageView.image = image;
    }
}
@end
