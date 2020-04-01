//
//  LTestSelectSoundController.m
//  langge
//
//  Created by samlee on 2019/3/26.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LTestSelectSoundController.h"
#import "SelectSoundCell.h"
#import "LTestMatchingController.h"

@interface LTestSelectSoundController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *errorView;
- (IBAction)nextBtnClick:(UIButton *)sender;
- (IBAction)submitBtnClick:(UIButton *)sender;

@end

@implementation LTestSelectSoundController
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}
- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
    [self.submitBtn modifyWithcornerRadius:20 borderColor:nil borderWidth:0];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = barItem;
    barItem.title = @"";
    self.title = @"阶段测试";
    self.topConstraint.constant = StatusHeight+NaviHeight+20;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SelectSoundCell" bundle:nil] forCellReuseIdentifier:@"SelectSoundCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundView.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
}

#pragma mark -- UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectSoundCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectSoundCell"];
    return cell;
}

- (IBAction)nextBtnClick:(UIButton *)sender {
}

- (IBAction)submitBtnClick:(UIButton *)sender {
    LTestMatchingController *vc = [[LTestMatchingController alloc] initWithNibName:@"LTestMatchingController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
