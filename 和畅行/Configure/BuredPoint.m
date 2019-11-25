//
//  BuredPoint.m
//  YHBuriedPoint
//
//  Created by Wei Zhao on 2019/6/21.
//  Copyright © 2019 Wei Zhao. All rights reserved.
//

#import "BuredPoint.h"
#import <CommonCrypto/CommonCrypto.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <sys/utsname.h>
#import <UIKit/UIKit.h>
static NSMutableArray *tasks;
@interface BuredPoint ()

@property (nonatomic,copy)NSString *signStr;
@property (nonatomic,copy)NSString *openStr;
@property (nonatomic,copy)NSString *locationKey;
@property (nonatomic,copy)NSString *pointToken;
@end
@implementation BuredPoint

+ (BuredPoint *)sharedYHBuriedPoint
{
    static id sharedBANetManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedBANetManager = [[BuredPoint alloc] init];
    });
    return sharedBANetManager;
}


-(void)setTheSignatureWithSignStr:(NSString *)signString withOpenStr:(NSString *)openStr withLacationKey:(NSString *)lacationKey{
    self.openStr = openStr;
    if(signString&&signString.length > 0){
        self.signStr = signString;
         NSLog(@"========设置签名成功==========");
    }else{
        NSLog(@"========设置签名失败==========");
    }
    
    if(lacationKey&&lacationKey.length > 0){
        self.locationKey = lacationKey;
        NSLog(@"========百度定位key设置成功==========");
    }else{
        NSLog(@"========百度定位key设置失败==========");
    }
}

- (NSString *)md5Points:(NSString *)str
{
    if(self.signStr&&self.signStr.length > 0){
        NSString *keyStr = [NSString stringWithFormat:@"&key=%@",self.signStr];
        str = [str stringByAppendingString:keyStr];
        
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
    }else{
            NSLog(@"========设置签名失败 导致加密失败==========");
            return nil;
    }
    
}

+ (NSMutableArray *)tasks
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"创建数组");
        tasks = [[NSMutableArray alloc] init];
    });
    
    return tasks;
}

//获取埋点token 登录认证

-(void)getTokenWithUrl:(NSString *)myUrl  dic:(NSDictionary *)dic successBlock:(BAResponseSuccess)successBlock failureBlock:(BAResponseFail)failureBlock{
    
    if(![self.openStr isEqualToString:@"1"]){
        NSLog(@"数据上传开关为关闭状态");
        return;
    }
    if(!myUrl||myUrl.length<1){
        NSLog(@"===========url错误============");
        return;
    }
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *string =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    string =  [string stringByReplacingOccurrencesOfString:@"'\\'" withString:@""];
    string =  [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSURL *url = [NSURL URLWithString:myUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:self.pointToken forHTTPHeaderField:@"x-auth-token"];
    //    [request setValue:tokenStr forHTTPHeaderField:@"token"];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    
    //3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSString *token = [NSString stringWithFormat:@"%@",[dict valueForKey:@"data11"]];
            if (![self stringEqualNull:token]) {
                self.pointToken = token;
                if (successBlock)
                {
                    successBlock(response);
                }
            }else{
                self.pointToken = nil;
            }
          
             NSLog(@"%@",self.pointToken);
        }else{
            self.pointToken = nil;
            if (failureBlock)
            {
                failureBlock(error);
            }
        }
    }];
    
    //5.执行任务
    [dataTask resume];
    
    
}


//正常情况下的 埋点数据上传  (有定位)

-(void)submitLocationWithUrl:(NSString *)myUrl Dic:(NSDictionary *)dic successBlock:(BAResponseSuccess)successBlock failureBlock:(BAResponseFail)failureBlock{
    
    
    NSMutableDictionary *parmDic1 = [[NSMutableDictionary alloc]initWithDictionary:dic];
    NSMutableDictionary *parmDic2 = [[NSMutableDictionary alloc]initWithDictionary:[dic valueForKey:@"body"]];
    if( self.locationKey&& self.locationKey.length > 0){
        
        NSURL *urlStr = [NSURL URLWithString: [NSString stringWithFormat:@"http://api.map.baidu.com/location/ip?ak=%@",self.locationKey]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:urlStr cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        //3.获得会话对象
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error == nil) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                if (successBlock)
                {
                    if ([[[dict valueForKey:@"content"] valueForKey:@"address_detail"] valueForKey:@"province"]) {
                        parmDic2[@"province"] = [[[dict valueForKey:@"content"] valueForKey:@"address_detail"] valueForKey:@"province"];
                        parmDic2[@"city"]  =     [[[dict valueForKey:@"content"] valueForKey:@"address_detail"] valueForKey:@"city"] ;
                        [parmDic1 setValue:parmDic2 forKey:@"body"];
                    }
                    
                    [self submitWithUrl:myUrl dic:parmDic1 successBlock:^(id  _Nonnull response) {
                        if (successBlock)
                        {
                            successBlock(response);
                        }
                    } failureBlock:^(NSError * _Nonnull error) {
                        if (failureBlock)
                        {
                            failureBlock(error);
                        }
                    }];
                }
            }else{
                
                [self submitWithUrl:myUrl dic:dic successBlock:^(id  _Nonnull response) {
                    if (successBlock)
                    {
                        successBlock(response);
                    }
                } failureBlock:^(NSError * _Nonnull error) {
                    if (failureBlock)
                    {
                        failureBlock(error);
                    }
                }];
                
            }
        }];
        
        //5.执行任务
        [dataTask resume];
        
    }else{
        [self submitWithUrl:myUrl dic:dic successBlock:^(id  _Nonnull response) {
            if (successBlock)
            {
                successBlock(response);
            }
        } failureBlock:^(NSError * _Nonnull error) {
            if (failureBlock)
            {
                failureBlock(error);
            }
        }];
    }
}



