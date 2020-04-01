//
//  AudioManager.h
//  langge
//
//  Created by samlee on 2019/3/28.
//  Copyright © 2019 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AudioManagerDelegate <NSObject>

-(void)playFinish:(NSString *)urlStr;
-(void)playError:(NSString *)error urlStr:(NSString *)urlStr;
-(void)playReady:(NSString *)urlStr;
@end

@interface AudioManager : NSObject

@property(nonatomic,assign)id<AudioManagerDelegate>delegate;
+(instancetype)shareManager;
@property(nonatomic,strong)NSString *urlStr;
@property(nonatomic,strong)NSURL *url;

-(void)playWithUrl:(NSURL *)url;
-(void)playWithUrl:(NSURL *)url count:(int)count;
-(void)pause;
-(void)resume;
@end

NS_ASSUME_NONNULL_END
