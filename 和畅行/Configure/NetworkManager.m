//
//  NetworkManager.m
//  和畅行
//
//  Created by 刘晓明 on 2018/7/5.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "NetworkManager.h"
#import "AFNetworking.h"

static NSMutableArray *tasks;

@implementation NetworkManager

+ (NetworkManager *)sharedNetworkManager
{
    /*! 为单例对象创建的静态实例，置为nil，因为对象的唯一性，必须是static类型 */
    static id sharedBANetManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedBANetManager = [[NetworkManager alloc] init];
    });
    return sharedBANetManager;
}



- (AFHTTPSessionManager *)sharedAFManager
{
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    //最大请求并发任务数
//    manager.operationQueue.maxConcurrentOperationCount = 5;
//
//    // 请求格式
//    // AFHTTPRequestSerializer            二进制格式
//    // AFJSONRequestSerializer            JSON
//    // AFPropertyListRequestSerializer    PList(是一种特殊的XML,解析起来相对容易)
//
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 上传普通格式
//
//    // 超时时间
//    manager.requestSerializer.timeoutInterval = 30.0f;
//    // 设置请求头
//    [manager.requestSerializer setValue:[UserShareOnce shareOnce].languageType forHTTPHeaderField:@"language"];
//    // 设置接收的Content-Type
//    manager.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"application/xml", @"text/xml",@"text/html", @"application/json",@"text/plain",nil];
//
//    // 返回格式
//    // AFHTTPResponseSerializer           二进制格式
//    // AFJSONResponseSerializer           JSON
//    // AFXMLParserResponseSerializer      XML,只能返回XMLParser,还需要自己通过代理方法解析
//    // AFXMLDocumentResponseSerializer (Mac OS X)
//    // AFPropertyListResponseSerializer   PList
//    // AFImageResponseSerializer          Image
//    // AFCompoundResponseSerializer       组合
//
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];//返回格式 JSON
//    //设置返回C的ontent-type
//    manager.responseSerializer.acceptableContentTypes=[[NSSet alloc] initWithObjects:@"application/xml", @"text/xml",@"text/html", @"application/json",@"text/plain",nil];
//
//    return manager;
       AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];



        /*! 设置请求超时时间 */
        manager.requestSerializer.timeoutInterval = 30;

        /*! 打开状态栏的等待菊花 */
        //[AFNetworkActivityIndicatorManager sharedManager].enabled = YES;

        /*! 设置相应的缓存策略：此处选择不用加载也可以使用自动缓存【注：只有get方法才能用此缓存策略，NSURLRequestReturnCacheDataDontLoad】 */
        //manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;

        /*! 设置返回数据类型为 json, 分别设置请求以及相应的序列化器 */
        /*!
         根据服务器的设定不同还可以设置：
         json：[AFJSONResponseSerializer serializer](常用)
         http：[AFHTTPResponseSerializer serializer]
         */
        /*! 这里是去掉了键值对里空对象的键值 */
        //response.removesKeysWithNullValues = YES;
        manager.responseSerializer = [AFJSONResponseSerializer serializer]; // 设置接收数据为 JSON 数据

    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];// 请求返回的格式为json
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    manager.responseSerializer =[AFJSONResponseSerializer serializerWithReadingOptions: NSJSONReadingAllowFragments];
    if([UserShareOnce shareOnce].languageType){
        [manager.requestSerializer setValue:[UserShareOnce shareOnce].languageType forHTTPHeaderField:@"language"];
    }
    
//    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    NSArray *_tmpArray = [NSArray arrayWithArray:[cookieStorage cookies]];
//    NSLog(@"%@",_tmpArray);
    
        /* 设置请求服务器数类型式为 json */
        /*! 根据服务器的设定不同还可以设置 [AFJSONRequestSerializer serializer](常用) */

        /* 设置请求和接收的数据编码格式 */
//        manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 设置请求数据为 JSON 数据



        /*! 设置apikey ------类似于自己应用中的tokken---此处仅仅作为测试使用*/
        //        [manager.requestSerializer setValue:apikey forHTTPHeaderField:@"apikey"];

        /*! 复杂的参数类型 需要使用json传值-设置请求内容的类型*/
        //        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

        /*! 设置响应数据的基本类型 */
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/xml",@"text/plain", @"application/javascript", @"image/*", nil];

        /*! https 参数配置 */
        /*!
         采用默认的defaultPolicy就可以了. AFN默认的securityPolicy就是它, 不必另写代码. AFSecurityPolicy类中会调用苹果security.framework的机制去自行验证本次请求服务端放回的证书是否是经过正规签名.
         */
