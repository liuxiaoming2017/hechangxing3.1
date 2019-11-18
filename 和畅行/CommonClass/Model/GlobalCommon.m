//
//  GlobalCommon.m
//  Voicediagno
//
//  Created by 刘晓明 on 2018/5/9.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "GlobalCommon.h"
#import <sys/utsname.h>
#import <CommonCrypto/CommonDigest.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "Reachability.h"
#import "AESCipher.h"
#import <sys/utsname.h>

#import <OGABluetooth530/OGABluetooth530.h>

@interface GlobalCommon()

@property (nonatomic,strong) MBProgressHUD *MBHud;

@end
@implementation GlobalCommon
@synthesize MBHud;

//弹出提示信息，N秒后消失
+ (void)showMessage:(NSString *)message duration:(NSTimeInterval)time
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [GlobalCommon showMessage:message duration:time onView:window];
}

+ (void)showMessage2:(NSString *)message duration2:(NSTimeInterval)time
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [GlobalCommon showMessage2:message duration2:time onView2:window];
}

+ (void)showMessage:(NSString *)message duration:(NSTimeInterval)time onView:(UIView *)view
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *lastView = [window viewWithTag:1111111];
    if(lastView){
        [lastView removeFromSuperview];
    }
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor blackColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 0.9f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    showview.tag = 1111111;
    [view addSubview:showview];
    
    UILabel *label = [[UILabel alloc]init];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                 NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize labelSize = [message boundingRectWithSize:CGSizeMake(ScreenWidth/2, 999)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:attributes context:nil].size;
    
    label.frame = CGRectMake(10, 15, labelSize.width + 20, labelSize.height);
    label.text = message;
    label.numberOfLines = 5;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14];
    [showview addSubview:label];
    
//    showview.frame = CGRectMake((screenSize.width - labelSize.width - 40)/2,
//                                (screenSize.height - labelSize.height - 20)/2,
//                                labelSize.width+40,
//                                labelSize.height+30);
    showview.frame = CGRectMake((screenSize.width - labelSize.width - 40)/2,
                                ScreenHeight-labelSize.height-65-10,
                                labelSize.width+40,
                                labelSize.height+30);
    
    NSLog(@"show:%@",NSStringFromCGRect(showview.frame));
    
    [UIView animateWithDuration:time animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}

+ (void)showMessage2:(NSString *)message duration2:(NSTimeInterval)time onView2:(UIView *)view
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *lastView = [window viewWithTag:1111111];
    if(lastView){
        [lastView removeFromSuperview];
    }
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor blackColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 0.9f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    showview.tag = 1111111;
    [view addSubview:showview];
    
    UILabel *label = [[UILabel alloc]init];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                 NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize labelSize = [message boundingRectWithSize:CGSizeMake(ScreenWidth/2-20, 999)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:attributes context:nil].size;
    
    label.frame = CGRectMake(10, 15, ScreenWidth/2-20, labelSize.height);
    label.text = message;
    label.numberOfLines = 5;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14];
    [showview addSubview:label];
    
    showview.frame = CGRectMake((screenSize.width - ScreenWidth/2)/2,
                                    (screenSize.height - labelSize.height - 20)/2,
                                    ScreenWidth/2,
                                    labelSize.height+30);
//    showview.frame = CGRectMake((screenSize.width - labelSize.width - 40)/2,
//                                ScreenHeight-labelSize.height-65,
//                                labelSize.width+40,
//                                labelSize.height+30);
    
    NSLog(@"show:%@",NSStringFromCGRect(showview.frame));
    
    [UIView animateWithDuration:time animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}

