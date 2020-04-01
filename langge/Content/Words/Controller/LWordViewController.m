//
//  LWordViewController.m
//  langge
//
//  Created by samlee on 2019/4/12.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LWordViewController.h"
#import "LBookListTableViewCell.h"
#import "LAddBookViewController.h"
#import "WPAlertControl.h"
#import "LBookDeleteAlertView.h"
#import "LReviewViewController.h"
#import "LBookModel.h"
#import "LGameViewController.h"
#import "LCommonTableHeaderView.h"

@interface LWordViewController ()<UITableViewDelegate,UITableViewDataSource,LBookListTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *addBookImageView;

@property(nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation LWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadBookList) name:@"loginStatusChange" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadBookList) name:@"updataWordList" object:nil];
}
-(void)setUI{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadBookList) name:@"UpDataBookList" object:nil];
    
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = barItem;
    barItem.title = @"";
    self.shouldNavigationBarHidden = NO;
    [self.tableView  registerNib:[UINib nibWithNibName:@"LCommonTableHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"LCommonTableHeaderView"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundView.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadBookList)];
    [self.tableView.mj_header beginRefreshing];
    
    UIButton *right = [[UIButton alloc] init];
    [right setImage:[UIImage imageNamed:@"add_icon"] forState:UIControlStateNormal];
    [right addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:right];
    
    
    self.addBookImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addBtnClick)];
    [self.addBookImageView addGestureRecognizer:tap];
}


-(void)loadBookList{
    if (![SingleTon getInstance].isLogin) {
        self.tableView.hidden = YES;
        [self.tableView.mj_header endRefreshing];
        return;
    }
    
    [[APIManager getInstance] getPlanListWithCallback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            [self.tableView.mj_header endRefreshing];
            
            self.dataSource = result;
            if (self.dataSource.count == 0) {
                self.tableView.hidden = YES;
            }else{
                [self.tableView reloadData];
                self.tableView.hidden = NO;
            }
            
        }else{
            [SVProgressHUD showErrorWithStatus:result];
        }
    }];
}

-(void)sortingDataWith:(NSMutableArray *)result{
    self.dataSource = [NSMutableArray array];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (int i = 0; i < result.count; i++) {
        if (i%3==0) {
            if (i>0) {
                [self.dataSource addObject:mutableArray];
            }
            mutableArray = [NSMutableArray array];
        }
        [mutableArray addObject:result[i]];
    }
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 137;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    LCommonTableHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LCommonTableHeaderView"];
    view.backgroundColor = [UIColor greenColor];
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LBookListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBookListTableViewCell"];
    cell.book = self.dataSource[indexPath.section];
    cell.delegate = self;
    return cell;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        LBookDeleteAlertView *view = [[NSBundle mainBundle] loadNibNamed:@"LBookDeleteAlertView" owner:nil options:nil].firstObject;
        view.frame = CGRectMake((ScreenWidth-300)/2, (ScreenHeight-190)/2, 300, 190);
        view.book = self.dataSource[indexPath.section];
        __weak typeof(self)weakSelf = self;
        view.selectBlock = ^(BOOL result) {
            if (result) {
                
                LBookModel *book = weakSelf.dataSource[indexPath.section];
                [[APIManager getInstance] delUserWordbookWithBid:book.bookId callback:^(BOOL success, id  _Nonnull result) {
                    if (success) {
                        [weakSelf.dataSource removeObject:book];
                        [weakSelf.tableView reloadData];
                        
                    }else{
                        [SVProgressHUD showErrorWithStatus:result];
                    }
                }];
            }
            [WPAlertControl alertHiddenForRootControl:weakSelf completion:nil];
        };
        [WPAlertControl alertForView:view begin:WPAlertBeginCenter end:WPAlertEndCenter animateType:WPAlertAnimateBounce constant:0 animageBeginInterval:0.3 animageEndInterval:0.3 maskColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] pan:YES rootControl:self mackClick:nil animateStatus:nil];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}


#pragma mark -- LBookListTableViewCellDelegate
-(void)clickReveiw:(id)book{
    LBookModel *bookModel = (LBookModel *)book;
    LGameViewController *vc = [[LGameViewController alloc] init];
    NSString *urlStr = [NSString stringWithFormat:@"%@Subjectwrong/wrongList?user_token=%@&page=1&bid=%@",API_Root,[[SingleTon getInstance] getUser_tocken],bookModel.bookId];
    vc.urlStr = urlStr;
    vc.shouldNavigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)clickStart:(id)book{
    LBookModel *bookModel = (LBookModel *)book;
    LGameViewController *vc = [[LGameViewController alloc] init];
    NSString *urlStr = [NSString stringWithFormat:@"%@Studyplangame/wordLevel?bid=%@&user_token=%@",API_Root,bookModel.bookId,[[SingleTon getInstance] getUser_tocken]];
    vc.urlStr = urlStr;
    vc.shouldNavigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- action
-(void)addBtnClick{
    if ([SingleTon getInstance].isLogin) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Word" bundle:nil];
        LAddBookViewController *vc = sb.instantiateInitialViewController;
        __weak typeof(self)weakSelf = self;
        vc.reloadDataBlock = ^{
            [weakSelf loadBookList];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        [self.navigationController presentViewController:sb.instantiateInitialViewController animated:YES completion:nil];
    }
    
}
-(void)recordBtnClick{
    
}
@end
