//
//  LPageViewController.m
//  langge
//
//  Created by samlee on 2019/4/14.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LPageViewController.h"
#import "SPPageMenu.h"
#import "LNewViewController.h"
#import "LNewDetailViewController.h"
#import "LAddNewTypeViewController.h"


#define screenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height
#define pageMenuH 40
#define NaviH (screenH >= 812 ? 88 : 64) // 812是iPhoneX的高度
#define scrollViewHeight (screenH-NaviH-pageMenuH)

@interface LPageViewController ()<SPPageMenuDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, weak) SPPageMenu *pageMenu;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *myChildViewControllers;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
- (IBAction)backBtnClick:(UIButton *)sender;
- (IBAction)addBtnClick:(id)sender;

@end

@implementation LPageViewController
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}
- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (NSMutableArray *)myChildViewControllers {
    if (!_myChildViewControllers) {
        _myChildViewControllers = [NSMutableArray array];
    }
    return _myChildViewControllers;
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NaviH+pageMenuH, screenW, scrollViewHeight)];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return  _scrollView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)setUI {
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = barItem;
    barItem.title = @"";
    
    self.topConstraint.constant = StatusHeight+13;
    self.heightConstraint.constant = StatusHeight+NaviHeight +pageMenuH;
    
    self.dataArr = @[@"生活",@"影视中心",@"交通",@"电视剧",@"搞笑",@"综艺"];
    SPPageMenu *pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, NaviH, screenW, pageMenuH) trackerStyle:SPPageMenuTrackerStyleLine];
    [pageMenu setItems:self.dataArr selectedItemIndex:0];
    pageMenu.delegate = self;
    pageMenu.bridgeScrollView = self.scrollView;
    pageMenu.selectedItemTitleColor = [UIColor whiteColor];
    pageMenu.unSelectedItemTitleColor = [UIColor colorWithWhite:1 alpha:0.7];
    pageMenu.backgroundColor = [UIColor clearColor];
    [self.view addSubview:pageMenu];
    _pageMenu = pageMenu;
    
    [self.view addSubview:self.scrollView];
    
    for (int i = 0; i < self.dataArr.count; i++) {
        LNewViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LNewViewController"];
        [self addChildViewController:vc];
        [self.myChildViewControllers addObject:vc];
    }
    if (self.pageMenu.selectedItemIndex < self.myChildViewControllers.count) {
        LNewViewController *vc = self.myChildViewControllers[self.pageMenu.selectedItemIndex];
        [self.scrollView addSubview:vc.view];
        vc.view.frame = CGRectMake(screenW*self.pageMenu.selectedItemIndex, 0, screenW, scrollViewHeight);
        self.scrollView .contentOffset = CGPointMake(screenW*self.pageMenu.selectedItemIndex, 0);
        self.scrollView .contentSize = CGSizeMake(self.dataArr.count*screenW, 0);
    }
}


#pragma mark - SPPageMenu的代理方法

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedAtIndex:(NSInteger)index {
    NSLog(@"%zd",index);
}

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    NSLog(@"%zd------->%zd",fromIndex,toIndex);
    if (!self.scrollView.isDragging) { // 判断用户是否在拖拽scrollView
        // 如果fromIndex与toIndex之差大于等于2,说明跨界面移动了,此时不动画.
        if (labs(toIndex - fromIndex) >= 2) {
            [self.scrollView setContentOffset:CGPointMake(screenW * toIndex, 0) animated:NO];
        } else {
            [self.scrollView setContentOffset:CGPointMake(screenW * toIndex, 0) animated:YES];
        }
    }
    
    if (self.myChildViewControllers.count <= toIndex) {return;}
    
    UIViewController *targetViewController = self.myChildViewControllers[toIndex];
    // 如果已经加载过，就不再加载
    if ([targetViewController isViewLoaded]) return;
    
    targetViewController.view.frame = CGRectMake(screenW * toIndex, 0, screenW, scrollViewHeight);
    [_scrollView addSubview:targetViewController.view];
    
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 这一步是实现跟踪器时刻跟随scrollView滑动的效果,如果对self.pageMenu.scrollView赋了值，这一步可省
    [self.pageMenu moveTrackerFollowScrollView:scrollView];
}

- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addBtnClick:(id)sender {
    LAddNewTypeViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"LAddNewTypeViewController"];
    [self.navigationController pushViewController:VC animated:YES];
}



#pragma mark - GKPageScrollViewDelegate



@end
