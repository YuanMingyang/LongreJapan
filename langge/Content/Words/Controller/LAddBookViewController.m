//
//  LAddBookViewController.m
//  langge
//
//  Created by samlee on 2019/4/12.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LAddBookViewController.h"
#import "LAddBookCell.h"
#import "WPAlertControl.h"
#import "LBookAlertView.h"
#import "LSetStudyTargetController.h"
#import "LBookModel.h"
#import "LGameViewController.h"

@interface LAddBookViewController ()<UITableViewDelegate,UITableViewDataSource,LAddBookCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation LAddBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self loadData];
}
-(void)setUI{
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = barItem;
    barItem.title = @"";
    self.title = @"添加词书";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundView.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
}

-(void)loadData{
    [SVProgressHUD showWithStatus:@"加载中"];
    [[APIManager getInstance] getAllBookListWithCallback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            [SVProgressHUD dismiss];
            [self sortingDataWith:result];
            
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
        
        if (i==result.count-1) {
            [self.dataSource addObject:mutableArray];
        }
    }
    [self.tableView reloadData];
}

#pragma mark -- UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LAddBookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LAddBookCell"];
    cell.bookArray = self.dataSource[indexPath.row];
    cell.delegate = self;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark -- LAddBookCellDelegate
-(void)seleckBookWith:(LBookModel *)book{
    if ([book.is_add isEqualToString:@"1"]) {
        [self showAlertWith:book];
        return;
    }
    [SVProgressHUD showWithStatus:@"提交中"];
    __weak typeof(self)weakSelf = self;
    [[APIManager getInstance] addWordBookWithbid:book._id callback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            [SVProgressHUD dismiss];
            [weakSelf showAlertWith:book];
            [weakSelf loadData];
            weakSelf.reloadDataBlock();
        }else{
            [SVProgressHUD showErrorWithStatus:result];
        }
    }];
    
    
}

-(void)showAlertWith:(LBookModel *)book{
    LBookAlertView *alert = [[NSBundle mainBundle] loadNibNamed:@"LBookAlertView" owner:nil options:nil].firstObject;
    alert.book = book;
    alert.frame = [UIScreen mainScreen].bounds;
    __weak typeof(self)weakSelf = self;
    alert.selectDelect = ^(int status) {
        if (status == 1) {
            LSetStudyTargetController *vc = [weakSelf.storyboard instantiateViewControllerWithIdentifier:@"LSetStudyTargetController"];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else if (status == 2){
            
        }else if (status == 3){
            LGameViewController *vc = [[LGameViewController alloc] init];
            NSString *urlStr = [NSString stringWithFormat:@"%@Studyplangame/wordLevel?bid=%@&user_token=%@",API_Root,book._id,[[SingleTon getInstance] getUser_tocken]];
            vc.urlStr = urlStr;
            vc.shouldNavigationBarHidden = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        [WPAlertControl alertHiddenForRootControl:weakSelf completion:nil];
    };
    [WPAlertControl alertForView:alert begin:WPAlertBeginCenter end:WPAlertEndCenter animateType:WPAlertAnimateBounce constant:0 animageBeginInterval:0.3 animageEndInterval:0.3 maskColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] pan:YES rootControl:self mackClick:nil animateStatus:nil];
}
@end
