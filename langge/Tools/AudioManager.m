//
//  AudioManager.m
//  langge
//
//  Created by samlee on 2019/3/28.
//  Copyright © 2019 yang. All rights reserved.
//

#import "AudioManager.h"
#import <AVFoundation/AVFoundation.h>

@interface AudioManager ()
@property(nonatomic,strong)AVPlayer *player;
@property(nonatomic,strong)AVPlayerItem *playerItem;

@property(nonatomic,assign)int count;
@end

@implementation AudioManager
static AudioManager *manager = nil;
+(instancetype)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AudioManager new];
    });
    
    return manager;
}

-(AVPlayer *)player{
    if (_player == nil) {
        _player = [[AVPlayer alloc] init];
        _player.volume = 1.0; // 默认最大音量
        [self addObserver];
    }
    return _player;
}

-(void)playWithUrl:(NSURL *)url{
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    self.count = 1;
    self.urlStr = url.absoluteString;
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:url];
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    [self.player play];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showGif" object:self.urlStr];
}

-(void)playWithUrl:(NSURL *)url count:(int)count{
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    self.count = count;
    self.urlStr = url.absoluteString;
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:url];
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    [self.player play];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showGif" object:self.urlStr];
}

-(void)pause{

    [self.player pause];
    self.count = 0;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenGif" object:self.urlStr];
}
-(void)resume{
    [self.player play];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showGif" object:self.urlStr];
}

-(void)removeObserver{
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];

}

-(void)addObserver{
    //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
    [self.player.currentItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew) context:nil];
    //监控播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = [change[@"new"] integerValue];
        switch (status) {
            case AVPlayerItemStatusReadyToPlay:
            {
                NSLog(@"准备播放");
                
                [self.delegate playReady:self.urlStr];
            }
                break;
            case AVPlayerItemStatusFailed:
            {
                NSLog(@"加载失败");
                [self.delegate playError:@"加载失败" urlStr:self.urlStr];
            }
                break;
            case AVPlayerItemStatusUnknown:
            {
                NSLog(@"未知资源");
                [self.delegate playError:@"未知资源" urlStr:self.urlStr];
            }
                break;
            default:
                break;
        }
    }
}

- (void)playbackFinished:(NSNotification *)notifi {

    self.count--;
    
    if (self.count>0) {
        [self playWithUrl:[NSURL URLWithString:self.urlStr] count:self.count];
        
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenGif" object:self.urlStr];
        [self.delegate playFinish:self.urlStr];
    }
    
    
}
@end
