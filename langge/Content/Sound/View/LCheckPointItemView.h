//
//  LCheckPointItemView.h
//  langge
//
//  Created by samlee on 2019/3/24.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LCheckPointItemViewDelegate <NSObject>

-(void)selectItemWith:(id)item;

@end

@interface LCheckPointItemView : UIView
-(instancetype)initWithTitle:(NSString *)title count:(int)count;

@property(nonatomic,assign)id<LCheckPointItemViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
