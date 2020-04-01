//
//  LTestSelectTextController.m
//  langge
//
//  Created by samlee on 2019/3/26.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LTestSelectTextController.h"
#import "LSelectTextCell.h"
#import "LTestSelectSoundController.h"

@interface LTestSelectTextController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIView *erroeView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)nextBtnClick:(UIButton *)sender;
- (IBAction)playBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *explainLabel;

@end

@implementation LTestSelectTextController
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
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = barItem;
    barItem.title = @"";
    self.title = @"阶段测试";
    self.topConstraint.constant = StatusHeight+NaviHeight+20;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundView.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"LSelectTextCell" bundle:nil] forCellReuseIdentifier:@"LSelectTextCell"];
}


#pragma mark -- UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LSelectTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LSelectTextCell"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LTestSelectSoundController *vc = [[LTestSelectSoundController alloc] initWithNibName:@"LTestSelectSoundController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (IBAction)nextBtnClick:(UIButton *)sender {
}

- (IBAction)playBtnClick:(UIButton *)sender {
}
@end
