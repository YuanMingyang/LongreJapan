//
//  SingleTon.m
//  langge
//
//  Created by samlee on 2019/3/25.
//  Copyright © 2019 yang. All rights reserved.
//

#import "SingleTon.h"
#import "LPromotAlertView.h"

@implementation SingleTon

static SingleTon *single = nil;
+(instancetype)getInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        single = [[SingleTon alloc] init];
    });
    return single;
}

-(void)setUser_Tocken:(NSString *)user_tocken{
    [[NSUserDefaults standardUserDefaults] setObject:user_tocken forKey:@"user_tocken"];
}
-(NSString *)getUser_tocken{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"user_tocken"];
}

-(void)showPromotAlert{
    LPromotAlertView *promot = [[NSBundle mainBundle] loadNibNamed:@"LPromotAlertView" owner:nil options:nil].firstObject;
    UIWindow *window =[UIApplication sharedApplication].delegate.window;
    promot.frame = window.bounds;
    [window addSubview:promot];
}

-(void)showStartPage{
    
}
@end
