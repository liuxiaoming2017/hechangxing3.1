//
//  Tools.m
//  Hechangyi
//
//  Created by Mymac on 15/9/17.
//  Copyright (c) 2015年 ZhangYunguang. All rights reserved.
//

#import "Tools.h"

@implementation Tools

/**
 *  颜色值转换
 *
 *  @param hexString hexString description
 *
 *  @return return value description
 */
+(UIColor *) colorWithHexString: (NSString *) hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
        default:
            [NSException raise:@"Invalid color value" format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
            break;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}


+ (UILabel *)creatLabelWithFrame:(CGRect)frame text:(NSString *)text textSize:(CGFloat)size{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.font = [UIFont systemFontOfSize:size];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:15];
    return label;
}

+ (UIButton *)creatButtonWithFrame:(CGRect)frame target:(id)target sel:(SEL)sel tag:(NSInteger)tag image:(NSString *)name title:(NSString *)title{
    UIButton *button = nil;
    if (name) {
        //创建图片按钮
        //创建背景图片 按钮
        //button = [UIButton buttonWithType:UIButtonTypeCustom];
        button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [button setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
        if (title) {//图片标题按钮
            [button setTitle:title forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
        }
        
    }else if (title) {
        //创建标题按钮
        button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        //button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:title forState:UIControlStateNormal];
        
    }
    
    button.frame = frame;
    button.tag = tag;
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    return button;
}
+ (UIImageView *)creatImageViewWithFrame:(CGRect)frame imageName:(NSString *)name{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image  = [UIImage imageNamed:name];
    return imageView ;
}
+ (UITextField *)creatTextFieldWithFrame:(CGRect)frame placeHolder:(NSString *)string delegate:(id<UITextFieldDelegate>)delegate tag:(NSInteger)tag{
    
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    //设置风格类型
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.placeholder = string;
    //设置代理
    textField.delegate = delegate;
    //设置tag值
    textField.tag = tag;
    return textField;
    
}




+(UILabel *)labelWith:(NSString *)title frame:(CGRect)frame textSize:(CGFloat)size textColor:(UIColor *)color lines:(NSInteger)lines aligment:(NSTextAlignment)aligment{
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.text = title;
    label.textAlignment = aligment;
    label.font = [UIFont systemFontOfSize:size];
    label.textColor = color;
    label.numberOfLines = lines;
    return label;
}

+(UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title nomalImage:(NSString *)nomalImageName selectedImage:(NSString *)selectedImageName textSize:(CGFloat)size nomalColor:(UIColor *)nomalcolor selectedCocor:(UIColor *)selectedColor tag:(NSInteger)tag target:(id)target sel:(SEL)sel{
    
    UIButton *button = nil;
    if (nomalImageName) {
        //创建图片按钮
        //创建背景图片 按钮
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:nomalImageName] forState:UIControlStateNormal];
        if (title) {//图片标题按钮
            [button setTitle:title forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:nomalImageName] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
        }
        
    }else if (title) {
        //创建标题按钮
        button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:size];
        [button setTitleColor:nomalcolor forState:UIControlStateNormal];
        [button setTitleColor:selectedColor forState:UIControlStateSelected];
        //[button setBackgroundImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateSelected];
        [button setTintColor:[UIColor clearColor]];
    }
    
    button.frame = frame;
    button.tag = tag;
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    return button;
}


//+ (UIImage *)imageWithColor:(UIColor *)color {
//    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextSetFillColorWithColor(context, [color CGColor]);
//    CGContextFillRect(context, rect);
//    
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return image;
//}

//得到时间字符串  --------->>>  注意：传入的时间为mm
+(NSString *)timeYMDStringFrom:(double )time{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [dateFormatter setDateFormat:@"YYYY.MM.dd"];
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:time/1000.0f];
    return  [dateFormatter stringFromDate:timeDate];
}

+(NSString *)timeHMStringFrom:(double )time{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:time/1000.0f];
    return  [dateFormatter stringFromDate:timeDate];
}

+(NSString *)timeMDStingFrom:(double )time{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    //dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [dateFormatter setDateFormat:@"MM月dd日"];
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:time/1000.0f];
    return  [dateFormatter stringFromDate:timeDate];
}

+(NSString *)time_dateToString:(NSDate *)date
{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString* string=[dateFormat stringFromDate:date];
    return string;
}



#pragma mark - 将十六进制转化成十六机制的的字符串
+(NSString *)getStringByteWith:(NSData *)data{
    Byte *bytes = (Byte *)[data bytes];
    NSString *hexStr = @"";
    for(int i=0;i<[data length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}
+(NSData *)getDataWith:(NSData *)data{
    Byte *bytes = (Byte *)[data bytes];
    NSString *hexStr = @"";
    for(int i=0;i<[data length];i++)
    
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
        
        hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
        
        hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    NSData *dataR = [hexStr dataUsingEncoding:NSUTF8StringEncoding];
    return dataR;
}
+(NSString *)textFromData:(NSData *)data
{
    return [[NSString alloc]initWithData:data encoding:NSWindowsCP1252StringEncoding];
}




#pragma mark - 动态计算字符串的高度
+ (CGFloat)textHeightFromTextString:(NSString *)text width:(CGFloat)textWidth fontSize:(CGFloat)size{
    
        //iOS7之后
        /*
         第一个参数: 预设空间 宽度固定  高度预设 一个最大值
         第二个参数: 行间距 如果超出范围是否截断
         第三个参数: 属性字典 可以设置字体大小
         */
        NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:size]};
        CGRect rect = [text boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
        //返回计算出的行高
        return rect.size.height;
        
    
}

+(NSString *)stringFromArr:(NSMutableArray *)arr
{
    NSData *data=[NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    return jsonStr;
}

@end
