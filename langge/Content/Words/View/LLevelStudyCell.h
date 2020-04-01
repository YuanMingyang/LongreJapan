//
//  LLevelStudyCell.h
//  langge
//
//  Created by samlee on 2019/6/23.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLevelStudyCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *addWrongBtn;
- (IBAction)addWrongBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;
- (IBAction)playBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *jaLabel;
@property (weak, nonatomic) IBOutlet UILabel *cnLabel;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UIButton *errorBtn;
- (IBAction)errorBtnClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *postLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailheight;
@property (weak, nonatomic) IBOutlet UILabel *detail_jpLabel;
@property (weak, nonatomic) IBOutlet UILabel *detail_chLabel;
@property (weak, nonatomic) IBOutlet UILabel *jaSentenceLabel;
@property (weak, nonatomic) IBOutlet UILabel *cnSentenceLabel;
- (IBAction)sentencePlayBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *sentenceGifImageView;
@property(nonatomic,assign)int type;//1:词语   2:例句

@property(nonatomic,strong)void(^errorBlock)();

@property(nonatomic,strong)LWordModel *word;
@end

NS_ASSUME_NONNULL_END
