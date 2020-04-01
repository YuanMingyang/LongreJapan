//
//  LSoundCell.m
//  langge
//
//  Created by samlee on 2019/3/24.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LSoundCell.h"

@implementation LSoundCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setGame:(NSDictionary *)game{
    _game = game;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:game[@"img"]] placeholderImage:[UIImage imageNamed:@"defalut_img"]];
}
@end
