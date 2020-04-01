//
//  LNewViewController.m
//  langge
//
//  Created by samlee on 2019/4/14.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LNewViewController.h"
#import "LNewNewCell.h"
#import "LListCell.h"
#import "LNewDetailViewController.h"

@interface LNewViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,assign)int page;
@property(nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation LNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

-(void)setUI{
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = barItem;
    barItem.title = @"";
    
    self.dataSource = [NSMutableArray array];
    [self.tableView registerNib:[UINib nibWithNibName:@"LListCell" bundle:nil] forCellReuseIdentifier:@"LListCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundView.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}
-(void)loadNewData{
    self.page=1;
    [self.dataSource removeAllObjects];
    [self loadData];
}
-(void)loadMoreData{
    self.page ++;
    [self loadData];
}
-(void)loadData{
    [[APIManager getInstance] getNewListWith:self.menu._id page:[NSString stringWithFormat:@"%d",self.page] callback:^(BOOL success, id  _Nonnull result) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            
            if (self.page>1) {
                NSMutableArray *newList = (NSMutableArray *)result;
                if (newList.count<10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            [self.dataSource addObjectsFromArray:result];
            [self.tableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:result];
        }
    }];
}
#pragma mark -- UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return ScreenWidth*200/375+112;
    }else{
        return 127;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        LNewNewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LNewNewCell"];
        cell.news = self.dataSource[indexPath.row];
        return cell;
    }else{
        LListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LListCell"];
        cell.news = self.dataSource[indexPath.row];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    LNewDetailViewController *vc = [[LNewDetailViewController alloc] init];
//    vc.news = self.dataSource[indexPath.row];
//    [self.navigationController pushViewController:vc animated:YES];
    LNewsModel *news = self.dataSource[indexPath.row];
    __weak typeof(self)weakSelf = self;
    [SVProgressHUD showWithStatus:@"加载中"];
    [[APIManager getInstance] getNewsInfoWith:news._id callback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            [SVProgressHUD dismiss];
            LNewDetailViewController *vc = [[LNewDetailViewController alloc] init];
            vc.news = result;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:result];
        }
    }];
}
@end
