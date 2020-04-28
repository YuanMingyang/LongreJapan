//
//  APIManager.m
//  langge
//
//  Created by samlee on 2019/3/25.
//  Copyright © 2019 yang. All rights reserved.
//

#import "APIManager.h"
#import "LBannerModel.h"
#import "LDailySentenceModel.h"
#import "LCourseModel.h"
#import "LNewsModel.h"
#import "LLucyModel.h"
#import "LNewMenuModel.h"
#import "LCourseDetailModel.h"
#import "LFeedBackModel.h"
#import "LSystemMsgModel.h"
#import "LBookModel.h"
#import "LTargetModel.h"
#import "LStudyToolModel.h"
#import "LStrangeWordModel.h"
#import "LRankingModel.h"
#import "LMedalModel.h"
#import "LSubjectWrongModel.h"
#import "LFiftytonesModel.h"
#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>

@implementation APIManager
static APIManager *apiManager = nil;
static AFHTTPSessionManager *manager = nil;
+(instancetype)getInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        apiManager = [[APIManager alloc] init];
        manager = [AFHTTPSessionManager manager];
        [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain",nil]];
    });
    return apiManager;
}

-(void)getAuthWith:(void (^)(BOOL, id _Nonnull))callback{
    NSDictionary *dic = @{@"jwt_username":@"jwt_japanApp@eopfun.com",
                          @"jwt_password":@"7c012587d995eabc81465c9a24ac9cd1"};
    [manager POST:API_GetAuth parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue] == 0) {

            [SingleTon getInstance].authTocken = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"token"]];
            callback(YES,responseObject[@"data"][@"token"]);
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}

-(void)getMobileAuthWithMobile:(NSString *)mobile callback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_GetMobileAuth,[SingleTon getInstance].authTocken];
    NSDictionary *dic = @{
                          @"mobile":mobile
                          };
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue] == 0) {
            callback(YES,@"验证码获取成功");
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}

-(void)getWXAccessTokenWithCode:(NSString *)code callback:(void (^)(BOOL, id _Nonnull))callback{
    NSDictionary *param=@{
                          @"code" : code,
                          @"appid" :WECHAT_APP_ID,
                          @"secret":WECHAT_APP_SCRET,
                          @"grant_type" : @"authorization_code"
                          };
    [manager POST:API_GETWX_Token parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        callback(YES,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
    
}


-(void)getWXUserinfoWithToken:(NSString *)token openID:(NSString *)openID callback:(void (^)(BOOL, id _Nonnull))callback{
    NSDictionary *dic = @{
                          @"access_token":token,
                          @"openid":openID
                          };
    [manager POST:API_GET_WX_UserInfo parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        callback(YES,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}
-(void)getQQUserInfoWithAccess_token:(NSString *)access_token openid:(NSString *)openid oauth_consumer_key:(NSString *)oauth_consumer_key callback:(void (^)(BOOL, id _Nonnull))callback{
    NSDictionary *dic = @{
                          @"access_token":access_token,
                          @"openid":openid,
                          @"oauth_consumer_key":oauth_consumer_key
                          };
    [manager GET:API_GET_QQ_UserInfo parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)CustomerLoginWithMobile:(NSString *)mobile sms_code:(NSString *)sms_code open_id:(NSString *)open_id open_name:(NSString *)open_name type_open:(NSString *)type_open callback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSString *url = [NSString stringWithFormat:@"%@?token=%@&deviceId=%@",API_AuthLogin,[SingleTon getInstance].authTocken,idfa];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (mobile) {
        dic[@"mobile"] = mobile;
    }
    if (sms_code) {
        dic[@"sms_code"] = sms_code;
    }
    if (open_id) {
        dic[@"open_id"] = open_id;
    }
    if (type_open) {
        dic[@"type_open"] = type_open;
    }
    if (open_name) {
        dic[@"open_name"] = open_name;
    }
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue] == 0) {
            [[SingleTon getInstance] setUser_Tocken:responseObject[@"data"][@"user_info"][@"user_token"]];
            [SingleTon getInstance].isLogin = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginStatusChange" object:nil];
            
            [[APIManager getInstance] getUserInfoWithCallback:^(BOOL success, id  _Nonnull result) {
                if (success) {
                    [JPUSHService setAlias:[XSTools getMd5Str:[SingleTon getInstance].user.user_mobile] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                        NSLog(@"rescode: %ld, \ntags: %@, \nalias: %@\n", (long)iResCode, @"tag" , iAlias);
                    } seq:0];
                }else{
                    NSLog(@"获取用户信息失败");
                }
            }];
            if (mobile) {
                callback(YES,responseObject[@"data"]);
            }else{
                callback(YES,responseObject[@"errorMsg"]);
            }
            
        }else{
            if (mobile) {
                callback(NO,responseObject[@"errorMsg"]);
            }else{
                callback(NO,responseObject);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}

-(void)simpleLoginWithUserAccount:(NSString *)userAccount userPass:(NSString *)userPass callback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_SimpleLogin,[SingleTon getInstance].authTocken];
    NSDictionary *dic = @{
                          @"userAccount":userAccount,
                          @"userPass":userPass,
                          @"token":[SingleTon getInstance].authTocken
                          };
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue] == 0) {
            [[SingleTon getInstance] setUser_Tocken:responseObject[@"data"][@"user_info"][@"user_token"]];
            
            [SingleTon getInstance].isLogin = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginStatusChange" object:nil];
            [[APIManager getInstance] getUserInfoWithCallback:^(BOOL success, id  _Nonnull result) {
                if (success) {
                    [JPUSHService setAlias:[XSTools getMd5Str:[SingleTon getInstance].user.user_mobile] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                        NSLog(@"rescode: %ld, \ntags: %@, \nalias: %@\n", (long)iResCode, @"tag" , iAlias);
                    } seq:0];
                }else{
                    NSLog(@"获取用户信息失败");
                }
            }];
            callback(YES,responseObject[@"errorMsg"]);
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}

