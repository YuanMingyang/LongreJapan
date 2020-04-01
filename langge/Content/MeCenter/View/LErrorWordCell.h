//
//  LErrorWordCell.h
//  langge
//
//  Created by samlee on 2019/4/19.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSubjectWrongModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LErrorWordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *indexLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@property(nonatomic,assign)NSInteger thisIndex;
@property(nonatomic,strong)LSubjectWrongModel *subject;
@end

NS_ASSUME_NONNULL_END
