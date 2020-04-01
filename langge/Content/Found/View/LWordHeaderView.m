//
//  LWordHeaderView.m
//  langge
//
//  Created by samlee on 2019/4/13.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LWordHeaderView.h"
#import "UIRoundButton.h"
#import "HQFlowView.h"
#import "HQImagePageControl.h"
#import "LCourseCell.h"

#import <UIImage+GIF.h>

@interface LWordHeaderView()<HQFlowViewDelegate,HQFlowViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,AudioManagerDelegate>
@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
- (IBAction)reportsBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *chinaeseLabel;

@property (weak, nonatomic) IBOutlet UILabel *japanLabel;
@property (weak, nonatomic) IBOutlet UIRoundButton *courseLookBtn;
- (IBAction)courseLookBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *courseCollectionView;
@property (weak, nonatomic) IBOutlet UIRoundButton *newsLookBtn;
- (IBAction)newLookBtnClick:(id)sender;
- (IBAction)shareBtnClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *playOrPauseBtn;
- (IBAction)playOrPauseBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *creatVideoBtn;

- (IBAction)playMyVoiceBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *playMyVoiceBtn;
@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;

@property(nonatomic,strong)NSArray *banner_list;
@property(nonatomic,strong)NSArray *daily_sentence_list;
@property(nonatomic,strong)NSArray *course_list;

@property (nonatomic, strong) HQImagePageControl *pageC;
@property (nonatomic, strong) HQFlowView *pageFlowView;
@property (nonatomic, strong) UIScrollView *scrollView; // 轮播图容器
@property (weak, nonatomic) IBOutlet UIView *testView;
@property (weak, nonatomic) IBOutlet UIImageView *testImageView;

@end

@implementation LWordHeaderView

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 167)];
        _scrollView.backgroundColor = [UIColor clearColor];
        
    }
    return _scrollView;
}

- (HQFlowView *)pageFlowView
{
    if (!_pageFlowView) {
        
        _pageFlowView = [[HQFlowView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 167)];
        _pageFlowView.delegate = self;
        _pageFlowView.dataSource = self;
        _pageFlowView.minimumPageAlpha = 0.3;
        _pageFlowView.leftRightMargin = 15;
        _pageFlowView.topBottomMargin = 20;
        _pageFlowView.orginPageCount = 5;
        _pageFlowView.isOpenAutoScroll = YES;
        _pageFlowView.autoTime = 3.0;
        _pageFlowView.orientation = HQFlowViewOrientationHorizontal;
        
    }
    return _pageFlowView;
}

- (HQImagePageControl *)pageC{
    if (!_pageC) {
        //初始化pageControl
        if (!_pageC) {
            _pageC = [[HQImagePageControl alloc]initWithFrame:CGRectMake(0, self.scrollView.frame.size.height - 15, self.scrollView.frame.size.width, 7.5)];
        }
        [self.pageFlowView.pageControl setCurrentPage:0];
        self.pageFlowView.pageControl = _pageC;
    }
    return _pageC;
}

-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    self.course_list = dataDic[@"course_list"];
    self.banner_list = dataDic[@"banner_list"];
    self.daily_sentence_list = dataDic[@"daily_sentence_list"];
    [self.pageFlowView reloadData];
    [self.courseCollectionView reloadData];
    LDailySentenceModel *daily = self.daily_sentence_list.firstObject;
    self.japanLabel.text = daily.ja_string;
    self.chinaeseLabel.text = daily.cn_string;
    
    NSDictionary *stripData = dataDic[@"stripData"];
    [self.testImageView sd_setImageWithURL:[NSURL URLWithString:stripData[@"stripImgSrc"]]];
}


-(void)awakeFromNib{
    [super awakeFromNib];
    [self setUI];
}

-(void)setUI{
    [AudioManager shareManager].delegate = self;
    [self.bannerView addSubview:self.scrollView];
    [self.scrollView addSubview:self.pageFlowView];
    [self.pageFlowView addSubview:self.pageC];
    [self.pageFlowView reloadData];//刷新轮播
    [self.newsLookBtn modifyWithcornerRadius:10 borderColor:RGB(251, 124, 118) borderWidth:1];
    [self.courseLookBtn modifyWithcornerRadius:10 borderColor:RGB(251, 124, 118) borderWidth:1];
    [self.testView modifyWithcornerRadius:10 borderColor:nil borderWidth:0];
    
    self.testImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.testImageView addGestureRecognizer:tap];
    
    [self.courseCollectionView registerNib:[UINib nibWithNibName:@"LCourseCell" bundle:nil] forCellWithReuseIdentifier:@"LCourseCell"];
    self.courseCollectionView.delegate = self;
    self.courseCollectionView.dataSource = self;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(110, 66);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.courseCollectionView.collectionViewLayout = layout;
    
    self.dateLabel.text = [XSTools getCurrentDateStr];
    
    
    [self.creatVideoBtn addTarget:self action:@selector(btnStartRecordTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.creatVideoBtn addTarget:self action:@selector(btnStartRecordMoveIn:) forControlEvents:UIControlEventTouchDragInside];
    [self.creatVideoBtn addTarget:self action:@selector(btnStartRecordMoveOut:) forControlEvents:UIControlEventTouchDragOutside];
    [self.creatVideoBtn addTarget:self action:@selector(btnStartRecordTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.creatVideoBtn addTarget:self action:@selector(btnStartRecordTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"icon" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    UIImage *image = [UIImage sd_animatedGIFWithData:data];
    self.gifImageView.image = image;
    self.gifImageView.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showGif) name:@"showGif" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenGif) name:@"hiddenGif" object:nil];
}
-(void)showGif{
    self.gifImageView.hidden = NO;
}
-(void)hiddenGif{
    self.gifImageView.hidden = YES;
}

