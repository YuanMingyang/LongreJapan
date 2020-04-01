//
//  IntroduceView.h
//  langge
//
//  Created by samlee on 2019/3/25.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@protocol IntroduceViewDelegate <NSObject>

-(void)startStudy;

@end

@interface IntroduceView : UIView
@property(nonatomic,assign)id<IntroduceViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
