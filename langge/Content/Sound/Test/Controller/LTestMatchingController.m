//
//  LTestMatchingController.m
//  langge
//
//  Created by samlee on 2019/3/26.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LTestMatchingController.h"
#import "UIRoundButton.h"
#import "LTestWriteController.h"

@interface LTestMatchingController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
- (IBAction)submitBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
- (IBAction)leftBtnClick:(UIRoundButton *)sender;
- (IBAction)rightBtnClick:(UIRoundButton *)sender;

@property(nonatomic,strong)UIRoundButton *leftSelectBtn;
@property(nonatomic,strong)UIRoundButton *rightSelectBtn;

@property(nonatomic,strong)NSMutableArray *selectTagArr;
@property(nonatomic,strong)NSMutableArray *pathLayers;//所有线
@property(nonatomic,strong)CAShapeLayer *pathLayer;//当前线的layer
@property (nonatomic,strong)UIBezierPath *bezierPath;
@end

@implementation LTestMatchingController
-(NSMutableArray *)pathLayers{
    if (!_pathLayers) {
        _pathLayers = [NSMutableArray array];
    }
    return _pathLayers;
}
-(NSMutableArray *)selectTagArr{
    if (!_selectTagArr) {
        _selectTagArr = [NSMutableArray array];
    }
    return _selectTagArr;
}

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
    self.topConstraint.constant = StatusHeight+NaviHeight+30;
}
/** 判断此btn是否已经连线 */
-(BOOL)checkBtnIsSelectWith:(NSInteger)tag{
    for (NSString *str in self.selectTagArr) {
        if ([[NSString stringWithFormat:@"%lu",tag] isEqualToString:str]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark -- action

- (IBAction)submitBtnClick:(UIButton *)sender {
    LTestWriteController *vc = [[LTestWriteController alloc] initWithNibName:@"LTestWriteController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)leftBtnClick:(UIRoundButton *)sender {
    if ([self checkBtnIsSelectWith:sender.tag]) {
        return;
    }
    [self.leftSelectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.leftSelectBtn = sender;
    [sender setTitleColor:RGB(255, 184, 73) forState:UIControlStateNormal];
}

- (IBAction)rightBtnClick:(UIRoundButton *)sender {
    if ([self checkBtnIsSelectWith:sender.tag]) {
        return;
    }
    if (!self.leftSelectBtn) {
        return;
    }
    
    CGPoint leftPoint = CGPointMake(self.leftView.frame.size.width-25, (self.leftSelectBtn.tag-101)*55+35);
    CGPoint rightPoint = CGPointMake(25, (sender.tag-201)*55+35);
    leftPoint = [self.leftView convertPoint:leftPoint toView:self.view];
    rightPoint = [self.rightView convertPoint:rightPoint toView:self.view];
    [self createLineWithStratPoint:leftPoint endPoint:rightPoint];
    [self.selectTagArr addObject:[NSString stringWithFormat:@"%lu",self.leftSelectBtn.tag]];
    [self.selectTagArr addObject:[NSString stringWithFormat:@"%lu",sender.tag]];
    [self.leftSelectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.leftSelectBtn = nil;
}
-(void)createLineWithStratPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint{
    self.bezierPath = [UIBezierPath bezierPath];
    [self.bezierPath moveToPoint:startPoint];
    [self.bezierPath addLineToPoint:endPoint];
    self.pathLayer = [CAShapeLayer layer];
    self.pathLayer.frame = self.view.bounds;
    self.pathLayer.path = self.bezierPath.CGPath;
    self.pathLayer.lineWidth = 1;
    self.pathLayer.strokeColor = [UIColor blackColor].CGColor;
    self.pathLayer.fillColor = nil;
    [self.view.layer addSublayer:self.pathLayer];
    [self.pathLayers addObject:self.pathLayer];
}
@end
