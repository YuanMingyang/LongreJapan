//
//  LAnnotationView.h
//  langge
//
//  Created by samlee on 2019/4/19.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWordModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LAnnotationViewDelegate <NSObject>

-(void)moveWith:(UIPanGestureRecognizer *)pan;
-(void)clickError;
@end

@interface LAnnotationView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
- (IBAction)playBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UIButton *modifyErrorBtn;
- (IBAction)modifyErrorBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;

@property (weak, nonatomic) IBOutlet UILabel *cn_explanationLabel;
@property (weak, nonatomic) IBOutlet UIView *explainView;
@property (weak, nonatomic) IBOutlet UILabel *ja_explainLabel;
@property (weak, nonatomic) IBOutlet UILabel *cn_explainLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sentenceTop;
@property (weak, nonatomic) IBOutlet UILabel *ja_sentenceLabel;
@property (weak, nonatomic) IBOutlet UILabel *cn_sentenceLabel;
- (IBAction)playSentenceBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *sentenceGifImageView;


@property(nonatomic,strong)LWordModel *wordData;

@property(nonatomic,assign)id<LAnnotationViewDelegate>delegate;
@property(nonatomic,assign)int status;//0:完全隐藏状态 1:在下边的状态   2:全屏状态
@end

NS_ASSUME_NONNULL_END
