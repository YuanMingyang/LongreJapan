//
//  LAdviceViewController.m
//  langge
//
//  Created by samlee on 2019/4/21.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LAdviceViewController.h"
#import "LAddImageModel.h"
#import "LAddImageCell.h"
#import "WPAlertControl.h"
#import "LListAlertView.h"
#import "LFeedBackListViewController.h"
#import "UITextView+Placeholder.h"

@interface LAdviceViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *textCountLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *photoCountLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextfield;
- (IBAction)lookHistroryAdviceBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *feedback_numberLabel;

@property (weak, nonatomic) IBOutlet UILabel *playLabel;
@property(nonatomic,strong)NSMutableArray *photoArray;
@property(nonatomic,assign)NSInteger num;
@end

@implementation LAdviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}

-(void)setUI{
    self.widthConstraint.constant = ScreenWidth;
    self.heightConstraint.constant = ScreenHeight-StatusHeight-NaviHeight;
    
    self.textView = [[UITextView alloc] init];
    self.textView.editable = YES;
    self.textView.bounces = NO;
    self.textView.font = [UIFont systemFontOfSize:13];
    self.textView.textColor = [UIColor blackColor];
    self.textView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(20);
        make.height.mas_equalTo(100);
    }];
    
    [self.phoneTextfield modifyWithcornerRadius:5 borderColor:RGB(200, 200, 200) borderWidth:1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataUserInfo) name:@"updataUserInfo" object:nil];
    
    [self.feedback_numberLabel modifyWithcornerRadius:5 borderColor:nil borderWidth:0];
    if ([SingleTon getInstance].isLogin) {
        NSString *feedBackNum = [NSString stringWithFormat:@"%@",[SingleTon getInstance].user.feedback_number];
        if ([feedBackNum isEqualToString:@"0"]) {
            self.feedback_numberLabel.hidden = YES;
        }else{
            self.feedback_numberLabel.hidden = NO;
            self.feedback_numberLabel.text = feedBackNum;
        }
    }else{
        self.feedback_numberLabel.hidden = YES;
    }
    
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = barItem;
    barItem.title = @"";
    
    
    self.title = @"我要吐槽";
    UIButton *submitBtn = [[UIButton alloc] init];
    [submitBtn setTitleColor:RGB(251, 124, 118) forState:UIControlStateNormal];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitbtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:submitBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.textView.delegate = self;
    self.textView.editable = YES;
    
    //[self.textView setPlaceholder:@"亲爱的~我们非常重视您给我们提出宝贵的建议，帮助我们不断完善产品，非常感谢！" placeholdColor:RGB(150, 150, 150)];
    
    
    self.photoArray = [NSMutableArray array];
    LAddImageModel *model = [[LAddImageModel alloc] initWith:nil currentIndex:0 imageNum:1];
    [self.photoArray addObject:model];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((ScreenWidth-60)/4, 78);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

-(void)updataUserInfo{
    NSString *feedBackNum = [NSString stringWithFormat:@"%@",[SingleTon getInstance].user.feedback_number];
    if ([feedBackNum isEqualToString:@"0"]) {
        self.feedback_numberLabel.hidden = YES;
    }else{
        self.feedback_numberLabel.hidden = NO;
        self.feedback_numberLabel.text = feedBackNum;
    }
}

-(void)addImage{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    //imagePicker.allowsEditing= YES;
    LListAlertView *alert = [[NSBundle mainBundle] loadNibNamed:@"LListAlertView" owner:nil options:nil].firstObject;
    CGFloat height = 0;
    if (KIsiPhoneX) {
        height = 34;
    }
    alert.frame = CGRectMake(0, 0, ScreenWidth, 150+height);
    __weak typeof(self)weakSelf = self;
    alert.clickBlock = ^(NSInteger index) {
        
        if (index==0) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }else{
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController presentViewController:imagePicker animated:YES completion:nil];
        });
        [WPAlertControl alertHiddenForRootControl:weakSelf completion:nil];
    };
    [alert configWith:@"请选择照片来源" items:@[@"打开相机",@"从手机相册获取"]];
    [WPAlertControl alertForView:alert begin:WPAlertBeginBottem end:WPAlertEndBottem animateType:WPAlertAnimateBounce constant:0 animageBeginInterval:0.3 animageEndInterval:0.3 maskColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] pan:YES rootControl:self mackClick:nil animateStatus:nil];
}


#pragma mark -- UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    
    UIImage *newImage = info[UIImagePickerControllerOriginalImage];
    LAddImageModel *lastImageModel = self.photoArray.lastObject;
    lastImageModel.mainImage = newImage;
    lastImageModel.imageNum = self.photoArray.count+1;
    self.photoCountLabel.text = [NSString stringWithFormat:@"%lu/4",self.photoArray.count];
    if (self.photoArray.count<4) {
        LAddImageModel *newModel = [[LAddImageModel alloc] initWith:nil currentIndex:self.photoArray.count imageNum:self.photoArray.count+1];
        [self.photoArray addObject:newModel];
    }
    [self.collectionView reloadData];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photoArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LAddImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LAddImageCell" forIndexPath:indexPath];
    cell.imageModel = self.photoArray[indexPath.row];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==self.photoArray.count-1) {
        LAddImageModel *model = self.photoArray[indexPath.row];
        if (!model.mainImage) {
            [self addImage];
        }
    }
}

#pragma mark -- UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    self.num = 500-textView.text.length;
    if (self.num<=0) {
        self.num = 0;
    }
    self.textCountLabel.text = [NSString stringWithFormat:@"%lu/500",self.num];
    
    
    if (textView.text.length>0) {
        self.playLabel.hidden = YES;
    }else{
        self.playLabel.hidden = NO;
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (self.num == 500) {
        return NO;
    }
    return YES;
}


- (IBAction)lookHistroryAdviceBtnClick:(id)sender {
    if (![SingleTon getInstance].isLogin) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        [self.navigationController presentViewController:sb.instantiateInitialViewController animated:YES completion:nil];
        return;
    }
    
    
    LFeedBackListViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LFeedBackListViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)submitbtnClick{
    if (self.textView.text.length==0) {
        [SVProgressHUD showErrorWithStatus:@"请输入内容"];
        return;
    }
    NSMutableArray *imageArray = [NSMutableArray array];
    [SVProgressHUD showWithStatus:@"上传中"];
    for (LAddImageModel *imageModel in self.photoArray) {
        if (imageModel.mainImage) {
            [imageArray addObject:[XSTools imageToBase64With:imageModel.mainImage]];
        }
    }
    [[APIManager getInstance] feedbackActiveWithUser_suggest:self.textView.text phone:self.phoneTextfield.text imgArr:imageArray callback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            [SVProgressHUD showSuccessWithStatus:result];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:result];
        }
    }];
    
}
@end