-(void)tap{
    [self.delegate btnClickWithType:5];
}

#pragma mark -- UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.course_list.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LCourseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LCourseCell" forIndexPath:indexPath];
    cell.course = self.course_list[indexPath.row];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate courseClickWith:self.course_list[indexPath.row]];
}

#pragma mark JQFlowViewDelegate
- (CGSize)sizeForPageInFlowView:(HQFlowView *)flowView{
    return CGSizeMake(ScreenWidth-2*30, self.scrollView.frame.size.height-2*3);
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex{
    LBannerModel *banner = self.banner_list[subIndex];
    [self.delegate bannerClickWith:banner];
    
}
#pragma mark JQFlowViewDatasource
- (NSInteger)numberOfPagesInFlowView:(HQFlowView *)flowView{
    return self.banner_list.count;
}
- (HQIndexBannerSubview *)flowView:(HQFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    HQIndexBannerSubview *bannerView = (HQIndexBannerSubview *)[flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[HQIndexBannerSubview alloc] initWithFrame:CGRectMake(0, 0, self.pageFlowView.frame.size.width, self.pageFlowView.frame.size.height)];
        bannerView.layer.cornerRadius = 5;
        bannerView.layer.masksToBounds = YES;
        bannerView.coverView.backgroundColor = [UIColor darkGrayColor];
    }
    LBannerModel *banner = self.banner_list[index];
    [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:banner.img_src] placeholderImage:[UIImage imageNamed:@"defalut_img"]];
    return bannerView;
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(HQFlowView *)flowView{
    [self.pageFlowView.pageControl setCurrentPage:pageNumber];
}


- (IBAction)reportsBtnClick:(id)sender {
    [self.delegate btnClickWithType:1];
}
- (IBAction)courseLookBtnClick:(id)sender {
    [self.delegate btnClickWithType:2];
}
- (IBAction)newLookBtnClick:(id)sender {
    [self.delegate btnClickWithType:3];
}

- (IBAction)shareBtnClick:(UIButton *)sender {
    
    [self.delegate btnClickWithType:4];
}



- (void)dealloc{
    self.pageFlowView.delegate = nil;
    self.pageFlowView.dataSource = nil;
    [self.pageFlowView stopTimer];
}
- (IBAction)playOrPauseBtnClick:(UIButton *)sender {
    LDailySentenceModel *daily = self.daily_sentence_list.firstObject;
    [self.delegate playWordAudioClick];
    [[AudioManager shareManager] playWithUrl:[NSURL URLWithString:daily.audio_src]];
}



- (IBAction)playMyVoiceBtnClick:(UIButton *)sender {
    [[AudioManager shareManager] pause];
    [self.delegate playMyVideoClick];
}



#pragma mark -- AudioManagerDelegate
-(void)playReady:(NSString *)urlStr{
    
}
-(void)playFinish:(NSString *)urlStr{
    
}
-(void)playError:(NSString *)error urlStr:(NSString *)urlStr{
    [SVProgressHUD showErrorWithStatus:error];
}


#pragma mark -- action
- (void)btnStartRecordTouchDown:(id)sender {
    [[AudioManager shareManager] pause];
    [self.delegate createVideoBtnStatusChangeWithType:1];
}
- (void)btnStartRecordMoveOut:(id)sender {
    [self.delegate createVideoBtnStatusChangeWithType:3];
}
- (void)btnStartRecordMoveIn:(id)sender {
    [self.delegate createVideoBtnStatusChangeWithType:2];
}
- (void)btnStartRecordTouchUpInside:(id)sender {
    [self.delegate createVideoBtnStatusChangeWithType:4];
}
- (void)btnStartRecordTouchUpOutside:(id)sender {
    [self.delegate createVideoBtnStatusChangeWithType:5];
}

@end
