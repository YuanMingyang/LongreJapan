//
//  XSTools.m
//  langge
//
//  Created by samlee on 2019/3/21.
//  Copyright © 2019 yang. All rights reserved.
//

#import "XSTools.h"
#import <sys/utsname.h>
#import <CommonCrypto/CommonDigest.h>

@implementation XSTools
+(BOOL)checkMobileWith:(NSString *)mobile{
    NSString *mobileRegex = @"^1+\\d{10}";
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mobileRegex];
    return [pre evaluateWithObject:mobile];
}

+(BOOL)checkEmailWith:(NSString *)email{
    NSString *emailRegex = @"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
    return [pre evaluateWithObject:email];
}
+(NSAttributedString *)getAttributeWith:(id)sender
                                  string:(NSString *)string
                               orginFont:(CGFloat)orginFont
                              orginColor:(UIColor *)orginColor
                           attributeFont:(CGFloat)attributeFont
                          attributeColor:(UIColor *)attributeColor
{
    __block  NSMutableAttributedString *totalStr = [[NSMutableAttributedString alloc] initWithString:string];
    [totalStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:orginFont] range:NSMakeRange(0, string.length)];
    [totalStr addAttribute:NSForegroundColorAttributeName value:orginColor range:NSMakeRange(0, string.length)];
    if ([sender isKindOfClass:[NSArray class]]) {
        __block NSString *oringinStr = string;
        __weak typeof(self) weakSelf = self;
        [sender enumerateObjectsUsingBlock:^(NSString *  _Nonnull str, NSUInteger idx, BOOL * _Nonnull stop) {
            NSRange range = [oringinStr rangeOfString:str];
            [totalStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:attributeFont] range:range];
            [totalStr addAttribute:NSForegroundColorAttributeName value:attributeColor range:range];
            oringinStr = [oringinStr stringByReplacingCharactersInRange:range withString:[weakSelf getStringWithRange:range]];
        }];
    }else if ([sender isKindOfClass:[NSString class]]) {
        NSRange range = [string rangeOfString:sender];
        [totalStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:attributeFont] range:range];
        [totalStr addAttribute:NSForegroundColorAttributeName value:attributeColor range:range];
    }
    return totalStr;
}

+(NSString *)getStringWithRange:(NSRange)range
{
    NSMutableString *string = [NSMutableString string];
    for (int i = 0; i < range.length ; i++) {
        [string appendString:@" "];
    }
    return string;
}
+(NSDictionary *)jsonStrToDictionaryWith:(NSString *)jsonStr{
    if(!jsonStr){
        return nil;
    }

    NSError *error = nil;//NSUnicodeStringEncoding
    NSDictionary *string2dic = [NSJSONSerialization JSONObjectWithData: [jsonStr dataUsingEncoding:NSUTF8StringEncoding]
                                                               options: NSJSONReadingMutableContainers
                                                                 error: &error];
    return string2dic;
}

+ (NSArray *)jsonStrToArrayWith:(NSString *)jsonStr{
    NSError *error = nil;
    if (!jsonStr) {
        return nil;
    }
    NSArray * jsonObject = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
    
}


+(NSString *)FirstCharactor:(NSString *)pString{
    //转成了可变字符串
    NSMutableString *pStr = [NSMutableString stringWithString:pString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)pStr,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)pStr,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *pPinYin = [pStr capitalizedString];
    //获取并返回首字母
    return [pPinYin substringToIndex:1];
}

+(CGSize)getStringSizeWithFont:(NSInteger)font string:(NSString *)string{
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:font],};
    CGSize textSize = [string boundingRectWithSize:CGSizeMake(200, 20) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;;
    return textSize;
}

+(NSString *)getCurrentDateStr{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return [dateFormatter stringFromDate:[NSDate date]];
}


///时间戳转化为字符转0000-00-00 00:00

