//
//  YMYVideoView.m
//  YMYPlayer
//
//  Created by A589 on 2017/2/21.
//  Copyright © 2017年 A589. All rights reserved.
//

#import "YMYVideoView.h"
#import <AVFoundation/AVFoundation.h>
@interface YMYVideoView()
@property(nonatomic,strong)AVPlayer *player;
@property(nonatomic,strong)AVPlayerItem *playerItem;
@property(nonatomic,strong)AVPlayerLayer *playerLayer;

@property(nonatomic,strong)NSTimer *statusTimer;
@property(nonatomic,strong)NSTimer *sliderTimer;
@property(nonatomic,assign)BOOL isNeedStatus;
@property(nonatomic,assign)CGRect oldFrame;
@end
@implementation YMYVideoView
+(instancetype)videoView{
    return [[NSBundle mainBundle] loadNibNamed:@"YMYVideoView" owner:nil options:nil].firstObject;
}
-(void)setVideoUrl:(NSURL *)videoUrl{
    _videoUrl = videoUrl;
    self.playerItem = [AVPlayerItem playerItemWithURL:videoUrl];
}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.activity.hidden = YES;
    self.progressSlider.value = 0;
    self.loadProgressView.progress = 0;
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"prPoint"] forState:UIControlStateNormal];
    [self.voiceSlider setThumbImage:[UIImage imageNamed:@"prPoint"] forState:UIControlStateNormal];
    self.player = [[AVPlayer alloc] init];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.player.volume = 0.5;
    self.playerLayer.frame = self.backImageView.bounds;
    [self.backImageView.layer addSublayer:self.playerLayer];

    
    self.backImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updataStatusBar)];
    [self.backImageView addGestureRecognizer:tap];
}
-(void)updataStatusBar{
    if (self.isNeedStatus) {
        [UIView animateWithDuration:0.5 animations:^{
            self.statuBar.alpha = 1;
            self.backBtn.alpha = 1;
        }];
        if (self.playBtn.selected) {
            [self openStatusTimer];
        }
    }else{
        [self removeStatusTimer];
        [UIView animateWithDuration:0.5 animations:^{
            self.statuBar.alpha = 0;
            self.backBtn.alpha = 0;
        }];
    }
    self.isNeedStatus = !self.isNeedStatus;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    /** 当视频横向时 重新设置playerlayer的frame */
    self.playerLayer.frame = self.backImageView.bounds;
}
#pragma mark -- 用户点击事件
- (IBAction)playAgainBtnClick:(UIButton *)sender {
    self.progressSlider.value = 0;
    [self sliderTouchUpInside:self.progressSlider];

    [self bigPlayBtnClick:self.bigPlayBtn];
}

- (IBAction)backBtnClick:(UIButton *)sender {
    if (self.fullScreenBtn.selected) {
        [UIView animateWithDuration:0.2 animations:^{
            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
            self.frame = self.oldFrame;
        }];
        self.fullScreenBtn.selected = NO;
    }else{
        
    }
}

- (IBAction)voiceSliderChange:(UISlider *)sender {
    
    self.player.volume = sender.value;
}

- (IBAction)bigPlayBtnClick:(UIButton *)sender {
    self.playBtn.selected = YES;
    self.bigPlayBtn.hidden = YES;
    [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    [self.player play];
    /** 开始播放后 五秒后隐藏statusbar 并且开始更新视频缓存及播放进度 */
    [self openStatusTimer];
    [self openSliderTimer];
}

- (IBAction)fullScreenBtnClick:(UIButton *)sender {
    static dispatch_once_t onceToken;
    __weak typeof(self)weakSelf = self;
    dispatch_once(&onceToken, ^{
        weakSelf.oldFrame = weakSelf.frame;
    });
    [self.deleate screenBtnHander];
    if (!sender.selected) {
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    }else{
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
        self.frame = self.oldFrame;
    }

    sender.selected = !sender.selected;
    
}

- (IBAction)playBtnClick:(UIButton *)sender {
    if (!sender.selected) {
        [self bigPlayBtnClick:self.bigPlayBtn];
    }else{
        [self.player pause];
        [self removeStatusTimer];
        [self removeSliderTimer];
        sender.selected = NO;
    }
}

- (IBAction)sliderTouchDown:(UISlider *)sender {
    [self removeSliderTimer];
    [self removeStatusTimer];
    [self.player pause];
}

- (IBAction)sliderTouchUpInside:(UISlider *)sender {
    [self openSliderTimer];
    [self openStatusTimer];
    
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.duration)*sender.value;
    NSString *str = [self timeToStringWithTimeInterval:currentTime];
    NSLog(@"===%@",str);
    [self.player seekToTime:CMTimeMakeWithSeconds(currentTime, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    [self.player play];
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.duration)*sender.value;
    self.currenttimeLabel.text = [self timeToStringWithTimeInterval:currentTime];
}

#pragma mark -- 内部封装方法

-(void)closeVideo{
    [self.player pause];
    [self removeSliderTimer];
    [self removeStatusTimer];
}

-(void)openStatusTimer{
    self.statusTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(hiddenStatus) userInfo:nil repeats:NO];
}
-(void)hiddenStatus{
    self.isNeedStatus = YES;
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.statuBar.alpha = 0;
        weakSelf.backBtn.alpha = 0;
    }];
}
-(void)removeStatusTimer{
    [self.statusTimer invalidate];
    self.statusTimer = nil;
}
-(void)openSliderTimer{
    self.sliderTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
}
-(void)removeSliderTimer{
    [self.sliderTimer invalidate];
    self.sliderTimer = nil;
}
-(void)updateSlider{
    //缓存进度
    NSArray *loadedTimeRanges = [self.playerItem loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval timeInterval = startSeconds + durationSeconds;
    CMTime duration = self.playerItem.duration;
    CGFloat totalDuration = CMTimeGetSeconds(duration);
    self.loadProgressView.progress = timeInterval/totalDuration;
    //播放进度
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentTime);
    NSTimeInterval totalTime = CMTimeGetSeconds(self.player.currentItem.duration);
    self.currenttimeLabel.text = [self timeToStringWithTimeInterval:currentTime];
    self.totaltimeLabel.text = [self timeToStringWithTimeInterval:totalTime];

    self.progressSlider.value = currentTime/totalTime;
    //如果播放完成
    if (self.progressSlider.value == 1) {
        [self removeSliderTimer];
        self.playBtn.selected = NO;
        self.bigPlayBtn.hidden = NO;
    }
}

-(void)setBJImageWithUrl:(NSString *)urlStr{
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
}

-(void)replaceVideoWithUrl:(NSURL *)url{
    self.bigPlayBtn.hidden = YES;

    [self.player pause];
    self.playerItem = [AVPlayerItem playerItemWithURL:url];
    [self removeSliderTimer];
    [self removeStatusTimer];
    self.loadProgressView.progress = 0;
    self.progressSlider.value = 0;
    [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    [self.player play];
    [self openSliderTimer];
    [self openStatusTimer];
    self.playBtn.selected = YES;
}


/** 转换播放时间和总时间的方法 */
-(NSString *)timeToStringWithTimeInterval:(NSTimeInterval)interval;
{
    NSInteger Min = interval / 60;
    NSInteger Sec = (NSInteger)interval % 60;
    NSString *intervalString = [NSString stringWithFormat:@"%02ld:%02ld",Min,Sec];
    return intervalString;
}


-(void)dealloc{
    NSLog(@"<<<YMYVideoView>>>");
    [self.player pause];
    self.player = nil;
}


@end
