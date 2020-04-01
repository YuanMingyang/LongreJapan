//
//  LLucyViewController.m
//  langge
//
//  Created by samlee on 2019/4/24.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LLucyViewController.h"
#import "LLucyModel.h"
#import "LLucyCell.h"
#import "LLucyDetailViewController.h"

@interface LLucyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *noResultView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation LLucyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的奖品中心";
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = barItem;
    barItem.title = @"";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundView.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.dataSource = [NSMutableArray array];
    self.noResultView.hidden = YES;
    [self loadData];
}

-(void)loadData{
    [SVProgressHUD showWithStatus:@"加载中"];
    [self.dataSource removeAllObjects];
    [[APIManager getInstance] drawListWithCallback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            [SVProgressHUD dismiss];
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

#pragma mark -- UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LLucyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLucyCell"];
    cell.lucy = self.dataSource[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LLucyDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LLucyDetailViewController"];
    vc.lucy = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
