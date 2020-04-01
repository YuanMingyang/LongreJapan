//
//  LCheckPointViewController.m
//  langge
//
//  Created by samlee on 2019/3/24.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LCheckPointViewController.h"
#import "LQYView.h"
#import "LZYView.h"
#import "LAYView.h"
#import "LCYView.h"
#import "LCUYView.h"
#import "UIRoundButton.h"
#import "LSoundStudyViewController.h"

@interface LCheckPointViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIImageView *bjImageView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIRoundButton *selectBtn;
@property(nonatomic,strong)UIRoundButton *lastBtn;
- (IBAction)selectBtnClick:(UIRoundButton *)sender;
- (IBAction)backBtnClick:(UIButton *)sender;

@property(nonatomic,strong)NSMutableArray *viewArr;
@end

@implementation LCheckPointViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

-(void)setUI{
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = barItem;
    barItem.title = @"";
    
    
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    self.topConstraint.constant = statusRect.size.height+20;
    
    [self.bottomView modifyWithcornerRadius:20 borderColor:nil borderWidth:0];
    
    self.lastBtn = self.selectBtn;
    [self.selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.selectBtn.backgroundColor = RGB(255, 184, 73);
    
    
    self.viewArr  = [NSMutableArray array];
    LQYView *QY = [[LQYView alloc] init];
    QY.tag = 101;
    [self.viewArr addObject:QY];
    [self.contentView addSubview:QY];
    QY.hidden = NO;
    [QY mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(320);
        make.height.mas_equalTo(498);
        make.centerX.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView);
    }];
    
    LZYView *ZY = [[LZYView alloc] init];
    ZY.hidden = YES;
    ZY.tag = 102;
    [self.viewArr addObject:ZY];
    [self.contentView addSubview:ZY];
    [ZY mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(320);
        make.height.mas_equalTo(518);
        make.centerX.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView);
    }];
    
    LAYView *AY = [[LAYView alloc] init];
    AY.hidden = YES;
    AY.tag = 103;
    [self.viewArr addObject:AY];
    [self.contentView addSubview:AY];
    [AY mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(320);
        make.height.mas_equalTo(518);
        make.centerX.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView);
    }];
    
    LCYView *CY = [[LCYView alloc] init];
    CY.hidden = YES;
    CY.tag = 104;
    [self.viewArr addObject:CY];
    [self.contentView addSubview:CY];
    [CY mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(320);
        make.height.mas_equalTo(518);
        make.centerX.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView);
    }];
    
    LCUYView *CUY = [[LCUYView alloc] init];
    CUY.hidden = YES;
    CUY.tag = 105;
    [self.viewArr addObject:CUY];
    [self.contentView addSubview:CUY];
    [CUY mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(320);
        make.height.mas_equalTo(518);
        make.centerX.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView);
    }];

    [self.contentView bringSubviewToFront:self.backBtn];
    
}

- (IBAction)selectBtnClick:(UIRoundButton *)sender {
    if (sender == self.selectBtn) {
        return;
    }
    self.lastBtn = self.selectBtn;
    self.selectBtn = sender;
    [self.selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.selectBtn.backgroundColor = RGB(255, 184, 73);
    [self.lastBtn setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
    self.lastBtn.backgroundColor = [UIColor whiteColor];
    for (UIView *view in self.viewArr) {
        if (view.tag == sender.tag) {
            view.hidden = NO;
        }else{
            view.hidden = YES;
        }
    }
    self.bjImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%lu",sender.tag]];
}

- (IBAction)backBtnClick:(UIButton *)sender {
    //[self.navigationController popViewControllerAnimated:YES];
    
    LSoundStudyViewController *vc = [[LSoundStudyViewController alloc] initWithNibName:@"LSoundStudyViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
