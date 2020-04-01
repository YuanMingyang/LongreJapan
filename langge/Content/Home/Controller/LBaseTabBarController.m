//
//  LBaseTabBarController.m
//  langge
//
//  Created by samlee on 2019/3/22.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LBaseTabBarController.h"
#import "LWordBaseNaviController.h"

@interface LBaseTabBarController ()<UITabBarControllerDelegate>

@end

@implementation LBaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    UIView *bgView = [[UIView alloc] initWithFrame:self.tabBar.bounds];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.tabBar insertSubview:bgView atIndex:0];
    
    self.tabBar.tintColor = RGB(251, 124, 118);

    if (@available(iOS 10.0, *)) {
        self.tabBar.unselectedItemTintColor = RGB(153, 153, 153);
    } else {
        // Fallback on earlier versions
    }

}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    return YES;
}


@end
