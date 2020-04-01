//
//  LErrorReviewCell.h
//  langge
//
//  Created by samlee on 2019/4/20.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZSwipeableView.h"
#import "LStrangeWordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LErrorReviewCell : LZSwipeableViewCell
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
- (IBAction)playbtnClick:(UIButton *)sender;
- (IBAction)showDiscriptionBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *discriptionView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *kanaLabel;
@property (weak, nonatomic) IBOutlet UILabel *title2Label;
@property (weak, nonatomic) IBOutlet UILabel *kana2Label;

@property (weak, nonatomic) IBOutlet UIImageView *leftIcon;
@property (weak, nonatomic) IBOutlet UIImageView *rightIcon;
@property (weak, nonatomic) IBOutlet UIImageView *buttonIcon;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;

@property (weak, nonatomic) IBOutlet UILabel *posLabel;
@property (weak, nonatomic) IBOutlet UILabel *cn_explanationLabel;
@property (weak, nonatomic) IBOutlet UILabel *ja_explainLabel;
@property (weak, nonatomic) IBOutlet UILabel *cn_explainLabel;
@property (weak, nonatomic) IBOutlet UIView *explainView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sentenceTop;
@property (weak, nonatomic) IBOutlet UILabel *ja_sentenceLabel;
@property (weak, nonatomic) IBOutlet UILabel *cn_sentenceLabel;
- (IBAction)playSentenceBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *sentenceGifImageView;

@property(nonatomic,assign)NSInteger indexID;
@property(nonatomic,strong)LStrangeWordModel *strangeWord;
-(void)showIconWith:(NSInteger)type;//1:左  2:右  3:下  0:无

@end

NS_ASSUME_NONNULL_END
