//
//  LTestResultAlertView.m
//  langge
//
//  Created by samlee on 2019/5/23.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LTestResultAlertView.h"
#import "RadarChart.h"
@interface LTestResultAlertView ()
@property (nonatomic, strong) RadarDataSet * radarDataSet;
@property(nonatomic,strong)RadarChart * radarChart;
@property(nonatomic,strong)RadarData * radarData;
@end


@implementation LTestResultAlertView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.haha.layer addSublayer:[XSTools getColorLayerWithStartColor:RGB(251, 124, 118) endColor:RGB(255, 182, 171) frame:CGRectMake(0, 0, ScreenWidth-30, 154)]];
    [self.resultLabel modifyWithcornerRadius:10 borderColor:RGB(251, 124, 118) borderWidth:1];
    [self.continueStudyBtn modifyWithcornerRadius:20 borderColor:nil borderWidth:0];
    [self.appIconImageView modifyWithcornerRadius:5 borderColor:RGB(200, 200, 200) borderWidth:1];
    [self.qrCodeImageView modifyWithcornerRadius:5 borderColor:RGB(200, 200, 200) borderWidth:1];
    self.iconView.hidden = YES;
    self.radarDataSet = [[RadarDataSet alloc] init];
    self.radarDataSet.indicatorSet = @[RardarIndicatorMake(@"平假音", 10),
                                       RardarIndicatorMake(@"片假音", 10),
                                       RardarIndicatorMake(@"听力", 10)
                                       ];
    NSNumber * number1 = @(0);
    NSNumber * number2 = @(0);
    NSNumber * number3 = @(0);
    self.radarData = [[RadarData alloc] init];
    self.radarData.datas = @[number1, number2, number3];
    self.radarData.strockColor = [[UIColor whiteColor] colorWithAlphaComponent:.5f];
    self.radarData.lineWidth = .5f;
    self.radarData.shapeRadius = 1.5f;
    self.radarData.shapeLineWidth = .5f;
    self.radarData.fillColor = [UIColor colorWithRed:255/255.0 green:239/255.0 blue:130/255.0 alpha:1];
    self.radarData.shapeFillColor = RGB(151, 151, 151);
    _radarDataSet.titleFont = [UIFont boldSystemFontOfSize:14];
    _radarDataSet.strockColor = RGB(151, 151, 151);
    _radarDataSet.stringColor = RGB(51, 51, 51);
    _radarDataSet.lineWidth = .5f;
    _radarDataSet.radius = 70;
    _radarDataSet.borderWidth = 1.0f;
    _radarDataSet.splitCount = 5;
    _radarDataSet.isCirlre = NO;
    _radarDataSet.radarSet = @[self.radarData];
    self.radarChart = [[RadarChart alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-30, 240)];
    self.radarChart.radarData = _radarDataSet;
    [self.radarChart drawRadarChart];
    [self.contentView addSubview:self.radarChart];
    
    [[APIManager getInstance] getQRCodeWithCallback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            self.qrCodeImageView.image = [XSTools base64ToImageWith:result];
        }else{
            [SVProgressHUD showErrorWithStatus:result];
        }
    }];
}

-(void)setResultData:(NSDictionary *)resultData{
    _resultData = resultData;
    self.starImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"star%@",resultData[@"star"]]];
    self.scoreLabel.text = [NSString stringWithFormat:@"%@",resultData[@"grade"]];
    self.resultLabel.text = resultData[@"describe"];
    
    NSNumber * number1 = @([resultData[@"radar_map"][@"katakana"] intValue]);
    NSNumber * number2 = @([resultData[@"radar_map"][@"hiragana"] intValue]);
    NSNumber * number3 = @([resultData[@"radar_map"][@"listening"] intValue]);
    
    self.radarData.datas = @[number1, number2, number3];
    [self.radarChart drawRadarChart];
}


- (IBAction)closeBtnClick:(UIButton *)sender {
    self.selectClick(5);
}

- (IBAction)continueStudyBtnClick:(UIButton *)sender {
    self.selectClick(1);
}

- (IBAction)testAgainBtnClick:(UIButton *)sender {
    self.selectClick(2);
}

- (IBAction)shareBtnClick:(UIButton *)sender {
    self.shareClick(sender.tag-100);
}
@end