-(void)saveUserInfoWithParam:(NSMutableDictionary *)dic callback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_saveUserInfo,[SingleTon getInstance].authTocken];
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue] == 0) {
            callback(YES,responseObject[@"errorMsg"]);
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}

-(void)getUserInfoWithCallback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_GetUserInfo,[SingleTon getInstance].authTocken];
    NSDictionary *dic = @{
                          @"user_token":[[SingleTon getInstance] getUser_tocken]
                          };
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue] == 0) {
            LUserModel *user = [SingleTon getInstance].user;
            if (!user) {
                user = [LUserModel new];
                [SingleTon getInstance].user = user;
                user.user_token = [[SingleTon getInstance] getUser_tocken];
                
            }
            user.user_account = responseObject[@"data"][@"user_account"];
            user.user_mobile = responseObject[@"data"][@"user_mobile"];
            user.nick_name = responseObject[@"data"][@"nick_name"];
            user.user_img_src = responseObject[@"data"][@"user_img_src"];
            user.user_email = responseObject[@"data"][@"user_email"];
            user.user_sex = responseObject[@"data"][@"user_sex"];
            user.user_age = responseObject[@"data"][@"user_age"];
            user.city = responseObject[@"data"][@"city"];
            user.register_time = responseObject[@"data"][@"register_time"];
            user.weixin_open_id = responseObject[@"data"][@"weixin_open_id"];
            user.weixin_open_name = responseObject[@"data"][@"weixin_open_name"];
            user.qq_open_name = responseObject[@"data"][@"qq_open_name"];
            user.qq_open_id = responseObject[@"data"][@"qq_open_id"];
            user.sina_open_id = responseObject[@"data"][@"sina_open_id"];
            user.sina_open_name = responseObject[@"data"][@"sina_open_name"];
            user.is_auto_play = responseObject[@"data"][@"is_auto_play"];
            user.auto_play_frequency = responseObject[@"data"][@"auto_play_frequency"];
            user.is_receive_msg = responseObject[@"data"][@"is_receive_msg"];
            user.user_medal = responseObject[@"data"][@"user_medal"];
            user.tools_list = responseObject[@"data"][@"tools_list"];
            user.feedback_number = responseObject[@"data"][@"feedback_number"];
            //NSLog(@"user:%@",responseObject);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updataUserInfo" object:nil];
            callback(YES,@"拉取成功");
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}

-(void)restUserPasswordWithMobile:(NSString *)mobile userPassword:(NSString *)userPassword callback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_RestUserPassword,[SingleTon getInstance].authTocken];
    NSDictionary *dic = @{@"mobile":mobile,
                          @"user_token":[[SingleTon getInstance] getUser_tocken],
                          @"userPassword":userPassword
                          };
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue] == 0) {
            callback(YES,@"成功");
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}

