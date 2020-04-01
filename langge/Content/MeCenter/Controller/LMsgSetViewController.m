//
//  LMsgSetViewController.m
//  langge
//
//  Created by yang on 2019/12/14.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LMsgSetViewController.h"

@interface LMsgSetViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation LMsgSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"消息设置";
    [self.contentView modifyWithcornerRadius:5 borderColor:nil borderWidth:0];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
