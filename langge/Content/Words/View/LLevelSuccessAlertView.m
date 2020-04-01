//
//  LLevelSuccessAlertView.m
//  langge
//
//  Created by samlee on 2019/6/16.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LLevelSuccessAlertView.h"

@implementation LLevelSuccessAlertView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.bjView modifyWithcornerRadius:15 borderColor:nil borderWidth:0];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
}
-(void)tap{
    self.selectTyle(0);
}
- (IBAction)levelAgainBtnClick:(id)sender {
    self.selectTyle(1);
}

- (IBAction)reviewBtnClick:(id)sender {
    self.selectTyle(2);
}

- (IBAction)closeBtnClick:(id)sender {
    self.selectTyle(0);
}
@end
