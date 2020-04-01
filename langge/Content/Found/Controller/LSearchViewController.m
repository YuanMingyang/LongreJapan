//
//  LSearchViewController.m
//  langge
//
//  Created by samlee on 2019/4/14.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LSearchViewController.h"
#import "LHotNewCell.h"
#import "LHistorSearchCell.h"
#import "LListCell.h"
#import "LCourseTableCell.h"
#import "LNewDetailViewController.h"
#import "LCourseDetailViewController.h"
#import "LCourseDetailController.h"

@interface LSearchViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *seaechBar;
- (IBAction)closeBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *historyView;
@property (weak, nonatomic) IBOutlet UIView *searchResultView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *newsBtn;
@property (weak, nonatomic) IBOutlet UIButton *courseBtn;
- (IBAction)selectBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *resultCountLabel;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;

@property (weak, nonatomic) IBOutlet UIView *noResultView;
- (IBAction)deleteHistoryBtnClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UICollectionView *historyCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *hotCollectionView;

@property(nonatomic,strong)UILabel *lineLabel;
@property(nonatomic,assign)int type;//1:新闻 2:课程
@property(nonatomic,assign)int page;

@property(nonatomic,strong)NSMutableArray *searchArray;

@property(nonatomic,strong)NSMutableArray *hotSearchArray;
@property(nonatomic,strong)NSMutableArray *historySearchArray;
@end

@implementation LSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self loadHotSearchData];
    [self loadHistorySearch];
}

-(void)setUI{
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = barItem;
    barItem.title = @"";
    
    
    self.noResultView.hidden = YES;
    self.seaechBar.delegate = self;
    self.page = 1;
    self.searchArray = [NSMutableArray array];
    self.hotSearchArray = [NSMutableArray array];
    self.historySearchArray = [NSMutableArray array];
    
    self.searchResultView.hidden = YES;
    self.type = 1;
    self.newsBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    self.lineLabel = [[UILabel alloc] init];
    self.lineLabel.backgroundColor = RGB(102, 102, 102);
    [self.topView addSubview:self.lineLabel];
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(2);
        make.bottom.equalTo(self.topView);
        make.centerX.equalTo(self.newsBtn);
    }];
    
    UICollectionViewFlowLayout *historySearchLayout = [[UICollectionViewFlowLayout alloc] init];
    historySearchLayout.itemSize = CGSizeMake((ScreenWidth-90)/3, 32);
    historySearchLayout.minimumLineSpacing = 15;
    historySearchLayout.minimumInteritemSpacing = 30;
    self.historyCollectionView.collectionViewLayout = historySearchLayout;
    self.historyCollectionView.delegate = self;
    self.historyCollectionView.dataSource = self;
    
    UICollectionViewFlowLayout *hotLayout = [[UICollectionViewFlowLayout alloc] init];
    hotLayout.itemSize = CGSizeMake(ScreenWidth-60, (ScreenWidth-60)*165/316+100);
    hotLayout.minimumLineSpacing = 15;
    hotLayout.minimumInteritemSpacing = 0;
    hotLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.hotCollectionView.collectionViewLayout = hotLayout;
    self.hotCollectionView.delegate = self;
    self.hotCollectionView.dataSource = self;
    
    
    [self.searchTableView registerNib:[UINib nibWithNibName:@"LListCell" bundle:nil] forCellReuseIdentifier:@"LListCell"];
    [self.searchTableView registerNib:[UINib nibWithNibName:@"LCourseTableCell" bundle:nil] forCellReuseIdentifier:@"LCourseTableCell"];
    self.searchTableView.delegate = self;
    self.searchTableView.dataSource = self;
    
    self.searchTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.searchTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

-(void)loadHotSearchData{
    [SVProgressHUD showWithStatus:@"加载中"];
    [[APIManager getInstance] getHotSearchWithCallback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            [SVProgressHUD dismiss];
            [self.hotSearchArray addObjectsFromArray:result];
            [self.hotCollectionView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:result];
        }
    }];
}
-(void)loadHistorySearch{
    [self.historySearchArray removeAllObjects];
    NSString *historyStr = [[NSUserDefaults standardUserDefaults] valueForKey:@"historySearch"];
    if (!historyStr||historyStr.length==0) {
        return;
    }
    NSArray *array = [XSTools jsonStrToArrayWith:historyStr];
    [self.historySearchArray addObjectsFromArray:array];
    [self.historyCollectionView reloadData];
}

-(void)addHistorySearchWith:(NSString *)str{
    NSString *historyStr = [[NSUserDefaults standardUserDefaults] valueForKey:@"historySearch"];
    NSMutableArray *array = [XSTools jsonStrToArrayWith:historyStr].mutableCopy;
    if (!array) {
        array = [NSMutableArray array];
    }
    if (array&&array.count == 6) {
        [array removeObjectAtIndex:0];
    }
    [array addObject:str];
    [[NSUserDefaults standardUserDefaults] setValue:[XSTools dataTOjsonString:array] forKey:@"historySearch"];
    [self.historySearchArray removeAllObjects];
    [self.historySearchArray addObjectsFromArray:array];
    [self.historyCollectionView reloadData];
}
-(void)removeSearchHistory{
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"historySearch"];
    [self.historySearchArray removeAllObjects];
    [self.historyCollectionView reloadData];
}

