//
//  LVideoView.h
//  langge
//
//  Created by samlee on 2019/7/23.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCourseModel.h"
#import "LCourseDetailModel.h"
#import "ZFPlayer.h"
#import "ZFPlayerControlView.h"
#import "ZFAVPlayerManager.h"

NS_ASSUME_NONNULL_BEGIN


@interface LVideoView : UIView
@property (strong, nonatomic) UIView *videoView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *class_hour_numLabel;
@property (strong, nonatomic) UILabel *pri_priceLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UILabel *isDeleteLabel;
@property (strong, nonatomic) UIView *titleView;
@property (strong, nonatomic) UILabel *describeLabel;


@property(nonatomic,strong)NSString *course_id;
@property(nonatomic,strong)LCourseDetailModel *courseDetail;
@property(nonatomic,strong)LCourseModel *course;
@property(nonatomic,strong)LCourseClassHourModel *selectClassHour;

-(void)playVideoWith:(LCourseClassHourModel *)classHour;

@property (nonatomic, strong) ZFPlayerController *player;

@end

NS_ASSUME_NONNULL_END