-(void)getfxDataWithPage:(NSString *)page callback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_GetfxData,[SingleTon getInstance].authTocken];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"news_page"] = page;
    dic[@"news_page_sum"] = @"10";
    if ([[SingleTon getInstance] getUser_tocken]&&[[SingleTon getInstance]getUser_tocken].length>0) {
        dic[@"user_token"] = [[SingleTon getInstance] getUser_tocken];
    }

    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue]==401) {
            return ;
        }
        if ([responseObject[@"returnCode"] intValue]==0) {
            NSDictionary *data = responseObject[@"data"];
            NSMutableArray *banner_list = [NSMutableArray array];
            for (NSDictionary *dic in data[@"banner_list"]) {
                LBannerModel *banner = [[LBannerModel alloc] init];
                [banner setValuesForKeysWithDictionary:dic];
                [banner_list addObject:banner];
            }
            NSMutableArray *daily_sentence_list = [NSMutableArray array];
            for (NSDictionary *dic in data[@"daily_sentence_list"]) {
                LDailySentenceModel *daily = [[LDailySentenceModel alloc] init];
                [daily setValuesForKeysWithDictionary:dic];
                [daily_sentence_list addObject:daily];
            }
            NSMutableArray *course_list = [NSMutableArray array];
            for (NSDictionary *dic in data[@"course_list"]) {
                LCourseModel *course = [[LCourseModel alloc] init];
                [course setValuesForKeysWithDictionary:dic];
                [course_list addObject:course];
            }
            NSMutableArray *newsData = [NSMutableArray array];
            for (NSDictionary *dic in data[@"newsData"]) {
                LNewsModel *news = [[LNewsModel alloc] init];
                [news setValuesForKeysWithDictionary:dic];
                [newsData addObject:news];
            }
            callback(YES,@{@"banner_list":banner_list,
                           @"daily_sentence_list":daily_sentence_list,
                           @"course_list":course_list,
                           @"newsData":newsData,
                           @"stripData":@{@"stripImgSrc":data[@"stripImgSrc"],
                                          @"stripImgLink":data[@"stripImgLink"]
                           }
                           });
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}
-(void)getNewsInfoWith:(NSString *)newsId callback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_GetNewInfo,[SingleTon getInstance].authTocken];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"newsId"] = newsId;
    if ([SingleTon getInstance].isLogin) {
        dic[@"user_token"] = [[SingleTon getInstance] getUser_tocken];
    }
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue]==0) {
            LNewsModel *news = [[LNewsModel alloc] init];
            [news setValuesForKeysWithDictionary:responseObject[@"data"]];
            callback(YES,news);
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
    
}


-(void)collectionActiveWithType:(NSString *)type cid:(NSString *)cid callback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_collectionActive,[SingleTon getInstance].authTocken];
    NSString *user_tocken = [[SingleTon getInstance] getUser_tocken];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"user_token"] = user_tocken;
    dic[@"type"] = type;
    dic[@"cId"] = cid;

    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue] == 0) {
            callback(YES,responseObject[@"errorMsg"]);
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}

-(void)fxSearchWithType:(NSString *)type page:(NSString *)page title:(NSString *)title callback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_FX_Search,[SingleTon getInstance].authTocken];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"title"] = title;
    if ([type isEqualToString:@"1"]) {
        dic[@"new_page"] = page;
        dic[@"new_page_sum"] = @"10";
    }else{
        dic[@"course_page"] = page;
        dic[@"course_page_sum"] = @"10";
    }
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue] == 0) {
            if ([type isEqualToString:@"1"]) {
                NSArray *newList = responseObject[@"data"][@"newList"];
                NSMutableArray *mutableArray = [NSMutableArray array];
                for (NSDictionary *dic in newList) {
                    LNewsModel *news = [[LNewsModel alloc] init];
                    [news setValuesForKeysWithDictionary:dic];
                    [mutableArray addObject:news];
                }
                callback(YES,mutableArray);
            }else if ([type isEqualToString:@"2"]){
                NSArray *courseList = responseObject[@"data"][@"courseList"];
                NSMutableArray *mutableArray = [NSMutableArray array];
                for (NSDictionary *dic in courseList) {
                    LCourseModel *course = [[LCourseModel alloc] init];
                    [course setValuesForKeysWithDictionary:dic];
                    [mutableArray addObject:course];
                }
                callback(YES,mutableArray);
            }
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}


-(void)getCourseInfoWithcourseId:(NSString *)courseId class_hour_page:(NSString *)class_hour_page comment_page:(NSString *)comment_page callback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_GetCourseInfo,[SingleTon getInstance].authTocken];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"courseId"] = courseId;
    if ([SingleTon getInstance].isLogin) {
        dic[@"user_token"] = [[SingleTon getInstance] getUser_tocken];
    }
    if (class_hour_page) {
        dic[@"class_hour_page"] = class_hour_page;
    }
    if (comment_page) {
        dic[@"comment_page"] = comment_page;
    }

    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue]==0) {
            NSDictionary *data = responseObject[@"data"];
            LCourseDetailModel *courseDetail = [LCourseDetailModel new];
            [courseDetail setValuesForKeysWithDictionary:data];
            callback(YES,courseDetail);
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}



-(void)getSignListWith:(NSString *)date callback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_Sign_List,[SingleTon getInstance].authTocken];
    NSDictionary *dic = @{
                          @"user_token":[[SingleTon getInstance]getUser_tocken],
                          @"date":date
                          };
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue]==0) {
            callback(YES,responseObject[@"data"]);
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}

-(void)signActiveWithCallback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_Sign_Active,[SingleTon getInstance].authTocken];
    NSDictionary *dic = @{@"user_token":[[SingleTon getInstance]getUser_tocken]};
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue]==0) {
            callback(YES,responseObject[@"data"]);
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}

