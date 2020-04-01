//
//  LErrorReviewController.m
//  langge
//
//  Created by samlee on 2019/4/19.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LErrorReviewController.h"
#import "LZSwipeableView.h"
#import "LErrorReviewCell.h"
#import "AudioManager.h"
#import "LWordModel.h"

@interface LErrorReviewController ()<LZSwipeableViewDataSource,LZSwipeableViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet UISwitch *isAutoSwitch;

- (IBAction)backBtnClick:(id)sender;
- (IBAction)isAutoSwitchChange:(UISwitch *)sender;
@property (weak, nonatomic) IBOutlet UIView *roundView1;
@property (weak, nonatomic) IBOutlet UIView *roundView2;
@property (weak, nonatomic) IBOutlet UIView *roundView3;
@property (weak, nonatomic) IBOutlet UIView *contentView;
- (IBAction)startAgainBtnClick:(id)sender;
- (IBAction)restBtnClick:(id)sender;


@property (nonatomic, strong) LZSwipeableView *swipeableView;
@end

@implementation LErrorReviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *isFirstJoinErrorView = [[NSUserDefaults standardUserDefaults] valueForKey:@"isFirstJoinErrorView"];
    if (isFirstJoinErrorView && [isFirstJoinErrorView isEqualToString:@"1"]) {
        
    }else{
        [[SingleTon getInstance] showPromotAlert];
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"isFirstJoinErrorView"];
    }
    
    [self setUI];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[AudioManager shareManager] pause];
}

-(void)setUI{
    self.heightConstraint.constant = NaviHeight+StatusHeight;
    [self.roundView1 modifyWithcornerRadius:15 borderColor:nil borderWidth:0];
    [self.roundView2 modifyWithcornerRadius:15 borderColor:nil borderWidth:0];
    [self.roundView3 modifyWithcornerRadius:15 borderColor:nil borderWidth:0];
    [self.contentView modifyWithcornerRadius:15 borderColor:nil borderWidth:0];
    [self addSwipeableView];
    
    if ([[SingleTon getInstance].user.is_auto_play isEqualToString:@"1"]) {
        self.isAutoSwitch.on = YES;
    }else{
        self.isAutoSwitch.on = NO;
    }
}
-(void)addSwipeableView{
    self.swipeableView = [[LZSwipeableView alloc] init];
    self.swipeableView.datasource = self;
    self.swipeableView.delegate = self;
    self.swipeableView.backgroundColor = [UIColor orangeColor];
    self.swipeableView.bottomCardInsetHorizontalMargin = 0;
    self.swipeableView.bottomCardInsetVerticalMargin = 0;
    self.swipeableView.topCardInset = UIEdgeInsetsMake(1, 1, 1, 1);
    [self.swipeableView modifyWithcornerRadius:15 borderColor:nil borderWidth:0];
    //self.swipeableView.hidden = YES;
    [self.view addSubview:self.swipeableView];
    [self.swipeableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
    [self.swipeableView registerNibName:NSStringFromClass([LErrorReviewCell class]) forCellReuseIdentifier:NSStringFromClass([LErrorReviewCell class])];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //self.swipeableView.hidden = NO;
        [self.swipeableView reloadData];
        
        //创建好自动播放第一个
        if ([[SingleTon getInstance].user.is_auto_play isEqualToString:@"0"]) {
            return ;
        }
        LStrangeWordModel *newStrangeWord = self.strangeWordArray[0];
        [[AudioManager shareManager] playWithUrl:[NSURL URLWithString:newStrangeWord.data.audio_src] count:[[SingleTon getInstance].user.auto_play_frequency intValue]];
    });
}

#pragma mark LZSwipeableViewDataSource
- (NSInteger)swipeableViewNumberOfRowsInSection:(LZSwipeableView *)swipeableView{
    return self.strangeWordArray.count;
}

- (LZSwipeableViewCell *)swipeableView:(LZSwipeableView *)swipeableView cellForIndex:(NSInteger)index{
    LErrorReviewCell *cell = [swipeableView dequeueReusableCellWithIdentifier:NSStringFromClass([LErrorReviewCell class])];
    cell.indexID = index;
    cell.strangeWord = self.strangeWordArray[index];
    return cell;
}

- (LZSwipeableViewCell *)swipeableView:(LZSwipeableView *)swipeableView substituteCellForIndex:(NSInteger)index{
    LErrorReviewCell *cell = [[LErrorReviewCell alloc] initWithReuseIdentifier:@""];
    return cell;
}

#pragma mark LZSwipeableViewDelegate
- (NSInteger)swipeableViewMaxCardNumberWillShow:(LZSwipeableView *)swipeableView{
    return 2;
}
- (void)swipeableView:(LZSwipeableView *)swipeableView didTapCellAtIndex:(NSInteger)index{
    
}
- (CGFloat)heightForFooterView:(LZSwipeableView *)swipeableView{
    return 0;
}

