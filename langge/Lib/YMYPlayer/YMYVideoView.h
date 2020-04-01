//
//  YMYVideoView.h
//  YMYPlayer
//
//  Created by A589 on 2017/2/21.
//  Copyright © 2017年 A589. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YMYVideoViewDelegate <NSObject>
-(void)screenBtnHander;
@end

@interface YMYVideoView : UIView
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIButton *bigPlayBtn;
@property (weak, nonatomic) IBOutlet UIView *statuBar;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UILabel *currenttimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totaltimeLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *loadProgressView;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UIButton *fullScreenBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (weak, nonatomic) IBOutlet UISlider *voiceSlider;

- (IBAction)voiceSliderChange:(UISlider *)sender;

- (IBAction)bigPlayBtnClick:(UIButton *)sender;
- (IBAction)fullScreenBtnClick:(UIButton *)sender;
- (IBAction)playBtnClick:(UIButton *)sender;
- (IBAction)sliderTouchDown:(UISlider *)sender;
- (IBAction)sliderTouchUpInside:(UISlider *)sender;
- (IBAction)sliderValueChanged:(UISlider *)sender;

// define NO
@property (nonatomic, assign) BOOL isFullScreen;


+(instancetype)videoView;
/** 需要播放视频的url */
@property(nonatomic,strong)NSURL *videoUrl;
/** 协议 */
@property(nonatomic,assign)id<YMYVideoViewDelegate>deleate;
/** 切换视频 */
-(void)replaceVideoWithUrl:(NSURL *)url;


-(void)closeVideo;

/** 设置视频底部图片 */
-(void)setBJImageWithUrl:(NSString *)urlStr;
@end
