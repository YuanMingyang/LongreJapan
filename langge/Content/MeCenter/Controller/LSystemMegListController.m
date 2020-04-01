//
//  LSystemMegListController.m
//  langge
//
//  Created by samlee on 2019/4/2.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LSystemMegListController.h"
#import "LSystemMsgCell.h"
#import "LSystemDetailViewController.h"

@interface LSystemMegListController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *noResultView;
@property(nonatomic,strong)NSArray *dataSource;
@end

@implementation LSystemMegListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

-(void)setUI{
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = barItem;
    barItem.title = @"";
    self.title = @"系统消息";
    self.tableView.delegate = self;
    self.tableView.dataSource  = self;
    self.tableView.backgroundView.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.noResultView.hidden = YES;
    [self loadData];
}
-(void)loadData{
    [SVProgressHUD showWithStatus:@"加载中"];
    [[APIManager getInstance] getMessageListWithCallback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            [SVProgressHUD dismiss];
            self.dataSource = result;
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
    LSystemMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LSystemMsgCell"];
    cell.systemMsg = self.dataSource[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LSystemDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LSystemDetailViewController"];
    vc.systemMsg = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    
}
@end
