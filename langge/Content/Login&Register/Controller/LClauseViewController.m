//
//  LClauseViewController.m
//  langge
//
//  Created by samlee on 2019/5/19.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LClauseViewController.h"
#import "UIViewController+BackButtonHandler.h"

@interface LClauseViewController ()
@property(nonatomic,strong)UIWebView *webView;
@end

@implementation LClauseViewController

-(BOOL)navigationShouldPopOnBackButton{
    if (self.isFromStartPage) {
        self.closeBlock();
    }
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView = [[UIWebView alloc] init];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    if (self.htmlStr) {
        [self.webView loadHTMLString:self.htmlStr baseURL:nil];
    }
    if (self.urlStr) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    }
}

-(void)dealloc{
    
}

@end
