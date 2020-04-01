//
//  LHomeCell.m
//  langge
//
//  Created by samlee on 2019/3/25.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LHomeCell.h"

@implementation LHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setPlaysubject:(NSDictionary *)playsubject{
    _playsubject = playsubject;
    if (playsubject) {
        self.nameLabel.text = playsubject[@"name"];
        self.listeningProgressView.progress = [playsubject[@"listening"] floatValue]/100.0;
        self.hiraganaProgressView.progress = [playsubject[@"hiragana"] floatValue]/100.0;
        self.katakanaProgressView.progress = [playsubject[@"katakana"] floatValue]/100.0;
    }else{
        self.listeningProgressView.progress = 0;
        self.hiraganaProgressView.progress = 0;
        self.katakanaProgressView.progress = 0;
    }
}

-(void)setIndex:(NSInteger)index{
    switch (index) {
        case 0:
            self.nameLabel.text = @"清音";
            break;
        case 1:
            self.nameLabel.text = @"浊音";
            break;
        case 2:
            self.nameLabel.text = @"拗音";
            break;
        case 3:
            self.nameLabel.text = @"长音";
            break;
        case 4:
            self.nameLabel.text = @"促音";
            break;
        default:
            break;
    }
}
@end