+(NSString *)time_timestampToString:(NSString *)timestamp{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timestamp integerValue]];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString* string=[dateFormat stringFromDate:confromTimesp];
    return string;
    
}
+(NSDate *)getDateWithDateString:(NSString *)dateStr{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM"];
    NSDate *date = [dateFormat dateFromString:dateStr];
    return date;
}

+(NSString *)getDateStringWith:(NSDate *)date{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM"];
    return [dateFormat stringFromDate:date];
}

+ (NSString *) getweekDayStringWithDate:(NSDate *)date{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 指定日历的算法
    NSDateComponents *comps = [calendar components:NSCalendarUnitWeekday fromDate:date];
    // 1 是周日，2是周一 3.以此类推
    NSNumber * weekNumber = @([comps weekday]);
    NSInteger weekInt = [weekNumber integerValue];
    NSString *weekDayString = @"星期一";
    switch (weekInt) {case 1:
        {weekDayString = @"星期日";}
            break;
        case 2:{weekDayString = @"星期一";}
            break;
        case 3:{weekDayString = @"星期二";}
            break;
        case 4:{weekDayString = @"星期三";}
            break;
        case 5:{weekDayString = @"星期四";}
            break;
        case 6:{weekDayString = @"星期五";}
            break;
        case 7:{weekDayString = @"星期六";}
            break;
        default:break;
            
    }
    return weekDayString;
    
}

+(UIImage *)screenShotView:(UIView *)view{
    UIImage *imageRet = [[UIImage alloc]init];
    UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    imageRet = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageRet;
}