//有定位的同步请求
-(void)mainLocationThreadRequestWithUrl:(NSString *)myUrl dic:(NSDictionary *)dic resultBlock:(BAResponseResult)resultBlock {
    
    NSMutableDictionary *parmDic1 = [[NSMutableDictionary alloc]initWithDictionary:dic];
     NSMutableDictionary *parmDic2 = [[NSMutableDictionary alloc]initWithDictionary:[dic valueForKey:@"body"]];
    if( self.locationKey&& self.locationKey.length > 0){
        
        NSURL *urlStr = [NSURL URLWithString: [NSString stringWithFormat:@"http://api.map.baidu.com/location/ip?ak=%@",self.locationKey]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:urlStr cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        [request setHTTPMethod:@"GET"];//设置请求方式为POST，默认为GET
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSError *error = nil;
        NSDictionary  *  dic1  = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableContainers error:&error];
        
        if ([[[dic1 valueForKey:@"content"] valueForKey:@"address_detail"] valueForKey:@"province"]) {
            parmDic2[@"province"] = [[[dic1 valueForKey:@"content"] valueForKey:@"address_detail"] valueForKey:@"province"];
            parmDic2[@"city"]  =     [[[dic1 valueForKey:@"content"] valueForKey:@"address_detail"] valueForKey:@"city"];
            [parmDic1 setValue:parmDic2 forKey:@"body"];
        }
        dic = parmDic1;
        [self mainThreadRequestWithUrl:myUrl dic:dic resultBlock:^(id  _Nonnull response) {
            if (resultBlock)
            {
                resultBlock(response);
            }
        }];
        
    }else{
     
        [self mainThreadRequestWithUrl:myUrl dic:dic resultBlock:^(id  _Nonnull response) {
            if (resultBlock)
            {
                resultBlock(response);
            }
        }];
    
    }
}

//正常情况下的 埋点数据上传  (没有定位)
-(void)submitWithUrl:(NSString *)myUrl  dic:(NSDictionary *)dic successBlock:(BAResponseSuccess)successBlock failureBlock:(BAResponseFail)failureBlock{
    
    if(![self.openStr isEqualToString:@"1"]){
        NSLog(@"数据上传开关为关闭状态");
        return;
    }
    if(!myUrl||myUrl.length<1){
        NSLog(@"===========url错误============");
        return;
    }
    if(!dic||[dic isEqual: [NSNull null]]||![dic[@"body"] isKindOfClass:[NSDictionary class]]){
        NSLog(@"===========请求参数错误============");
        return;
    }
    
    if(!self.pointToken){
        NSLog(@"===========未成功获取埋点token============");
        return;
    }
    
    NSString *dataStr = [self dictionaryToJson:dic];
    NSString * tokenStr = [self sortingWithDic:dic];
    NSURL *url = [NSURL URLWithString:myUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:self.pointToken forHTTPHeaderField:@"x-auth-token"];
    [request setValue:tokenStr forHTTPHeaderField:@"token"];
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];

    //3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if (successBlock)
            {
                successBlock(dict);
            }
        }else{
            if (failureBlock)
            {
                failureBlock(error);
            }
        }
    }];
    
    //5.执行任务
    [dataTask resume];
    

    
}


