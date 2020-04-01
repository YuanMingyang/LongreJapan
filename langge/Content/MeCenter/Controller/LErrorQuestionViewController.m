//
//  LErrorQuestionViewController.m
//  langge
//
//  Created by samlee on 2019/4/19.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LErrorQuestionViewController.h"
#import "LErrorWordCell.h"
#import "LStrangeCell.h"
#import "LAnnotationView.h"
#import "LErrorReviewController.h"
#import "LStrangeWordModel.h"
#import "LSubjectWrongModel.h"
#import "AudioManager.h"
#import "LGameViewController.h"
#import "LWordModel.h"
#import "LAdviceViewController.h"

@interface LErrorQuestionViewController ()<UITableViewDelegate,UITableViewDataSource,LAnnotationViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *bjView;

- (IBAction)backBtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
- (IBAction)leftBtnClick:(UIButton *)sender;
- (IBAction)rightBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *errorView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;//默认40 X+20
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;
- (IBAction)startBtnClick:(id)sender;
- (IBAction)reviewBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *errorTableView;
@property (weak, nonatomic) IBOutlet UIView *strangeWordView;
- (IBAction)strangeStarBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *strangeWordTableView;
@property (weak, nonatomic) IBOutlet UIView *errorNoResultView;
@property (weak, nonatomic) IBOutlet UIView *strangeNoResultView;

@property(nonatomic,strong)LAnnotationView *annotationView;

@property(nonatomic,strong)NSMutableDictionary *subjectWrongList;

@property(nonatomic,strong)NSMutableArray *strangeWordArray;
@property(nonatomic,strong)NSMutableArray *errorArray;
@property(nonatomic,strong)LStrangeWordModel *selectStrangeWord;

@property(nonatomic,strong)UILabel *lineLabel;
@property(nonatomic,assign)int type;//1:错题集 2:生词本

@end

@implementation LErrorQuestionViewController
-(LAnnotationView *)annotationView{
    if (!_annotationView) {
        _annotationView = [[NSBundle mainBundle] loadNibNamed:@"LAnnotationView" owner:nil options:nil].firstObject;
        _annotationView.delegate = self;
        _annotationView.status = 0;
        [self.view addSubview:_annotationView];
        [_annotationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.height.mas_equalTo(ScreenHeight);
            make.bottom.equalTo(self.view).offset(ScreenHeight);
        }];
    }
    return _annotationView;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self getWordStrangeList];
    [self getSubjectWrong];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    
}
-(void)setUI{
    self.errorNoResultView.hidden = YES;
    self.strangeNoResultView.hidden = YES;
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = barItem;
    barItem.title = @"";
    [self.bjView.layer addSublayer:[XSTools getColorLayerWithStartColor:RGB(255, 182, 171) endColor:RGB(251, 124, 118) frame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)]];
    
    self.topViewHeightConstraint.constant = NaviHeight + StatusHeight;
    if (KIsiPhoneX) {
        self.bottomConstraint.constant = 60;
    }else{
        self.bottomConstraint.constant = 40;
    }
    self.lineLabel = [[UILabel alloc] init];
    self.lineLabel.backgroundColor = [UIColor whiteColor];
    [self.selectView addSubview:self.lineLabel];
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(46);
        make.height.mas_equalTo(2);
        make.bottom.equalTo(self.selectView);
        make.centerX.equalTo(self.leftBtn);
    }];
    self.leftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    self.type = 1;
    self.strangeWordView.hidden = YES;
    self.errorTableView.delegate = self;
    self.errorTableView.dataSource = self;
    self.strangeWordTableView.delegate = self;
    self.strangeWordTableView.dataSource = self;
}

-(void)getWordStrangeList{
    [SVProgressHUD showWithStatus:@"加载中"];
    [[APIManager getInstance] wordStrangeListWithtype:@"1" Callback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            [SVProgressHUD dismiss];
            self.strangeWordArray = result;
            if (self.strangeWordArray.count>0) {
                self.strangeNoResultView.hidden = YES;
            }else{
                self.strangeNoResultView.hidden = NO;
            }
            [self.strangeWordTableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:result];
        }
    }];
}

-(void)getSubjectWrong{
    [SVProgressHUD showWithStatus:@"加载中"];
    [[APIManager getInstance] subjectWrongListWithCallback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            [SVProgressHUD dismiss];
            self.subjectWrongList = result;
            if (self.subjectWrongList.count>0) {
                self.errorNoResultView.hidden = YES;
            }else{
                self.errorNoResultView.hidden = NO;
            }
            [self updataLeftBtnTitle];
            [self.errorTableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:result];
        }
    }];
}
-(void)updataLeftBtnTitle{
    NSInteger count = 0;
    for (NSArray *arr in self.subjectWrongList.allValues) {
        count+=arr.count;
    }
    [self.leftBtn setTitle:[NSString stringWithFormat:@"错题集 %lu",count] forState:UIControlStateNormal];
}

-(void)updataAnnotationLayout{
    CGFloat height = 0;
    if (KIsiPhoneX) {
        height = 30;
    }
    if (self.annotationView.status == 0) {
        self.annotationView.status = 1;
        [self.annotationView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(ScreenHeight-170-height-NaviHeight);
        }];
        self.bottomSpace.constant = 160+NaviHeight+height;
    }else if (self.annotationView.status==1){
        self.annotationView.status = 2;
        [self.annotationView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(0);
        }];
        self.bottomSpace.constant = 0;
    }else if (self.annotationView.status == 2){
        self.annotationView.status = 0;
        [self.annotationView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(ScreenHeight);
        }];
        self.bottomSpace.constant = 0;
    }
    [self.view layoutIfNeeded];
}