-(void)drawListWithCallback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_Draw_List,[SingleTon getInstance].authTocken];
    NSDictionary *dic = @{@"user_token":[[SingleTon getInstance]getUser_tocken]};
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue]==0) {
            NSArray *draw_list = responseObject[@"data"][@"draw_list"];
            NSMutableArray *mutableArray = [NSMutableArray array];
            for (NSDictionary *dic in draw_list) {
                LLucyModel *lucy = [LLucyModel new];
                [lucy setValuesForKeysWithDictionary:dic];
                [mutableArray addObject:lucy];
            }
            callback(YES,mutableArray);
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}
-(void)prize_detailsWithBid:(NSString *)bid callback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_Prize_Details,[SingleTon getInstance].authTocken];
    NSDictionary *dic = @{
                          @"user_token":[[SingleTon getInstance]getUser_tocken],
                          @"bid":bid
                          };
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue]==0) {
            LLucyModel *lucy = [LLucyModel new];
            [lucy setValuesForKeysWithDictionary:responseObject[@"data"]];
            callback(YES,lucy);
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}

-(void)getUserNewClassListWithCallback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_UserNewClassList,[SingleTon getInstance].authTocken];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if ([[SingleTon getInstance] getUser_tocken]&&[[SingleTon getInstance]getUser_tocken].length>0) {
        dic[@"user_token"] = [[SingleTon getInstance]getUser_tocken];
    }

    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue]==0) {
            NSArray *user_like_class = responseObject[@"data"][@"user_like_class"];
            NSMutableArray *mutableArray = [NSMutableArray array];
            for (NSDictionary *dic in user_like_class) {
                LNewMenuModel *menu = [LNewMenuModel new];
                menu._id = dic[@"id"];
                menu.title = dic[@"title"];
                menu.is_like = [dic[@"is_like"] boolValue]?@"1":@"0";
                [mutableArray addObject:menu];
            }
            callback(YES,mutableArray);
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}

-(void)userNewsclassActiveWith:(NSString *)json_all callback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_User_newsclass_active,[SingleTon getInstance].authTocken];
    NSDictionary *dic = @{
                          @"user_token":[[SingleTon getInstance]getUser_tocken],
                          @"json_all":json_all
                          };
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue]==0) {
            callback(YES,@"成功");
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}

-(void)getNewListWith:(NSString *)cid page:(NSString *)page callback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_GetNewList,[SingleTon getInstance].authTocken];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"cid"] = cid;
    dic[@"page"] = page;
    if ([[SingleTon getInstance] getUser_tocken]&&[[SingleTon getInstance]getUser_tocken].length>0) {
        dic[@"user_token"] = [[SingleTon getInstance] getUser_tocken];
    }
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue]==0) {
            NSArray *newList = responseObject[@"data"][@"NewsList"];
            NSMutableArray *mutableArray = [NSMutableArray array];
            for (NSDictionary *dic in newList) {
                LNewsModel *news = [[LNewsModel alloc] init];
                [news setValuesForKeysWithDictionary:dic];
                [mutableArray addObject:news];
            }
            callback(YES,mutableArray);
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}

-(void)getCourseListWith:(NSString *)title order_field:(NSString *)order_field order_value:(NSString *)order_value page:(NSString *)page callback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_GetCourseList,[SingleTon getInstance].authTocken];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"user_token"] = [[SingleTon getInstance] getUser_tocken];
    dic[@"page"] = page;
    if (title) {
        dic[@"title"] = title;
    }
    if (order_field) {
        dic[@"order_field"] = order_field;
    }
    if (order_value) {
        dic[@"order_value"] = order_value;
    }
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue]==0) {
            NSArray *courseList = responseObject[@"data"][@"CourseList"];
            NSMutableArray *mutableArray = [NSMutableArray array];
            for (NSDictionary *dic in courseList) {
                LCourseModel *course = [LCourseModel new];
                [course setValuesForKeysWithDictionary:dic];
                [mutableArray addObject:course];
            }
            callback(YES,mutableArray);
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}

-(void)SaveUserPrizeWithPid:(NSString *)pid callback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_Save_User_Prize,[SingleTon getInstance].authTocken];
    NSDictionary *dic = @{
                          @"user_token":[[SingleTon getInstance] getUser_tocken],
                          @"pid" : pid,
                          @"value" : @"1"
                          };
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue]==0) {
            callback(YES,responseObject[@"errorMsg"]);
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}

-(void)getHotSearchWithCallback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_Get_Hot_Search,[SingleTon getInstance].authTocken];
    [manager POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue]==0) {
            NSArray *data = responseObject[@"data"];
            NSMutableArray *mutableArray = [NSMutableArray array];
            for (NSDictionary *dic in data) {
                LNewsModel *news = [[LNewsModel alloc] init];
                [news setValuesForKeysWithDictionary:dic];
                [mutableArray addObject:news];
            }
            callback(YES,mutableArray);
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}

