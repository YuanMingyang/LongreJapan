//
//  LReviewFinishViewController.m
//  langge
//
//  Created by samlee on 2019/6/23.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LReviewFinishViewController.h"
#import "LGameViewController.h"
#import "LErrorQuestionViewController.h"
#import "LWordViewController.h"

@interface LReviewFinishViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet UIView *roundView1;
@property (weak, nonatomic) IBOutlet UIView *roundView2;
@property (weak, nonatomic) IBOutlet UIView *roundView3;
@property (weak, nonatomic) IBOutlet UIView *roundView4;
- (IBAction)backBtnClick:(id)sender;
- (IBAction)testBtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *bjView;
@end

@implementation LReviewFinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.heightConstraint.constant = StatusHeight+NaviHeight;
    [self.bjView.layer addSublayer:[XSTools getColorLayerWithStartColor:RGB(251, 124, 118) endColor:RGB(255, 182, 171) frame:CGRectMake(0, 0, ScreenWidth, 325)]];
    [self.roundView1 modifyWithcornerRadius:15 borderColor:nil borderWidth:0];
    [self.roundView2 modifyWithcornerRadius:15 borderColor:nil borderWidth:0];
    [self.roundView3 modifyWithcornerRadius:15 borderColor:nil borderWidth:0];
    [self.roundView4 modifyWithcornerRadius:15 borderColor:nil borderWidth:0];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backBtnClick:(id)sender {
    BOOL isback = NO;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[LErrorQuestionViewController class]]) {
            isback = YES;
            [self.navigationController popToViewController:vc animated:YES];
            
            break;
        }
    }
    if (!isback) {
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[LWordViewController class]]) {
                isback = YES;
                [self.navigationController popToViewController:vc animated:YES];
                
                break;
            }
        }
    }
}

- (IBAction)testBtnClick:(id)sender {
    LGameViewController *vc = [[LGameViewController alloc] init];
    vc.urlStr = [NSString stringWithFormat:@"%@Subjectwrong/wrongList?user_token=%@&isL=1",API_Root,[[SingleTon getInstance] getUser_tocken]];
    vc.shouldNavigationBarHidden = YES;
    vc.isFromErrorQuestion = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
