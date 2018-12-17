//
//  Tools.h
//  Hechangyi
//
//  Created by Mymac on 15/9/17.
//  Copyright (c) 2015年 ZhangYunguang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject



+(UIColor *) colorWithHexString: (NSString *) hexString;

+ (UILabel *)creatLabelWithFrame:(CGRect)frame text:(NSString *)text textSize:(CGFloat)size;
//创建button可以创建 标题按钮和 图片按钮
+ (UIButton *)creatButtonWithFrame:(CGRect)frame
                            target:(id)target
                               sel:(SEL)sel
                               tag:(NSInteger)tag
                             image:(NSString *)name
                             title:(NSString *)title;
//创建UIImageView
+ (UIImageView *)creatImageViewWithFrame:(CGRect)frame
                               imageName:(NSString *)name;
//创建UITextField
+ (UITextField *)creatTextFieldWithFrame:(CGRect)frame
                             placeHolder:(NSString *)string
                                delegate:(id <UITextFieldDelegate>)delegate
                                     tag:(NSInteger)tag;


+(UILabel *)labelWith:(NSString *)title frame:(CGRect) frame textSize:(CGFloat)size textColor:(UIColor *)color lines:(NSInteger)lines aligment:(NSTextAlignment)aligment;

+(UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title nomalImage:(NSString *)nomalImageName selectedImage:(NSString *)selectedImageName textSize:(CGFloat)size nomalColor:(UIColor *)nomalcolor selectedCocor:(UIColor *)selectedColor tag:(NSInteger)tag target:(id)target sel:(SEL)sel;
//时间字符串
+(NSString *)timeYMDStringFrom:(double )time;
+(NSString *)timeHMStringFrom:(double )time;
+(NSString *)timeMDStingFrom:(double )time;

//将data转化成十六进制的string
+(NSString *) getStringByteWith:(NSData *) data;
//将data转化成字符串
+(NSString *)textFromData:(NSData *)data;
+(NSData *)getDataWith:(NSData *)data;

+(NSString *)time_dateToString:(NSDate *)date;

+ (CGFloat)textHeightFromTextString:(NSString *)text width:(CGFloat)textWidth fontSize:(CGFloat)size;

+(NSString *)stringFromArr:(NSMutableArray *)arr;


@end
