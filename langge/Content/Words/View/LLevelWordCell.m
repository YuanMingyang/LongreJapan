//
//  LLevelWordCell.m
//  langge
//
//  Created by samlee on 2019/6/16.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LLevelWordCell.h"

@implementation LLevelWordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setWord:(NSDictionary *)word{
    _word = word;
    self.leftLabel.text = word[@"kana"];
    self.centerLabel.text = word[@"ja_word"];
    self.rightLabel.text = [NSString stringWithFormat:@"〔%@〕%@",word[@"pos"],word[@"cn_explanation"]];
}

-(void)setIndex:(NSInteger)index{
    if (index%2==0) {
        self.contentView.backgroundColor = RGB(243, 243, 243);
    }else{
        self.contentView.backgroundColor = RGB(255, 255, 255);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
