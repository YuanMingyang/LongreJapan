//
//  LSoundStudyViewController.m
//  langge
//
//  Created by samlee on 2019/3/26.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LSoundStudyViewController.h"
#import "LStudyCell.h"
#import "LBeforTestViewController.h"
#import "LFiftytonesModel.h"
#import "AudioManager.h"
#import <UIImage+GIF.h>
#import "ZWAMRPlayer.h"
#import "ZWMP3Player.h"
#import "ZWTalkingRecordView.h"

#import "LPainterAlertView.h"
#import "WPAlertControl.h"

@interface LSoundStudyViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,ZWTalkingRecordViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UIView *roundView1;
@property (weak, nonatomic) IBOutlet UIView *roundView2;
@property (weak, nonatomic) IBOutlet UIView *roundView3;
@property (weak, nonatomic) IBOutlet UIView *roundView4;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *bjView;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;

- (IBAction)playBtnClick:(UIButton *)sender;
- (IBAction)playSoundBtnClick:(UIButton *)sender;
- (IBAction)writeBtnClick:(UIButton *)sender;


@property(nonatomic,strong)LFiftytonesModel *currentModel;


/** 录制音频相关 */
@property (weak,   nonatomic) ZWTalkingRecordView *recordView;
@property (strong, nonatomic) ZWMP3Player * audioMP3Player;
@property(nonatomic,strong)NSString *audioPath;


@property(nonatomic,assign)BOOL isPush;//是否push，防止滚动的时候多次push
@end

