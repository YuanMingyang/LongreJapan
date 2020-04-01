//
//  LSearchWorDetailController.m
//  langge
//
//  Created by samlee on 2019/5/3.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LSearchWorDetailController.h"
#import "AudioManager.h"
#import "LAdviceViewController.h"
#import <UIImage+GIF.h>

@interface LSearchWorDetailController ()
@property (weak, nonatomic) IBOutlet UILabel *ja_wordLabel;
- (IBAction)playBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;

@property (weak, nonatomic) IBOutlet UILabel *kanaLabel;
@property (weak, nonatomic) IBOutlet UILabel *romoLabel;
@property (weak, nonatomic) IBOutlet UILabel *toneLabel;

@property (weak, nonatomic) IBOutlet UILabel *posLabel;
@property (weak, nonatomic) IBOutlet UILabel *cn_explannationLabel;
- (IBAction)backBtnClick:(UIButton *)sender;
- (IBAction)addBtnClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *errorBtn;
- (IBAction)errorBtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *explainView;
@property (weak, nonatomic) IBOutlet UILabel *ja_explainLabel;
@property (weak, nonatomic) IBOutlet UILabel *cn_explainLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sentenceTop;
@property (weak, nonatomic) IBOutlet UILabel *ja_sentenceLabel;
@property (weak, nonatomic) IBOutlet UILabel *cn_sentenceLabel;
- (IBAction)playSentenceBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *sentenceGifImageView;

@property(nonatomic,assign)int type;
@end

@implementation LSearchWorDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
    self.type = 1;
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = barItem;
    barItem.title = @"";
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"icon" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    UIImage *image = [UIImage sd_animatedGIFWithData:data];
    
    self.sentenceGifImageView.image = image;
    self.sentenceGifImageView.hidden = YES;
    
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"voice" ofType:@"gif"];
    NSData *data2 = [NSData dataWithContentsOfFile:path2];
    UIImage *image2 = [UIImage sd_animatedGIFWithData:data2];
    self.gifImageView.image = image2;
    self.gifImageView.hidden = YES;
    
    [self.errorBtn modifyWithcornerRadius:13 borderColor:RGB(251, 124, 118) borderWidth:1];
    self.ja_wordLabel.text = self.wordData.ja_word;
    self.kanaLabel.text = [NSString stringWithFormat:@"[%@]",self.wordData.kana];
    self.romoLabel.text = [NSString stringWithFormat:@"[%@]",self.wordData.rome];
    self.posLabel.text = [NSString stringWithFormat:@"   %@   ",self.wordData.pos];
    self.cn_explannationLabel.text = self.wordData.cn_explanation;
    self.toneLabel.text = self.wordData.tone;
    
    [self.posLabel modifyWithcornerRadius:3 borderColor:nil borderWidth:0];

    if (self.wordData.ja_explain.length==0&&self.wordData.cn_explain.length==0) {
        self.explainView.hidden = YES;
        self.sentenceTop.constant = 20;
    }else{
        self.explainView.hidden = NO;
        self.sentenceTop.constant = 90;
    }
    
    self.ja_explainLabel.text = self.wordData.ja_explain;
    self.cn_explainLabel.text = self.wordData.cn_explain;
    self.ja_sentenceLabel.text = self.wordData.ja_sentence;
    self.cn_sentenceLabel.text = self.wordData.cn_sentence;
    
    
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

- (IBAction)playBtnClick:(UIButton *)sender {
    self.type = 1;
    [[AudioManager shareManager] playWithUrl:[NSURL URLWithString:self.wordData.audio_src] count:[[SingleTon getInstance].user.auto_play_frequency intValue]];
}
- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES ];
}

- (IBAction)addBtnClick:(UIButton *)sender {
    if (![SingleTon getInstance].isLogin) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        [self.navigationController presentViewController:sb.instantiateInitialViewController animated:YES completion:nil];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"添加中"];
    [[APIManager getInstance] wordStrangeAddWithWid:self.wordData.ID callback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            [SVProgressHUD showSuccessWithStatus:result];
        }else{
            [SVProgressHUD showErrorWithStatus:result];
        }
    }];
}
- (IBAction)errorBtnClick:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    LAdviceViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LAdviceViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)playSentenceBtnClick:(id)sender {
    self.type = 2;
    [[AudioManager shareManager] playWithUrl:[NSURL URLWithString:self.wordData.sentence_audio_src] count:[[SingleTon getInstance].user.auto_play_frequency intValue]];
}
@end
