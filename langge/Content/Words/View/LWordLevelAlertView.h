//
//  LWordLevelAlertView.h
//  langge
//
//  Created by samlee on 2019/6/16.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LWordLevelAlertView : UIView

@property(nonatomic,strong)void(^selectBlock)(NSInteger type,NSDictionary *levelData);//1:闯关2:学习  0:关闭
@property (weak, nonatomic) IBOutlet UIView *bjView;

@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *studyBtn;
- (IBAction)starLevelBtnClick:(UIButton *)sender;
- (IBAction)studyBtnClick:(UIButton *)sender;
- (IBAction)closeBtnClick:(UIButton *)sender;


@property(nonatomic,strong)NSDictionary *levelData;
@end

NS_ASSUME_NONNULL_END
