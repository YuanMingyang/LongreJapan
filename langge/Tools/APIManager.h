//
//  APIManager.h
//  langge
//
//  Created by samlee on 2019/3/25.
//  Copyright © 2019 yang. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface APIManager : NSObject
+(instancetype)getInstance;

/** POST JWT授权 */
-(void)getAuthWith:(void(^)(BOOL success,id resule))callback;

/** 获取手机验证码 */
-(void)getMobileAuthWithMobile:(NSString *)mobile callback:(void(^)(BOOL success,id resule))callback;

/** 获取微信tocken */
-(void)getWXAccessTokenWithCode:(NSString *)code callback:(void(^)(BOOL success,id resule))callback;

/** 获取微信信息 */
-(void)getWXUserinfoWithToken:(NSString *)token openID:(NSString *)openID callback:(void(^)(BOOL success,id result))callback;

/** 获取QQ信息 */
-(void)getQQUserInfoWithAccess_token:(NSString *)access_token openid:(NSString *)openid oauth_consumer_key:(NSString *)oauth_consumer_key callback:(void(^)(BOOL success,id result))callback;

/** 短信登录&注册 */
-(void)CustomerLoginWithMobile:(NSString *)mobile sms_code:(NSString *)sms_code open_id:(NSString *)open_id  open_name:(NSString *)open_name type_open:(NSString *)type_open callback:(void(^)(BOOL success,id result))callback;

/** 账号密码登录 */
-(void)simpleLoginWithUserAccount:(NSString *)userAccount userPass:(NSString *)userPass callback:(void(^)(BOOL success,id result))callback;

/** 完善用户信息 */
-(void)saveUserInfoWithParam:(NSMutableDictionary *)dic callback:(void(^)(BOOL success,id result))callback;

/** 获取用户信息 */
-(void)getUserInfoWithCallback:(void(^)(BOOL success,id result))callback;

/** 重置密码 */
-(void)restUserPasswordWithMobile:(NSString *)mobile userPassword:(NSString *)userPassword callback:(void(^)(BOOL success,id result))callback;

/** banner/精选课程/新闻 */
-(void)getfxDataWithPage:(NSString *)page callback:(void(^)(BOOL success,id result))callback;

/** 获取新闻详情 */
-(void)getNewsInfoWith:(NSString *)newsId callback:(void(^)(BOOL success,id result))callback;

/**收藏、取消收藏*/
-(void)collectionActiveWithType:(NSString *)type cid:(NSString *)cid callback:(void(^)(BOOL success,id result))callback;

/** 发现页搜索  type:1 新闻  2课程 */
-(void)fxSearchWithType:(NSString *)type page:(NSString *)page title:(NSString *)title callback:(void(^)(BOOL success,id result))callback;

/** 获取课程详情 */
-(void)getCourseInfoWithcourseId:(NSString *)courseId class_hour_page:(NSString *)class_hour_page comment_page:(NSString *)comment_page callback:(void(^)(BOOL success,id result))callback;

/** 获取当月签到列表 */
-(void)getSignListWith:(NSString *)date callback:(void(^)(BOOL success,id result))callback;

/** 用户签到 */
-(void)signActiveWithCallback:(void(^)(BOOL success,id result))callback;

/** 获奖列表 */
-(void)drawListWithCallback:(void(^)(BOOL success,id result))callback;

/** 奖品详情 */
-(void)prize_detailsWithBid:(NSString *)bid callback:(void(^)(BOOL success,id result))callback;

/** 用户导航栏情报标签(包括全部标签) */
-(void)getUserNewClassListWithCallback:(void(^)(BOOL success,id result))callback;

/** 用户自定义感兴趣新闻标签 */
-(void)userNewsclassActiveWith:(NSString *)json_all callback:(void(^)(BOOL success,id result))callback;

/** 新闻列表 */
-(void)getNewListWith:(NSString *)cid page:(NSString *)page callback:(void(^)(BOOL success,id result))callback;

/** 课程列表 */
-(void)getCourseListWith:(NSString *)title order_field:(NSString *)order_field order_value:(NSString *)order_value page:(NSString *)page callback:(void(^)(BOOL success,id result))callback;

/** 更新u用户奖品状态 */
-(void)SaveUserPrizeWithPid:(NSString *)pid callback:(void(^)(BOOL success,id result))callback;

/** 大家都在搜 */
-(void)getHotSearchWithCallback:(void(^)(BOOL success,id result))callback;

/** 获取app下载地址 */
-(void)getQRCodeWithCallback:(void(^)(BOOL success,id result))callback;

/** 用户吐槽 */
-(void)feedbackActiveWithUser_suggest:(NSString *)user_suggest phone:(NSString *)phone imgArr:(NSMutableArray *)imgArr callback:(void(^)(BOOL success,id result))callback;

