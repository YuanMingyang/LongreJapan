//
//  LPageController.m
//  langge
//
//  Created by samlee on 2019/4/18.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LPageController.h"
#import "LNewViewController.h"
#import "LNewMenuModel.h"
#import "LAddNewTypeViewController.h"

@interface LPageController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeightConstraint;
- (IBAction)backBtnClick:(id)sender;
- (IBAction)addBtnClick:(id)sender;

@property(nonatomic,strong)NSMutableArray *likeMenuArr;
@property(nonatomic,strong)NSMutableArray *allMenuArr;
@end

@implementation LPageController
- (NSArray<NSString *> *)titles {
    return @[@"生活",@"影视中心",@"交通",@"电视剧",@"搞笑",@"综艺"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = barItem;
    barItem.title = @"";
    
    self.topViewHeightConstraint.constant = NaviHeight+StatusHeight;
    self.view.backgroundColor = RGB(255, 182, 171);
    self.likeMenuArr = [NSMutableArray array];
    self.allMenuArr = [NSMutableArray array];
    self.automaticallyCalculatesItemWidths = YES;
    [self loadMenu];
}
-(void)loadMenu{
    [SVProgressHUD showWithStatus:@"加载中"];
    
    [[APIManager getInstance] getUserNewClassListWithCallback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            [SVProgressHUD dismiss];
            [self.allMenuArr removeAllObjects];
            [self.likeMenuArr removeAllObjects];
            [self.allMenuArr addObjectsFromArray:result];
            for (LNewMenuModel *menu in self.allMenuArr) {
                if ([menu.is_like isEqualToString:@"1"]) {
                    [self.likeMenuArr addObject:menu];
                }
            }
            if (self.likeMenuArr.count == 0) {
                [SVProgressHUD showInfoWithStatus:@"还没有感兴趣的情报，快去添加吧!"];
            }else{
                [self reloadData];
            }
            
        }else{
            [SVProgressHUD showErrorWithStatus:result];
        }
    }];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSMutableArray *mutableWidth = [NSMutableArray array];
        for (LNewMenuModel *menu in self.likeMenuArr) {
            CGSize size = [XSTools getStringSizeWithFont:15 string:menu.title];
            [mutableWidth addObject:[NSNumber numberWithFloat:size.width+15.0]];
        }
        self.itemsWidths = mutableWidth;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.titleSizeSelected = 15.0;
        self.titleSizeNormal = 14;
        self.titleColorSelected = [UIColor whiteColor];
        self.titleColorNormal = RGB(242, 242, 242);
    }
    return self;
}


#pragma mark - WMPageController DataSource
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return self.likeMenuArr.count;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    LNewMenuModel *menu = self.likeMenuArr[index];
    return menu.title;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Found" bundle:nil];
    LNewViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LNewViewController"];
    vc.menu = self.likeMenuArr[index];
    return vc;
}
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    return CGRectMake(0, NaviHeight+StatusHeight, ScreenWidth, 40);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    return CGRectMake(0, NaviHeight+StatusHeight+40, ScreenWidth, ScreenHeight-NaviHeight-StatusHeight-40);
}
- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addBtnClick:(id)sender {
    if (![SingleTon getInstance].isLogin) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        [self.navigationController presentViewController:sb.instantiateInitialViewController animated:YES completion:nil];
        return;
    }
    
    
    LAddNewTypeViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"LAddNewTypeViewController"];
    VC.allMenuArr = self.allMenuArr;
    __weak typeof(self)weakSelf = self;
    VC.resultBlock = ^{
        [weakSelf loadMenu];
    };
    [self.navigationController pushViewController:VC animated:YES];
}
@end
