//
//  LLevelFailAlertViewController.m
//  langge
//
//  Created by samlee on 2019/6/23.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LLevelFailAlertViewController.h"
#import "LLevelFailAlertView.h"
#import "LSelectCityViewController.h"
#import "LGameViewController.h"
#import "LLucyViewController.h"
#import "LShareLevelAlert.h"
#import "WPAlertControl.h"
#import "WXApiRequestHandler.h"
#import "wxApiManager.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import "LRankingTableCell1.h"
#import "LWordLevelAlertView.h"
#import "LGameViewController.h"
#import "WPAlertControl.h"
#import "LLevelStudyViewController.h"

@interface LLevelFailAlertViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
- (IBAction)backBtnClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *startImageView;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;
@property (weak, nonatomic) IBOutlet UIView *prezeView;
@property (weak, nonatomic) IBOutlet UILabel *prizeTitle;
@property (weak, nonatomic) IBOutlet UIButton *prizeBtn;
- (IBAction)prizeBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *prizeHeight;
- (IBAction)shareBtnClick:(id)sender;
- (IBAction)nextLevelBtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *selectRegionView;

@property (weak, nonatomic) IBOutlet UITableView *rankTableView;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
- (IBAction)selectBtnClick:(UIButton *)sender;

@property(nonatomic,strong)UILabel *lineLabel;
@property(nonatomic,assign)int type;
@property(nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation LLevelFailAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUI];
}


-(void)setUI{
    
    NSLog(@"2222222222:%@",[NSThread currentThread]);
    
    self.widthConstraint.constant = ScreenWidth;
    self.heightConstraint.constant = StatusHeight + NaviHeight;
    [self.describeLabel modifyWithcornerRadius:10 borderColor:nil borderWidth:0];
    
    self.dataSource = [NSMutableArray array];
    [self.rankTableView registerNib:[UINib nibWithNibName:@"LRankingTableCell1" bundle:nil] forCellReuseIdentifier:@"LRankingTableCell1"];
    self.rankTableView.delegate = self;
    self.rankTableView.dataSource = self;
    
    self.lineLabel = [[UILabel alloc] init];
    self.lineLabel.text = @"";
    self.lineLabel.backgroundColor = RGB(105, 207, 219);
    [self.selectRegionView addSubview:self.lineLabel];
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(2);
        make.bottom.equalTo(self.selectRegionView);
        make.centerX.equalTo(self.leftBtn);
    }];
    
    self.type = 1;
    
    
    NSString *starName = [NSString stringWithFormat:@"star%@",self.data[@"star"]];
    self.startImageView.image = [UIImage imageNamed:starName];
    self.titleLabel.text = [NSString stringWithFormat:@"第%@关",self.data[@"level"]];
    self.gradeLabel.text = self.data[@"grade"];
    self.describeLabel.text = self.data[@"describe"];
    NSDictionary *prize = self.data[@"prize"];
    if (prize[@"title"]) {
        self.prizeTitle.text = prize[@"title"];
        self.prizeHeight.constant = 80;
        self.prezeView.hidden = NO;
    }else{
        self.prezeView.hidden = YES;
        self.prizeHeight.constant = 41;
    }
    
    [self loadData];
}


-(void)loadData{
    if (self.type ==1) {
        [self loadRankingWithCity:nil];
    }else{
        if ([SingleTon getInstance].user.city&&[SingleTon getInstance].user.city.length>0) {
            [self loadRankingWithCity:[SingleTon getInstance].user.city];
        }else{
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
            LSelectCityViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LSelectCityViewController"];
            vc.resultBlock = ^(NSString * _Nonnull cityName) {
            [self loadRankingWithCity:cityName];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"user_token"] = [[SingleTon getInstance] getUser_tocken];
            dic[@"city"] = cityName;
            [[APIManager getInstance] saveUserInfoWithParam:dic callback:^(BOOL success, id  _Nonnull result) {
            
            }];
        };
        }
    }
}

-(void)loadRankingWithCity:(NSString *)city{
    [SVProgressHUD showWithStatus:@"加载中"];
    [self.dataSource removeAllObjects];
    [[APIManager getInstance] rankingListWithCity:city callback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            
            [self.dataSource addObject:result[@"my"]];
            [self.dataSource addObjectsFromArray:result[@"all"]];
            [self.rankTableView reloadData];
            
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD showErrorWithStatus:result];
        }
    }];
}


#pragma mark -- UITableviewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LRankingTableCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"LRankingTableCell1"];
    cell.ranking = self.dataSource[indexPath.row];
    cell.index = indexPath.row;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}





