//
//  LReceiveCourseAlertView.m
//  langge
//
//  Created by yang on 2019/12/23.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LReceiveCourseAlertView.h"

@implementation LReceiveCourseAlertView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.contentView modifyWithcornerRadius:10 borderColor:nil borderWidth:0];
}

- (IBAction)closeBtnClick:(UIButton *)sender {
    self.closeBlock();
}

- (IBAction)submitBtnClick:(id)sender {
    UIImageWriteToSavedPhotosAlbum(self.codeImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
    if (!error) {
        self.openWechatBlock();
    }
    
}
@end