-(void)getQRCodeWithCallback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_Get_QRCode,[SingleTon getInstance].authTocken];
    NSDictionary *dic = @{
                          @"type":@"2"
                          };
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue]==0) {
            
            callback(YES,responseObject[@"data"][@"qrcode"]);
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}


-(void)feedbackActiveWithUser_suggest:(NSString *)user_suggest phone:(NSString *)phone imgArr:(NSMutableArray *)imgArr callback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_FeedbackActive,[SingleTon getInstance].authTocken];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if ([[SingleTon getInstance] getUser_tocken]&&[[SingleTon getInstance] getUser_tocken].length>0) {
        dic[@"user_token"] = [[SingleTon getInstance] getUser_tocken];
    }
    dic[@"phone"] = phone;
    dic[@"user_suggest"] = user_suggest;
    for (int i = 0; i<imgArr.count; i++) {
        [dic setValue:imgArr[i] forKey:[NSString stringWithFormat:@"img%d",i+1]];
    }
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue]==0) {
            callback(YES,responseObject[@"errorMsg"]);
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}


-(void)getCollectionListWithType:(NSString *)type page:(NSString *)page callback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_CollectionList,[SingleTon getInstance].authTocken];
    NSDictionary *dic = @{
                          @"user_token":[[SingleTon getInstance] getUser_tocken],
                          @"type":type,
                          @"page":page
                          };
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue]==0) {
            NSArray *data = responseObject[@"data"];
            NSMutableArray *mutableArray = [NSMutableArray array];
            for (NSDictionary *dic in data) {
                if ([type isEqualToString:@"1"]) {
                    LCourseModel *course = [LCourseModel new];
                    [course setValuesForKeysWithDictionary:dic];
                    [mutableArray addObject:course];
                }else{
                    LNewsModel *news = [LNewsModel new];
                    [news setValuesForKeysWithDictionary:dic];
                    [mutableArray addObject:news];
                }
                
            }
            callback(YES,mutableArray);
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}


-(void)getFeedbackListWithCallback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_FeedbackList,[SingleTon getInstance].authTocken];
    NSDictionary *dic = @{
                          @"user_token":[[SingleTon getInstance] getUser_tocken]
                          };
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue]==0) {
            NSArray *data = responseObject[@"data"];
            NSMutableArray *mutableArray = [NSMutableArray array];
            for (NSDictionary *dic in data) {
                LFeedBackModel *feedBack = [LFeedBackModel new];
                [feedBack setValuesForKeysWithDictionary:dic];
                [mutableArray addObject:feedBack];
            }
            callback(YES,mutableArray);
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}

-(void)getFeedbackInfoWithBackID:(NSString *)backId callback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_FeedbackInfo,[SingleTon getInstance].authTocken];
    NSDictionary *dic = @{
                          @"backId":backId
                          };
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue]==0) {
            LFeedBackModel *feedBack = [LFeedBackModel new];
            [feedBack setValuesForKeysWithDictionary:responseObject[@"data"]];
            callback(YES,feedBack);
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}

-(void)getMessageListWithCallback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_GetMessageList,[SingleTon getInstance].authTocken];
    NSString *user_token = [[SingleTon getInstance] getUser_tocken];
    if (!user_token) {
        user_token = @"";
    }
    NSDictionary *dic = @{
                          @"user_token":user_token
                          };
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue]==0) {
            NSArray *data = responseObject[@"data"];
            NSMutableArray *mutableArray = [NSMutableArray array];
            for (NSDictionary *dic in data) {
                LSystemMsgModel *systemMsg = [LSystemMsgModel new];
                [systemMsg setValuesForKeysWithDictionary:dic];
                [mutableArray addObject:systemMsg];
            }
            callback(YES,mutableArray);
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}


-(void)getMessageDetailWithMid:(NSString *)mid callback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_GetMessageDetail,[SingleTon getInstance].authTocken];
    NSDictionary *dic = @{
                          @"mid":mid
                          };
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue]==0) {
            NSDictionary *data = responseObject[@"data"];
            LSystemMsgModel *systemMsg = [LSystemMsgModel new];
            [systemMsg setValuesForKeysWithDictionary:data];
            callback(YES,systemMsg);
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}


-(void)getWordDataWithJa_word:(NSString *)ja_word callback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_GetWordData,[SingleTon getInstance].authTocken];
    NSDictionary *dic = @{
                          @"ja_word":ja_word
                          };
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"returnCode"] intValue]==0) {
            id data = responseObject[@"data"];
            if ([data isKindOfClass:[NSDictionary class]]) {
                callback(YES,(NSDictionary*)data);
            }else{
                callback(NO,@"暂无词汇");
            }
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        callback(NO,error.localizedDescription);
    }];
}


