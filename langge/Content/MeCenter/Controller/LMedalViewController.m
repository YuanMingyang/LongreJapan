//
//  LMedalViewController.m
//  langge
//
//  Created by samlee on 2019/5/16.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LMedalViewController.h"
#import "LMedalCell.h"
#import "LMediaTabelCell.h"
#import "LMedalModel.h"

@interface LMedalViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *bjView;
@property (weak, nonatomic) IBOutlet UIView *bjView2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

- (IBAction)backBtnClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *medalImageView;
@property (weak, nonatomic) IBOutlet UILabel *medalNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *wordTotallabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)NSDictionary *my_medal;
@property(nonatomic,strong)NSMutableArray *medal_list;

@end

@implementation LMedalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self loadMedal];
}
-(void)setUI{
    self.topConstraint.constant = StatusHeight+NaviHeight;
    [self.avatarImageView modifyWithcornerRadius:35 borderColor:nil borderWidth:0];
    [self.bjView modifyWithcornerRadius:15 borderColor:nil borderWidth:0];
    [self.bjView2 modifyWithcornerRadius:15 borderColor:nil borderWidth:0];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundView.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];

    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((ScreenWidth-90)/7, 80);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 10;
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.avatarImageView.image = [XSTools base64ToImageWith:[SingleTon getInstance].user.user_img_src];
}

-(void)loadMedal{
    [SVProgressHUD showWithStatus:@"加载中"];
    [[APIManager getInstance] getUserMedalWithCallback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            [SVProgressHUD dismiss];
            self.my_medal = result[@"my_medal"];
            self.medal_list = result[@"medal_list"];
            [self updataUI];
        }else{
            [SVProgressHUD showErrorWithStatus:result];
        }
    }];
}
-(void)updataUI{
    NSString *imgSrc = self.my_medal[@"img"];
    if (imgSrc&&imgSrc.length>0) {
        [self.medalImageView sd_setImageWithURL:[NSURL URLWithString:self.my_medal[@"img"]] placeholderImage:[UIImage imageNamed:@"defalut_img"]];
        self.medalImageView.hidden = NO;
    }else{
        self.medalImageView.hidden = YES;
    }
    self.medalNameLabel.text = self.my_medal[@"name"];
    self.wordTotallabel.text = [NSString stringWithFormat:@"%@",self.my_medal[@"word_total"]];
    
    [self.tableView reloadData];
    [self.collectionView reloadData];
}

#pragma mark--UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.medal_list.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LMediaTabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LMediaTabelCell"];
    cell.medal = self.medal_list[indexPath.row];
    return cell;
}

#pragma mark -- UICollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.medal_list.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LMedalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LMedalCell" forIndexPath:indexPath];
    cell.medal = self.medal_list[indexPath.row];
    return cell;
}

- (IBAction)backBtnClick:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