- (UIView *)headerViewForSwipeableView:(LZSwipeableView *)swipeableView{
    return nil;
}

- (CGFloat)heightForHeaderView:(LZSwipeableView *)swipeableView{
    return 0;
}

// 拉到最后一个
- (void)swipeableViewDidLastCardRemoved:(LZSwipeableView *)swipeableView{
    [[AudioManager shareManager] pause];
    
    
    [[APIManager getInstance] wordStrangeListWithtype:@"1" Callback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            self.strangeWordArray = result;
            
            if (self.strangeWordArray.count>0) {
                [self.swipeableView reloadData];
            }else{
                [self.swipeableView removeFromSuperview];
            }
            
        }else{
            [SVProgressHUD showErrorWithStatus:result];
        }
    }];
}

- (void)swipeableView:(LZSwipeableView *)swipeableView didCardRemovedAtIndex:(NSInteger)index withDirection:(LZSwipeableViewCellSwipeDirection)direction{
    [[AudioManager shareManager] pause];
    //移除了这长卡片，那就要自动发音下一个卡片了
    
    if ([[SingleTon getInstance].user.is_auto_play isEqualToString:@"1"]) {
        if (index+1<self.strangeWordArray.count) {
            LStrangeWordModel *newStrangeWord = self.strangeWordArray[index+1];
            [[AudioManager shareManager] playWithUrl:[NSURL URLWithString:newStrangeWord.data.audio_src] count:[[SingleTon getInstance].user.auto_play_frequency intValue]];
        }
    }
    
    
    if ([self.type isEqualToString:@"2"]) {
        return;
    }
    LStrangeWordModel *strangeWord = self.strangeWordArray[index];
    NSString *type = @"";
    if (direction == LZSwipeableViewCellSwipeDirectionRight) {
        type = @"-1";
    }else if (direction == LZSwipeableViewCellSwipeDirectionTop){
        type = @"0";
    }else if (direction == LZSwipeableViewCellSwipeDirectionLeft){
        type = @"1";
    }
    [[APIManager getInstance] wordStrangeActionWithWid:strangeWord.data.ID type:type callback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            
        }else{
            
        }
    }];
    
    
    
}

-(void)swipeableView:(LZSwipeableView *)swipeableView cardMoveDirectionAtIndex:(NSInteger)index withDirection:(LZSwipeableViewCellSwipeDirection)direction{
    for (LErrorReviewCell *cell in swipeableView.cardViewArray) {
        if (cell.indexID == index) {
            if (direction==LZSwipeableViewCellSwipeDirectionTop) {
                [cell showIconWith:3];
            }else if (direction == LZSwipeableViewCellSwipeDirectionLeft){
                [cell showIconWith:2];
            }else if (direction == LZSwipeableViewCellSwipeDirectionRight){
                [cell showIconWith:1];
            }else if (direction == LZSwipeableViewCellSwipeDirectionCenter){
                [cell showIconWith:0];
            }
        }
    }
    
}

- (void)swipeableView:(LZSwipeableView *)swipeableView didTopCardShow:(LZSwipeableViewCell *)topCell{
    
}


- (void)swipeableView:(LZSwipeableView *)swipeableView didLastCardShow:(LZSwipeableViewCell *)cell{
    
}





- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)isAutoSwitchChange:(UISwitch *)sender {
    NSString *is_auto_play = @"0";
    if ([[SingleTon getInstance].user.is_auto_play isEqualToString:@"1"]) {
        is_auto_play = @"0";
    }else{
        is_auto_play = @"1";
    }
    NSDictionary *dic = @{@"is_auto_play":is_auto_play,
                          @"user_token":[[SingleTon getInstance] getUser_tocken]
                          };
    [SVProgressHUD showWithStatus:@"提交中"];
    [[APIManager getInstance] saveUserInfoWithParam:dic.mutableCopy callback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            [SingleTon getInstance].user.is_auto_play = is_auto_play;
        }else{
            [SVProgressHUD showErrorWithStatus:result];
            sender.on = !sender.on;
        }
    }];
}




- (IBAction)startAgainBtnClick:(id)sender {
    [[APIManager getInstance] wordStrangeListWithtype:@"2" Callback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            self.type = @"2";
            self.strangeWordArray = result;
            if (self.strangeWordArray.count==0) {
                [SVProgressHUD showErrorWithStatus:@"没有生词了"];
                return ;
            }
            [self addSwipeableView];
        }else{
            [SVProgressHUD showErrorWithStatus:result];
        }
    }];
    
}

- (IBAction)restBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