#pragma mark -- UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.errorTableView) {
        return self.subjectWrongList.allKeys.count;
    }else{
        return 1;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.errorTableView) {
        NSArray *array = self.subjectWrongList.allValues[section];
        return array.count;
    }else{
        return self.strangeWordArray.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.errorTableView) {
        NSArray *array = self.subjectWrongList.allValues[indexPath.section];
        LSubjectWrongModel *subject = array[indexPath.row];
        LErrorWordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LErrorWordCell"];
        cell.subject = subject;
        cell.thisIndex = indexPath.row;
        return cell;
    }else{
        LStrangeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LStrangeCell"];
        LStrangeWordModel *strangeWord = self.strangeWordArray[indexPath.row];
        cell.titleLabel.text = strangeWord.title;
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (tableView==self.errorTableView) {
        
    }else{
        LStrangeWordModel *strangeWord = self.strangeWordArray[indexPath.row];
        if (self.selectStrangeWord==strangeWord) {
            return;
        }
        self.selectStrangeWord = self.strangeWordArray[indexPath.row];
        [SVProgressHUD showWithStatus:@"加载中"];
        __weak typeof(self)weakSelf = self;
        [[APIManager getInstance] getWordDataWithJa_word:strangeWord.title callback:^(BOOL success, id  _Nonnull result) {
            if (success) {
                [SVProgressHUD dismiss];
                LWordModel *word = [[LWordModel alloc] init];
                [word setValuesForKeysWithDictionary:result];
                strangeWord.data = word;
                weakSelf.annotationView.wordData = word;
                if (weakSelf.annotationView.status==0) {
                    [weakSelf updataAnnotationLayout];
                }
            }else{
                [SVProgressHUD showErrorWithStatus:result];
            }
        }];
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView == self.errorTableView) {
        return self.subjectWrongList.allKeys[section];
    }else{
        return @"";
    }
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.errorTableView) {
        return YES;
    }else{
        return NO;
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray *array = self.subjectWrongList.allValues[indexPath.section];
        LSubjectWrongModel *subject = array[indexPath.row];
        __weak typeof(self)weakSelf = self;
        [[APIManager getInstance] delSubjectWrongWithID:subject._id callback:^(BOOL success, id  _Nonnull result) {
            if (success) {
                [array removeObject:subject];
                [self updataLeftBtnTitle];
                [weakSelf.errorTableView reloadData];
            }else{
                [SVProgressHUD showErrorWithStatus:result];
            }
        }];
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

#pragma mark -- LAnnotationViewDelegate
-(void)clickError{
    LAdviceViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LAdviceViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)moveWith:(UIPanGestureRecognizer *)pan{
    CGPoint point = [pan translationInView:self.view];
    CGFloat height = 0;
    if (KIsiPhoneX) {
        height = 30;
    }
    [[AudioManager shareManager] pause];
    if (self.annotationView.status==1) {
        if (point.y<0) {
            [self.annotationView mas_updateConstraints:^(MASConstraintMaker *make) {
               make.bottom.equalTo(self.view).offset(ScreenHeight-170-height-NaviHeight+point.y);
            }];
            if (point.y<-160-height) {
                [self updataAnnotationLayout];
            }
        }
    }else if (self.annotationView.status == 2){
        if (point.y>0) {
            [self.annotationView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view).offset(point.y);
            }];
            if (point.y>160+height) {
                [self updataAnnotationLayout];
            }
        }
    }
    [self.view layoutIfNeeded];
}

#pragma mark -- action

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)leftBtnClick:(UIButton *)sender {
    [[AudioManager shareManager] pause];
    if (self.type == 1) {
        return;
    }
    self.leftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.type = 1;
    self.errorView.hidden = NO;
    self.strangeWordView.hidden = YES;
    [self.lineLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
    }];
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(46);
        make.height.mas_equalTo(2);
        make.bottom.equalTo(self.selectView);
        make.centerX.equalTo(self.leftBtn);
    }];
    
    if (self.annotationView.status == 1) {
        [self.annotationView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(ScreenHeight);
        }];
        self.bottomSpace.constant = 0;
        self.annotationView.status = 0;
        [self.view layoutIfNeeded];
    }
}

- (IBAction)rightBtnClick:(UIButton *)sender {
    if (self.type == 2) {
        return;
    }
    self.rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    self.leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.type = 2;
    self.errorView.hidden = YES;
    self.strangeWordView.hidden = NO;
    [self.lineLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
    }];
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(46);
        make.height.mas_equalTo(2);
        make.bottom.equalTo(self.selectView);
        make.centerX.equalTo(self.rightBtn);
    }];
}
- (IBAction)startBtnClick:(id)sender {
    LGameViewController *vc = [[LGameViewController alloc] init];
    vc.urlStr = [NSString stringWithFormat:@"%@Subjectwrong/wrongList?user_token=%@&isL=1",API_Root,[[SingleTon getInstance] getUser_tocken]];
    vc.shouldNavigationBarHidden = YES;
    vc.isFromErrorQuestion = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)reviewBtnClick:(id)sender {
    LGameViewController *vc = [[LGameViewController alloc] init];
    vc.urlStr = [NSString stringWithFormat:@"%@Subjectwrong/wrongList?user_token=%@&isL=1&isR=1",API_Root,[[SingleTon getInstance] getUser_tocken]];
    vc.isFromErrorQuestion = YES;
    vc.shouldNavigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)strangeStarBtnClick:(id)sender {
    
    if (self.strangeWordArray.count==0) {
        [SVProgressHUD showErrorWithStatus:@"当前还没生词"];
        return;
    }
    
    LErrorReviewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LErrorReviewController"];
    vc.shouldNavigationBarHidden = YES;
    vc.type = @"1";
    vc.strangeWordArray = self.strangeWordArray;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
