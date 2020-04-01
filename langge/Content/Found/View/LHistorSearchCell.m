//
//  LHistorSearchCell.m
//  langge
//
//  Created by samlee on 2019/4/14.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LHistorSearchCell.h"

@implementation LHistorSearchCell



-(void)setSearchTXT:(NSString *)searchTXT{
    _searchTXT = searchTXT;
    [self.titleLabel modifyWithcornerRadius:16 borderColor:nil borderWidth:0];
    self.titleLabel.text = searchTXT;
}
@end