+ (NSString *)dataTOjsonString:(id)object{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted 
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

+(NSString *)imageToBase64With:(UIImage *)image{
    //NSData *imgData = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedImageStr = [[XSTools imageWithImage:image] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encodedImageStr;
}

+(NSData *)imageWithImage:(UIImage*)image{
    CGSize newSize;
    if (image.size.width>image.size.height) {
        newSize = CGSizeMake(1000, 1000*image.size.height/image.size.width);
    }else{
        newSize = CGSizeMake(image.size.width*1000/image.size.height, 1000);
    }
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGFloat compression = 1.0f;
    CGFloat maxCompression = 0.1f;
    NSData *data = UIImageJPEGRepresentation(newImage, compression);
    while ([data length] > 1000*1024 && compression > maxCompression) {
        compression -= 0.1;
        data = UIImageJPEGRepresentation(newImage, compression);
    }
    return data;
}

+(UIImage *)base64ToImageWith:(NSString *)base64{
    if ([base64 isKindOfClass:[NSNull class]]) {
        return nil;
    }
    if (!base64) {
        return nil;
    }
    if ([base64 rangeOfString:@"data:image/png;base64"].location != NSNotFound) {
        base64  = [base64 stringByReplacingOccurrencesOfString:@"data:image/png;base64" withString:@""];
    }
    NSData *decodeData = [[NSData alloc]initWithBase64EncodedString:base64 options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
    // 将NSData转为UIImage
    UIImage *decodedImage = [UIImage imageWithData: decodeData];
    return decodedImage;
}

+(CAGradientLayer *)getColorLayerWithStartColor:(UIColor *)color endColor:(UIColor *)endColor frame:(CGRect)frame{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = frame;
    gradient.colors = @[(id)color.CGColor,(id)endColor.CGColor];
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(1, 1);
    return gradient;
}

+(NSString *)getDeviceName{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *model = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    return [XSTools currentModel:model];
}


+ (NSString *)currentModel:(NSString *)phoneModel {
    if ([phoneModel isEqualToString:@"iPhone1,1"])    return @"Apple#iPhone 1G";
    if ([phoneModel isEqualToString:@"iPhone1,2"])    return @"Apple#iPhone 3G";
    if ([phoneModel isEqualToString:@"iPhone2,1"])    return @"Apple#iPhone 3GS";
    if ([phoneModel isEqualToString:@"iPhone3,1"])    return @"Apple#iPhone 4";
    if ([phoneModel isEqualToString:@"iPhone3,2"])    return @"Apple#iPhone 4 Verizon";
    if ([phoneModel isEqualToString:@"iPhone4,1"])    return @"Apple#iPhone 4S";
    if ([phoneModel isEqualToString:@"iPhone5,2"])    return @"Apple#iPhone 5";
    if ([phoneModel isEqualToString:@"iPhone5,3"])    return @"Apple#iPhone 5c";
    if ([phoneModel isEqualToString:@"iPhone5,4"])    return @"Apple#iPhone 5c";
    if ([phoneModel isEqualToString:@"iPhone6,1"])    return @"Apple#iPhone 5s";
    if ([phoneModel isEqualToString:@"iPhone6,2"])    return @"Apple#iPhone 5s";
    if ([phoneModel isEqualToString:@"iPhone7,1"])    return @"Apple#iPhone 6 Plus";
    if ([phoneModel isEqualToString:@"iPhone7,2"])    return @"Apple#iPhone 6";
    if ([phoneModel isEqualToString:@"iPhone8,1"])    return @"Apple#iPhone 6s";
    if ([phoneModel isEqualToString:@"iPhone8,2"])    return @"Apple#iPhone 6s Plus";
    if ([phoneModel isEqualToString:@"iPhone8,4"])    return @"Apple#iPhone SE";
    if ([phoneModel isEqualToString:@"iPhone9,1"])    return @"Apple#iPhone 7";
    if ([phoneModel isEqualToString:@"iPhone9,2"])    return @"Apple#iPhone 7 Plus";
    if ([phoneModel isEqualToString:@"iPhone9,3"])    return @"Apple#iPhone 7";
    if ([phoneModel isEqualToString:@"iPhone9,4"])    return @"Apple#iPhone 7 Plus";
    if ([phoneModel isEqualToString:@"iPhone10,1"])   return @"Apple#iPhone 8 Global";
    if ([phoneModel isEqualToString:@"iPhone10,2"])   return @"Apple#iPhone 8 Plus Global";
    if ([phoneModel isEqualToString:@"iPhone10,3"])   return @"Apple#iPhone X Global";
    if ([phoneModel isEqualToString:@"iPhone10,4"])   return @"Apple#iPhone 8 GSM";
    if ([phoneModel isEqualToString:@"iPhone10,5"])   return @"Apple#iPhone 8 Plus GSM";
    if ([phoneModel isEqualToString:@"iPhone10,6"])   return @"Apple#iPhone X GSM";
    
    if ([phoneModel isEqualToString:@"iPhone11,2"])   return @"Apple#iPhone XS";
    if ([phoneModel isEqualToString:@"iPhone11,4"])   return @"Apple#iPhone XS Max (China)";
    if ([phoneModel isEqualToString:@"iPhone11,6"])   return @"Apple#iPhone XS Max";
    if ([phoneModel isEqualToString:@"iPhone11,8"])   return @"Apple#iPhone XR";
    
    if ([phoneModel isEqualToString:@"i386"])         return @"Apple#Simulator 32";
    if ([phoneModel isEqualToString:@"x86_64"])       return @"Apple#Simulator 64";
    
    if ([phoneModel isEqualToString:@"iPad1,1"]) return @"iPad";
    if ([phoneModel isEqualToString:@"iPad2,1"] ||
        [phoneModel isEqualToString:@"iPad2,2"] ||
        [phoneModel isEqualToString:@"iPad2,3"] ||
        [phoneModel isEqualToString:@"iPad2,4"]) return @"iPad 2";
    if ([phoneModel isEqualToString:@"iPad3,1"] ||
        [phoneModel isEqualToString:@"iPad3,2"] ||
        [phoneModel isEqualToString:@"iPad3,3"]) return @"iPad 3";
    if ([phoneModel isEqualToString:@"iPad3,4"] ||
        [phoneModel isEqualToString:@"iPad3,5"] ||
        [phoneModel isEqualToString:@"iPad3,6"]) return @"iPad 4";
    if ([phoneModel isEqualToString:@"iPad4,1"] ||
        [phoneModel isEqualToString:@"iPad4,2"] ||
        [phoneModel isEqualToString:@"iPad4,3"]) return @"iPad Air";
    if ([phoneModel isEqualToString:@"iPad5,3"] ||
        [phoneModel isEqualToString:@"iPad5,4"]) return @"iPad Air 2";
    if ([phoneModel isEqualToString:@"iPad6,3"] ||
        [phoneModel isEqualToString:@"iPad6,4"]) return @"iPad Pro 9.7-inch";
    if ([phoneModel isEqualToString:@"iPad6,7"] ||
        [phoneModel isEqualToString:@"iPad6,8"]) return @"iPad Pro 12.9-inch";
    if ([phoneModel isEqualToString:@"iPad6,11"] ||
        [phoneModel isEqualToString:@"iPad6,12"]) return @"iPad 5";
    if ([phoneModel isEqualToString:@"iPad7,1"] ||
        [phoneModel isEqualToString:@"iPad7,2"]) return @"iPad Pro 12.9-inch 2";
    if ([phoneModel isEqualToString:@"iPad7,3"] ||
        [phoneModel isEqualToString:@"iPad7,4"]) return @"iPad Pro 10.5-inch";
    
    if ([phoneModel isEqualToString:@"iPad2,5"] ||
        [phoneModel isEqualToString:@"iPad2,6"] ||
        [phoneModel isEqualToString:@"iPad2,7"]) return @"iPad mini";
    if ([phoneModel isEqualToString:@"iPad4,4"] ||
        [phoneModel isEqualToString:@"iPad4,5"] ||
        [phoneModel isEqualToString:@"iPad4,6"]) return @"iPad mini 2";
    if ([phoneModel isEqualToString:@"iPad4,7"] ||
        [phoneModel isEqualToString:@"iPad4,8"] ||
        [phoneModel isEqualToString:@"iPad4,9"]) return @"iPad mini 3";
    if ([phoneModel isEqualToString:@"iPad5,1"] ||
        [phoneModel isEqualToString:@"iPad5,2"]) return @"iPad mini 4";
    
    if ([phoneModel isEqualToString:@"iPod1,1"]) return @"iTouch";
    if ([phoneModel isEqualToString:@"iPod2,1"]) return @"iTouch2";
    if ([phoneModel isEqualToString:@"iPod3,1"]) return @"iTouch3";
    if ([phoneModel isEqualToString:@"iPod4,1"]) return @"iTouch4";
    if ([phoneModel isEqualToString:@"iPod5,1"]) return @"iTouch5";
    if ([phoneModel isEqualToString:@"iPod7,1"]) return @"iTouch6";
    
#ifdef  DEBUG
    NSLog(@"NOTE: Unknown device type: %@", phoneModel);
#endif
    return [NSString stringWithFormat:@"Apple#%@",phoneModel];
}


+(NSData *)dataWithImage:(UIImage*)image{
    CGSize newSize;
    if (image.size.width>image.size.height) {
        newSize = CGSizeMake(1000, 1000*image.size.height/image.size.width);
    }else{
        newSize = CGSizeMake(image.size.width*1000/image.size.height, 1000);
    }
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGFloat compression = 1.0f;
    CGFloat maxCompression = 0.1f;
    NSData *data = UIImageJPEGRepresentation(newImage, compression);
    while ([data length] > 1000*30 && compression > maxCompression) {
        compression -= 0.1;
        data = UIImageJPEGRepresentation(newImage, compression);
    }
    return data;
}

+(NSString *)getMd5Str:(NSString *)str{
    // 判断传入的字符串是否为空
    if (! str) return nil;
    // 转成utf-8字符串
    const char *cStr = str.UTF8String;
    // 设置一个接收数组
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    // 对密码进行加密
    CC_MD5(cStr, (CC_LONG) strlen(cStr), result);
    NSMutableString *md5Str = [NSMutableString string];
    // 转成32字节的16进制
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i ++) {
        [md5Str appendFormat:@"%02x", result[i]];
    }
    return md5Str;


}
@end