-(void)mainThreadRequestWithUrl:(NSString *)myUrl  dic:(NSDictionary *)dic resultBlock:(BAResponseResult)resultBlock{
    
    if(![self.openStr isEqualToString:@"1"]){
         NSLog(@"数据上传开关为关闭状态");
        return;
    }
    if(!myUrl||myUrl.length<10){
        NSLog(@"============url错误============");
        return;
    }
    
    if(!dic||[dic isEqual: [NSNull null]]||![dic[@"body"] isKindOfClass:[NSDictionary class]]){
        NSLog(@"===========请求参数错误============");
        return;
    }
    
    if(!self.pointToken){
        NSLog(@"===========未成功获取埋点token============");
        return;
    }
    NSString *dataStr = [self dictionaryToJson:dic];
    NSString * tokenStr = [self sortingWithDic:dic];
    NSURL *url = [NSURL URLWithString:myUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:self.pointToken forHTTPHeaderField:@"x-auth-token"];
    [request setValue:tokenStr forHTTPHeaderField:@"token"];
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary  *  dic1  = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableContainers error:nil];
    if (resultBlock)
    {
        resultBlock(dic1);
    }
}
-(NSString*)dictionaryToJson:(NSDictionary *)dic{
    NSArray *keyArray = [dic[@"body"] allKeys];
    for (NSString *keyStr in keyArray) {
        if ([dic[@"body"][keyStr] isEqualToString:@""]||!dic[@"body"][keyStr]) {
            NSMutableDictionary *bodyDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            NSMutableDictionary *myDic = [NSMutableDictionary dictionaryWithDictionary:dic[@"body"]];
            
            NSArray *keyArray = [myDic allKeys];
            for (int i = 0 ; i< keyArray.count; i++) {
                NSString *valueStr = myDic[keyArray[i]];
                if([valueStr isEqualToString:@""]){
                    [myDic removeObjectForKey:keyArray[i]];
                }
            }
            [bodyDic setValue:myDic forKeyPath:@"body"];
            dic = bodyDic.copy;
        }
    }

    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *string =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    string =  [string stringByReplacingOccurrencesOfString:@"'\\'" withString:@""];
    string =  [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return string;
}


-(NSString *)sortingWithDic:(NSDictionary *)dic{

    NSArray *allKeyArray = [dic[@"body"] allKeys];
    
    NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch|NSNumericSearch|
    
    NSWidthInsensitiveSearch|NSForcedOrderingSearch;
    
    NSComparator sort = ^(NSString *obj1,NSString *obj2){
        
        NSRange range = NSMakeRange(0,obj1.length);
        
        return [obj1 compare:obj2 options:comparisonOptions range:range];
        
    };
    
    NSArray *resultArray = [allKeyArray sortedArrayUsingComparator:sort];
    NSMutableArray *keyArray = [NSMutableArray arrayWithArray:resultArray];
    NSMutableArray *valueArray = [NSMutableArray array];
    
    for (int i = 0; i<resultArray.count; i++) {
        NSString *sortsing = resultArray[i];
        NSString *valueString = [dic[@"body"]  objectForKey:sortsing];
        if([valueString isEqualToString:@""]){
            [keyArray removeObject:sortsing];
        }else{
            [valueArray addObject:valueString];
        }
    }
    
    NSString *tokenStr = [NSString string];
    for (int i = 0 ; i < keyArray.count; i++) {
        tokenStr = [tokenStr stringByAppendingFormat:@"%@=%@&",keyArray[i],valueArray[i]];
    }
    tokenStr = [tokenStr substringWithRange:NSMakeRange(0, tokenStr.length -1)];
    tokenStr =  [self md5Points:tokenStr];
    return tokenStr;
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

//获取手机型号
+ (NSString *)getCurrentDeviceModel{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    
    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceModel isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
    if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([deviceModel isEqualToString:@"iPhone10,1"])   return @"iPhone_8";
    if ([deviceModel isEqualToString:@"iPhone10,4"])   return @"iPhone_8";
    if ([deviceModel isEqualToString:@"iPhone10,2"])   return @"iPhone_8_Plus";
    if ([deviceModel isEqualToString:@"iPhone10,5"])   return @"iPhone_8_Plus";
    if ([deviceModel isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([deviceModel isEqualToString:@"iPhone10,6"])   return @"iPhone X";
    if ([deviceModel isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
    if ([deviceModel isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
    if ([deviceModel isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
    if ([deviceModel isEqualToString:@"iPhone11,4"])   return @"iPhone XS Max";
    if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceModel isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([deviceModel isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([deviceModel isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([deviceModel isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([deviceModel isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([deviceModel isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    if ([deviceModel isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    
    if ([deviceModel isEqualToString:@"AppleTV2,1"])      return @"Apple TV 2";
    if ([deviceModel isEqualToString:@"AppleTV3,1"])      return @"Apple TV 3";
    if ([deviceModel isEqualToString:@"AppleTV3,2"])      return @"Apple TV 3";
    if ([deviceModel isEqualToString:@"AppleTV5,3"])      return @"Apple TV 4";
    
    if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
    return deviceModel;
}

//获取屏幕分辨率
+(NSString *)getScreenPix{
    NSString *screenPix = @"";
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    screenPix = [NSString stringWithFormat:@"%.0fx%.0f",width*scale_screen,height*scale_screen];
    return screenPix;
}


//获取本机运营商名称
+(NSString *)getOperator{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    
    CTCarrier *carrier = [info subscriberCellularProvider];
    
    NSString *mobile;
    
    
    if (!carrier.isoCountryCode) {
        
        NSLog(@"没有SIM卡");
        
        mobile = @"无卡";
        
    }else{
        
        mobile = [carrier carrierName];
//        if([mobile isEqualToString:@"中国移动"]){
//            mobile = @"1";
//        }else  if([mobile isEqualToString:@"中国联通"]){
//            mobile = @"2";
//        }else  if([mobile isEqualToString:@"中国电信"]){
//            mobile = @"3";
//        }else{
//            mobile = @"0";
//        }
//
        
    }
    return mobile;
}

- (BOOL)stringEqualNull:(NSString *)str
{
    if([str isEqual:[NSNull null]] || str == nil || str.length == 0 || [str isEqualToString:@"(null)"]){
        return YES;
    }else{
        return NO;
    }
}


@end
