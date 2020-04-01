//
//  SingleTon.h
//  langge
//
//  Created by samlee on 2019/3/25.
//  Copyright © 2019 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LUserModel.h"
#import "LPrivacyPolicyView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SingleTon : NSObject
@property(nonatomic,strong)LUserModel *user;
@property(nonatomic,strong)NSString *authTocken;
@property(nonatomic,assign)BOOL isLogin;
+(instancetype)getInstance;


-(void)setUser_Tocken:(NSString *)user_tocken;
-(NSString *)getUser_tocken;


-(void)showPromotAlert;
@property(nonatomic,assign)BOOL isShare;

-(void)showStartPage;
@end

NS_ASSUME_NONNULL_END
