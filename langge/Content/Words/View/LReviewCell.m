//
//  LReviewCell.m
//  langge
//
//  Created by samlee on 2019/4/17.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LReviewCell.h"
#import "LStrokeSmallCell.h"
#import "LWordCollectionCell.h"
@interface LReviewCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@end


@implementation LReviewCell
-(void)awakeFromNib{
    [super awakeFromNib];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((ScreenWidth-70)/10, 40);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    self.centerCollectionView.collectionViewLayout = layout;
    self.centerCollectionView.delegate = self;
    self.centerCollectionView.dataSource = self;
}
-(void)setNaviHight:(CGFloat)naviHight{
    _naviHight = naviHight;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((ScreenWidth-60)/4, (ScreenHeight-431-StatusHeight-self.naviHight)/4);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    [self.strokrCollectionView modifyWithcornerRadius:15 borderColor:RGB(242, 242, 242) borderWidth:0.5];
    self.strokrCollectionView.collectionViewLayout = layout;
    self.strokrCollectionView.delegate = self;
    self.strokrCollectionView.dataSource = self;
    
    
    
}
#pragma mark -- UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == self.strokrCollectionView) {
        return 16;
    }else{
        return 10;
    }
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.strokrCollectionView) {
        LStrokeSmallCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LStrokeSmallCell" forIndexPath:indexPath];
        return cell;
    }else{
        LWordCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LWordCollectionCell" forIndexPath:indexPath];
        return cell;
    }
}


- (IBAction)playBtnClick:(UIButton *)sender {
    
}
- (IBAction)submitBtnClick:(UIButton *)sender {
}
@end
