//
//  LVideoView.m
//  langge
//
//  Created by samlee on 2019/7/23.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LVideoView.h"

@interface LVideoView ()





@property (nonatomic, strong) UIImageView *containerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong) UIButton *playBtn;
@end


@implementation LVideoView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self setUI];
}

-(instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

-(void)setUI{
    self.backgroundColor = [UIColor whiteColor];
    
    self.videoView = [[UIView alloc] init];
    [self addSubview:self.videoView];
    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(ScreenWidth*211/375);
    }];
    
    self.titleView = [UIView new];
    [self addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.videoView.mas_bottom);
        make.right.equalTo(self);
        make.height.mas_equalTo(89);
    }];
    
    self.class_hour_numLabel = [[UILabel alloc] init];
    self.class_hour_numLabel.textColor = RGB(251, 124, 118);
    self.class_hour_numLabel.font = [UIFont systemFontOfSize:13];
    self.class_hour_numLabel.textAlignment = NSTextAlignmentRight;
    [self.titleView addSubview:self.class_hour_numLabel];
    [self.class_hour_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView).offset(20);
        make.right.equalTo(self.titleView).offset(-10);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = RGB(51, 51, 51);
    self.titleLabel.font =[UIFont boldSystemFontOfSize:17];
    [self.titleView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleView).offset(20);
        make.top.equalTo(self.titleView).offset(20);
        make.right.equalTo(self.class_hour_numLabel.mas_right).offset(-20);
        make.height.mas_equalTo(20);
    }];
    
    
    
    self.pri_priceLabel = [[UILabel alloc] init];
    self.pri_priceLabel.textColor = RGB(251, 124, 118);
    self.pri_priceLabel.font =[UIFont boldSystemFontOfSize:15];
    [self.titleView addSubview:self.pri_priceLabel];
    [self.pri_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleView).offset(20);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.bottom.equalTo(self.titleView);
    }];
    
    self.priceLabel = [[UILabel alloc] init];
    self.priceLabel.textColor = RGB(153, 153, 153);
    self.priceLabel.font = [UIFont systemFontOfSize:13];
    [self.titleView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pri_priceLabel.mas_right).offset(20);
        make.top.equalTo(self.pri_priceLabel.mas_top);
        make.bottom.equalTo(self.pri_priceLabel.mas_bottom);
    }];
    
    self.isDeleteLabel = [[UILabel alloc] init];
    self.isDeleteLabel.backgroundColor = RGB(153, 153, 153);
    [self.titleView addSubview:self.isDeleteLabel];
    [self.isDeleteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLabel);
        make.right.equalTo(self.priceLabel);
        make.height.mas_equalTo(0.5);
        make.centerY.equalTo(self.priceLabel);
    }];
    
    
    UILabel *lineLabel = [UILabel new];
    lineLabel.backgroundColor = RGB(242, 242, 242);
    [self addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.bottom.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(8);
    }];
    
    self.describeLabel = [[UILabel alloc] init];
    self.describeLabel.textColor = RGB(102, 102, 102);
    self.describeLabel.font = [UIFont systemFontOfSize:13];
    self.describeLabel.numberOfLines = 0;
    [self addSubview:self.describeLabel];
    [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self.titleView.mas_bottom);
        make.right.equalTo(self).offset(-15);
        make.bottom.equalTo(lineLabel.mas_top);
    }];
    
    self.containerView = [UIImageView new];
    self.containerView.contentMode = UIViewContentModeScaleToFill;
    self.containerView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [self.videoView addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.videoView);
        make.top.equalTo(self.videoView);
        make.right.equalTo(self.videoView);
        make.bottom.equalTo(self.videoView);
    }];
    
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playBtn setImage:[UIImage imageNamed:@"new_allPlay_44x44_"] forState:UIControlStateNormal];
    [self.playBtn addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:self.playBtn];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(80);
        make.centerX.equalTo(self.containerView);
        make.centerY.equalTo(self.containerView);
    }];
    
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    /// 播放器相关
    
    self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.containerView];
    self.player.controlView = self.controlView;
    /// 设置退到后台继续播放
    self.player.pauseWhenAppResignActive = YES;
    @weakify(self)
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        //[self setNeedsStatusBarAppearanceUpdate];
    };
    
    /// 播放完成
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        [self.player.currentPlayerManager replay];
        [self.player playTheNext];
        if (!self.player.isLastAssetURL) {
            [self.controlView showTitle:self.selectClassHour.title coverURLString:self.course.cover_img_src fullScreenMode:ZFFullScreenModeAutomatic];
        } else {
            [self.player stop];
        }
    };
}

-(void)playVideoWith:(LCourseClassHourModel *)classHour{
    self.selectClassHour = classHour;
    [self.player stop];
    self.player.assetURL = [NSURL URLWithString:classHour.video_src];
    [self.controlView showTitle:self.selectClassHour.title coverURLString:self.course.cover_img_src fullScreenMode:ZFFullScreenModeAutomatic];
    
    
}
- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        _controlView.fastViewAnimated = YES;
        _controlView.autoHiddenTimeInterval = 5;
        _controlView.autoFadeTimeInterval = 0.5;
        _controlView.prepareShowLoading = YES;
        _controlView.prepareShowControlView = YES;
    }
    return _controlView;
}





- (void)playClick:(UIButton *)sender {
    [self.player playTheIndex:0];
    [self.controlView showTitle:self.selectClassHour.title coverURLString:self.course.cover_img_src fullScreenMode:ZFFullScreenModeAutomatic];
}

-(void)setCourseDetail:(LCourseDetailModel *)courseDetail{
    _courseDetail = courseDetail;
    self.titleLabel.text = self.courseDetail.course_info.title;
    self.class_hour_numLabel.text = [NSString stringWithFormat:@"%@课时",self.courseDetail.course_info.class_hour_num];
    if ([self.courseDetail.course_info.is_agio isEqualToString:@"1"]) {
        self.pri_priceLabel.text = [NSString stringWithFormat:@"优惠价:￥%@",self.courseDetail.course_info.pri_price];
        self.priceLabel.text = [NSString stringWithFormat:@"原价:￥%@",self.courseDetail.course_info.price];
        self.isDeleteLabel.hidden = NO;
    }else{
        self.pri_priceLabel.text = @"";
        self.priceLabel.text = [NSString stringWithFormat:@"价格:￥%@",self.courseDetail.course_info.price];
        self.isDeleteLabel.hidden = YES;
    }
    self.describeLabel.text = self.courseDetail.course_info.describe;
}

-(void)setCourse:(LCourseModel *)course{
    _course = course;
    [self.containerView sd_setImageWithURL:[NSURL URLWithString:course.cover_img_src]];
    
}

-(void)setSelectClassHour:(LCourseClassHourModel *)selectClassHour{
    _selectClassHour = selectClassHour;
    [self.player stop];
    self.player.assetURLs = @[[NSURL URLWithString:selectClassHour.video_src]];
    [self.controlView showTitle:self.selectClassHour.title coverURLString:self.course.cover_img_src fullScreenMode:ZFFullScreenModeAutomatic];
    
}







-(void)dealloc{
    NSLog(@"1111111111");
}
@end