//        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
//        securityPolicy.allowInvalidCertificates = YES;
//        securityPolicy.validatesDomainName = NO;
//        manager.securityPolicy = securityPolicy;

        /*! 自定义的CA证书配置如下： */
        /*! 自定义security policy, 先前确保你的自定义CA证书已放入工程Bundle */
        /*!
         https://api.github.com网址的证书实际上是正规CADigiCert签发的, 这里把Charles的CA根证书导入系统并设为信任后, 把Charles设为该网址的SSL Proxy (相当于"中间人"), 这样通过代理访问服务器返回将是由Charles伪CA签发的证书.
         */
        //        NSSet <NSData *> *cerSet = [AFSecurityPolicy certificatesInBundle:[NSBundle mainBundle]];
        //        AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:cerSet];
        //        policy.allowInvalidCertificates = YES;
        //        manager.securityPolicy = policy;

        /*! 如果服务端使用的是正规CA签发的证书, 那么以下几行就可去掉: */
        //        NSSet <NSData *> *cerSet = [AFSecurityPolicy certificatesInBundle:[NSBundle mainBundle]];
        //        AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:cerSet];
        //        policy.allowInvalidCertificates = YES;
        //        manager.securityPolicy = policy;


    return manager;
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

- (void)requestWithType:(BAHttpRequestType)type
                               urlString:(NSString *)urlString
                              parameters:(NSDictionary *)parameters
                            successBlock:(BAResponseSuccess)successBlock
                            failureBlock:(BAResponseFail)failureBlock
{
    if (urlString == nil)
    {
        return ;
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",URL_PRE,urlString];
    /*! 检查地址中是否有中文 */
    NSString *URLString = [NSURL URLWithString:urlStr] ? urlStr : [self strUTF8Encoding:urlStr];
    
    NSString *requestType;
    switch (type) {
        case 0:
            requestType = @"GET";
            break;
        case 1:
            requestType = @"POST";
            break;
        default:
            break;
    }
    
    BAURLSessionTask *sessionTask = nil;
    
    if (type == BAHttpRequestTypeGet)
    {
        AFHTTPSessionManager *manager = [self sharedAFManager];
       
        sessionTask = [manager GET:URLString parameters:parameters  progress:^(NSProgress * _Nonnull downloadProgress) {

        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

            
            if (successBlock)
            {
                successBlock(responseObject);
            }


        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

            if (failureBlock)
            {
                failureBlock(error);
            }


        }];
        
    }
    
    else if (type == BAHttpRequestTypeHeadGet){
        
        AFHTTPSessionManager *manager = [self sharedAFManager];
//        NSDictionary *headers = @{@"version":@"ios_hcy-oem-3.1.3",
//                                  @"token":[UserShareOnce shareOnce].token,
//                                  @"Cookie":[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",
//                                             [UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]};
        
//        for(NSString *key in headers.allKeys){
//            [manager.requestSerializer setValue:[headers objectForKey:key] forHTTPHeaderField:key];
//        }
        
        [manager.requestSerializer setValue:@"ios_hcy-oem-3.1.3" forHTTPHeaderField:@"version"];
        [manager.requestSerializer setValue:[UserShareOnce shareOnce].token forHTTPHeaderField:@"token"];
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",
                                             [UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID] forHTTPHeaderField:@"Cookie"];
        sessionTask = [manager GET:URLString parameters:parameters  progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (successBlock)
            {
                successBlock(responseObject);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (failureBlock)
            {
                failureBlock(error);
            }
            
        }];
        
    }
    
    else if (type == BAHttpRequestTypePost)
    {
        AFHTTPSessionManager *manager = [self sharedAFManager];
        
        
        
        sessionTask = [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (successBlock)
            {
                successBlock(responseObject);
            }
            
           
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (failureBlock)
            {
                failureBlock(error);
                NSLog(@"错误信息：%@",error);
            }
            
            
        }];
    }
   
    
}


