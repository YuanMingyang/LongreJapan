//
//  LLevelStudyViewController.m
//  langge
//
//  Created by samlee on 2019/6/23.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LLevelStudyViewController.h"
#import "LWordModel.h"
#import "LLevelStudyCell.h"
#import "AudioManager.h"
#import "LGameViewController.h"
#import "LAdviceViewController.h"
#import "AudioManager.h"

@interface LLevelStudyViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
- (IBAction)backBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet UIView *roundView1;
@property (weak, nonatomic) IBOutlet UIView *roundView2;
@property (weak, nonatomic) IBOutlet UIView *roundView3;
@property (weak, nonatomic) IBOutlet UIView *roundView4;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIView *finishView;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
- (IBAction)startLevelBtnClick:(id)sender;

- (IBAction)studyAgainBtnClick:(UIButton *)sender;

@property(nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation LLevelStudyViewController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[AudioManager shareManager] pause];
    //self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self setUI];
}

-(void)loadData{
    NSArray *wordList = self.data[@"wordList"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in wordList) {
        LWordModel *word = [[LWordModel alloc] init];
        [word setValuesForKeysWithDictionary:dic];
        [mutableArray addObject:word];
    }
    self.dataSource = mutableArray;
    
}

-(void)setUI{
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = barItem;
    barItem.title = @"";
    self.heightConstraint.constant = StatusHeight+NaviHeight;
    
    [self.roundView1 modifyWithcornerRadius:15 borderColor:nil borderWidth:0];
    [self.roundView2 modifyWithcornerRadius:15 borderColor:nil borderWidth:0];
    [self.roundView3 modifyWithcornerRadius:15 borderColor:nil borderWidth:0];
    [self.roundView4 modifyWithcornerRadius:15 borderColor:nil borderWidth:0];
    
    self.finishView.hidden = YES;
    self.levelLabel.text = [NSString stringWithFormat:@"恭喜您已完成第%@关词汇复习，",self.data[@"level"]];
    self.titleLabel.text = [NSString stringWithFormat:@"第%@关",self.data[@"level"]];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(ScreenWidth-30, ScreenHeight-98-StatusHeight-NaviHeight);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.pagingEnabled = YES;
}



#pragma mark -- UICollectionViewDelegate,UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LLevelStudyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LLevelStudyCell" forIndexPath:indexPath];
    cell.word = self.dataSource[indexPath.row];
    __weak typeof(self)weakSelf = self;
    cell.errorBlock = ^{
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
        LAdviceViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LAdviceViewController"];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat itemWidth = ScreenWidth-30;
    CGFloat offSetX = scrollView.contentOffset.x;

    if (offSetX>itemWidth*(self.dataSource.count-1)) {
        self.finishView.hidden = NO;
        [[AudioManager shareManager] pause];
    }

}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    LWordModel *word = self.dataSource[indexPath.row];
    if (!word) {
        return;
    }
    if ([[SingleTon getInstance].user.is_auto_play isEqualToString:@"1"]) {
        [[AudioManager shareManager] playWithUrl:[NSURL URLWithString:word.audio_src] count:[[SingleTon getInstance].user.auto_play_frequency intValue]];
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"2222222222");
    
}


- (IBAction)startLevelBtnClick:(id)sender {
    LGameViewController *vc = [[LGameViewController alloc] init];
    vc.urlStr = [NSString stringWithFormat:@"%@Studyplangame/wordTopic?user_token=%@&bid=%@&level=%@&isPrize=%@",API_Root,[[SingleTon getInstance] getUser_tocken],self.data[@"bid"],self.data[@"level"],self.data[@"isPrize"]];
    vc.shouldNavigationBarHidden = YES;
    vc.isFromTest = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)studyAgainBtnClick:(UIButton *)sender {
    self.finishView.hidden = YES;
    self.collectionView.contentOffset = CGPointMake(0, 0);
}
- (IBAction)backBtnClick:(id)sender {
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[LGameViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
}
@end
