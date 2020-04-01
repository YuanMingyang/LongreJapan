//
//  LLucyDetailViewController.m
//  langge
//
//  Created by samlee on 2019/4/24.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LLucyDetailViewController.h"
#import "LConsultingViewController.h"
#import "UIRoundButton.h"

@interface LLucyDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
- (IBAction)startBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIRoundButton *startBtn;
@property (weak, nonatomic) IBOutlet UILabel *explainLabel;

@end

@implementation LLucyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的奖品中心";
    self.webView.scrollView.bounces = NO;
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = barItem;
    barItem.title = @"";
    [self loadData];
}
-(void)loadData{
    [SVProgressHUD showWithStatus:@"加载中"];
    [[APIManager getInstance] prize_detailsWithBid:self.lucy.bid callback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            [SVProgressHUD dismiss];
            [self updataUIWithLucy:result];
        }else{
            [SVProgressHUD showErrorWithStatus:result];
        }
    }];
}
-(void)updataUIWithLucy:(LLucyModel *)lucy{
    self.titleLabel.text = lucy.title;
    self.dateLabel.text = [NSString stringWithFormat:@"有效期至%@-%@止",lucy.start_time,lucy.end_time];
    [self.webView loadHTMLString:lucy.explain baseURL:nil];
    self.explainLabel.text = lucy.explain;
    
    if ([lucy.state isEqualToString:@"0"]) {
        self.startBtn.enabled = NO;
        [self.startBtn setTitle:@"已过期" forState:UIControlStateNormal];
        self.startBtn.backgroundColor = RGB(153, 153, 153);
    }
}

- (IBAction)startBtnClick:(id)sender {
    LConsultingViewController *vc = [[LConsultingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
