//
//  LListAlertView.h
//  langge
//
//  Created by samlee on 2019/4/1.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LListAlertView : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property(nonatomic,strong)void(^clickBlock)(NSInteger index);

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

-(void)configWith:(NSString *)title items:(NSArray *)items;
@end

NS_ASSUME_NONNULL_END
