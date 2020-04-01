//
//  LWordLevelAlertView.m
//  langge
//
//  Created by samlee on 2019/6/16.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LWordLevelAlertView.h"
#import "LLevelWordCell.h"
@interface LWordLevelAlertView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray *wordList;
@end

@implementation LWordLevelAlertView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.studyBtn modifyWithcornerRadius:25 borderColor:RGB(255, 184, 73) borderWidth:1];
    [self.bjView modifyWithcornerRadius:15 borderColor:nil borderWidth:0];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LLevelWordCell" bundle:nil] forCellReuseIdentifier:@"LLevelWordCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundView.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    
}

-(void)tap{
    self.selectBlock(0,self.levelData);
}

-(void)setLevelData:(NSDictionary *)levelData{
    _levelData = levelData;
    self.levelLabel.text = [NSString stringWithFormat:@"第%@关",levelData[@"level"]];
    self.wordList = levelData[@"wordList"];
    [self.tableView reloadData];
}


#pragma mark -- UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.wordList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 37;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LLevelWordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLevelWordCell"];
    cell.word = self.wordList[indexPath.row];
    cell.index = indexPath.row;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)starLevelBtnClick:(UIButton *)sender {
    self.selectBlock(1,self.levelData);
}

- (IBAction)studyBtnClick:(UIButton *)sender {
    self.selectBlock(2,self.levelData);
}

- (IBAction)closeBtnClick:(UIButton *)sender {
    self.selectBlock(0,self.levelData);
}
@end
