//
//  LWrongTopicEndAlert.m
//  langge
//
//  Created by samlee on 2019/6/23.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LWrongTopicEndAlert.h"

@implementation LWrongTopicEndAlert

-(void)awakeFromNib{
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
}
-(void)tap{
     self.closeBlock();
}

- (IBAction)closeBtnClick:(id)sender {
    self.closeBlock();
}
@end
