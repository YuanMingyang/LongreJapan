//
//  LUserModel.h
//  langge
//
//  Created by samlee on 2019/4/10.
//  Copyright © 2019 yang. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LUserModel : JSONModel
@property(nonatomic,strong)NSString <Optional>*acc_id;
@property(nonatomic,strong)NSString <Optional>*user_token;
@property(nonatomic,strong)NSString <Optional>*nick_name;
@property(nonatomic,strong)NSString <Optional>*user_img_src;
@property(nonatomic,strong)NSString <Optional>*user_sex;
@property(nonatomic,strong)NSString <Optional>*city;
@property(nonatomic,strong)NSString <Optional>*occupation;
@property(nonatomic,strong)NSString <Optional>*target_score;
@property(nonatomic,strong)NSString <Optional>*register_time;
@property(nonatomic,strong)NSString <Optional>*user_account;
@property(nonatomic,strong)NSString <Optional>*user_mobile;
@property(nonatomic,strong)NSString <Optional>*user_email;
@property(nonatomic,strong)NSString <Optional>*user_age;
@property(nonatomic,strong)NSString <Optional>*weixin_open_id;
@property(nonatomic,strong)NSString <Optional>*weixin_open_name;
@property(nonatomic,strong)NSString <Optional>*qq_open_id;
@property(nonatomic,strong)NSString <Optional>*qq_open_name;
@property(nonatomic,strong)NSString <Optional>*sina_open_id;
@property(nonatomic,strong)NSString <Optional>*sina_open_name;
@property(nonatomic,strong)NSString <Optional>*is_auto_play;
@property(nonatomic,strong)NSString <Optional>*auto_play_frequency;
@property(nonatomic,strong)NSString <Optional>*is_receive_msg;
@property(nonatomic,strong)NSDictionary <Optional>*user_medal;
@property(nonatomic,strong)NSString <Optional>*feedback_number;
@property(nonatomic,strong)NSArray <Optional> *tools_list;

@end

NS_ASSUME_NONNULL_END