+(NSString *)getStringWithSubjectSn:(NSString *)nameStr
{
    NSArray *arr = [nameStr componentsSeparatedByString:@"-"];
    NSString *returnStr = @"";
    if(arr.count>0){
        NSString *str1 = [arr objectAtIndex:1];
        NSString *firstStr = [str1 substringToIndex:1];
        NSString *lastStr = [str1 substringFromIndex:str1.length-1];
        NSInteger numberIndex = [lastStr integerValue];
        if([firstStr isEqualToString:@"G"]){
            NSArray *arr = @[@"大宫",@"加宫",@"上宫",@"少宫",@"左角宫"];
            returnStr = [arr objectAtIndex:numberIndex-1];
        }else if([firstStr isEqualToString:@"S"]){
            NSArray *arr = @[@"上商",@"少商",@"钛商",@"右商",@"左商"];
            returnStr = [arr objectAtIndex:numberIndex-1];
        }else if([firstStr isEqualToString:@"J"]){
            NSArray *arr = @[@"大角",@"判角",@"上角",@"少角",@"钛角"];
            returnStr = [arr objectAtIndex:numberIndex-1];
        }else if([firstStr isEqualToString:@"Z"]){
            NSArray *arr = @[@"判徵",@"上徵",@"少徵",@"右徵",@"质徵"];
            returnStr = [arr objectAtIndex:numberIndex-1];
        }else if([firstStr isEqualToString:@"Y"]){
            NSArray *arr = @[@"大羽",@"上羽",@"少羽",@"桎羽",@"众羽"];
            returnStr = [arr objectAtIndex:numberIndex-1];
        }
    }
    return returnStr;
}

+(NSString *)getSubjectSnFrom:(NSString *)subjectName{
    if ([subjectName isEqualToString:@"大宫"]) {
        return @"JLBS-G1";
    }else if ([subjectName isEqualToString:@"加宫"]) {
        return @"JLBS-G2";
    }else if ([subjectName isEqualToString:@"上宫"]) {
        return @"JLBS-G3";
    }else if ([subjectName isEqualToString:@"少宫"]) {
        return @"JLBS-G4";
    }else if ([subjectName isEqualToString:@"左角宫"]) {
        return @"JLBS-G5";
    }else if ([subjectName isEqualToString:@"上商"]) {
        return @"JLBS-S1";
    }else if ([subjectName isEqualToString:@"少商"]) {
        return @"JLBS-S2";
    }else if ([subjectName isEqualToString:@"钛商"]) {
        return @"JLBS-S3";
    }else if ([subjectName isEqualToString:@"右商"]) {
        return @"JLBS-S4";
    }else if ([subjectName isEqualToString:@"左商"]) {
        return @"JLBS-S5";
    }else if ([subjectName isEqualToString:@"大角"]) {
        return @"JLBS-J1";
    }else if ([subjectName isEqualToString:@"判角"]) {
        return @"JLBS-J2";
    }else if ([subjectName isEqualToString:@"上角"]) {
        return @"JLBS-J3";
    }else if ([subjectName isEqualToString:@"少角"]) {
        return @"JLBS-J4";
    }else if ([subjectName isEqualToString:@"钛角"]) {
        return @"JLBS-J5";
    }else if ([subjectName isEqualToString:@"判徵"]) {
        return @"JLBS-Z1";
    }else if ([subjectName isEqualToString:@"上徵"]) {
        return @"JLBS-Z2";
    }else if ([subjectName isEqualToString:@"少徵"]) {
        return @"JLBS-Z3";
    }else if ([subjectName isEqualToString:@"右徵"]) {
        return @"JLBS-Z4";
    }else if ([subjectName isEqualToString:@"质徵"]) {
        return @"JLBS-Z5";
    }else if ([subjectName isEqualToString:@"大羽"]) {
        return @"JLBS-Y1";
    }else if ([subjectName isEqualToString:@"上羽"]) {
        return @"JLBS-Y2";
    }else if ([subjectName isEqualToString:@"少羽"]) {
        return @"JLBS-Y3";
    }else if ([subjectName isEqualToString:@"桎羽"]) {
        return @"JLBS-Y4";
    }else if ([subjectName isEqualToString:@"众羽"]) {
        return @"JLBS-Y5";
    }
    return nil;
}