- (IBAction)prizeBtnClick:(UIButton *)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Found" bundle:nil];
    LLucyViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LLucyViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)shareBtnClick:(id)sender {
    
    LShareLevelAlert *alert = [[NSBundle mainBundle] loadNibNamed:@"LShareLevelAlert" owner:nil options:nil].firstObject;
    alert.frame = [UIScreen mainScreen].bounds;
    alert.data = self.data;
    __weak typeof(self)weakSelf = self;
    __weak typeof(alert)weakAlert = alert;
    alert.selectBlock = ^(NSInteger type) {
        weakAlert.bjView.hidden = NO;
        UIImage *viewImage = [XSTools screenShotView:weakAlert.shareView];
        if (type == 1) {
            [WXApiRequestHandler sendImageData:UIImagePNGRepresentation(viewImage) TagName:nil MessageExt:nil Action:nil ThumbImage:nil InScene:WXSceneSession];
            [SingleTon getInstance].isShare = YES;

        }else if (type == 2){
            [WXApiRequestHandler sendImageData:UIImagePNGRepresentation(viewImage) TagName:nil MessageExt:nil Action:nil ThumbImage:nil InScene:WXSceneTimeline];
            [SingleTon getInstance].isShare = YES;

        }else if (type == 3){
            QQApiImageObject *obj = [QQApiImageObject objectWithData:UIImagePNGRepresentation(viewImage) previewImageData:UIImagePNGRepresentation(viewImage) title:@"" description:@""];
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:obj];
            QQApiSendResultCode sent = [QQApiInterface sendReq:req];
            [SingleTon getInstance].isShare = YES;
        }else if (type == 4){
            QQApiImageObject *obj = [QQApiImageObject objectWithData:UIImagePNGRepresentation(viewImage) previewImageData:UIImagePNGRepresentation(viewImage) title:@"" description:@""];
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:obj];
            QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
            [SingleTon getInstance].isShare = YES;
        }else if (type == 5){
            WBImageObject *imageOBJ = [WBImageObject object];
            imageOBJ.imageData = UIImagePNGRepresentation(viewImage);
            WBMessageObject *message = [WBMessageObject message];
            message.imageObject = imageOBJ;
            WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
            authRequest.redirectURI = kRedirectURI;
            authRequest.scope = @"all";
            WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:nil];
            [WeiboSDK sendRequest:request];
        }
        [WPAlertControl alertHiddenForRootControl:weakSelf completion:nil];
    };
    [WPAlertControl alertForView:alert begin:WPAlertBeginCenter end:WPAlertEndCenter animateType:WPAlertAnimateBounce constant:0 animageBeginInterval:0.3 animageEndInterval:0.3 maskColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] pan:YES rootControl:self mackClick:nil animateStatus:nil];
    
}

- (IBAction)nextLevelBtnClick:(id)sender {
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithDictionary:self.data[@"NextData"]];
    data[@"bid"] = self.data[@"bid"];
    if ([[NSString stringWithFormat:@"%@",data[@"level"]] isEqualToString:@"0"]) {
        [SVProgressHUD showErrorWithStatus:@"已经是最后一关了"];
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[LGameViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
        return;
    }
    
    LWordLevelAlertView *alert = [[NSBundle mainBundle] loadNibNamed:@"LWordLevelAlertView" owner:nil options:nil].firstObject;
    alert.frame = [UIScreen mainScreen].bounds;
    alert.levelData = data;
    __weak typeof(self)weakSelf = self;
    alert.selectBlock = ^(NSInteger type, NSDictionary * _Nonnull levelData) {
        if (type == 1) {
            LGameViewController *vc = [[LGameViewController alloc] init];
            vc.urlStr = [NSString stringWithFormat:@"%@Studyplangame/wordTopic?user_token=%@&bid=%@&level=%@&isPrize=%@",API_Root,[[SingleTon getInstance] getUser_tocken],data[@"bid"],data[@"level"],data[@"isPrize"]];
            vc.shouldNavigationBarHidden = YES;
            vc.isFromTest = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else if (type == 2){
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Word" bundle:nil];
            LLevelStudyViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LLevelStudyViewController"];
            vc.shouldNavigationBarHidden = YES;
            vc.data = data;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        [WPAlertControl alertHiddenForRootControl:weakSelf completion:nil];
    };
    
    [WPAlertControl alertForView:alert begin:WPAlertBeginCenter end:WPAlertEndCenter animateType:WPAlertAnimateBounce constant:0 animageBeginInterval:0.3 animageEndInterval:0.3 maskColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] pan:YES rootControl:self mackClick:nil animateStatus:nil];
    
}
- (IBAction)selectBtnClick:(UIButton *)sender {
    if (sender.tag == 101) {
        if (self.type==1) {
            return;
        }
        [self.lineLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
        [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(45);
            make.height.mas_equalTo(2);
            make.bottom.equalTo(self.selectRegionView);
            make.centerX.equalTo(self.leftBtn);
        }];
        self.leftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [self.leftBtn setTitleColor:RGB(105, 217, 219) forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        self.type = 1;
        [self loadData];
        
    }else if (sender.tag == 102){
        if (self.type == 2) {
            return;
        }
        [self.lineLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
        [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(45);
            make.height.mas_equalTo(2);
            make.bottom.equalTo(self.selectRegionView);
            make.centerX.equalTo(self.rightBtn);
        }];
        self.rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        self.leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.leftBtn setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:RGB(105, 217, 219) forState:UIControlStateNormal];
        self.type = 2;
        [self loadData];
    }
}
- (IBAction)backBtnClick:(UIButton *)sender {
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[LGameViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}
@end
