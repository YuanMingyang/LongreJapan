//
//  LBookListTableViewCell.h
//  langge
//
//  Created by samlee on 2019/4/12.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBookModel.h"

@protocol LBookListTableViewCellDelegate <NSObject>

-(void)clickReveiw:(id _Nullable )book;
-(void)clickStart:(id _Nullable )book;

@end

NS_ASSUME_NONNULL_BEGIN

@interface LBookListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bookImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *remainingIcon;
@property (weak, nonatomic) IBOutlet UILabel *remainingLabel;
@property (weak, nonatomic) IBOutlet UILabel *wordLabel;
@property (weak, nonatomic) IBOutlet UILabel *starLabel;


@property (weak, nonatomic) IBOutlet UIButton *reviewBtn;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
- (IBAction)reviewBtnClick:(id)sender;
- (IBAction)startBtnClick:(id)sender;

@property(nonatomic,strong)LBookModel *book;

@property(nonatomic,assign)id<LBookListTableViewCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
