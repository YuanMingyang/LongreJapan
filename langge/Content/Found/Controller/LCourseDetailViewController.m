//
//  LCourseDetailViewController.m
//  langge
//
//  Created by samlee on 2019/4/15.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LCourseDetailViewController.h"
#import "LCourseListCell.h"
#import "LCourseCommontCell.h"
#import "YMYVideoView.h"
#import "LConsultingViewController.h"
#import "LCommonShareView.h"
#import "WPAlertControl.h"
#import "WXApiRequestHandler.h"
#import "wxApiManager.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>

@interface LCourseDetailViewController ()<UITableViewDelegate,UITableViewDataSource,YMYVideoViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet UIView *selectBJView;
@property (weak, nonatomic) IBOutlet UIButton *courseListBtn;
@property (weak, nonatomic) IBOutlet UIButton *courseInformationBtn;
@property (weak, nonatomic) IBOutlet UIButton *courseCommontsBtn;
- (IBAction)selectBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITableView *courseListTableView;
@property (weak, nonatomic) IBOutlet UIWebView *courseInformationWebView;

@property (weak, nonatomic) IBOutlet UIView *courseCommintsView;
@property (weak, nonatomic) IBOutlet UITableView *courseCommontsTableView;

@property (weak, nonatomic) IBOutlet UILabel *pre_priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *class_hour_numLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;
@property (weak, nonatomic) IBOutlet UILabel *isDeleteLabel;

- (IBAction)consultingBtnClick:(UIButton *)sender;
- (IBAction)phoneBtnClick:(UIButton *)sender;
- (IBAction)collectionBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;
@property (weak, nonatomic) IBOutlet UIImageView *collectionIcon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectBJTopConstraint;


@property(nonatomic,strong)UILabel *lineLabel;
@property(nonatomic,assign)NSInteger currentSelect;//1:课程列表 2：课程信息 3：评论
@property(nonatomic,strong)YMYVideoView *ymyVideoView;

@property(nonatomic,strong)LCourseClassHourModel *selectClassHour;

@property(nonatomic,assign)CGFloat lastOffSetY;
@end