-(void)loadNewData{
    self.page = 1;
    [self loadData];
}
-(void)loadMoreData{
    self.page ++;
    [self loadData];
}
-(void)loadData{
    [[APIManager getInstance] fxSearchWithType:[NSString stringWithFormat:@"%d",self.type] page:[NSString stringWithFormat:@"%d",self.page] title:self.seaechBar.text callback:^(BOOL success, id  _Nonnull result) {
        [self.searchTableView.mj_header endRefreshing];
        [self.searchTableView.mj_footer endRefreshing];
        if (success) {
            
            if (self.page==1) {
                [self.searchArray removeAllObjects];
            }else{
                NSArray *data = (NSArray *)result;
                if (data.count<10) {
                    [self.searchTableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            [self.searchArray addObjectsFromArray:result];
            self.resultCountLabel.text = [NSString stringWithFormat:@"%lu条结果",self.searchArray.count];
            [self.searchTableView reloadData];
            if (self.searchArray.count==0) {
                self.noResultView.hidden = NO;
            }else{
                self.noResultView.hidden = YES;
            }
        }else{
            [SVProgressHUD showErrorWithStatus:result];
        }
    }];
    
}

#pragma mark -- UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 127;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == 1) {
        LListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LListCell"];
        cell.news = self.searchArray[indexPath.row];
        return cell;
    }else{
        LCourseTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCourseTableCell"];
        cell.course = self.searchArray[indexPath.row];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.type == 1) {
        LNewsModel *news = self.searchArray[indexPath.row];
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
    }else if (self.type == 2){
        LCourseModel *course = self.searchArray[indexPath.row];
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

#pragma mark -- UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == self.historyCollectionView) {
        return self.historySearchArray.count;
    }else{
        return self.hotSearchArray.count;
    }
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.historyCollectionView) {
        LHistorSearchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LHistorSearchCell" forIndexPath:indexPath];
        cell.searchTXT = self.historySearchArray[indexPath.row];
        return cell;
    }else{
        LHotNewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LHotNewCell" forIndexPath:indexPath];
        cell.news = self.hotSearchArray[indexPath.row];
        return cell;
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.historyCollectionView) {
        self.seaechBar.text = self.historySearchArray[indexPath.row];
        [self searchBarSearchButtonClicked:self.seaechBar];
    }else{
        LNewsModel *news = self.hotSearchArray[indexPath.row];
        if ([news.type isEqualToString:@"1"]) {
            [SVProgressHUD showWithStatus:@"加载中"];
            __weak typeof(self)wealSelf = self;
            [[APIManager getInstance] getCourseInfoWithcourseId:news._id class_hour_page:nil comment_page:nil callback:^(BOOL success, id  _Nonnull result) {
                if (success) {
                    [SVProgressHUD dismiss];
                    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Found" bundle:nil];
                    LCourseDetailController *vc = [sb instantiateViewControllerWithIdentifier:@"LCourseDetailController"];
                    vc.course_id = news._id;
                    vc.courseDetail = result;
                    LCourseModel *course = [[LCourseModel alloc] init];
                    course.cover_img_src = news.cover_img_src;
                    vc.course = course;
                    [wealSelf.navigationController pushViewController:vc animated:YES];
                }else{
                    [SVProgressHUD showErrorWithStatus:result];
                }
            }];
        }else{
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
    }
}

#pragma mark -- UISeaechBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.view endEditing:YES];
    if (self.seaechBar.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入您要搜索的内容"];
        return;
    }
    self.historyView.hidden = YES;
    self.searchResultView.hidden = NO;
    [self.searchTableView.mj_header beginRefreshing];
    [self addHistorySearchWith:searchBar.text];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.view endEditing:YES];
}
- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar{
    
}

- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar{
    
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"----%@",searchText);
    if (searchText.length == 0) {
        
    }
}
- (IBAction)closeBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)selectBtnClick:(UIButton *)sender {
    if (sender.tag == 101) {
        if (self.type == 1) {
            return;
        }
        
        [self.lineLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
        [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(45);
            make.height.mas_equalTo(2);
            make.bottom.equalTo(self.topView);
            make.centerX.equalTo(self.newsBtn);
        }];
        self.type = 1;
        self.newsBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        self.courseBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        
    }else if (sender.tag == 102){
        if (self.type == 2) {
            return;
        }
        [self.lineLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
        [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(45);
            make.height.mas_equalTo(2);
            make.bottom.equalTo(self.topView);
            make.centerX.equalTo(self.courseBtn);
        }];
        self.type = 2;
        self.newsBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        self.courseBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        
    }
    [self.searchArray removeAllObjects];
    [self.searchTableView reloadData];
    [self.searchTableView.mj_header beginRefreshing];
}
- (IBAction)deleteHistoryBtnClick:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"确认删除全部历史记录?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    __weak typeof(self)weakSelf = self;
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf removeSearchHistory];
    }];
    [alert addAction:cancel];
    [alert addAction:sure];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
    
}
@end