-(void)bindingWithMark:(NSString *)mark value:(NSString *)value type:(NSString *)type name:(NSString *)name callback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_Binding,[SingleTon getInstance].authTocken];
    NSDictionary *dic = @{
                          @"user_token":[[SingleTon getInstance] getUser_tocken],
                          @"mark":mark,
                          @"value":value,
                          @"type":type,
                          @"name":name
                          };
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue]==0) {
            
            callback(YES,responseObject[@"errorMsg"]);
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}


-(void)validateVerifyCodeWithMobile:(NSString *)mobile sms_code:(NSString *)sms_code callback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_validateVerifyCode,[SingleTon getInstance].authTocken];
    NSDictionary *dic = @{
                          @"mobile":mobile,
                          @"sms_code":sms_code
                          };
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue]==0) {
            callback(YES,responseObject[@"errorMsg"]);
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}


-(void)getPlanListWithCallback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_GetPlanList,[SingleTon getInstance].authTocken];
    NSDictionary *dic = @{
                          @"user_token":[[SingleTon getInstance] getUser_tocken]
                          };
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue]==0) {
            NSArray *data = responseObject[@"data"];
            NSMutableArray *mutableArray = [NSMutableArray array];
            for (NSDictionary *dic in data) {
                LBookModel *book = [LBookModel new];
                [book setValuesForKeysWithDictionary:dic];
                [mutableArray addObject:book];
            }
            callback(YES,mutableArray);
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}

-(void)getAllBookListWithCallback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_GetAllBook,[SingleTon getInstance].authTocken];
    NSDictionary *dic = @{
                          @"user_token":[[SingleTon getInstance] getUser_tocken]
                          };
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue]==0) {
            NSArray *data = responseObject[@"data"];
            NSMutableArray *mutableArray = [NSMutableArray array];
            for (NSDictionary *dic in data) {
                LBookModel *book = [LBookModel new];
                [book setValuesForKeysWithDictionary:dic];
                [mutableArray addObject:book];
            }
            callback(YES,mutableArray);
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}


-(void)addWordBookWithbid:(NSString *)bid callback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_AddWordbook,[SingleTon getInstance].authTocken];
    NSDictionary *dic = @{
                          @"user_token":[[SingleTon getInstance] getUser_tocken],
                          @"bid":bid
                          };
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue]==0) {
            callback(YES,responseObject[@"errorMsg"]);
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}


-(void)StudyTargetWithbid:(NSString *)bid callback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_StudyTarget,[SingleTon getInstance].authTocken];
    NSDictionary *dic = @{
                          @"user_token":[[SingleTon getInstance] getUser_tocken],
                          @"bid":bid
                          };
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue]==0) {
            NSArray *data = responseObject[@"data"];
            NSMutableArray *mutableArray = [NSMutableArray array];
            for (NSDictionary *dic in data) {
                LTargetModel *target = [LTargetModel new];
                [target setValuesForKeysWithDictionary:dic];
                [mutableArray addObject:target];
            }
            callback(YES,mutableArray);
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}

-(void)studyTargetActionWithBid:(NSString *)bid level:(NSString *)level callback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_StudyTargetAction,[SingleTon getInstance].authTocken];
    NSDictionary *dic = @{
                          @"user_token":[[SingleTon getInstance] getUser_tocken],
                          @"bid":bid,
                          @"level":level
                          };
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue]==0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpDataBookList" object:nil];
            callback(YES,responseObject[@"errorMsg"]);
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}

-(void)updStudyTargetActionWithBid:(NSString *)bid status:(NSString *)status callback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_UpdStudyTargetAction,[SingleTon getInstance].authTocken];
    NSDictionary *dic = @{
                          @"user_token":[[SingleTon getInstance] getUser_tocken],
                          @"bid":bid,
                          @"status":status
                          };
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue]==0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpDataBookList" object:nil];
            callback(YES,responseObject[@"errorMsg"]);
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}


-(void)delUserWordbookWithBid:(NSString *)bid callback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_DelUserWordbook,[SingleTon getInstance].authTocken];
    NSDictionary *dic = @{
                          @"user_token":[[SingleTon getInstance] getUser_tocken],
                          @"bid":bid
                          };
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue]==0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpDataBookList" object:nil];
            callback(YES,responseObject[@"errorMsg"]);
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}

-(void)getStudyToolWithCallback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_GetStudyTool,[SingleTon getInstance].authTocken];
    [manager POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue]==0) {
            NSArray *data = responseObject[@"data"];
            NSMutableArray *mutableArray = [NSMutableArray array];
            for (NSDictionary *dic in data) {
                LStudyToolModel *studyTool = [LStudyToolModel new];
                [studyTool setValuesForKeysWithDictionary:dic];
                [mutableArray addObject:studyTool];
            }
            callback(YES,mutableArray);
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}