/** 收藏列表 */
-(void)getCollectionListWithType:(NSString *)type page:(NSString *)page callback:(void(^)(BOOL success,id result))callback;

/** 吐槽列表 */
-(void)getFeedbackListWithCallback:(void(^)(BOOL success,id result))callback;


/**吐槽详情*/
-(void)getFeedbackInfoWithBackID:(NSString *)backId callback:(void(^)(BOOL success,id result))callback;

/** 系统消息列表 */
-(void)getMessageListWithCallback:(void(^)(BOOL success,id result))callback;

/** 系统消息详情 */
-(void)getMessageDetailWithMid:(NSString *)mid callback:(void(^)(BOOL success,id result))callback;

/** 搜单词 */
-(void)getWordDataWithJa_word:(NSString *)ja_word callback:(void(^)(BOOL success,id result))callback;

/** 账号绑定、解绑 */
-(void)bindingWithMark:(NSString *)mark value:(NSString *)value type:(NSString *)type name:(NSString *)name callback:(void(^)(BOOL success,id result))callback;

/** 验证手机验证码 */
-(void)validateVerifyCodeWithMobile:(NSString *)mobile sms_code:(NSString *)sms_code callback:(void(^)(BOOL success,id result))callback;


/** 用户词书列表 */
-(void)getPlanListWithCallback:(void(^)(BOOL success,id result))callback;

/** 词书列表 */
-(void)getAllBookListWithCallback:(void(^)(BOOL success,id result))callback;

/** 添加词书 */
-(void)addWordBookWithbid:(NSString *)bid callback:(void(^)(BOOL success,id result))callback;

/** 词书学习目标 */
-(void)StudyTargetWithbid:(NSString *)bid callback:(void(^)(BOOL success,id result))callback;

/** 设置词书学习m计划 */
-(void)studyTargetActionWithBid:(NSString *)bid level:(NSString *)level callback:(void(^)(BOOL success,id result))callback;

/** 开启、关闭学习计划 */
-(void)updStudyTargetActionWithBid:(NSString *)bid status:(NSString *)status callback:(void(^)(BOOL success,id result))callback;

/** 删除用户词书 */
-(void)delUserWordbookWithBid:(NSString *)bid callback:(void(^)(BOOL success,id result))callback;

/** 学习工具列表 */
-(void)getStudyToolWithCallback:(void(^)(BOOL success,id result))callback;

/** 生词列表 */
-(void)wordStrangeListWithtype:(NSString *)type Callback:(void(^)(BOOL success,id result))callback;

/** 生词操作 */
-(void)wordStrangeActionWithWid:(NSString *)wid type:(NSString *)type callback:(void(^)(BOOL success,id result))callback;

/** 大神排行榜 */
-(void)rankingListWithCity:(NSString *)city callback:(void(^)(BOOL success,id result))callback;

/** 勋章 */
-(void)getUserMedalWithCallback:(void(^)(BOOL success,id result))callback;

/** 错题集 */
-(void)subjectWrongListWithCallback:(void(^)(BOOL success,id result))callback;

/** 错题集删除 */
-(void)delSubjectWrongWithID:(NSString *)ID callback:(void(^)(BOOL success,id result))callback;


/** 五十音页接口 */
-(void)fiftytonesIndexWithCallback:(void(^)(BOOL success,id result))callback;

/** 用户协议和隐私条款 */
-(void)get_clauseWithType:(NSString *)type callback:(void(^)(BOOL success,id result))callback;

/** 五十音学习接口 */
-(void)fiftytonesDetailsWithType:(NSString *)type row:(NSString *)row callback:(void(^)(BOOL success,id result))callback;

/** 生词i添加 */
-(void)wordStrangeAddWithWid:(NSString *)wid callback:(void(^)(BOOL success,id result))callback;

/** 单词模糊查询 */
-(void)getWordListWithJa_word:(NSString *)ja_word page:(NSString *)page callback:(void(^)(BOOL success,id result))callback;

/** 获取微博信息 */
-(void)getWBUserWithAccess_token:(NSString *)access_token uid:(NSString *)uid callback:(void(^)(BOOL success,id data))callback;

/**获取开屏页*/
-(void)getStartPageWithCallback:(void(^)(BOOL success,id data))callback;

/**领取课程 */
-(void)receiveActionWithCid:(NSString *)cid title:(NSString *)title type:(NSString *)type callback:(void(^)(BOOL success,id data))callback;

/*客服地址**/
-(void)getCSUrlWithCallback:(void(^)(BOOL success,id data))callback;

/**添加idfa*/
-(void)addIDFA;

/**新增点击开屏页数据记录*/
-(void)gkJapanWithSource:(NSString *)source;
@end

NS_ASSUME_NONNULL_END

