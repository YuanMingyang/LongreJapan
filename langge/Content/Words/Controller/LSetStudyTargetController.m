//
//  LSetStudyTargetController.m
//  langge
//
//  Created by samlee on 2019/4/16.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LSetStudyTargetController.h"
#import "UIRoundButton.h"
#import "LBookSetTargetCell.h"
#import "LBookModel.h"
#import "LAddBookViewController.h"
#import "LTargetModel.h"
#import "LReviewViewController.h"
#import "LBookDeleteAlertView.h"
#import "WPAlertControl.h"

@interface LSetStudyTargetController ()<UIPickerViewDelegate,UIPickerViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,LBookSetTargetCellDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *addImageView;
@property (weak, nonatomic) IBOutlet UISwitch *openOrCloseSwitch;

@property (weak, nonatomic) IBOutlet UIView *notargetView;
@property (weak, nonatomic) IBOutlet UIButton *firstSetTargerBtn;
- (IBAction)firstSetTargerBtnClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *openOrCloseLabel;
@property (weak, nonatomic) IBOutlet UILabel *title2Label;
- (IBAction)switchClick:(UISwitch *)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *bookCollectionView;

@property (weak, nonatomic) IBOutlet UIView *switchView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIRoundButton *startStudyTargetBtn;
- (IBAction)startStudyTargetBtnClick:(id)sender;


@property(nonatomic,strong)NSMutableArray *bookArray;
@property(nonatomic,strong)NSMutableArray *targetArray;

@property(nonatomic,strong)LBookModel *selectBook;
@property(nonatomic,strong)LTargetModel *selectTarget;
@property(nonatomic,assign)NSInteger selectTargetIndex;
@end

@implementation LSetStudyTargetController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self loadBookList];
    
}
-(void)setUI{
    self.addImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addBtnClick)];
    [self.addImageView addGestureRecognizer:tap];
    
    
    self.openOrCloseLabel.text = @"关闭学习计划";
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = barItem;
    barItem.title = @"";
    
    UIButton *right = [[UIButton alloc] init];
    [right setImage:[UIImage imageNamed:@"add_icon"] forState:UIControlStateNormal];
    [right addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:right];
    
    [self.firstSetTargerBtn modifyWithcornerRadius:20 borderColor:nil borderWidth:0];
    self.title = @"设置学习目标";
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self.switchView modifyWithcornerRadius:15 borderColor:nil borderWidth:0];
    [self.contentView modifyWithcornerRadius:15 borderColor:nil borderWidth:0];
    [self.notargetView modifyWithcornerRadius:15 borderColor:nil borderWidth:0];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((ScreenWidth-60)/3, 153);
    layout.minimumLineSpacing = 15;
    layout.minimumInteritemSpacing = 15;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.bookCollectionView.collectionViewLayout = layout;
    self.bookCollectionView.delegate = self;
    self.bookCollectionView.dataSource = self;
}

-(void)loadBookList{
    [SVProgressHUD showWithStatus:@"加载中"];
    [[APIManager getInstance] getPlanListWithCallback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            [SVProgressHUD dismiss];
            self.bookArray = result;
            if (self.bookArray.count>0) {
                LBookModel *book = self.bookArray.firstObject;
                book.isSelect = @"1";
                self.selectBook = book;
                [self loadTargetList];
                [self updataBookUI];
                [self.bookCollectionView reloadData];
                self.addImageView.hidden = YES;
            }else{
                self.addImageView.hidden = NO;
            }
            
            
            
            
        }else{
            [SVProgressHUD showErrorWithStatus:result];
        }
    }];
}

-(void)updataBookUI{
    self.titleLabel.text = self.selectBook.title;
    self.title2Label.text = self.selectBook.title;
}

-(void)loadTargetList{
    [SVProgressHUD showWithStatus:@"加载中"];
    [[APIManager getInstance] StudyTargetWithbid:self.selectBook.bookId callback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            [SVProgressHUD dismiss];
            self.targetArray = result;
            [self.pickerView reloadAllComponents];
            [self updataContentUI];
        }else{
            [SVProgressHUD showErrorWithStatus:result];
        }
    }];
}

