//
//  LAddNewTypeViewController.m
//  langge
//
//  Created by samlee on 2019/4/14.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LAddNewTypeViewController.h"
#import "LNewTypeCell.h"

@interface LAddNewTypeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation LAddNewTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

-(void)setUI{
    self.title = @"添加感兴趣的新闻";
    UIButton *submitBtn = [[UIButton alloc] init];
    [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [submitBtn setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.frame = CGRectMake(0, 0, 50, 30);
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithCustomView:submitBtn];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((ScreenWidth-66)/4, 32);
    layout.minimumLineSpacing = 26;
    layout.minimumInteritemSpacing = 12;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}


#pragma mark -- UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.allMenuArr.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LNewTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LNewTypeCell" forIndexPath:indexPath];
    cell.menu = self.allMenuArr[indexPath.row];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    LNewMenuModel *menu = self.allMenuArr[indexPath.row];
    if ([menu.is_like isEqualToString:@"1"]) {
        menu.is_like = @"0";
    }else if ([menu.is_like isEqualToString:@"0"]){
        menu.is_like = @"1";
    }
    [self.collectionView reloadData];
}


#pragma mark -- action
-(void)submitBtnClick{
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (LNewMenuModel *menu in self.allMenuArr) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"cid"] = menu._id;
        dic[@"is_like"] = menu.is_like;
        [mutableArray addObject:dic];
    }
    [SVProgressHUD showWithStatus:@"提交中"];
    __weak typeof(self)weakSelf = self;
    [[APIManager getInstance] userNewsclassActiveWith:[XSTools dataTOjsonString:mutableArray] callback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            [SVProgressHUD dismiss];
            weakSelf.resultBlock();
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:result];
        }
    }];
}@end
