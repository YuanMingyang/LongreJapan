//
//  LReviewViewController.m
//  langge
//
//  Created by samlee on 2019/4/17.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LReviewViewController.h"
#import "LReviewCell.h"


@interface LReviewViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *errorWidthConstraint;
@property (weak, nonatomic) IBOutlet UILabel *rightCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *unCompleteLabel;

@property (weak, nonatomic) IBOutlet UIView *roundView01;
@property (weak, nonatomic) IBOutlet UIView *roundView02;
@property (weak, nonatomic) IBOutlet UIView *roundView03;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;




- (IBAction)backBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeightConstraint;

@end

@implementation LReviewViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"复习巩固";
    [self setUI];
}
-(void)setUI{
    self.topViewHeightConstraint.constant = NaviHeight+StatusHeight;
    
    [self.roundView01 modifyWithcornerRadius:15 borderColor:nil borderWidth:0];
    [self.roundView02 modifyWithcornerRadius:15 borderColor:nil borderWidth:0];
    [self.roundView03 modifyWithcornerRadius:15 borderColor:nil borderWidth:0];
    [self.collectionView modifyWithcornerRadius:15 borderColor:nil borderWidth:0];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(ScreenWidth-30, ScreenHeight-163-StatusHeight-NaviHeight);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}


#pragma mark -- UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LReviewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LReviewCell" forIndexPath:indexPath];
    cell.naviHight = NaviHeight;
    return cell;
}
- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
