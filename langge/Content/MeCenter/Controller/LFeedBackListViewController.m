//
//  LFeedBackListViewController.m
//  langge
//
//  Created by samlee on 2019/5/2.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LFeedBackListViewController.h"
#import "LFeedBackModel.h"
#import "LFeedBackCell.h"
#import "LAdviceDetailViewController.h"

@interface LFeedBackListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *noResultView;

@property(nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation LFeedBackListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的吐槽记录";
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
    [[APIManager getInstance] getFeedbackListWithCallback:^(BOOL success, id  _Nonnull result) {
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
    LFeedBackCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LFeedBackCell"];
    cell.feedBack = self.dataSource[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LFeedBackModel *feedBack = self.dataSource[indexPath.row];
    [SVProgressHUD showWithStatus:@"加载中"];
    [[APIManager getInstance] getFeedbackInfoWithBackID:feedBack._id callback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            [SVProgressHUD dismiss];
            LAdviceDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LAdviceDetailViewController"];
            vc.feedback = result;
            if (![[NSString stringWithFormat:@"%@",feedBack.is_reply] isEqualToString:@"0"]) {
                feedBack.is_reply = @"0";
                [self.tableView  reloadData];
                [[APIManager getInstance] getUserInfoWithCallback:^(BOOL success, id  _Nonnull result) {
                    
                }];
            }
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:result];
        }
    }];
}
@end
