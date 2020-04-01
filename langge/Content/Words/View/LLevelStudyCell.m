//
//  LLevelStudyCell.m
//  langge
//
//  Created by samlee on 2019/6/23.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LLevelStudyCell.h"
#import "AudioManager.h"
#import <UIImage+GIF.h>

@interface LLevelStudyCell ()

@end

@implementation LLevelStudyCell



-(void)awakeFromNib{
    [super awakeFromNib];
    NSLog(@"7777777777");
    NSString *path = [[NSBundle mainBundle] pathForResource:@"icon" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    UIImage *image = [UIImage sd_animatedGIFWithData:data];
    self.gifImageView.image = image;
    self.gifImageView.hidden = YES;
    self.sentenceGifImageView.image = image;
    self.sentenceGifImageView.hidden = YES;
    [self.errorBtn modifyWithcornerRadius:13 borderColor:RGB(251, 124, 118) borderWidth:1];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showGif:) name:@"showGif" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenGif:) name:@"hiddenGif" object:nil];
}



-(void)setWord:(LWordModel *)word{
    _word = word;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"icon" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    UIImage *image = [UIImage sd_animatedGIFWithData:data];
    self.gifImageView.image = image;
    self.sentenceGifImageView.image = image;
    
    self.type = 1;
    self.jaLabel.text = self.word.ja_word;
    self.cnLabel.text = [NSString stringWithFormat:@"[%@] %@ %@",self.word.kana,self.word.rome,self.word.tone];
    self.label3.text = self.word.pos;
    [self.label3 modifyWithcornerRadius:3 borderColor:nil borderWidth:0];
    [self.postLabel modifyWithcornerRadius:3 borderColor:nil borderWidth:0];
    self.label4.text = self.word.cn_explanation;
    if ([self.word.isStrange isEqualToString:@"1"]) {
        self.addWrongBtn.selected = YES;
    }else{
        self.addWrongBtn.selected = NO;
    }
    if (word.ja_explain.length>0||word.ja_explain.length>0) {
        
        self.detailLabel.text = @"详细释义";
        self.detailheight.constant = 20;
        self.postLabel.text =  word.pos;
        self.detail_jpLabel.text = word.ja_explain;
        self.detail_chLabel.text = word.cn_explain;
    }else{
        self.detailLabel.text = @"";
        self.detailheight.constant = 0;
        self.postLabel.text =  @"";
        self.detail_jpLabel.text = @"";
        self.detail_chLabel.text = @"";
    }
    
    
    self.jaSentenceLabel.text = word.ja_sentence;
    self.cnSentenceLabel.text = word.cn_sentence;
    
    
    

}


-(void)showGif:(NSNotification*)sender{
    
    if ([sender.object isEqualToString:self.word.audio_src]) {
        self.gifImageView.hidden = NO;
        self.sentenceGifImageView.hidden = YES;
    }else if ([sender.object isEqualToString:self.word.sentence_audio_src]){
        self.gifImageView.hidden = YES;
        self.sentenceGifImageView.hidden = NO;
    }else{
        self.gifImageView.hidden = YES;
        self.sentenceGifImageView.hidden = YES;
    }
    
}
-(void)hiddenGif:(NSNotification*)sender{
    self.gifImageView.hidden = YES;
    self.sentenceGifImageView.hidden = YES;
}

- (IBAction)addWrongBtnClick:(UIButton *)sender {
    [SVProgressHUD showWithStatus:@"操作中"];
    [[APIManager getInstance] wordStrangeAddWithWid:self.word.ID callback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            [SVProgressHUD showSuccessWithStatus:result];
            sender.selected = !sender.selected;
        }else{
            [SVProgressHUD showErrorWithStatus:result];
        }
    }];
}
- (IBAction)playBtnClick:(UIButton *)sender {
    self.type = 1;
    [[AudioManager shareManager] playWithUrl:[NSURL URLWithString:self.word.audio_src] count:[[SingleTon getInstance].user.auto_play_frequency intValue]];
}
- (IBAction)errorBtnClick:(UIButton *)sender {
    self.errorBlock();
}
- (IBAction)sentencePlayBtnClick:(id)sender {
    self.type = 2;
    [[AudioManager shareManager] playWithUrl:[NSURL URLWithString:self.word.sentence_audio_src] count:[[SingleTon getInstance].user.auto_play_frequency intValue]];
}
@end
