//
//  LLevelFailAlertView.h
//  langge
//
//  Created by samlee on 2019/6/16.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLevelFailAlertView : UIView

//1:领取  2:分享  3:下一关  4:选择城市  5:返回
@property(nonatomic,strong)void(^selectBlock)(NSInteger type);

- (IBAction)backBtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UIImageView *starImageView;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;
@property (weak, nonatomic) IBOutlet UIView *prizeView;
@property (weak, nonatomic) IBOutlet UILabel *prizeTitle;
@property (weak, nonatomic) IBOutlet UIButton *prizeBtn;
- (IBAction)prizeBtnClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *prizeHeight;

- (IBAction)shareBtnClick:(id)sender;
- (IBAction)nextLevelBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rankHeight;

@property (weak, nonatomic) IBOutlet UIView *selectRegionView;
@property (weak, nonatomic) IBOutlet UITableView *rankTableView;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
- (IBAction)selectBtnClick:(UIButton *)sender;


@property(nonatomic,strong)NSDictionary *data;
-(void)loadRankingWithCity:(NSString *)city;
@end

NS_ASSUME_NONNULL_END
