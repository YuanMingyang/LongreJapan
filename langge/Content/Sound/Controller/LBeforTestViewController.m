//
//  LBeforTestViewController.m
//  langge
//
//  Created by samlee on 2019/3/26.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LBeforTestViewController.h"
#import "LTestSelectTextController.h"
#import "LGameViewController.h"
#import "AudioManager.h"

@interface LBeforTestViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
- (IBAction)startBtnClick:(UIButton *)sender;

@end

@implementation LBeforTestViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = RGB(51, 51, 51);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : RGB(51, 51, 51),NSFontAttributeName : [UIFont systemFontOfSize:17]}];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor whiteColor],NSFontAttributeName : [UIFont systemFontOfSize:17]}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

-(void)setUI{
    self.title = self.row;
    [self.startBtn modifyWithcornerRadius:20 borderColor:nil borderWidth:0];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = barItem;
    barItem.title = @"";
}

- (IBAction)startBtnClick:(UIButton *)sender {
    LGameViewController *vc = [[LGameViewController alloc] init];
    vc.isFromTest = YES;
    NSString *str = @"";
    if ([SingleTon getInstance].isLogin) {
        str = [NSString stringWithFormat:@"%@Fiftytones/fiftytonesTopic?user_token=%@&type=%@&row=%@",API_Root,[[SingleTon getInstance] getUser_tocken],self.type,self.row];
        vc.urlStr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        vc.shouldNavigationBarHidden = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        [self.navigationController presentViewController:sb.instantiateInitialViewController animated:YES completion:nil];
    }
    
    
}
@end
