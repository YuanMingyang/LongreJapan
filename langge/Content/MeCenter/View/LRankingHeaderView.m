//
//  LRankingHeaderView.m
//  langge
//
//  Created by samlee on 2019/4/18.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LRankingHeaderView.h"

@implementation LRankingHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    if (ScreenWidth >= 414) {
        self.leftSpace.constant = 60;
        self.rightSpace.constant = 60;
    }else{
        self.leftSpace.constant = 50;
        self.rightSpace.constant = 50;
    }
    
    [self.firstImageView modifyWithcornerRadius:35 borderColor:nil borderWidth:0];
    [self.secondImageView modifyWithcornerRadius:29 borderColor:nil borderWidth:0];
    [self.thirdImageView modifyWithcornerRadius:29 borderColor:nil borderWidth:0];
    
    self.firstBJ.hidden = YES;
    self.secondBJ.hidden = YES;
    self.thirdBJ.hidden = YES;
}

-(void)setFirstRanking:(LRankingModel *)firstRanking{
    _firstRanking = firstRanking;
    if (firstRanking) {
        self.firstImageView.image = [XSTools base64ToImageWith:firstRanking.user_img_src];
        self.fitstNickNameLabel.text = firstRanking.nick_name;
        self.firstTotalLabel.text = [NSString stringWithFormat:@"%@关",firstRanking.total];
        self.firstBJ.hidden = NO;
    }else{
        self.firstBJ.hidden = YES;
        self.firstImageView.image = [UIImage imageNamed:@""];
        self.fitstNickNameLabel.text = @"";
        self.firstTotalLabel.text = @"";
    }
}
-(void)setSecondRanking:(LRankingModel *)secondRanking{
    _secondRanking = secondRanking;
    if (secondRanking) {
        self.secondImageView.image = [XSTools base64ToImageWith:secondRanking.user_img_src];
        self.secondNickNameLabel.text = secondRanking.nick_name;
        self.secondTotalLabel.text = [NSString stringWithFormat:@"%@关",secondRanking.total];
        self.secondBJ.hidden = NO;
    }else{
        self.secondBJ.hidden = YES;
        self.secondImageView.image = [UIImage imageNamed:@""];
        self.secondNickNameLabel.text = @"";
        self.secondTotalLabel.text = @"";
    }
}
-(void)setThirdRanking:(LRankingModel *)thirdRanking{
    _thirdRanking = thirdRanking;
    if (thirdRanking) {
        self.thirdImageView.image = [XSTools base64ToImageWith:thirdRanking.user_img_src];
        self.thirdNickNameLabel.text = thirdRanking.nick_name;
        self.thirdTotalLabel.text = [NSString stringWithFormat:@"%@关",thirdRanking.total];
        self.thirdBJ.hidden = NO;
    }else{
        self.thirdBJ.hidden = YES;
        self.thirdImageView.image = [UIImage imageNamed:@""];
        self.thirdNickNameLabel.text = @"";
        self.thirdTotalLabel.text = @"";
    }
}

@end
