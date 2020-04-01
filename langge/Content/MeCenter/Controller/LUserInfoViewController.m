//
//  LUserInfoViewController.m
//  langge
//
//  Created by samlee on 2019/4/1.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LUserInfoViewController.h"
#import "LListAlertView.h"
#import "WPAlertControl.h"
#import "LDateAlertView.h"
#import "LSubmitViewController.h"
#import "LSelectCityViewController.h"
#import "LMedalViewController.h"

@interface LUserInfoViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@property (weak, nonatomic) IBOutlet UIImageView *medalIcon;
@property (weak, nonatomic) IBOutlet UILabel *medalNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *medalWordTotalLabel;

- (IBAction)submitBtnClick:(id)sender;


@property(nonatomic,strong)UIImage *selectImage;

@end

@implementation LUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

-(void)setUI{
    [self.avatarImageView modifyWithcornerRadius:22 borderColor:nil borderWidth:0];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = barItem;
    barItem.title = @"";
    self.title = @"个人资料";
    
    self.avatarImageView.image = [XSTools base64ToImageWith:[SingleTon getInstance].user.user_img_src];
    self.nicknameLabel.text = [SingleTon getInstance].user.nick_name;
    NSString *user_sex = [NSString stringWithFormat:@"%@",[SingleTon getInstance].user.user_sex];
    self.genderLabel.text = @"";
    if (user_sex&&user_sex.length>0) {
        if ([user_sex isEqualToString:@"1"]) {
            self.genderLabel.text = @"男";
        }else if ([user_sex isEqualToString:@"2"]){
            self.genderLabel.text = @"女";
        }else{
            self.genderLabel.text = @"";
        }
    }
    
    self.birthdayLabel.text = [SingleTon getInstance].user.user_age;
    if ([SingleTon getInstance].user.city&&[SingleTon getInstance].user.city.length>0) {
        self.cityLabel.text = [SingleTon getInstance].user.city;
    }else{
        self.cityLabel.text = @"选择城市";
    }

    
    NSString *user_medal_img = [SingleTon getInstance].user.user_medal[@"img"];
    if (user_medal_img&&user_medal_img.length>0) {
        [self.medalIcon sd_setImageWithURL:[NSURL URLWithString:[SingleTon getInstance].user.user_medal[@"img"]] placeholderImage:[UIImage imageNamed:@"defalut_img"]];
        self.medalIcon.hidden = NO;
    }else{
        self.medalIcon.hidden = YES;
    }
    
    
    self.medalNameLabel.text =[SingleTon getInstance].user.user_medal[@"name"];
    self.medalWordTotalLabel.text = [NSString stringWithFormat:@"背词%@个",[SingleTon getInstance].user.user_medal[@"word_total"]];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 80;
    }else if (indexPath.row == 6){
        return 103;
    }else{
        return 50;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        //头像
        [self selectAvatar];
    }else if (indexPath.row == 1){
        //昵称
        [self changeNickname];
    }else if (indexPath.row == 2){
        //性别
        [self selectGender];
    }else if (indexPath.row == 3){
        //生日
        [self selectDate];
    }else if (indexPath.row == 4){
        //城市
        [self selectCity];
    }else if (indexPath.row == 5){
        //背词
        [self selectMedal];
    }
}
-(void)selectMedal{
    LMedalViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LMedalViewController"];
    vc.shouldNavigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)selectCity{
    LSelectCityViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LSelectCityViewController"];
    __weak typeof(self)weakSelf = self;
    vc.resultBlock = ^(NSString * _Nonnull cityName) {
        weakSelf.cityLabel.text = cityName;
    };
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)selectAvatar{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    
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

-(void)selectGender{
    LListAlertView *alert = [[NSBundle mainBundle] loadNibNamed:@"LListAlertView" owner:nil options:nil].firstObject;
    CGFloat height = 0;
    if (KIsiPhoneX) {
        height = 34;
    }
    alert.frame = CGRectMake(0, 0, ScreenWidth, 150+height);
    __weak typeof(self)weakSelf = self;
    alert.clickBlock = ^(NSInteger index) {
        if (index==0) {
            self.genderLabel.text = @"女";
        }else{
            self.genderLabel.text = @"男";
        }
        
        [WPAlertControl alertHiddenForRootControl:weakSelf completion:nil];
    };
    [alert configWith:@"请选择" items:@[@"女",@"男"]];
    [WPAlertControl alertForView:alert begin:WPAlertBeginBottem end:WPAlertEndBottem animateType:WPAlertAnimateBounce constant:0 animageBeginInterval:0.3 animageEndInterval:0.3 maskColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] pan:YES rootControl:self mackClick:nil animateStatus:nil];
}
-(void)selectDate{
    LDateAlertView *alert = [[NSBundle mainBundle] loadNibNamed:@"LDateAlertView" owner:nil options:nil].firstObject;
    CGFloat height = 0;
    if (KIsiPhoneX) {
        height = 34;
    }
    alert.frame = CGRectMake(0, 0, ScreenWidth, 200+height);
    __weak typeof(self)weakSelf = self;
    alert.submitBlock = ^(NSString * _Nonnull dateStr) {
        if (dateStr.length>0) {
            weakSelf.birthdayLabel.text = dateStr;
        }
        [WPAlertControl alertHiddenForRootControl:weakSelf completion:nil];
    };
    [WPAlertControl alertForView:alert begin:WPAlertBeginBottem end:WPAlertEndBottem animateType:WPAlertAnimateBounce constant:0 animageBeginInterval:0.3 animageEndInterval:0.3 maskColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] pan:YES rootControl:self mackClick:nil animateStatus:nil];
}

-(void)changeNickname{
    LSubmitViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LSubmitViewController"];
    vc.titleStr = @"昵称";
    __weak typeof(self)weakSelf = self;
    vc.resultBlock = ^(NSString * _Nonnull result) {
        weakSelf.nicknameLabel.text = result;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    UIImage *newImage = info[UIImagePickerControllerEditedImage];
    self.avatarImageView.image = newImage;
    self.selectImage = newImage;
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)submitBtnClick:(id)sender {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"user_token"] = [[SingleTon getInstance] getUser_tocken];
    if (self.selectImage) {
        dic[@"user_img_src"] = [XSTools imageToBase64With:self.selectImage];
    }
    if (self.nicknameLabel.text.length>0) {
        dic[@"nick_name"] = self.nicknameLabel.text;
    }
    if (self.cityLabel.text.length>0) {
        dic[@"city"] = self.cityLabel.text;
    }
    if (self.genderLabel.text.length>0) {
        if ([self.genderLabel.text isEqualToString:@"男"]) {
            dic[@"user_sex"] = @"1";
        }else if([self.genderLabel.text isEqualToString:@"女"]){
            dic[@"user_sex"] = @"2";
        }
    }
    if (self.birthdayLabel.text.length>0) {
        dic[@"user_age"] = self.birthdayLabel.text;
    }
    
    [SVProgressHUD showWithStatus:@"提交中"];
    [[APIManager getInstance] saveUserInfoWithParam:dic callback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            [[APIManager getInstance] getUserInfoWithCallback:^(BOOL success, id  _Nonnull result) {
                
            }];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:result];
        }
    }];
}
@end
