//
//  LErrorWordCell.m
//  langge
//
//  Created by samlee on 2019/4/19.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LErrorWordCell.h"

@implementation LErrorWordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setSubject:(LSubjectWrongModel *)subject{
    _subject = subject;
    self.titleLabel.text = subject.title;
}
-(void)setThisIndex:(NSInteger)thisIndex{
    _thisIndex = thisIndex;
    self.indexLabel.text = [NSString stringWithFormat:@"%lu",thisIndex+1];
}
@end
