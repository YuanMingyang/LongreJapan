//
//  LCourseListViewController.m
//  langge
//
//  Created by samlee on 2019/4/15.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LCourseListViewController.h"
#import "LCourseTableCell.h"
#import "LCourseDetailViewController.h"
#import "LConsultingViewController.h"
#import "LCourseDetailController.h"

@interface LCourseListViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIView *noResultView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *welcomeBtn;
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
@property (weak, nonatomic) IBOutlet UIButton *headsetBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)welComeBtnClick:(UIButton *)sender;
- (IBAction)priceBtnClick:(UIButton *)sender;
- (IBAction)headsetBtnClick:(UIButton *)sender;

@property(nonatomic,strong)NSString *order_field;
@property(nonatomic,strong)NSString *order_value;
@property(nonatomic,assign)int page;
@property(nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation LCourseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
    self.noResultView.hidden = YES;
    self.title = @"日本語課程";
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = barItem;
    barItem.title = @"";
    self.searchBar.delegate = self;
    [self.welcomeBtn setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    [self.welcomeBtn setImage:[UIImage imageNamed:@"up"] forState:UIControlStateSelected];
    [self.priceBtn setImage:nil forState:UIControlStateNormal];
    [self.priceBtn setImage:nil forState:UIControlStateSelected];
    self.order_field = @"buyers_num";
    self.order_value = @"DESC";
    self.page = 1;
    self.dataSource = [NSMutableArray array];
    [self.headsetBtn modifyWithcornerRadius:24 borderColor:[UIColor whiteColor] borderWidth:2];
    [self.tableView registerNib:[UINib nibWithNibName:@"LCourseTableCell" bundle:nil] forCellReuseIdentifier:@"LCourseTableCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundView.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
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
    
    [[APIManager getInstance] getCourseListWith:self.searchBar.text order_field:self.order_field order_value:self.order_value page:[NSString stringWithFormat:@"%d",self.page] callback:^(BOOL success, id  _Nonnull result) {

        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            if (self.page == 1) {
                [self.dataSource removeAllObjects];
            }else{
                NSArray *courseList = (NSArray *)result;
                if (courseList.count<10) {
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
            [SVProgressHUD dismiss];
        }
    }];
}

#pragma mark -- UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 127;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LCourseTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCourseTableCell"];
    cell.course = self.dataSource[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

#pragma mark -- UISeaechBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.view endEditing:YES];
    if (self.searchBar.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入您要搜索的内容"];
        return;
    }
    [self.tableView.mj_header beginRefreshing];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.view endEditing:YES];
}

- (IBAction)welComeBtnClick:(UIButton *)sender {
    if ([self.order_field isEqualToString:@"buyers_num"]) {
        sender.selected = !sender.selected;
        if (sender.selected) {
            self.order_value = @"ASC";
        }else{
            self.order_value = @"DESC";
        }
    }else{
        [sender setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"up"] forState:UIControlStateSelected];
        [self.priceBtn setImage:nil forState:UIControlStateNormal];
        [self.priceBtn setImage:nil forState:UIControlStateSelected];
        sender.selected = NO;
        self.order_field = @"buyers_num";
        self.order_value = @"DESC";
    }
    [self.tableView.mj_header beginRefreshing];
}

- (IBAction)priceBtnClick:(UIButton *)sender {
    if ([self.order_field isEqualToString:@"price"]) {
        sender.selected = !sender.selected;
        if (sender.selected) {
            self.order_value = @"ASC";
        }else{
            self.order_value = @"DESC";
        }
    }else{
        [sender setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"up"] forState:UIControlStateSelected];
        [self.welcomeBtn setImage:nil forState:UIControlStateNormal];
        [self.welcomeBtn setImage:nil forState:UIControlStateSelected];
        sender.selected = NO;
        self.order_field = @"price";
        self.order_value = @"DESC";
    }
    [self.tableView.mj_header beginRefreshing];
}

- (IBAction)headsetBtnClick:(UIButton *)sender {
    LConsultingViewController *vc = [[LConsultingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
