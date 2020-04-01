//
//  LDateAlertView.m
//  langge
//
//  Created by samlee on 2019/4/1.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LDateAlertView.h"

@implementation LDateAlertView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.datePicker.maximumDate = [NSDate date];
    if (KIsiPhoneX) {
        self.bottomConstraint.constant = 34;
    }else{
        self.bottomConstraint.constant = 0;
    }
}

- (IBAction)closeBtnClick:(id)sender {
    
    self.submitBlock(@"");
}

- (IBAction)submitBtnClick:(id)sender {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [dateFormatter stringFromDate:self.datePicker.date];
    self.submitBlock(dateStr);
}
@end