@implementation LCourseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}
-(void)setUI{
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = barItem;
    barItem.title = @"";
    
    
    self.heightConstraint.constant = ScreenWidth*211/375;
    [self.courseInformationWebView loadHTMLString:self.courseDetail.course_info.content baseURL:nil];
    self.titleLabel.text = self.courseDetail.course_info.title;
    self.class_hour_numLabel.text = [NSString stringWithFormat:@"%@课时",self.courseDetail.course_info.class_hour_num];
    if ([self.courseDetail.course_info.is_agio isEqualToString:@"1"]) {
        self.pre_priceLabel.text = [NSString stringWithFormat:@"优惠价:￥%@",self.courseDetail.course_info.pri_price];
        self.priceLabel.text = [NSString stringWithFormat:@"原价:%@",self.courseDetail.course_info.price];
        self.isDeleteLabel.hidden = NO;
    }else{
        self.pre_priceLabel.text = @"";
        self.priceLabel.text = [NSString stringWithFormat:@"价格:%@",self.courseDetail.course_info.price];
        self.isDeleteLabel.hidden = YES;
    }
    if ([self.courseDetail.is_collection isEqualToString:@"1"]) {
        self.collectionBtn.selected = YES;
        self.collectionIcon.image = [UIImage imageNamed:@"collection_select"];
    }else{
        self.collectionBtn.selected = NO;
        self.collectionIcon.image = [UIImage imageNamed:@"collection"];
    }
    
    if (self.courseDetail.course_class_hour_list.count>0) {
        self.selectClassHour = self.courseDetail.course_class_hour_list.firstObject;
        self.selectClassHour.is_select = @"1";
    }
    self.title = @"课程目录";
    self.lineLabel = [[UILabel alloc] init];
    self.lineLabel.backgroundColor = RGB(251, 124, 118);
    [self.selectBJView addSubview:self.lineLabel];
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(2);
        make.bottom.equalTo(self.selectBJView);
        make.centerX.equalTo(self.courseListBtn);
    }];
    self.courseListBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [self.courseListBtn setTintColor:RGB(251, 124, 118)];
    self.currentSelect = 1;
    self.courseInformationWebView.hidden = YES;
    self.courseCommintsView.hidden = YES;
    
    [self.courseListTableView registerNib:[UINib nibWithNibName:@"LCourseListCell" bundle:nil] forCellReuseIdentifier:@"LCourseListCell"];
    self.courseListTableView.delegate = self;
    self.courseListTableView.dataSource = self;
    [self.courseCommontsTableView registerNib:[UINib nibWithNibName:@"LCourseCommontCell" bundle:nil] forCellReuseIdentifier:@"LCourseCommontCell"];
    self.courseCommontsTableView.estimatedRowHeight = 90;
    self.courseCommontsTableView.rowHeight = UITableViewAutomaticDimension;
    self.courseCommontsTableView.delegate = self;
    self.courseCommontsTableView.dataSource = self;
 
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [shareBtn setImage:[UIImage imageNamed:@"icon27"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    
    self.ymyVideoView = [[NSBundle mainBundle] loadNibNamed:@"YMYVideoView" owner:nil options:nil].firstObject;
    self.ymyVideoView.frame = CGRectMake(0, StatusHeight+NaviHeight, ScreenWidth, self.heightConstraint.constant);
    self.ymyVideoView.deleate = self;
    [self.ymyVideoView setBJImageWithUrl:self.course.cover_img_src];
    [self.view addSubview:self.ymyVideoView];

    //[self playVideo];
    self.ymyVideoView.videoUrl = [NSURL URLWithString:self.selectClassHour.video_src];
}

-(void)playVideo{
    [self.ymyVideoView replaceVideoWithUrl:[NSURL URLWithString:self.selectClassHour.video_src]];
}

#pragma mark -- UITableViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.courseListTableView) {
        if (scrollView.contentOffset.y - self.lastOffSetY > 0) {
            NSLog(@"正在向上滑动");
            //self.selectBJTopConstraint.constant = 0;
        }
        else {
            NSLog(@"正在向下滑动");
            //self.selectBJTopConstraint.constant = 373;
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView == self.courseListTableView) {
        self.lastOffSetY = scrollView.contentOffset.y;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.courseListTableView) {
        return self.courseDetail.course_class_hour_list.count;
    }else{
        return self.courseDetail.course_comment_list.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.courseListTableView) {
        return 44;
    }else{
        return UITableViewAutomaticDimension;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.courseListTableView) {
        LCourseListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCourseListCell"];
        cell.classHour = self.courseDetail.course_class_hour_list[indexPath.row];
        return cell;
    }else{
        LCourseCommontCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCourseCommontCell"];
        cell.courseComment = self.courseDetail.course_comment_list[indexPath.row];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.courseListTableView) {
        LCourseClassHourModel *currentClassHour = self.courseDetail.course_class_hour_list[indexPath.row];
        if ([currentClassHour.is_preview isEqualToString:@"0"]) {
            LConsultingViewController *vc = [[LConsultingViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        for (LCourseClassHourModel *classHour in self.courseDetail.course_class_hour_list) {
            classHour.is_select = @"0";
        }
        
        currentClassHour.is_select = @"1";
        self.selectClassHour = currentClassHour;
        [self.courseListTableView reloadData];
        [self playVideo];
    }
}

#pragma mark -- YMYVideoViewDelegate
-(void)screenBtnHander{
    self.navigationController.navigationBarHidden = !self.navigationController.navigationBarHidden;
}

- (IBAction)selectBtnClick:(UIButton *)sender {
    if (sender.tag == 101) {
        if (self.currentSelect == 1) {
            return;
        }
        [self.lineLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
        [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(2);
            make.bottom.equalTo(self.selectBJView);
            make.centerX.equalTo(self.courseListBtn);
        }];
        self.courseListBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [self.courseListBtn setTitleColor:RGB(251, 124, 118) forState:UIControlStateNormal];
        self.courseInformationBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.courseInformationBtn setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
        self.courseCommontsBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.courseCommontsBtn setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
        self.currentSelect = 1;
        self.courseListTableView.hidden = NO;
        self.courseInformationWebView.hidden = YES;
        self.courseCommintsView.hidden = YES;
        [self selectCourseList];
    }else if (sender.tag == 102){
        if (self.currentSelect == 2) {
            return;
        }
        [self.lineLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
        [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(2);
            make.bottom.equalTo(self.selectBJView);
            make.centerX.equalTo(self.courseInformationBtn);
        }];
        self.courseInformationBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [self.courseInformationBtn setTitleColor:RGB(251, 124, 118) forState:UIControlStateNormal];
        self.courseListBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.courseListBtn setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
        self.courseCommontsBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.courseCommontsBtn setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
        self.currentSelect = 2;
        self.courseListTableView.hidden = YES;
        self.courseInformationWebView.hidden = NO;
        self.courseCommintsView.hidden = YES;
        [self selectCourseInformation];
        
    }else if (sender.tag == 103){
        if (self.currentSelect == 3) {
            return;
        }
        [self.lineLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
        [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(2);
            make.bottom.equalTo(self.selectBJView);
            make.centerX.equalTo(self.courseCommontsBtn);
        }];
        self.courseListBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.courseListBtn setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
        self.courseInformationBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.courseInformationBtn setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
        self.courseCommontsBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [self.courseCommontsBtn setTitleColor:RGB(251, 124, 118) forState:UIControlStateNormal];
        self.currentSelect = 3;
        self.courseListTableView.hidden = YES;
        self.courseInformationWebView.hidden = YES;
        self.courseCommintsView.hidden = NO;
        [self selectCourseCommonts];
    }
}
-(void)selectCourseList{
    self.title = @"课程目录";
}
-(void)selectCourseInformation{
    self.title = @"课程信息";
}
-(void)selectCourseCommonts{
    self.title = @"学员评论";
}

-(void)shareBtnClick{
    NSLog(@"点击了分享");
    LCommonShareView *share = [[NSBundle mainBundle] loadNibNamed:@"LCommonShareView" owner:nil options:nil].firstObject;
    CGFloat height = 0;
    if (KIsiPhoneX) {
        height = 24;
    }
    share.frame = CGRectMake(0, 0, ScreenWidth, 150+height);
    __weak typeof(self)weakSelf = self;
    share.selectResult = ^(NSInteger type) {
        if (type == 0) {
            
        }else if (type == 1){
            NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.course.cover_img_src]];
            UIImage *image = [UIImage imageWithData:data];
            
            [WXApiRequestHandler sendLinkURL:self.courseDetail.share_link TagName:nil Title:self.courseDetail.course_info.title Description:self.courseDetail.course_info.describe ThumbImage:image InScene:WXSceneSession];
            [SingleTon getInstance].isShare = YES;

        }else if (type == 2){
            NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.course.cover_img_src]];
            UIImage *image = [UIImage imageWithData:data];
            
            [WXApiRequestHandler sendLinkURL:self.courseDetail.share_link TagName:nil Title:self.courseDetail.course_info.title Description:self.courseDetail.course_info.describe ThumbImage:image InScene:WXSceneTimeline];
            [SingleTon getInstance].isShare = YES;

        }else if (type == 3){
            QQApiNewsObject *obj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:self.courseDetail.share_link] title:self.courseDetail.course_info.title description:self.courseDetail.course_info.describe previewImageURL:[NSURL URLWithString:self.course.cover_img_src]];
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:obj];
            QQApiSendResultCode sent = [QQApiInterface sendReq:req];
            [SingleTon getInstance].isShare = YES;
            
        }else if (type == 4){
            QQApiNewsObject *obj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:self.courseDetail.share_link] title:self.courseDetail.course_info.title description:self.courseDetail.course_info.describe previewImageURL:[NSURL URLWithString:self.course.cover_img_src]];
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:obj];
            QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
            [SingleTon getInstance].isShare = YES;
        }else if (type == 5){
            
        }
        
        [WPAlertControl alertHiddenForRootControl:weakSelf completion:nil];
    };
    
    [WPAlertControl alertForView:share begin:WPAlertBeginBottem end:WPAlertEndBottem animateType:WPAlertAnimateBounce constant:0 animageBeginInterval:0.3 animageEndInterval:0.3 maskColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] pan:YES rootControl:self mackClick:nil animateStatus:nil];
}
- (IBAction)consultingBtnClick:(UIButton *)sender {
    LConsultingViewController *vc = [[LConsultingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)phoneBtnClick:(UIButton *)sender {
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"4009938812"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

}

- (IBAction)collectionBtnClick:(UIButton *)sender {
    if (![SingleTon getInstance].isLogin) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        [self.navigationController presentViewController:sb.instantiateInitialViewController animated:YES completion:nil];
        return;
    }
    
    self.collectionBtn.selected = !self.collectionBtn.selected;
    if (self.collectionBtn.selected) {
        self.collectionIcon.image = [UIImage imageNamed:@"collection_select"];
    }else{
        self.collectionIcon.image = [UIImage imageNamed:@"collection"];
    }
    self.collectionBtn.userInteractionEnabled = NO;
    [[APIManager getInstance] collectionActiveWithType:@"1" cid:self.course_id callback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            [SVProgressHUD showSuccessWithStatus:result];
        }else{
            [SVProgressHUD showErrorWithStatus:result];
            self.collectionBtn.selected = !self.collectionBtn.selected;
            if (self.collectionBtn.selected) {
                self.collectionIcon.image = [UIImage imageNamed:@"collection_select"];
            }else{
                self.collectionIcon.image = [UIImage imageNamed:@"collection"];
            }
        }
        self.collectionBtn.userInteractionEnabled = YES;
    }];
}


-(void)dealloc{
    [self.ymyVideoView closeVideo];
    NSLog(@"<<<LCourseDetailViewController>>>");
}
@end