- (void)requestWithformDataWithurlString:(NSString *)urlString
             parameters:(NSDictionary *)parameters
              formDataBlock:(BAResponseForm)formDataBlock
           successBlock:(BAResponseSuccess)successBlock
           failureBlock:(BAResponseFail)failureBlock
{
    BAURLSessionTask *sessionTask = nil;
    AFHTTPSessionManager *manager = [self sharedAFManager];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",URL_PRE,urlString];
    /*! 检查地址中是否有中文 */
    NSString *URLString = [NSURL URLWithString:urlStr] ? urlStr : [self strUTF8Encoding:urlStr];
    
    sessionTask = [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
//        if (formDataBlock)
//        {
//            formDataBlock(formData);
//        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (successBlock)
        {
            successBlock(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureBlock)
        {
            failureBlock(error);
            NSLog(@"错误信息：%@",error);
        }
    }];
    
}

- (void)requestWithType:(BAHttpRequestType)type
              urlString:(NSString *)urlString
         headParameters:(NSDictionary *)headerDic
             parameters:(NSDictionary *)parameters
           successBlock:(BAResponseSuccess)successBlock
           failureBlock:(BAResponseFail)failureBlock
{
    if (urlString == nil)
    {
        return ;
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",URL_PRE,urlString];
    /*! 检查地址中是否有中文 */
    NSString *URLString = [NSURL URLWithString:urlStr] ? urlStr : [self strUTF8Encoding:urlStr];
    
    NSString *requestType;
    switch (type) {
        case 0:
            requestType = @"GET";
            break;
        case 1:
            requestType = @"POST";
            break;
        default:
            break;
    }
    
    BAURLSessionTask *sessionTask = nil;
    if (type == BAHttpRequestTypeGet)
    {
       // AFHTTPSessionManager *manager = [self sharedAFManager];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        /*! 设置请求超时时间 */
        manager.requestSerializer.timeoutInterval = 30;
        
        for(NSString *key in headerDic.allKeys){
            [manager.requestSerializer setValue:[headerDic objectForKey:key] forHTTPHeaderField:key];
        }
        
       
        
        
        sessionTask = [manager GET:URLString parameters:parameters  progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (successBlock)
            {
                successBlock(responseObject);
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (failureBlock)
            {
                failureBlock(error);
            }
            
            
        }];
        
    }else if (type == BAHttpRequestTypePost)
    {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        /*! 设置请求超时时间 */
        manager.requestSerializer.timeoutInterval = 30;
        
        
        AFJSONRequestSerializer *rqSerializer = [AFJSONRequestSerializer serializerWithWritingOptions:0];//NSJSONWritingPrettyPrinted
        
        rqSerializer.stringEncoding = NSUTF8StringEncoding;
        
        AFJSONResponseSerializer *rsSerializer = [AFJSONResponseSerializer serializer];
        
        rsSerializer.stringEncoding = NSUTF8StringEncoding;
        //manager.requestSerializer = [AFJSONRequestSerializer new];
        manager.requestSerializer = rqSerializer;
        manager.responseSerializer = rsSerializer;
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/xml",@"text/plain", @"application/javascript", @"image/*", nil];
        
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"content-type"];
        
        for(NSString *key in headerDic.allKeys){
            [manager.requestSerializer setValue:[headerDic objectForKey:key] forHTTPHeaderField:key];
           
        }
        
        sessionTask = [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (successBlock)
            {
                successBlock(responseObject);
            }
            
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (failureBlock)
            {
                failureBlock(error);
                NSLog(@"错误信息：%@",error);
            }
            
            
        }];
    }
}

-(void)submitWithUrl:(NSString *)url token:(NSString *)token dic:(NSDictionary *)dic {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 30;
    AFJSONRequestSerializer *rqSerializer = [AFJSONRequestSerializer serializerWithWritingOptions:0];//NSJSONWritingPrettyPrinted
    rqSerializer.stringEncoding = NSUTF8StringEncoding;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/xml",@"text/plain", @"application/javascript", @"image/*", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    
    [manager POST:url  parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@------",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}



-(void)mainThreadRequestWithUrl:(NSString *)myUrl token:(NSString *)token dic:(NSDictionary *)dic{
    
    NSString *dataStr = [self dictionaryToJson:dic];
    dataStr =  [dataStr stringByReplacingOccurrencesOfString:@"'\\'" withString:@""];
    dataStr =  [dataStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSURL *url = [NSURL URLWithString:myUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:token forHTTPHeaderField:@"token"];
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary  *  dic1  = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"--------------%@",dic1);
    
}
-(NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

#pragma mark - url 中文格式化
- (NSString *)strUTF8Encoding:(NSString *)str
{
    /*! ios9适配的话 打开第一个 */
    if ([[UIDevice currentDevice] systemVersion].floatValue >= 9.0)
    {
        return [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    }
    else
    {
        return [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }
}

@end
