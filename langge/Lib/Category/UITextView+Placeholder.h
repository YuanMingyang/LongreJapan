//
//  UITextView+Placeholder.h
//  langge
//
//  Created by samlee on 2019/6/15.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
#define HKVersion [[[UIDevice currentDevice] systemVersion] floatValue]

@interface UITextView (Placeholder)
-(void)setPlaceholder:(NSString *)placeholdStr placeholdColor:(UIColor *)placeholdColor;
@end

NS_ASSUME_NONNULL_END
