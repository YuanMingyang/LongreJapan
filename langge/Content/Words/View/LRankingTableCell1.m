//
//  LRankingTableCell.m
//  langge
//
//  Created by samlee on 2019/6/23.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LRankingTableCell1.h"

@implementation LRankingTableCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.avatarImageView modifyWithcornerRadius:16 borderColor:nil borderWidth:0];
}

-(void)setRanking:(LRankingModel *)ranking{
    _ranking = ranking;
    self.rankingLabel.text = ranking.ranking;
    self.nicknameLabel.text = ranking.nick_name;
    self.avatarImageView.image = [XSTools base64ToImageWith:ranking.user_img_src];
    self.totalLabel.text  = [NSString stringWithFormat:@"%@关",ranking.total];
}

-(void)setIndex:(NSInteger)index{
    _index = index;
    if (index == 1) {
        self.rankingLabel.textColor = RGB(266, 83, 33);
    }else if (index == 2){
        self.rankingLabel.textColor = RGB(243, 143, 25);
    }else if (index == 3){
        self.rankingLabel.textColor = RGB(251, 184, 36);
    }else if (index == 0){
        self.rankingLabel.textColor = RGB(53, 53, 53);
    }else{
        self.rankingLabel.textColor = RGB(102, 102, 102);
    }
    
    if (self.index == 0) {
        
        self.nicknameLabel.textColor = RGB(53, 53, 53);
        self.totalLabel.textColor = RGB(53, 53, 53);
    }else{
        self.nicknameLabel.textColor = RGB(102, 102, 102);
        self.totalLabel.textColor = RGB(102, 102, 102);
    }
}
@end