+(NSString *)getSportTypeFrom:(NSString *)subjectName
{
    if ([subjectName isEqualToString:@"大宫"] || [subjectName isEqualToString:@"加宫"] || [subjectName isEqualToString:@"上宫"] || [subjectName isEqualToString:@"少宫"] || [subjectName isEqualToString:@"左角宫"]) {
        //return @"俯身下探加强式";
        return @"6";
    }else if ([subjectName isEqualToString:@"上商"] || [subjectName isEqualToString:@"钛商"] || [subjectName isEqualToString:@"右商"] || [subjectName isEqualToString:@"左商"]) {
        //return @"剑指后仰式";
        return @"2";
    }else if ([subjectName isEqualToString:@"少商"]) {
        //return @"体侧弯腰式";
        return @"5";
    }else if ([subjectName isEqualToString:@"大角"] || [subjectName isEqualToString:@"上角"] || [subjectName isEqualToString:@"少角"] || [subjectName isEqualToString:@"钛角"] || [subjectName isEqualToString:@"判角"]) {
        //return @"体侧弯腰式";
        return @"5";
    }else if ([subjectName isEqualToString:@"判徵"] || [subjectName isEqualToString:@"上徵"] || [subjectName isEqualToString:@"少徵"] || [subjectName isEqualToString:@"右徵"] || [subjectName isEqualToString:@"质徵"]) {
        //return @"左右扭转式";
        return @"4";
    }else if ([subjectName isEqualToString:@"大羽"] || [subjectName isEqualToString:@"上羽"] || [subjectName isEqualToString:@"少羽"] || [subjectName isEqualToString:@"桎羽"] || [subjectName isEqualToString:@"众羽"]) {
        //return @"俯身下探式";
        return @"3";
    }
    return nil;
}

+(NSString *)getSportNameWithIndex:(NSInteger)index
{
    if(index == 1){
        return ModuleZW(@"预备   ");
    }else if(index == 2){
        return ModuleZW(@"第一式");
    }
    else if(index == 3){
        return ModuleZW(@"第二式");
    }else if (index == 4){
        return ModuleZW(@"第三式");
    }else if (index == 5){
        return ModuleZW(@"第四式");
    }else if (index == 6){
        return ModuleZW(@"第五式");
    }else if (index == 7){
        return ModuleZW(@"第六式");
    }else if (index == 8){
        return ModuleZW(@"第七式");
    }else if (index == 9){
        return ModuleZW(@"第八式");
    }
    return ModuleZW(@"全部   ");
}

+(NSString *)getRemindTRypeWithStr:(NSString *)typeStr
{
    if([typeStr isEqualToString:@"yizhan"]){
        return  ModuleZW(@"一站");
    }else if ([typeStr isEqualToString:@"yiting"]){
        return ModuleZW(@"一听");
    }else if ([typeStr isEqualToString:@"yitui"]){
        return ModuleZW(@"一推");
    }else if ([typeStr isEqualToString:@"yishuo"]){
        return ModuleZW(@"一说");
    }else if ([typeStr isEqualToString:@"yixie"]){
        return ModuleZW(@"一写");
    }else if ([typeStr isEqualToString:@"yidian"]){
        return ModuleZW(@"一点");
    }
    return nil;
}

