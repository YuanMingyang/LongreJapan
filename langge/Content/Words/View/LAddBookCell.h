//
//  LAddBookCell.h
//  langge
//
//  Created by samlee on 2019/4/12.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBookModel.h"
@protocol LAddBookCellDelegate <NSObject>

-(void)seleckBookWith:(LBookModel *)book;

@end
NS_ASSUME_NONNULL_BEGIN



@interface LAddBookCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;
- (IBAction)leftBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *leftAllSelectView;
@property (weak, nonatomic) IBOutlet UIImageView *centerImageView;
@property (weak, nonatomic) IBOutlet UILabel *centerTitleLabel;
- (IBAction)centerBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *centerAllSelectView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UILabel *rightTitleLabel;
- (IBAction)rightBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *rightAllSelectView;

@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet UIView *rightView;

@property(nonatomic,assign)id<LAddBookCellDelegate>delegate;

@property(nonatomic,strong)NSMutableArray *bookArray;
@end

NS_ASSUME_NONNULL_END