-(void)updataContentUI{
    
    for (NSInteger i = 0; i<self.targetArray.count; i++) {
        LTargetModel *target = self.targetArray[i];
        if ([target.is_plan isEqualToString:@"1"]) {
            self.selectBook.target = target;
            self.selectTargetIndex = i;
            self.selectTarget = target;
        }
    }
    
    if (!self.selectTarget) {
        self.selectTarget = self.targetArray.firstObject;
        self.selectTargetIndex = 0;
        [self.pickerView selectRow:self.selectTargetIndex inComponent:0 animated:YES];
        [self.pickerView selectRow:self.selectTargetIndex inComponent:1 animated:YES];
        [self.pickerView selectRow:self.selectTargetIndex inComponent:2 animated:YES];
        
    }
    NSString *today_word_surplus = [NSString stringWithFormat:@"%@",self.selectBook.today_word_surplus];
    if ([today_word_surplus isEqualToString:@"-1"]) {
        self.notargetView.hidden = NO;
        [self.firstSetTargerBtn setTitle:@"设定每日学习计划" forState:UIControlStateNormal];
    }else{
        self.notargetView.hidden = YES;
    }
    
    
    if (self.selectBook.target) {
        self.startStudyTargetBtn.backgroundColor = RGB(204, 204, 204);
        [self.pickerView selectRow:self.selectTargetIndex inComponent:0 animated:YES];
        [self.pickerView selectRow:self.selectTargetIndex inComponent:1 animated:YES];
        [self.pickerView selectRow:self.selectTargetIndex inComponent:2 animated:YES];
        [self.startStudyTargetBtn setTitle:@"继续学习该计划" forState:UIControlStateNormal];
        if ([self.selectBook.target.status isEqualToString:@"0"]) {
            self.notargetView.hidden = NO;
            [self.firstSetTargerBtn setTitle:@"开启该学习计划" forState:UIControlStateNormal];
        }
        
    }else{
        self.startStudyTargetBtn.backgroundColor = RGB(255, 184, 73);
        [self.startStudyTargetBtn setTitle:@"开始学习该计划" forState:UIControlStateNormal];
    }
}

#pragma mark -- UIPickerViewDelegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.targetArray.count;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return ScreenWidth/3-10;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    LTargetModel *target = self.targetArray[row];
    if (component==0) {
        return [NSString stringWithFormat:@"第%@关",target.level];
    }else if (component == 1){
        return [NSString stringWithFormat:@"%@个",target.word_number];
    }else{
        return [NSString stringWithFormat:@"%@天",target.completion_times];
    }
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *label = (UILabel *)view;
    if (label == nil) {
        label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
    }
    label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return label;
    
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.selectTarget = self.targetArray[row];
    self.selectTargetIndex = row;
    self.startStudyTargetBtn.backgroundColor = RGB(255, 184, 73);
    if (component==0) {
        [self.pickerView selectRow:self.selectTargetIndex inComponent:1 animated:YES];
        [self.pickerView selectRow:self.selectTargetIndex inComponent:2 animated:YES];
    }else if (component == 1){
        [self.pickerView selectRow:self.selectTargetIndex inComponent:0 animated:YES];
        [self.pickerView selectRow:self.selectTargetIndex inComponent:2 animated:YES];
    }else if (component==2){
        [self.pickerView selectRow:self.selectTargetIndex inComponent:0 animated:YES];
        [self.pickerView selectRow:self.selectTargetIndex inComponent:1 animated:YES];
    }
}
#pragma mark -- UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.bookArray.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LBookSetTargetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LBookSetTargetCell" forIndexPath:indexPath];
    cell.book = self.bookArray[indexPath.row];
    cell.delegate = self;
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    LBookModel *book = self.bookArray[indexPath.row];
    if (book == self.selectBook) {
        return;
    }
    for (LBookModel *current in self.bookArray) {
        current.isSelect = @"0";
    }
    book.isSelect = @"1";
    
    self.selectBook = book;
    self.openOrCloseSwitch.on = YES;
    self.selectTarget = nil;
    [self updataBookUI];
    [self loadTargetList];
    [self.bookCollectionView reloadData];
}
#pragma mark -- LBookSetTargetCellDelegate
-(void)deleteBookWith:(LBookModel *)book{
    LBookDeleteAlertView *view = [[NSBundle mainBundle] loadNibNamed:@"LBookDeleteAlertView" owner:nil options:nil].firstObject;
    view.frame = CGRectMake((ScreenWidth-300)/2, (ScreenHeight-190)/2, 300, 190);
    view.book = book;
    __weak typeof(self)weakSelf = self;
    view.selectBlock = ^(BOOL result) {
        if (result) {
            [[APIManager getInstance] delUserWordbookWithBid:book.bookId callback:^(BOOL success, id  _Nonnull result) {
                if (success) {
                    [SVProgressHUD dismiss];
                    [weakSelf.bookArray removeObject:book];
                    [weakSelf.bookCollectionView reloadData];
                    if (book.isSelect) {
                        if (weakSelf.bookArray.count) {
                            LBookModel *firstBook = weakSelf.bookArray.firstObject;
                            firstBook.isSelect=@"1";
                            weakSelf.selectBook = firstBook;
                            [weakSelf loadTargetList];
                            self.addImageView.hidden = YES;
                        }else{
                            self.addImageView.hidden = NO;
                        }
                        
                    }
                }else{
                    [SVProgressHUD showErrorWithStatus:result];
                }
            }];
        }
        [WPAlertControl alertHiddenForRootControl:weakSelf completion:nil];
    };
    [WPAlertControl alertForView:view begin:WPAlertBeginCenter end:WPAlertEndCenter animateType:WPAlertAnimateBounce constant:0 animageBeginInterval:0.3 animageEndInterval:0.3 maskColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] pan:YES rootControl:self mackClick:nil animateStatus:nil];
}

