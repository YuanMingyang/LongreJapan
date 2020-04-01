//
//  LListAlertView.m
//  langge
//
//  Created by samlee on 2019/4/1.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LListAlertView.h"

@interface LListAlertView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray *dataSource;
@end

@implementation LListAlertView
-(void)awakeFromNib{
    [super awakeFromNib];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundView.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    if (KIsiPhoneX) {
        self.bottomConstraint.constant = 34;
    }else{
        self.bottomConstraint.constant = 0;
    }
}
-(void)configWith:(NSString *)title items:(NSArray *)items{
    self.titleLabel.text = title;
    self.dataSource = items;
    [self.tableView reloadData];
}

#pragma mark -- UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 49;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"itemCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"itemCell"];
        cell.textLabel.textColor = RGB(251, 124, 118);
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.clickBlock(indexPath.row);
}

-(void)dealloc{
    NSLog(@"<<<LListAlertView>>>");
}

@end
