//
//  LAdviceDetailViewController.m
//  langge
//
//  Created by samlee on 2019/5/2.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LAdviceDetailViewController.h"
#import "LFeedBackImageCell.h"

@interface LAdviceDetailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thistWidyh;
@property (weak, nonatomic) IBOutlet UILabel *user_suggestLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *adminBackLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property(nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation LAdviceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

-(void)setUI{
    self.thistWidyh.constant = ScreenWidth;
    self.user_suggestLabel.text = self.feedback.user_suggest;
    self.adminBackLabel.text = self.feedback.admin_back;
    if ([[NSString stringWithFormat:@"%@",self.feedback.back_time] isEqualToString:@"0"]) {
        self.dateLabel.hidden = YES;
    }else{
        self.dateLabel.hidden = NO;
        self.dateLabel.text = [XSTools time_timestampToString:self.feedback.back_time];
    }
    
    self.dataSource = [NSMutableArray array];
    if (self.feedback.img1.length>0) {
        [self.dataSource addObject:self.feedback.img1];
    }
    if (self.feedback.img2.length>0) {
        [self.dataSource addObject:self.feedback.img2];
    }
    if (self.feedback.img3.length>0) {
        [self.dataSource addObject:self.feedback.img3];
    }
    if (self.feedback.img4.length>0) {
        [self.dataSource addObject:self.feedback.img4];
    }
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((ScreenWidth-60)/4, 78);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}


#pragma mark -- UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LFeedBackImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LFeedBackImageCell" forIndexPath:indexPath];
    cell.img_src = self.dataSource[indexPath.row];
    return cell;
}
@end
