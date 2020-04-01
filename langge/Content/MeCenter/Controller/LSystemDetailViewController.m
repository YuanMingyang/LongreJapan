//
//  LSystemDetailViewController.m
//  langge
//
//  Created by samlee on 2019/5/3.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LSystemDetailViewController.h"


@interface LSystemDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *senderLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation LSystemDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

-(void)setUI{
    self.webView.scrollView.bounces = NO;
    self.titleLabel.text = self.systemMsg.title;
    self.dateLabel.text = [XSTools time_timestampToString:self.systemMsg.create_time];
    self.senderLabel.text = self.systemMsg.sender;
    [self.webView loadHTMLString:self.systemMsg.content baseURL:nil];
}
@end