-(void)wordStrangeListWithtype:(NSString *)type Callback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_WordStrangeList,[SingleTon getInstance].authTocken];
    NSDictionary *dic = @{
                          @"user_token":[[SingleTon getInstance] getUser_tocken],
                          @"type":type
                          };
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue]==0) {
            NSArray *data = responseObject[@"data"];
            NSMutableArray *mutableArray = [NSMutableArray array];
            for (NSString *str in data) {
                LStrangeWordModel *strangeWord = [LStrangeWordModel new];
                strangeWord.title = str;
                [mutableArray addObject:strangeWord];
            }
            callback(YES,mutableArray);
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}

-(void)wordStrangeActionWithWid:(NSString *)wid type:(NSString *)type callback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_WordStrangeAction,[SingleTon getInstance].authTocken];
    NSDictionary *dic = @{
                          @"user_token":[[SingleTon getInstance] getUser_tocken],
                          @"wid":wid,
                          @"type":type
                          };
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue]==0) {
            callback(YES,responseObject[@"errorMsg"]);
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}


-(void)rankingListWithCity:(NSString *)city callback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_RankingList,[SingleTon getInstance].authTocken];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if ([[SingleTon getInstance] getUser_tocken] && [[SingleTon getInstance] getUser_tocken].length>0) {
        dic[@"user_token"] = [[SingleTon getInstance] getUser_tocken];
    }
    
    if (city&&city.length>0) {
        dic[@"city"] = city;
    }
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue]==0) {
            LRankingModel *my = nil;
            if (responseObject[@"data"][@"my"]) {
                my = [[LRankingModel alloc] init];
                [my setValuesForKeysWithDictionary:responseObject[@"data"][@"my"]];
            }
            
            NSArray *all = responseObject[@"data"][@"all"];
            NSMutableArray *mutableArray = [NSMutableArray array];
            for (NSDictionary *dic in all) {
                LRankingModel *ranking = [LRankingModel new];
                [ranking setValuesForKeysWithDictionary:dic];
                [mutableArray addObject:ranking];
            }
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            if (my) {
                dic[@"my"] = my;
            }
            dic[@"all"] = mutableArray;
            callback(YES,dic);
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}


-(void)getUserMedalWithCallback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_GetUserMedal,[SingleTon getInstance].authTocken];
    NSDictionary *dic = @{
                          @"user_token":[[SingleTon getInstance] getUser_tocken]
                          };
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue]==0) {
            NSDictionary *my_medal = responseObject[@"data"][@"my_medal"];
            NSArray *medal_list = responseObject[@"data"][@"medal_list"];
            NSMutableArray *mutablearray = [NSMutableArray array];
            for (NSDictionary *dic in medal_list) {
                LMedalModel *medal = [LMedalModel new];
                [medal setValuesForKeysWithDictionary:dic];
                [mutablearray addObject:medal];
            }
            callback(YES,@{
                           @"my_medal":my_medal,
                           @"medal_list":mutablearray
                           });
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}


-(void)subjectWrongListWithCallback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_SubjectWrongList,[SingleTon getInstance].authTocken];
    NSDictionary *dic = @{
                          @"user_token":[[SingleTon getInstance] getUser_tocken]
                          };
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue]==0) {
            if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
                callback(YES,@{});
            }else{
                NSDictionary *data = responseObject[@"data"];
                NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
                for (NSString *key in data.allKeys) {
                    NSArray *array = [data valueForKey:key];
                    NSMutableArray *mutableArray = [NSMutableArray array];
                    for (NSDictionary *dic in array) {
                        LSubjectWrongModel *subject = [LSubjectWrongModel new];
                        [subject setValuesForKeysWithDictionary:dic];
                        [mutableArray addObject:subject];
                    }
                    [mutableDic setValue:mutableArray forKey:key];
                }
                callback(YES,mutableDic);
            }
            
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}


-(void)delSubjectWrongWithID:(NSString *)ID callback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_DelSubjectWrong,[SingleTon getInstance].authTocken];
    NSDictionary *dic = @{
                          @"user_token":[[SingleTon getInstance] getUser_tocken],
                          @"id":ID
                          };
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue] == 0) {
            callback(YES,responseObject[@"errorMsg"]);
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}

-(void)fiftytonesIndexWithCallback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_FiftytonesIndex,[SingleTon getInstance].authTocken];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if ([[SingleTon getInstance] getUser_tocken]&&[[SingleTon getInstance]getUser_tocken].length>0) {
        dic[@"user_token"] = [[SingleTon getInstance] getUser_tocken];
    }

    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue] == 0) {
            callback(YES,responseObject[@"data"]);
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}

