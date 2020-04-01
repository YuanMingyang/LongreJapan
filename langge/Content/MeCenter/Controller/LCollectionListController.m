//
//  LCollectionListController.m
//  langge
//
//  Created by samlee on 2019/4/2.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LCollectionListController.h"
#import "LListCell.h"
#import "LCourseTableCell.h"
#import "LNewDetailViewController.h"
#import "LCourseDetailViewController.h"
#import "LCourseDetailController.h"

@interface LCollectionListController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *newsBtn;
@property (weak, nonatomic) IBOutlet UIButton *courseBtn;
@property (weak, nonatomic) IBOutlet UIView *topBJView;
- (IBAction)selectBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *noResultView;

@property(nonatomic,strong)UILabel *lineLabel;
@property(nonatomic,assign)int type;//1:课程 2:新闻
@property(nonatomic,assign)int page;
@property(nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation LCollectionListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
    self.title = @"我的收藏";
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = barItem;
    barItem.title = @"";
    self.noResultView.hidden = YES;
    
    self.page = 1;
    self.dataSource = [NSMutableArray array];
    self.type = 2;
    self.newsBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    self.lineLabel = [[UILabel alloc] init];
    self.lineLabel.backgroundColor = RGB(102, 102, 102);
    [self.topBJView addSubview:self.lineLabel];
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(2);
        make.bottom.equalTo(self.topBJView);
        make.centerX.equalTo(self.newsBtn);
    }];
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundView.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"LListCell" bundle:nil] forCellReuseIdentifier:@"LListCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"LCourseTableCell" bundle:nil] forCellReuseIdentifier:@"LCourseTableCell"];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}
-(void)loadNewData{
    self.page = 1;
    [self loadData];
}
-(void)loadMoreData{
    self.page++;
    [self loadData];
}
-(void)loadData{
    [[APIManager getInstance] getCollectionListWithType:[NSString stringWithFormat:@"%d",self.type] page:[NSString stringWithFormat:@"%d",self.page] callback:^(BOOL success, id  _Nonnull result) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        if (success) {
            if (self.page == 1) {
                [self.dataSource removeAllObjects];
            }else{
                NSArray *arr = (NSArray *)result;
                if (arr.count<10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                
            }
            [self.dataSource addObjectsFromArray:result];
            if (self.dataSource.count>0) {
                self.noResultView.hidden = YES;
            }else{
                self.noResultView.hidden = NO;
            }
            [self.tableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:result];
        }
    }];
}
#pragma mark - - UITableViewDelegate;
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 127;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == 2) {
        LListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LListCell"];
        cell.news = self.dataSource[indexPath.row];
        return cell;
    }else{
        LCourseTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCourseTableCell"];
        cell.course = self.dataSource[indexPath.row];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.type == 2) {
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
    }else if (self.type == 1){
        LCourseModel *course = self.dataSource[indexPath.row];
        [SVProgressHUD showWithStatus:@"加载中"];
        __weak typeof(self)wealSelf = self;
        [[APIManager getInstance] getCourseInfoWithcourseId:course._id class_hour_page:nil comment_page:nil callback:^(BOOL success, id  _Nonnull result) {
            if (success) {
                [SVProgressHUD dismiss];
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Found" bundle:nil];
                LCourseDetailController *vc = [sb instantiateViewControllerWithIdentifier:@"LCourseDetailController"];
                vc.course_id = course._id;
                vc.courseDetail = result;
                vc.course = course;
                [wealSelf.navigationController pushViewController:vc animated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:result];
            }
        }];
    }
}



- (IBAction)selectBtnClick:(UIButton *)sender {
    if (sender.tag == 101) {
        if (self.type == 2) {
            return;
        }
        
        [self.lineLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
        [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(45);
            make.height.mas_equalTo(2);
            make.bottom.equalTo(self.topBJView);
            make.centerX.equalTo(self.newsBtn);
        }];
        self.type = 2;
        self.newsBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        self.courseBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }else if (sender.tag == 102){
        if (self.type == 1) {
            return;
        }
        [self.lineLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
        [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(45);
            make.height.mas_equalTo(2);
            make.bottom.equalTo(self.topBJView);
            make.centerX.equalTo(self.courseBtn);
        }];
        self.type = 1;
        self.newsBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        self.courseBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        
    }
    [self.dataSource removeAllObjects];
    [self.tableView reloadData];
    
    [self.tableView.mj_header beginRefreshing];
}
@end