+(NSString*) Createfilepath
{
    NSString *path = [ NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *str = [GlobalCommon userInfoTmp];
    
    NSString *folderPath = [path stringByAppendingPathComponent:str];
    NSLog(@"%@",folderPath);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:folderPath];
    if(!fileExists)
    {
        
        [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    [GlobalCommon addSkipBackupAttributeToItemAtPath:folderPath];
    return folderPath;
}

+ (NSString*)createYueYaoZhiFufilepath
{
    NSString *path = [ NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *str = [NSString stringWithFormat:@"yueyaozhifuTemp/%@/", [MemberUserShance shareOnce].name];
    NSString *folderPath = [path stringByAppendingPathComponent:str];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:folderPath];
    if(!fileExists)
    {
        [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return folderPath;
}

+ (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *) filePathString
{
    NSURL* URL= [NSURL fileURLWithPath: filePathString];
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

+ (NSString *)userInfoTmp{
   // NSMutableDictionary *dic = [UtilityFunc mutableDictionaryFromUserInfo];
    
   
    
    NSString *str = [NSString stringWithFormat:@"tmp/%@/", [MemberUserShance shareOnce].name];
    
    
    return str;
}

+ (UIImage*)createImageWithColor: (UIColor*) color

{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return theImage;
    
}

//对图片尺寸进行压缩--
+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

+ (void)insertSublayerWithView:(UIView *)mainView withImageView:(UIImageView *)imageV
{
    CALayer *subLayer=[CALayer layer];
    CGRect fixframe = imageV.frame;
    subLayer.frame= fixframe;
    subLayer.cornerRadius=8;
    subLayer.backgroundColor=[UIColorFromHex(0xc5c5c5) colorWithAlphaComponent:1.0].CGColor;
    subLayer.masksToBounds=NO;
    subLayer.shadowColor = UIColorFromHex(0xc5c5c5).CGColor;//shadowColor阴影颜色
    subLayer.shadowOffset = CGSizeMake(2,2);//shadowOffset阴影偏移,x向右偏移3，y向下偏移2，默认(0, -3),这个跟shadowRadius配合使用
    subLayer.shadowOpacity = 0.6;//阴影透明度，默认0
    subLayer.shadowRadius = 3;//阴影半径，默认3
    [mainView.layer insertSublayer:subLayer below:imageV.layer];
}

//栏目条背景图
+(UIImage *)columnBarImage{
    
    CGRect rect = CGRectMake(0.0f, 0.0f, ScreenWidth, kNavBarHeight);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (void)showMBHudWithView:(UIView *)view
{
   [MBProgressHUD showHUDAddedTo:view animated:YES];
}

+ (void)hideMBHudWithView:(UIView *)view
{
    [MBProgressHUD hideHUDForView:view animated:YES];
    
}

+ (void)showMBHudTitleWithView:(UIView *)view
{
    
    MBProgressHUD *progress = [[MBProgressHUD alloc] initWithView:view];
    progress.label.text = ModuleZW(@"请稍后");
    progress.tag = 101;
    [view addSubview:progress];
    [view bringSubviewToFront:progress];
    [progress showAnimated:YES];
    
}

+ (void)showMBHudWithTitle:(NSString *)title
{
    
    
    
    MBProgressHUD *progress = [[MBProgressHUD alloc] initWithView:[[UIApplication sharedApplication] keyWindow]];
    progress.label.text = title;
    progress.tag = 102;
    [[[UIApplication sharedApplication] keyWindow] addSubview:progress];
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:progress];
    [progress showAnimated:YES];
}

+ (void)hideMBHud
{
    MBProgressHUD *progress = (MBProgressHUD *)[[[UIApplication sharedApplication] keyWindow] viewWithTag:102];
    [progress removeFromSuperview];
    progress = nil;
}

+ (void)hideMBHudTitleWithView:(UIView *)view
{
    MBProgressHUD *progress = (MBProgressHUD *)[view viewWithTag:101];
    [progress removeFromSuperview];
    progress = nil;
}

+ (BOOL)isManyMember
{
     NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberChirldArr"];
    if(arr.count>1){
        return YES;
    }else{
        return NO;
    }
}

+ (NSString *)md5:(NSString *)str
{
    str = [str stringByAppendingString:@"xinxijishubu"];
    
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (int)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
    
}




//获取当前的时间

+(NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
        NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}

+ (BOOL)stringEqualNull:(NSString *)str
{
    if([str isEqual:[NSNull null]] || str == nil || str.length == 0 || [str isEqualToString:@"(null)"]){
        return YES;
    }else{
        return NO;
    }
}


+(NSString *)getNowTimeTimestamp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    
    return timeSp;
}

+ (void)addMaskView
{
    UIView *maskView = [[UIApplication sharedApplication].keyWindow viewWithTag:111111112];
    if(!maskView){
        UIView *maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        maskView.backgroundColor = [UIColor blackColor];
        maskView.alpha = 0.3;
        maskView.tag = 111111112;
        
        [[UIApplication sharedApplication].keyWindow addSubview:maskView];
    }
}

+ (void)removeMaskView
{
    UIView *maskView = [[UIApplication sharedApplication].keyWindow viewWithTag:111111112];
    if(maskView){
        [maskView removeFromSuperview];
    }
}


//计算年龄
+(NSString *)calculateAgeStr:(NSString *)str{
    //截取身份证的出生日期并转换为日期格式
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy/mm/dd";
    NSDate *birthDate =  [formatter dateFromString:str];
    NSTimeInterval dateDiff = [birthDate timeIntervalSinceNow];
    
    // 计算年龄
    int age  =  trunc(dateDiff/(60*60*24))/365;
    NSString *ageStr = [NSString stringWithFormat:@"%d", -age];
    
    return ageStr;
}



//获取网路链接方式
+(NSString *)internetStatus {
    
    Reachability *reachability   = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    NSString *net = @"WIFI";
    switch (internetStatus) {
        case ReachableViaWiFi:
            net = @"wifi";
            break;
            
        case ReachableViaWWAN:
            net = @"流量";
            //net = [self getNetType ];   //判断具体类型
            break;
            
        case NotReachable:
            net = @"无连接";
            
        default:
            break;
    }
    
    return net;
}


+ (NSString *)AESEncodeWithString:(NSString *)str
{
    // 加密密钥
    NSString *AESKey = @"AESkeyQWEasduigjgk";
    
    NSString *AESEncodeString = [AESCipher encryptAES:str key:AESKey];
    
    return AESEncodeString;
}

+ (NSString *)AESDecodeWithString:(NSString *)str
{
    // 加密密钥
    NSString *AESKey = @"AESkeyQWEasduigjgk";
    
    NSString *AESDecodeString = [AESCipher decryptAES:str key:AESKey];
    
    return AESDecodeString;
}

+ (NSString *)commandFromName:(NSString *)str
{
    NSDictionary *dic = @{
                          @"大师精选":k530Command_MassageMaster,
                          @"轻松自在":k530Command_MassageRelease,
                          @"关节呵护":k530Command_KneeCare,
                          @"脊柱支柱":k530Command_SpinalReleasePressure,
                          @"驾车族":k530Command_Traceller,
                          @"低头族":k530Command_TextNeck,
                          @"御宅派":k530Command_CosyComfort,
                          @"运动派":k530Command_Athlete,
                          @"爱购派":k530Command_Shopping,
                          @"巴黎式":k530Command_Balinese,
                          @"中式":k530Command_MassageChinese,
                          @"泰式":k530Command_MassageThai,
                          @"深层按摩":k530Command_MassageDeepTissue,
                          @"美臀塑型":k530Command_MassageHipsShapping,
                          @"活血循环":k530Command_MassageBloodCirculation,
                          @"元气复苏":k530Command_MassageEnergyRecovery,
                          @"活力唤醒":k530Command_MassageMotionRecovery,
                          @"绽放魅力":k530Command_MassageBalanceMind,
                          @"清晨唤醒":k530Command_MassageAMRoutine,
                          @"瞬间补眠":k530Command_MassageMiddayRest,
                          @"夜晚助眠":k530Command_MassageSweetDreams,
                          @"酸疼检测":k530Command_MassageIntellect
                          };
    if(str){
        NSString *resultStr = [dic objectForKey:str];
        if(resultStr){
           return resultStr;
        }
        return @"";
    }
    return @"";
}


//页面使用时间
+(void)pageDurationWithpageId:(NSString *)pageIdStr  withstartTime:(NSString *)startTime  withendTime:(NSString *)endTime{
    
    NSString *userSign = [UserShareOnce shareOnce].uid;
    if ([GlobalCommon stringEqualNull:userSign]) {
        userSign = @"";
    }
    
    if ([GlobalCommon stringEqualNull:startTime]||[GlobalCommon stringEqualNull:startTime]||[GlobalCommon stringEqualNull:pageIdStr]) {
        NSLog(@"=========== 有参数为 null");
        return;
    }
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow(CFBridgingRetain(infoDictionary));
    NSString *versionStr = [infoDictionary objectForKey:@"CFBundleShortVersionString"];//版本
    NSString *downloadStr = [NSString stringWithFormat:@"%@/user/visit",DATAURL_PRE];
    NSDictionary *downloadDic = @{ @"body":@{
                                           @"userId":userSign,
                                           @"pageId":pageIdStr,
                                           @"eventId":@"1",
                                           @"startTime":startTime,
                                           @"endTime":endTime,
                                           @"version":versionStr,
                                           @"remark":@"1"}
                                   };
    
    [[BuredPoint sharedYHBuriedPoint] submitWithUrl:downloadStr dic:downloadDic successBlock:^(id  _Nonnull response) {
        NSLog(@"%@",response);
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];
}


@end
