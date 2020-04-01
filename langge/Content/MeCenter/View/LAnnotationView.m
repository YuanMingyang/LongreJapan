//
//  LAnnotationView.m
//  langge
//
//  Created by samlee on 2019/4/19.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LAnnotationView.h"
#import "AudioManager.h"
#import <UIImage+GIF.h>
@interface LAnnotationView()
@property(nonatomic,assign)NSInteger type;
@end
@implementation LAnnotationView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.modifyErrorBtn modifyWithcornerRadius:13 borderColor:RGB(251, 124, 118) borderWidth:1];
    self.topConstraint.constant = StatusHeight;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    self.topView.userInteractionEnabled = YES;
    [self.topView addGestureRecognizer:pan];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"icon" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    UIImage *image = [UIImage sd_animatedGIFWithData:data];
    self.gifImageView.image = image;
    self.gifImageView.hidden = YES;
    self.sentenceGifImageView.image = image;
    self.sentenceGifImageView.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showGif) name:@"showGif" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenGif) name:@"hiddenGif" object:nil];
}
-(void)showGif{
    if (self.type == 1) {
        self.gifImageView.hidden = NO;
        self.sentenceGifImageView.hidden = YES;
    }else if (self.type == 2){
        self.gifImageView.hidden = YES;
        self.sentenceGifImageView.hidden = NO;
    }
}
-(void)hiddenGif{
    self.gifImageView.hidden = YES;
    self.sentenceGifImageView.hidden = YES;
}
-(void)pan:(UIPanGestureRecognizer *)sender{
    [self.delegate moveWith:sender];
}

-(void)setWordData:(LWordModel *)wordData{
    _wordData = wordData;
    self.type = 1;
    self.titleLabel.text = wordData.ja_word;
    self.descriptionLabel.text = [NSString stringWithFormat:@"[%@] [%@] %@",wordData.kana,wordData.rome,wordData.tone];
    self.cn_explanationLabel.text = wordData.cn_explanation;
    if (wordData.cn_explain.length == 0&&wordData.ja_explain.length==0) {
        self.explainView.hidden = YES;
        self.sentenceTop.constant = 20;
    }else{
        self.explainView.hidden = NO;
        self.sentenceTop.constant = 110;
    }
    self.ja_explainLabel.text = wordData.ja_explain;
    self.cn_explainLabel.text = wordData.cn_explain;
    self.ja_sentenceLabel.text = wordData.ja_sentence;
    self.cn_sentenceLabel.text = wordData.cn_sentence;

}
- (IBAction)playBtnClick:(id)sender {
    self.type = 1;
    [[AudioManager shareManager] playWithUrl:[NSURL URLWithString:self.wordData.audio_src] count:[[SingleTon getInstance].user.auto_play_frequency intValue]];
    
}
- (IBAction)modifyErrorBtnClick:(id)sender {
    [self.delegate clickError];
}
- (IBAction)playSentenceBtnClick:(id)sender {
    self.type = 2;
    [[AudioManager shareManager] playWithUrl:[NSURL URLWithString:self.wordData.sentence_audio_src] count:[[SingleTon getInstance].user.auto_play_frequency intValue]];
}
@end