-(void)addBtnClick{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Word" bundle:nil];
    LAddBookViewController *vc = sb.instantiateInitialViewController;
    __weak typeof(self)weakSelf = self;
    vc.reloadDataBlock = ^{
        [weakSelf loadBookList];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)switchClick:(UISwitch *)sender {
    if (!sender.on) {
        if (!self.selectBook.target) {
            [SVProgressHUD showErrorWithStatus:@"还没制定学习计划"];
            sender.on = YES;
            return;
        }
        [SVProgressHUD showWithStatus:@"提交中"];
        [[APIManager getInstance] updStudyTargetActionWithBid:self.selectBook.bookId status:@"0" callback:^(BOOL success, id  _Nonnull result) {
            if (success) {
                [SVProgressHUD dismiss];
                self.notargetView.hidden = NO;
                self.selectBook.target.status = @"0";
                [self.firstSetTargerBtn setTitle:@"开启该学习计划" forState:UIControlStateNormal];
                
            }else{
                [SVProgressHUD showErrorWithStatus:result];
            }
        }];
    }
}
- (IBAction)firstSetTargerBtnClick:(UIButton *)sender {
    self.notargetView.hidden = YES;
    self.openOrCloseSwitch.on = YES;
    if (self.selectBook.target) {
        [SVProgressHUD showWithStatus:@"提交中"];
        [[APIManager getInstance] updStudyTargetActionWithBid:self.selectBook.bookId status:@"1" callback:^(BOOL success, id  _Nonnull result) {
            if (success) {
                [SVProgressHUD dismiss];
                self.selectBook.target.status = @"1";
            }else{
                [SVProgressHUD showErrorWithStatus:result];
            }
        }];
    }
}
- (IBAction)startStudyTargetBtnClick:(id)sender {
    [SVProgressHUD showWithStatus:@"加载中"];
    [[APIManager getInstance] studyTargetActionWithBid:self.selectBook.bookId level:self.selectTarget.level callback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            [SVProgressHUD dismiss];
            self.selectBook.target = self.selectTarget;
            self.selectBook.today_word_surplus = self.selectTarget.word_number;
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }else{
            [SVProgressHUD showErrorWithStatus:result];
        }
    }];
}
@end
