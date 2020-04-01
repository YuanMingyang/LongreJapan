//
//  LSearchWordViewController.m
//  langge
//
//  Created by samlee on 2019/5/3.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LSearchWordViewController.h"
#import "LSearchWorDetailController.h"
#import "LWordModel.h"
#import "LWordCell.h"

@interface LSearchWordViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UIView *noResultView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
- (IBAction)cancelBtnClick:(id)sender;

- (IBAction)deleteBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;


@property(nonatomic,strong)NSMutableArray *historySearchArray;
@property(nonatomic,strong)NSMutableArray *wordArray;
@property(nonatomic,assign)int page;

@end

@implementation LSearchWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topViewHeightConstraint.constant = StatusHeight+NaviHeight;
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = barItem;
    barItem.title = @"";
    self.historySearchArray = [NSMutableArray array];
    self.searchBar.delegate = self;
    self.wordArray = [NSMutableArray array];
    [self loadHistorySearch];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundView.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.searchTableView.delegate = self;
    self.searchTableView.dataSource = self;
    self.searchTableView.backgroundView.backgroundColor = [UIColor whiteColor];
    self.searchTableView.backgroundColor = [UIColor whiteColor];
    self.searchTableView.hidden = YES;
    self.noResultView.hidden = YES;
    self.searchTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    self.searchTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

-(void)loadNewData{
    self.page = 1;
    [self.wordArray removeAllObjects];
    [self loadWordList];
}
-(void)loadMoreData{
    self.page ++;
    [self loadWordList];
}

-(void)loadWordList{
    self.searchTableView.hidden = NO;
    [[APIManager getInstance] getWordListWithJa_word:self.searchBar.text page:[NSString stringWithFormat:@"%d",self.page] callback:^(BOOL success, id  _Nonnull result) {
        [self.searchTableView.mj_header endRefreshing];
        [self.searchTableView.mj_footer endRefreshing];
        if (success) {
            
            [self.wordArray addObjectsFromArray:result];
            [self.searchTableView reloadData];
            if (self.page>1) {
                NSArray *arr = (NSArray *)result;
                if (arr.count<10) {
                    [self.searchTableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            
            if (self.wordArray.count==0) {
                self.noResultView.hidden = NO;
                //[SVProgressHUD showErrorWithStatus:@"没有这个单词哦"];
            }else{
                self.noResultView.hidden = YES;
            }
        }else{
            [SVProgressHUD showErrorWithStatus:result];
        }
    }];
}

-(void)loadHistorySearch{
    [self.historySearchArray removeAllObjects];
    NSString *historyStr = [[NSUserDefaults standardUserDefaults] valueForKey:@"wordHistorySearch"];
    if (!historyStr||historyStr.length==0) {
        return;
    }
    NSArray *array = [XSTools jsonStrToArrayWith:historyStr];
    [self.historySearchArray addObjectsFromArray:array];
    [self.tableView reloadData];
}

-(void)addHistorySearchWith:(NSString *)str{
    NSString *historyStr = [[NSUserDefaults standardUserDefaults] valueForKey:@"wordHistorySearch"];
    NSMutableArray *array = [XSTools jsonStrToArrayWith:historyStr].mutableCopy;
    if (!array) {
        array = [NSMutableArray array];
    }
    if (array&&array.count == 20) {
        [array removeLastObject];
    }
    [array insertObject:str atIndex:0];
    [[NSUserDefaults standardUserDefaults] setValue:[XSTools dataTOjsonString:array] forKey:@"wordHistorySearch"];
    [self.historySearchArray removeAllObjects];
    [self.historySearchArray addObjectsFromArray:array];
    [self.tableView reloadData];
}
-(void)removeSearchHistory{
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"wordHistorySearch"];
    [self.historySearchArray removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark -- UISearchBarDelegate
#pragma mark -- UISeaechBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.view endEditing:YES];
    if (self.searchBar.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入您要搜索的内容"];
        return;
    }
    [self addHistorySearchWith:searchBar.text];
    
    self.searchTableView.hidden = NO;
    [self.searchTableView.mj_header beginRefreshing];
    return;
    
    [SVProgressHUD showWithStatus:@"加载中"];
    __weak typeof(self)weakSelf = self;
    [[APIManager getInstance] getWordDataWithJa_word:self.searchBar.text callback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            [SVProgressHUD dismiss];
            LSearchWorDetailController *vc = [weakSelf.storyboard instantiateViewControllerWithIdentifier:@"LSearchWorDetailController"];
            LWordModel *word = [[LWordModel alloc] init];
            [word setValuesForKeysWithDictionary:result];
            vc.wordData = word;
            vc.shouldNavigationBarHidden = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:result];
        }
    }];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length>0) {
        [self addHistorySearchWith:searchBar.text];
        self.searchTableView.hidden = NO;
        [self.searchTableView.mj_header beginRefreshing];
    }else{
        self.searchTableView.hidden = YES;
        self.noResultView.hidden = YES;
    }
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.view endEditing:YES];
}

#pragma mark -- UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.tableView) {
        return self.historySearchArray.count;
    }else{
        return self.wordArray.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LWordSearchCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LWordSearchCell"];
        }
        cell.backgroundColor = [UIColor whiteColor];
        
        cell.textLabel.text = self.historySearchArray[indexPath.row];
        cell.textLabel.textColor = [UIColor blackColor];
        return cell;
    }else{
        LWordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LWordCell"];
        cell.word = self.wordArray[indexPath.row];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.tableView) {
        self.searchBar.text = self.historySearchArray[indexPath.row];
        [self searchBarSearchButtonClicked:self.searchBar];
    }else{
        LSearchWorDetailController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LSearchWorDetailController"];

        vc.wordData = self.wordArray[indexPath.row];
        vc.shouldNavigationBarHidden = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}



- (IBAction)cancelBtnClick:(id)sender {
    if (self.searchTableView.hidden == NO) {
        self.searchTableView.hidden = YES;
        self.noResultView.hidden = YES;
        self.searchBar.text = @"";
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (IBAction)deleteBtnClick:(id)sender {
    __weak typeof(self)weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"确认删除全部历史记录？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf removeSearchHistory];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [alert addAction:sure];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
    
}
@end
