//
//  LSignAlertView.m
//  langge
//
//  Created by samlee on 2019/4/24.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LSignAlertView.h"
#import "OttoScratchView.h"
#import "LPrizeView.h"
#import "LNOPrizeView.h"

@interface LSignAlertView ()<OttoScratchViewDelegate>
@property(nonatomic,strong)NSDictionary *prize_data;

@property(nonatomic,strong)LPrizeView *prizeView;
@property(nonatomic,strong)LNOPrizeView *noPrizeView;
@property (nonatomic,strong) OttoScratchView * ottoScratchView;
@end

@implementation LSignAlertView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.weakLabel.text = [XSTools getweekDayStringWithDate:[NSDate date]];
    NSString *dateStr = [XSTools getCurrentDateStr];
    self.monthLabel.text = [[dateStr substringWithRange:NSMakeRange(5, 2)] stringByAppendingString:@"月"];
    self.haveSignImageView.hidden = YES;
    self.dayLabel.text = [dateStr substringFromIndex:8];
    self.lucyView.hidden = YES;
    [self.corverImageView modifyWithcornerRadius:15 borderColor:nil borderWidth:0];
    [self.drawLuckView modifyWithcornerRadius:15 borderColor:nil borderWidth:0];
}

- (IBAction)signBtnClick:(UIButton *)sender {
    
    
    [SVProgressHUD showWithStatus:@"提交中"];
    __weak typeof(self)weakSelf = self;
    [[APIManager getInstance] signActiveWithCallback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            [SVProgressHUD dismiss];
            sender.hidden = YES;
            weakSelf.actionClick(1);
            weakSelf.lucyView.hidden = NO;
            weakSelf.prize_data = result;
            weakSelf.haveSignImageView.hidden = NO;
        }else{
            [SVProgressHUD showErrorWithStatus:result];
        }
        
    }];
}
- (IBAction)closeBtnClick:(UIButton *)sender {
    self.actionClick(2);
    [self removeFromSuperview];
}

- (IBAction)drawLuckBtnClick:(id)sender {
    self.drawLuckView.hidden = YES;
    if ([self.prize_data[@"is_prize"] isEqualToString:@"1"]) {
        self.prizeView = [self createPrizeView];
        __weak typeof(self)weakSelf = self;
        self.prizeView.receive = ^{
            weakSelf.actionClick(3);
            [weakSelf removeFromSuperview];
        };
        [self.scratchView addSubview:self.prizeView];
    }else{
        self.noPrizeView = [self createNoPrizeView];
        [self.scratchView addSubview:self.noPrizeView];
    }
    
    [self ottoSetScratchView];
}


-(LPrizeView *)createPrizeView{
    LPrizeView *prizeView = [[LPrizeView alloc] initWithFrame:self.scratchView.bounds];
    prizeView.titleLabel.text = self.prize_data[@"prize_data"][@"title"];
    prizeView.receiveBtn.userInteractionEnabled = NO;
    return prizeView;
}
-(LNOPrizeView *)createNoPrizeView{
    LNOPrizeView* noPrizeView = [[LNOPrizeView alloc] initWithFrame:self.scratchView.bounds];
    [noPrizeView.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.prize_data[@"prize_data"][@"img_src"]] placeholderImage:[UIImage imageNamed:@"no_prize"]];
     noPrizeView.titleLabel.text = self.prize_data[@"prize_data"][@"msg"];
    return noPrizeView;
}

- (void)ottoSetScratchView{
    [self.ottoScratchView removeFromSuperview];
    
    self.ottoScratchView = [[OttoScratchView alloc] initWithFrame:CGRectMake(0, 0, self.scratchView.frame.size.width, self.scratchView.frame.size.height)];
    self.ottoScratchView.delegate = self;
    self.ottoScratchView.scratchLineWidth = 10;
    self.ottoScratchView.passCount = 10;
    

    if ([self.prize_data[@"is_prize"] isEqualToString:@"1"]) {
        LPrizeView *peizeView = [self createPrizeView];
        peizeView.receiveBtn.userInteractionEnabled = NO;
        self.prizeView.hidden = YES;
        [self.ottoScratchView addSubview:peizeView];

    }else{
        LNOPrizeView *noPrizeView = [self createNoPrizeView];
        [self.noPrizeView setHidden:YES];
        [self.ottoScratchView addSubview:noPrizeView];
    }
    [self.scratchView addSubview:self.ottoScratchView];
    

}

- (void)scratchViewDone{
    [self.ottoScratchView removeFromSuperview];
    if ([self.prize_data[@"is_prize"] isEqualToString:@"1"]) {
        [self.prizeView setHidden:NO];
        self.prizeView.receiveBtn.userInteractionEnabled = YES;
        [[APIManager getInstance] SaveUserPrizeWithPid:self.prize_data[@"prize_data"][@"pid"] callback:^(BOOL success, id  _Nonnull result) {
            if (!success) {
                [SVProgressHUD showErrorWithStatus:result];
            }
        }];
    }else{
        [self.noPrizeView setHidden:NO];
    }
    
    
}

@end
