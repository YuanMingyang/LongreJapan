//
//  LLevelFailAlertView.m
//  langge
//
//  Created by samlee on 2019/6/16.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LLevelFailAlertView.h"
#import "LRankingTableCell1.h"
#import "LRankingModel.h"

@interface LLevelFailAlertView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UILabel *lineLabel;
@property(nonatomic,assign)int type;

@property(nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation LLevelFailAlertView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.dataSource = [NSMutableArray array];
    [self.rankTableView registerNib:[UINib nibWithNibName:@"LRankingTableCell1" bundle:nil] forCellReuseIdentifier:@"LRankingTableCell1"];
    self.rankTableView.delegate = self;
    self.rankTableView.dataSource = self;
    
    self.lineLabel = [[UILabel alloc] init];
    self.lineLabel.text = @"";
    self.lineLabel.backgroundColor = RGB(105, 207, 219);
    [self.selectRegionView addSubview:self.lineLabel];
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(2);
        make.bottom.equalTo(self.selectRegionView);
        make.centerX.equalTo(self.leftBtn);
    }];
    
    self.type = 1;
    [self loadData];
}


-(void)setData:(NSDictionary *)data{
    _data = data;
    NSString *starName = [NSString stringWithFormat:@"star%@",data[@"star"]];
    self.starImageView.image = [UIImage imageNamed:starName];
    self.levelLabel.text = [NSString stringWithFormat:@"第%@关",data[@"level"]];
    self.gradeLabel.text = data[@"grade"];
    self.describeLabel.textColor = data[@"describe"];
    NSDictionary *prize = data[@"prize"];
    if (prize) {
        self.prizeTitle.text = prize[@"title"];
        self.prizeHeight.constant = 80;
        self.prizeView.hidden = NO;
    }else{
        self.prizeView.hidden = YES;
        self.prizeHeight.constant = 41;
    }
}


-(void)loadData{
    if (self.type ==1) {
        [self loadRankingWithCity:nil];
    }else{
        if ([SingleTon getInstance].user.city&&[SingleTon getInstance].user.city.length>0) {
            [self loadRankingWithCity:[SingleTon getInstance].user.city];
        }else{
            self.selectBlock(4);
        }
    }
}
-(void)loadRankingWithCity:(NSString *)city{
    [SVProgressHUD showWithStatus:@"加载中"];
    [[APIManager getInstance] rankingListWithCity:city callback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            [self.dataSource addObject:result[@"my"]];
            [self.dataSource addObjectsFromArray:result[@"all"]];
            [self.rankTableView reloadData];
            
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD showErrorWithStatus:result];
        }
    }];
}

#pragma mark -- UITableviewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LRankingTableCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"LRankingTableCell1"];
    cell.ranking = self.dataSource[indexPath.row];
    cell.index = indexPath.row;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)shareBtnClick:(id)sender {
    self.selectBlock(2);
}

- (IBAction)nextLevelBtnClick:(id)sender {
    self.selectBlock(3);
}
- (IBAction)selectBtnClick:(UIButton *)sender {
    if (sender.tag == 101) {
        if (self.type==1) {
            return;
        }
        [self.lineLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
        [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(45);
            make.height.mas_equalTo(2);
            make.bottom.equalTo(self.selectRegionView);
            make.centerX.equalTo(self.leftBtn);
        }];
        self.leftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        self.type = 1;
        [self loadData];
        
    }else if (sender.tag == 102){
        if (self.type == 2) {
            return;
        }
        [self.lineLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
        [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(45);
            make.height.mas_equalTo(2);
            make.bottom.equalTo(self.selectRegionView);
            make.centerX.equalTo(self.rightBtn);
        }];
        self.rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        self.leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        self.type = 1;
        [self loadData];
    }
}
- (IBAction)prizeBtnClick:(UIButton *)sender {
    self.selectBlock(1);
}
- (IBAction)backBtnClick:(id)sender {
    self.selectBlock(5);
}
@end
