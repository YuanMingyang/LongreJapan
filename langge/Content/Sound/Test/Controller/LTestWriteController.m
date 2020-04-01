//
//  LTestWriteController.m
//  langge
//
//  Created by samlee on 2019/3/26.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LTestWriteController.h"
#import "LStrokeCell.h"

@interface LTestWriteController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
- (IBAction)playBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *centerImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

@end

@implementation LTestWriteController
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}
- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

-(void)setUI{
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = barItem;
    barItem.title = @"";
    self.title = @"阶段测试";
    self.topConstraint.constant = StatusHeight+NaviHeight+30;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"LStrokeCell" bundle:nil] forCellWithReuseIdentifier:@"LStrokeCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((ScreenWidth-33)/4, 49.5);
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    self.collectionView.collectionViewLayout = layout;
}


#pragma mark -- UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 8;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LStrokeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LStrokeCell" forIndexPath:indexPath];
    return cell;
}


- (IBAction)playBtnClick:(UIButton *)sender {
}
@end
