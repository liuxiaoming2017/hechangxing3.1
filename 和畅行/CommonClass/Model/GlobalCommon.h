//
//  GlobalCommon.h
//  Voicediagno
//
//  Created by 刘晓明 on 2018/5/9.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalCommon : NSObject

+ (void)showMessage:(NSString *)message duration:(NSTimeInterval)time;

+ (void)showMessage2:(NSString *)message duration2:(NSTimeInterval)time;

+(NSString *)getSubjectSnFrom:(NSString *)subjectName;

+(NSString*) Createfilepath;

+ (NSString*)createYueYaoZhiFufilepath;

+(NSString *)getSportTypeFrom:(NSString *)nameStr;

+(NSString *)getSportNameWithIndex:(NSInteger)index;

//颜色转图片
+ (UIImage*)createImageWithColor: (UIColor*) color;

+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

+ (void)insertSublayerWithView:(UIView *)mainView withImageView:(UIImageView *)imageV;

+(NSString *)getRemindTRypeWithStr:(NSString *)typeStr;

+ (void)showMBHudWithView:(UIView *)view;
+ (void)hideMBHudWithView:(UIView *)view;

+ (void)showMBHudTitleWithView:(UIView *)view;
+ (void)hideMBHudTitleWithView:(UIView *)view;

+ (void)showMBHudWithTitle:(NSString *)title;
+ (void)hideMBHud;

+(UIImage *)columnBarImage;

+ (BOOL)isManyMember;

+ (NSString *)md5:(NSString *)str;
+(NSString*)getCurrentTimes;

//+ (NSString *)md5Points:(NSString *)str;

+ (BOOL)stringEqualNull:(NSString *)str;

+(NSString *)getStringWithSubjectSn:(NSString *)nameStr;

+(NSString *)getStringWithLanguageSubjectSn:(NSString *)nameStr;

+(NSString *)getNowTimeTimestamp;

+ (void)addMaskView;

+ (void)removeMaskView;



//获取网路链接方式
+(NSString *)internetStatus;

+ (NSString *)AESEncodeWithString:(NSString *)str;
+ (NSString *)AESDecodeWithString:(NSString *)str;

+ (NSString *)commandFromName:(NSString *)str;

//页面使用时间
+(void)pageDurationWithpageId:(NSString *)pageIdStr  withstartTime:(NSString *)startTime  withendTime:(NSString *)endTime;

+ (void)removeCache:(NSString *)path;
+ (float)sizeAtPath:(NSString *)path;

+ (void)networkStatusChange;
@end
