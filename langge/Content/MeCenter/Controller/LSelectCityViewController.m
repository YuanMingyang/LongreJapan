//
//  LSelectCityViewController.m
//  langge
//
//  Created by samlee on 2019/4/17.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LSelectCityViewController.h"
#import "LCityCell.h"
#import "SectionModel.h"

@interface LSelectCityViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSArray *dataSource;
@end

@implementation LSelectCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"json"];
    NSString *jsonStr = [NSString stringWithContentsOfFile:jsonPath encoding:NSUTF8StringEncoding error:nil];
    self.dataSource = [XSTools jsonStrToArrayWith:jsonStr];
    //self.dataSource = [[NSMutableDictionary alloc] initWithDictionary:dic];

    
    self.title = @"选择城市";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundView.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
}

#pragma mark -- UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *city = self.dataSource[section];
    NSArray *citys = city[@"citys"];
    return citys.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LCityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCityCell"];
    NSDictionary *city = self.dataSource[indexPath.section];
    NSArray *citys = city[@"citys"];
    cell.titleLabel.text = citys[indexPath.row];
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSDictionary *city = self.dataSource[section];
    return city[@"title"];
    
}
- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    return @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *city = self.dataSource[indexPath.section];
    NSArray *citys = city[@"citys"];
    self.resultBlock(citys[indexPath.row]);
    [self.navigationController popViewControllerAnimated:YES];
}

//获取拼音首字母(传入汉字字符串, 返回大写拼音首字母)
-(NSString *)FirstCharactor:(NSString *)pString{
    //转成了可变字符串
    NSMutableString *pStr = [NSMutableString stringWithString:pString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)pStr,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)pStr,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *pPinYin = [pStr capitalizedString];
    //获取并返回首字母
    NSString *first = [pPinYin substringToIndex:1];
    return first;
}

@end