-(void)get_clauseWithType:(NSString *)type callback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_Get_clause,[SingleTon getInstance].authTocken];
    NSDictionary *dic = @{
                          @"type":type
                          };
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue] == 0) {
            callback(YES,responseObject[@"data"][@"content"]);
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}

-(void)fiftytonesDetailsWithType:(NSString *)type row:(NSString *)row callback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_FiftytonesDetails,[SingleTon getInstance].authTocken];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"type"] = type;
    dic[@"row"] = row;
    if ([[SingleTon getInstance] getUser_tocken]&&[[SingleTon getInstance]getUser_tocken].length>0) {
        dic[@"user_token"] = [[SingleTon getInstance] getUser_tocken];
    }

    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue] == 0) {
            NSArray *data = responseObject[@"data"];
            NSMutableArray *mutableArray = [NSMutableArray array];
            for (NSDictionary *dic in data) {
                LFiftytonesModel *model = [LFiftytonesModel new];
                [model setValuesForKeysWithDictionary:dic];
                [mutableArray addObject:model];
            }
            callback(YES,mutableArray);
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}


-(void)wordStrangeAddWithWid:(NSString *)wid callback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_WordStrangeAdd,[SingleTon getInstance].authTocken];
    NSDictionary *dic = @{
                          @"user_token":[[SingleTon getInstance] getUser_tocken],
                          @"wid":wid
                          };
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue] == 0) {
            callback(YES,responseObject[@"errorMsg"]);
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}

-(void)getWordListWithJa_word:(NSString *)ja_word page:(NSString *)page callback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_Get_WordList,[SingleTon getInstance].authTocken];
    NSDictionary *dic = @{
                          @"ja_word":ja_word,
                          @"page":page
                          };
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue] == 0) {
            NSArray *data = responseObject[@"data"];
            NSMutableArray *mutableArray = [NSMutableArray array];
            for (NSDictionary *dic in data) {
                LWordModel *word = [[LWordModel alloc] init];
                [word setValuesForKeysWithDictionary:dic];
                [mutableArray addObject:word];
            }
            callback(YES,mutableArray);
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}

-(void)getWBUserWithAccess_token:(NSString *)access_token uid:(NSString *)uid callback:(void (^)(BOOL, id _Nonnull))callback{
    NSDictionary *dic = @{
                          @"access_token":access_token,
                          @"uid":uid
                          };
    [manager GET:@"https://api.weibo.com/2/users/show.json" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        callback(YES,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}



-(void)getStartPageWithCallback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_StarPage,[SingleTon getInstance].authTocken];
    [manager POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue] == 0) {
            callback(YES,responseObject[@"data"]);
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}

-(void)receiveActionWithCid:(NSString *)cid title:(NSString *)title type:(NSString *)type callback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_ReceiveAction,[SingleTon getInstance].authTocken];
//    NSDictionary *dic= @{
//        @"user_token":[[SingleTon getInstance] getUser_tocken],
//        @"cid":cid,
//        @"ctitle":title
//    };
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"user_token"] = [[SingleTon getInstance] getUser_tocken];
    if (cid) {
        dic[@"cid"] = cid;
    }
    if (title) {
        dic[@"ctitle"] = title;
    }
    if (type) {
        dic[@"type"] = type;
    }
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue] == 0) {
            if ([responseObject[@"data"][@"status"] intValue]==1) {
                callback(YES,responseObject[@"errorMsg"]);
            }else{
                callback(NO,responseObject[@"errorMsg"]);
            }
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}


-(void)getCSUrlWithCallback:(void (^)(BOOL, id _Nonnull))callback{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_CSUrl,[SingleTon getInstance].authTocken];
    [manager POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue] == 0) {
            callback(YES,responseObject[@"data"][@"url"]);
        }else{
            callback(NO,responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO,error.localizedDescription);
    }];
}

-(void)addIDFA{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_Idfa_checkAdmove,[SingleTon getInstance].authTocken];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"platform"] = @"ios";
    dic[@"uuid"] = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue] == 0) {
            NSLog(@"idfa添加成功");
        }else{
            NSLog(@"idfa添加失败:%@",responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"idfa添加失败:%@",error.localizedDescription);
    }];
}

-(void)gkJapanWithSource:(NSString *)source{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"status"] = @(10);
    dic[@"source"] = source;
    if ([[SingleTon getInstance] getUser_tocken]) {
        dic[@"user_token"] = [[SingleTon getInstance] getUser_tocken];
    }
    NSLog(@"开屏页数据:%@",dic);
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",API_GK_Japan,[SingleTon getInstance].authTocken];
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"returnCode"] intValue] == 0) {
            NSLog(@"开屏页数据记录成功");
        }else{
            NSLog(@"开屏页数据记录失败:%@",responseObject[@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"开屏页数据记录失败:%@",error.localizedDescription);
    }];
}
@end
