//
//  LConsultingViewController.m
//  langge
//
//  Created by samlee on 2019/4/27.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LConsultingViewController.h"

@interface LConsultingViewController ()
@property(nonatomic,strong)UIWebView *webView;
@end

@implementation LConsultingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[UIWebView alloc] init];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    self.webView.scrollView.bounces = NO;
    //https://static.meiqia.com/dist/standalone.html?_=t&eid=136380
//    NSString *urlStr = @"https://chat.meiqiayun.com/widget/standalone.html?eid=136380&utm_source=日语助手app";
//    urlStr =  [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    
    [SVProgressHUD showWithStatus:@"加载中"];
    [[APIManager getInstance] getCSUrlWithCallback:^(BOOL success, id  _Nonnull data) {
        if (success) {
            [SVProgressHUD dismiss];
            NSString *url = [data stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        }else{
            [SVProgressHUD showErrorWithStatus:data];
        }
    }];
}



@end
