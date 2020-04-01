//
//  LWordHeaderView.h
//  langge
//
//  Created by samlee on 2019/4/13.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBannerModel.h"
#import "LDailySentenceModel.h"
#import "LCourseModel.h"
#import "AudioManager.h"
NS_ASSUME_NONNULL_BEGIN
@protocol LWordHeaderViewDelegate <NSObject>
-(void)bannerClickWith:(LBannerModel *)bannner;
-(void)courseClickWith:(LCourseModel *)course;
-(void)btnClickWithType:(int)type;//1:签到  2:课程   3:新闻  4:分享  5:开始测试
/** 录制按钮状态发生变化
 1.btnStartRecordTouchDown
 2.btnStartRecordMoveIn
 3.btnStartRecordMoveOut
 4.btnStartRecordTouchUpInside
 5.btnStartRecordTouchUpOutside
 */
-(void)createVideoBtnStatusChangeWithType:(int)type;
-(void)playMyVideoClick;
-(void)playWordAudioClick;
@end
@interface LWordHeaderView : UITableViewHeaderFooterView
@property(nonatomic,assign)id<LWordHeaderViewDelegate>delegate;

@property(nonatomic,strong)NSDictionary *dataDic;
@property(nonatomic,strong)NSDictionary *testDic;
@end

NS_ASSUME_NONNULL_END