@implementation LSoundStudyViewController
- (void)viewWillAppear:(BOOL)animated{
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    self.isPush = NO;
    //self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:nil];
    //self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    [[AudioManager shareManager] pause];
    if (self.audioMP3Player) {
        [self.audioMP3Player stopPlaying];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentModel = self.dataSource.firstObject;
    if ([[SingleTon getInstance].user.is_auto_play isEqualToString:@"1"]) {
        [[AudioManager shareManager] playWithUrl:[NSURL URLWithString:self.currentModel.audio_link] count:[[SingleTon getInstance].user.auto_play_frequency intValue]];
        NSLog(@"1111111111");
    }
    [self setUI];
    
}

-(void)setUI{
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = barItem;
    barItem.title = @"";
    
    [self.bjView.layer addSublayer:[XSTools getColorLayerWithStartColor:RGB(255, 182, 171) endColor:RGB(251, 124, 118) frame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)]];
    self.gifImageView.hidden = YES;
    
    [self.roundView1 modifyWithcornerRadius:15 borderColor:nil borderWidth:0];
    [self.roundView2 modifyWithcornerRadius:15 borderColor:nil borderWidth:0];
    [self.roundView3 modifyWithcornerRadius:15 borderColor:nil borderWidth:0];
    [self.roundView4 modifyWithcornerRadius:15 borderColor:nil borderWidth:0];
    
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    CGRect navRect = self.navigationController.navigationBar.frame;
    
    self.topConstraint.constant = statusRect.size.height+navRect.size.height+20;
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"LStudyCell" bundle:nil] forCellWithReuseIdentifier:@"LStudyCell"];
    UICollectionViewFlowLayout *layout2 = [[UICollectionViewFlowLayout alloc] init];
    layout2.itemSize = CGSizeMake(ScreenWidth-30, ScreenHeight-153-statusRect.size.height-navRect.size.height);
    layout2.minimumLineSpacing = 0;
    layout2.minimumInteritemSpacing = 0;
    layout2.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    if (self.dataSource.count>1) {
        self.collectionView.pagingEnabled = YES;
        
    }else{
        //self.collectionView.pagingEnabled = NO;
        layout2.itemSize = CGSizeMake(ScreenWidth-29, ScreenHeight-153-statusRect.size.height-navRect.size.height);
    }
    self.collectionView.collectionViewLayout = layout2;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    
    ZWTalkingRecordView * recordView = [[ZWTalkingRecordView alloc] initWithFrame:CGRectMake((ScreenWidth - 160) / 2, 100, 160, 160) delegate:self WithAudio:ZWAudioMP3];
    [self.view addSubview:recordView];
    self.recordView = recordView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showGif) name:@"showGif" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenGif) name:@"hiddenGif" object:nil];
    
    
    [self.recordBtn addTarget:self action:@selector(btnStartRecordTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.recordBtn addTarget:self action:@selector(btnStartRecordMoveIn:) forControlEvents:UIControlEventTouchDragInside];
    [self.recordBtn addTarget:self action:@selector(btnStartRecordMoveOut:) forControlEvents:UIControlEventTouchDragOutside];
    [self.recordBtn addTarget:self action:@selector(btnStartRecordTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.recordBtn addTarget:self action:@selector(btnStartRecordTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    
}

-(void)showGif{
    self.playBtn.hidden = YES;
    self.gifImageView.hidden = NO;
}
-(void)hiddenGif{
    self.playBtn.hidden = NO;
    self.gifImageView.hidden = YES;
}


#pragma mark -- UICollectionViewDelegate,UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    LStudyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LStudyCell" forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    LFiftytonesModel *word = self.dataSource[indexPath.row];
    if (!word) {
        return;
    }
    if ([[SingleTon getInstance].user.is_auto_play isEqualToString:@"1"]) {
        [[AudioManager shareManager] playWithUrl:[NSURL URLWithString:word.audio_link] count:[[SingleTon getInstance].user.auto_play_frequency intValue]];
    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat itemWidth = ScreenWidth-30;
    CGFloat offSetX = scrollView.contentOffset.x;
    NSInteger index = offSetX/itemWidth;
    self.currentModel = self.dataSource[index];
    self.audioPath = nil;
    if (offSetX>itemWidth*(self.dataSource.count-1)) {
        if (!self.isPush) {
            LBeforTestViewController *vc = [[LBeforTestViewController alloc] initWithNibName:@"LBeforTestViewController" bundle:nil];
            vc.type = self.type;
            vc.row = self.row;
            [[AudioManager shareManager] pause];
            [self.navigationController pushViewController:vc animated:YES];
            self.isPush = YES;
            return;
        }
    }
}

- (IBAction)playBtnClick:(UIButton *)sender {
    if (self.audioMP3Player) {
        [self.audioMP3Player stopPlaying];
    }
    [[AudioManager shareManager] playWithUrl:[NSURL URLWithString:self.currentModel.audio_link] count:[[SingleTon getInstance].user.auto_play_frequency intValue]];
}


- (void)btnStartRecordTouchDown:(id)sender {
    [[AudioManager shareManager] pause];
    [self actionBarZWTalkStateChanged:ZWTalkStateTalking];
}
- (void)btnStartRecordMoveOut:(id)sender {
    [self actionBarZWTalkStateChanged:ZWTalkStateCanceling];
}
- (void)btnStartRecordMoveIn:(id)sender {
    [self actionBarZWTalkStateChanged:ZWTalkStateTalking];
}
- (void)btnStartRecordTouchUpInside:(id)sender {
    [self actionBarTalkFinished];
}
- (void)btnStartRecordTouchUpOutside:(id)sender {
    [self actionBarZWTalkStateChanged:ZWTalkStateNone];
}



- (void)actionBarZWTalkStateChanged:(ZWTalkState)sts {
    if (sts == ZWTalkStateTalking) {
        self.recordView.hidden = NO;
    } else if (sts == ZWTalkStateCanceling) {
        self.recordView.hidden = NO;
    } else {
        self.recordView.hidden = YES;
        [_recordView recordCancel];
    }
    self.recordView.state = sts;
}

- (void)actionBarTalkFinished {
    self.recordView.hidden = YES;
    [self.recordView recordEnd];
}


#pragma mark - TalkingRecordViewDelegate
- (void)recordView:(ZWTalkingRecordView *)sender didFinish:(NSString*)path duration:(NSTimeInterval)du WithAudio:(ZWAudio)Audio{
    _recordView.hidden = YES;
    self.audioPath = path;
}



- (IBAction)playSoundBtnClick:(UIButton *)sender {
    if (!self.audioPath) {
        [SVProgressHUD showErrorWithStatus:@"您还没有录制"];
        return;
    }
    self.audioMP3Player = [[ZWMP3Player alloc] initWithDelegate:self];
    [self.audioMP3Player  playAtPath:self.audioPath];
}

- (IBAction)writeBtnClick:(UIButton *)sender {
    LPainterAlertView *alert = [[NSBundle mainBundle] loadNibNamed:@"LPainterAlertView" owner:nil options:nil].firstObject;
    alert.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    alert.gifUrl = self.currentModel.hiragana_gif;
    [[UIApplication sharedApplication].delegate.window addSubview:alert];

}

@end
