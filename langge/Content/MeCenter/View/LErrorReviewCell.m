//
//  LErrorReviewCell.m
//  langge
//
//  Created by samlee on 2019/4/20.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LErrorReviewCell.h"
#import "AudioManager.h"
#import <UIImage+GIF.h>

@interface LErrorReviewCell ()
@property(nonatomic,assign)NSInteger type;
@end


@implementation LErrorReviewCell


-(void)awakeFromNib{
    [super awakeFromNib];
    self.webView.scrollView.bounces = NO;
    [self.webView loadHTMLString:@"哈哈啊哈哈哈哈哈哈" baseURL:nil];
    
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

-(void)setStrangeWord:(LStrangeWordModel *)strangeWord{
    _strangeWord = strangeWord;
    if (strangeWord.data) {
        [self upDataUI];
    }else{
        [[APIManager getInstance] getWordDataWithJa_word:strangeWord.title callback:^(BOOL success, id  _Nonnull result) {
            if (success) {
                LWordModel *word = [[LWordModel alloc] init];
                [word setValuesForKeysWithDictionary:result];
                strangeWord.data = word;
                [self upDataUI];
            }else{
                [SVProgressHUD showErrorWithStatus:result];
            }
        }];
    }
}

-(void)upDataUI{
    self.type = 1;
    self.discriptionView.hidden = YES;
    self.leftIcon.hidden = YES;
    self.rightIcon.hidden = YES;
    self.buttonIcon.hidden = YES;
    
    self.titleLabel.text = self.strangeWord.title;
    self.kanaLabel.text = [NSString stringWithFormat:@"[%@] [%@] %@",self.strangeWord.data.kana,self.strangeWord.data.rome,self.strangeWord.data.tone];
    self.title2Label.text = self.strangeWord.title;
    self.kana2Label.text = [NSString stringWithFormat:@"[%@] [%@] %@",self.strangeWord.data.kana,self.strangeWord.data.rome,self.strangeWord.data.tone];
    self.posLabel.text = [NSString stringWithFormat:@"   %@   ",self.strangeWord.data.pos];
    [self.posLabel modifyWithcornerRadius:10 borderColor:nil borderWidth:0];
    self.kana2Label.text = self.strangeWord.data.kana;
    self.cn_explanationLabel.text = self.strangeWord.data.cn_explanation;
    
    self.cn_explainLabel.text = self.strangeWord.data.cn_explain;
    self.ja_explainLabel.text = self.strangeWord.data.ja_explain;
    self.ja_sentenceLabel.text = self.strangeWord.data.ja_sentence;
    self.cn_sentenceLabel.text = self.strangeWord.data.cn_explanation;
    if (self.strangeWord.data.cn_explain.length==0&&self.strangeWord.data.ja_explain.length==0) {
        self.explainView.hidden = YES;
        self.sentenceTop.constant = 20;
    }else{
        self.explainView.hidden = NO;
        self.sentenceTop.constant = 110;
    }

    
    
    
    if ([[SingleTon getInstance].user.is_auto_play isEqualToString:@"1"]) {
        [[AudioManager shareManager] playWithUrl:[NSURL URLWithString:self.strangeWord.data.audio_src] count:[[SingleTon getInstance].user.auto_play_frequency intValue]];
    }
}


-(void)showIconWith:(NSInteger)type{
    if (type==0) {
        self.leftIcon.hidden = YES;
        self.rightIcon.hidden = YES;
        self.buttonIcon.hidden = YES;
    }else if (type == 1){
        self.leftIcon.hidden = NO;
        self.rightIcon.hidden = YES;
        self.buttonIcon.hidden = YES;
    }else if (type == 2){
        self.leftIcon.hidden = YES;
        self.rightIcon.hidden = NO;
        self.buttonIcon.hidden = YES;
    }else if (type == 3){
        self.leftIcon.hidden = YES;
        self.rightIcon.hidden = YES;
        self.buttonIcon.hidden = NO;
    }
}
- (IBAction)playbtnClick:(UIButton *)sender {
    self.type = 1;
    [[AudioManager shareManager] playWithUrl:[NSURL URLWithString:self.strangeWord.data.audio_src] count:[[SingleTon getInstance].user.auto_play_frequency intValue]];
    
}

- (IBAction)showDiscriptionBtnClick:(UIButton *)sender {
    self.discriptionView.hidden = NO;
}
- (IBAction)playSentenceBtnClick:(id)sender {
    self.type = 2;
    [[AudioManager shareManager] playWithUrl:[NSURL URLWithString:self.strangeWord.data.sentence_audio_src] count:[[SingleTon getInstance].user.auto_play_frequency intValue]];
}
@end
