//
//  LRankingTableCell.m
//  langge
//
//  Created by samlee on 2019/4/18.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LRankingTableCell.h"

@implementation LRankingTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.avatarImageView modifyWithcornerRadius:15 borderColor:nil borderWidth:0];
}

-(void)setRanking:(LRankingModel *)ranking{
    _ranking = ranking;
    self.avatarImageView.image = [XSTools base64ToImageWith:ranking.user_img_src];
    self.progressLabel.text  = [NSString stringWithFormat:@"%@关",ranking.total];
    self.nicknameLabel.text = ranking.nick_name;
    self.progressLabel.text  = [NSString stringWithFormat:@"%@关",ranking.total];
    self.rankingLabel.text = ranking.ranking;
}
-(void)setIndex:(NSInteger)index{
    _index = index;
    if (index == 0) {
        self.rankingLabel.textColor = RGB(53, 53, 53);
        self.rankingLabel.font = [UIFont boldSystemFontOfSize:13];
        self.nicknameLabel.textColor = RGB(53, 53, 53);
        self.nicknameLabel.font = [UIFont boldSystemFontOfSize:13];
        self.progressLabel.textColor = RGB(53, 53, 53);
        self.progressLabel.font = [UIFont boldSystemFontOfSize:13];
    }else{
        self.rankingLabel.textColor = RGB(102, 102, 102);
        self.rankingLabel.font = [UIFont systemFontOfSize:13];
        self.nicknameLabel.textColor = RGB(102, 102, 102);
        self.nicknameLabel.font = [UIFont systemFontOfSize:13];
        self.progressLabel.textColor = RGB(102, 102, 102);
        self.progressLabel.font = [UIFont systemFontOfSize:13];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
