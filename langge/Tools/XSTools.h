//
//  XSTools.h
//  langge
//
//  Created by samlee on 2019/3/21.
//  Copyright © 2019 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XSTools : NSObject
/** 验证手机号 */
+(BOOL)checkMobileWith:(NSString *)mobile;

/** 验证邮箱 */
+(BOOL)checkEmailWith:(NSString *)email;

/** 获取AttributedString */
+(NSAttributedString *)getAttributeWith:(id)sender
                                 string:(NSString *)string
                              orginFont:(CGFloat)orginFont
                             orginColor:(UIColor *)orginColor
                          attributeFont:(CGFloat)attributeFont
                         attributeColor:(UIColor *)attributeColor;
/** 获取range */
+(NSString *)getStringWithRange:(NSRange)range;

/** json转字典 */
+(NSDictionary *)jsonStrToDictionaryWith:(NSString *)jsonStr;

/** json转数组 */
+ (NSArray *)jsonStrToArrayWith:(NSString *)jsonStr;

/** 获取拼音首字母 */
+(NSString *)FirstCharactor:(NSString *)pString;

/** 根据字符串获取字体尺寸 */
+(CGSize)getStringSizeWithFont:(NSInteger)font string:(NSString *)string;

/** 获取当前时间 */
+(NSString *)getCurrentDateStr;

/** 时间戳转时间字符串 */
+ (NSString *)time_timestampToString:(NSString *)timestamp;

/** date转时间字符串 */
+(NSString *)getDateStringWith:(NSDate *)date;

/** 获取周几 */
+ (NSString *)getweekDayStringWithDate:(NSDate *)date;

/** 时间字符串转date */
+(NSDate *)getDateWithDateString:(NSString *)dateStr;

/** 获取view上的视图 */
+(UIImage *)screenShotView:(UIView *)view;

/** 对象转json */
+ (NSString *)dataTOjsonString:(id)object;

/** 图片转base64 */
+(NSString *)imageToBase64With:(UIImage *)image;

/** base64转图片 */
+(UIImage *)base64ToImageWith:(NSString *)base64;

/** 获得渐变色的layer */
+(CAGradientLayer *)getColorLayerWithStartColor:(UIColor *)color endColor:(UIColor *)endColor frame:(CGRect)frame;

/** 获取设备名字 */
+(NSString *)getDeviceName;

/** 压缩图片到3k */
+(NSData *)dataWithImage:(UIImage*)image;

/** md5加密 */
+(NSString *)getMd5Str:(NSString *)str;
@end

NS_ASSUME_NONNULL_END
