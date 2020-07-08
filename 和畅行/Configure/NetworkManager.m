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
    
    
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *_tmpArray = [NSArray arrayWithArray:[cookieStorage cookies]];
    NSLog(@"=====-=-=-=-=-=--------%@",_tmpArray);
    

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
    
    __weak typeof(self) weakSelf = self;
    
    if (type == BAHttpRequestTypeHeadGet || type == BAHttpRequestTypeGet){
        
        AFHTTPSessionManager *manager = [self sharedAFManager];

        
        //[manager.requestSerializer setValue:@"ios_jlsl-yh-3" forHTTPHeaderField:@"version"];
        
        if(type == BAHttpRequestTypeHeadGet){
           // [manager.requestSerializer setValue:@"ios_hcy-oem-3.1.3" forHTTPHeaderField:@"version"];
            NSString *nowVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
            NSString *headStr = [NSString stringWithFormat:@"ios_hcy-oem-%@",nowVersion];
            [manager.requestSerializer setValue:headStr forHTTPHeaderField:@"version"];
        }
        
       
        sessionTask = [manager GET:URLString parameters:parameters  progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (successBlock)
            {
                successBlock(responseObject);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            /***start***/
            
            if([urlString isEqualToString:@"login/commit.jhtml"] || [urlString isEqualToString:@"weiq/weiq/weix/authlogin.jhtml"] || [urlString isEqualToString:@"weiq/sms/relogin.jhtml"]){ //登录接口不做处理
                if (failureBlock)
                {
                    failureBlock(error);
                }
            }else{ //其他接口 先判断该用户是否在登录状态,在直接返回 如不在 先登录 成功后 再次请求该接口
                if([weakSelf isNetworkLogin]){
                    if (failureBlock)
                    {
                        failureBlock(error);
                    }
                }else{
                    [weakSelf loginAgainWithTwo:NO withBlock:^(NSString *blockParam) {
                        if([blockParam isEqualToString:@"error"]){
                            if (failureBlock)
                            {
                                failureBlock(error);
                            }
                        }else{
                            [manager GET:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
                    }];
                }
            }
            
            /***end***/
            
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
            
            /***start***/
            if([weakSelf isNetworkLogin]){
                if (failureBlock)
                {
                    failureBlock(error);
                }
            }else{
                [weakSelf loginAgainWithTwo:NO withBlock:^(NSString *blockParam) {
                    if([blockParam isEqualToString:@"error"]){
                        if (failureBlock)
                        {
                            failureBlock(error);
                        }
                    }else{
                        [manager POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
                }];
            }
            /***end***/
            
        }];
    }
   
    
}



- (void)requestWithCookieType:(BAHttpRequestType)type
              urlString:(NSString *)urlString
         headParameters:(NSDictionary *)headerDic
             parameters:(NSMutableDictionary *)parameters
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
    __weak typeof(self) weakSelf = self;
    BAURLSessionTask *sessionTask = nil;
    if (type == BAHttpRequestTypeGet)
    {
        
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
            
            /***start***/
            if([weakSelf isNetworkLogin]){
                if (failureBlock)
                {
                    failureBlock(error);
                }
            }else{
                [weakSelf loginAgainWithTwo:NO withBlock:^(NSString *blockParam) {
                    if([blockParam isEqualToString:@"error"]){
                        if (failureBlock)
                        {
                            failureBlock(error);
                        }
                    }else{
                        [manager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
                }];
            }
            /***end***/
            
        }];
        
    }else if (type == BAHttpRequestTypePost || type == BAHttpRequestTypeFilePost)
    {
        AFHTTPSessionManager *manager = [self sharedAFManager];
        
         manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];

        NSDictionary *headers = @{@"token":[UserShareOnce shareOnce].token,
                                  @"Set-Cookie":[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",
                                             [UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]};
        
        for(NSString *key in headers.allKeys){
            [manager.requestSerializer setValue:[headers objectForKey:key] forHTTPHeaderField:key];
        }
        
        //[self setCookieWithManager:manager];
        
        if(headerDic){
            for(NSString *key in headerDic.allKeys){
                [manager.requestSerializer setValue:[headerDic objectForKey:key] forHTTPHeaderField:key];
            }
        }
        
        if(type == BAHttpRequestTypePost){
            
            NSString *paramsStr = [[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
            NSLog(@"请求地址：  %@, 请求参数： %@\n", URLString, paramsStr);
            sessionTask = [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                
                if (successBlock)
                {
                    successBlock(responseObject);
                }
                
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                /***start***/
                if([weakSelf isNetworkLogin]){
                    if (failureBlock)
                    {
                        failureBlock(error);
                    }
                }else{
                    [weakSelf loginAgainWithTwo:NO withBlock:^(NSString *blockParam) {
                        if([blockParam isEqualToString:@"error"]){
                            if (failureBlock)
                            {
                                failureBlock(error);
                            }
                        }else{
                            
                            //登录后cookie已经发生变化,需要重新设置
                            NSDictionary *headers = @{@"token":[UserShareOnce shareOnce].token,
                                                      @"Set-Cookie":[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",
                                                                     [UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]};
                            
                            for(NSString *key in headers.allKeys){
                                [manager.requestSerializer setValue:[headers objectForKey:key] forHTTPHeaderField:key];
                            }
                            
                            [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
                    }];
                }
                /***end***/
                
            }];
        }else{
            //提交文件
            [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                for (NSString *key in parameters) {
                    id value = parameters[key];
                    [formData appendPartWithFileURL:[NSURL fileURLWithPath:value] name:@"file" error:nil];
                }
                
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                id status=[responseObject objectForKey:@"status"];
                if([status intValue] == 44){
                    [weakSelf loginAgainWithTwo:NO withBlock:^(NSString *blockParam) {
                        if([blockParam isEqualToString:@"error"]){
                            if (failureBlock)
                            {
                                NSError *error = NULL;
                                failureBlock(error);
                            }
                        }else{
                            //登录后cookie已经发生变化,需要重新设置
                            NSDictionary *headers = @{@"token":[UserShareOnce shareOnce].token,
                                                      @"Set-Cookie":[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",
                                                                     [UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]};
                            
                            for(NSString *key in headers.allKeys){
                                [manager.requestSerializer setValue:[headers objectForKey:key] forHTTPHeaderField:key];
                            }
                            
                            [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                                for (NSString *key in parameters) {
                                    id value = parameters[key];
                                    [formData appendPartWithFileURL:[NSURL fileURLWithPath:value] name:@"file" error:nil];
                                }
                            } progress:^(NSProgress * _Nonnull uploadProgress) {
                                
                            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                if (successBlock) {
                                    successBlock(responseObject);
                                }
                            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                if (failureBlock)
                                {
                                    failureBlock(error);
                                }
                            }];
                        }
                    }];
                    
                }else{
                    if (successBlock) {
                        successBlock(responseObject);
                    }
                }
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                /***start***/
                if([weakSelf isNetworkLogin]){
                    if (failureBlock)
                    {
                        failureBlock(error);
                    }
                }else{
                    [weakSelf loginAgainWithTwo:NO withBlock:^(NSString *blockParam) {
                        if([blockParam isEqualToString:@"error"]){
                            if (failureBlock)
                            {
                                failureBlock(error);
                            }
                        }else{
                            //登录后cookie已经发生变化,需要重新设置
                            NSDictionary *headers = @{@"token":[UserShareOnce shareOnce].token,
                                                      @"Set-Cookie":[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",
                                                                     [UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]};
                            
                            for(NSString *key in headers.allKeys){
                                [manager.requestSerializer setValue:[headers objectForKey:key] forHTTPHeaderField:key];
                            }
                            
                            [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                                for (NSString *key in parameters) {
                                    id value = parameters[key];
                                    [formData appendPartWithFileURL:[NSURL fileURLWithPath:value] name:@"file" error:nil];
                                }
                            } progress:^(NSProgress * _Nonnull uploadProgress) {
                                
                            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                if (successBlock) {
                                    successBlock(responseObject);
                                }
                            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                if (failureBlock)
                                {
                                    failureBlock(error);
                                }
                            }];
                        }
                    }];
                }
                /***end***/
            }];
        }
       
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
    
    myUrl = @"http://api.map.baidu.com/location/ip?ak=AeKAfeKr4YGknb2kPxd8d4xqxFcbjhg0";
    NSURL *url = [NSURL URLWithString:myUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"GET"];//设置请求方式为POST，默认为GET
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
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

+ (void)dataGetMethod:(NSString *)urlString withParams:(NSDictionary *)params withBlock:(void (^)(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error))block{
    NSMutableString *tmpUrlString = [NSMutableString stringWithFormat:@"%@?",urlString];
    NSArray *allKeys = [params allKeys];
    for (NSString *key in allKeys) {
        [tmpUrlString appendFormat:@"%@=%@&",key,[params objectForKey:key]];
    }
    
    //移除最后一个&
    NSString *url = [tmpUrlString substringToIndex:tmpUrlString.length-1];
    //    NSLog(@"%@",url);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:@"token"];
    
    if (token&&![token isEqualToString:@""]&&![token isEqualToString:@"(null)"]) {
        configuration.HTTPAdditionalHeaders = @{@"Authorization":token};
    }
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.session.configuration.timeoutIntervalForRequest = 10.0f;//设置超时时间 同上面的类似
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        //回调
        if (error) {
            //            NSLog(@"%@",error);
        }else{
            //            NSLog(@"%@",responseObject);
        }
        block(response,responseObject,error);
    }];
    [dataTask resume];
}
# pragma mark - 判断是否处于登录状态
- (BOOL)isNetworkLogin
{
    
   // dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    __weak typeof(self) weakSelf = self;
    
   // AFHTTPSessionManager *manager = [weakSelf sharedAFManager];
    
    __block BOOL isLogin = NO;
    
    NSString *urlStr = [NSString stringWithFormat:@"%@login/logincheck.jhtml?memberId=%@",URL_PRE,[UserShareOnce shareOnce].uid];



//    [manager GET:urlStr parameters:nil progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//        if([[responseObject objectForKey:@"status"] integerValue] == 100){
//            if([[responseObject objectForKey:@"data"] boolValue] == YES){
//                isLogin = YES;
//            }else{
//                isLogin = NO;
//            }
//        }
//
//        dispatch_semaphore_signal(semaphore);
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//        //接口请求失败 代表不是cookie问题
//        isLogin = YES;
//
//        dispatch_semaphore_signal(semaphore);
//    }];

   // dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    return isLogin;
}

# pragma mark - 进行重新登录操作
- (void)loginAgainWithTwo:(BOOL)isTwo withBlock:(void(^)(NSString * blockParam))callBack
{
    NSMutableDictionary* dicTmp = [UtilityFunc mutableDictionaryFromAppConfig];
    NSString *strcheck=[dicTmp objectForKey:@"ischeck"];
    if([GlobalCommon stringEqualNull:strcheck] || [strcheck isEqualToString:@"0"]){
        return;
    }
    NSString *aUrl = @"";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if([strcheck isEqualToString:@"1"]){
        
        
        CGRect rect = [[UIScreen mainScreen] bounds];
        CGSize size = rect.size;
        CGFloat width = size.width;
        CGFloat height = size.height;
        NSString* widthheight=[NSString stringWithFormat:@"%d*%d",(int)width,(int)height ];
        NSDate *datenow = [NSDate date];
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
        
        
        [dic setObject:@"beta1.4" forKey:@"softver"];
        [dic setObject:[[UIDevice currentDevice] systemVersion] forKey:@"osver"];
        [dic setObject:widthheight forKey:@"resolution"];
        [dic setObject:timeSp forKey:@"time"];
        NSString *usernameStr = [GlobalCommon AESDecodeWithString:[dicTmp objectForKey:@"USERNAME"]];
        NSString *passwordStr = [GlobalCommon AESDecodeWithString:[dicTmp objectForKey:@"PASSWORDAES"]];
        if([usernameStr isEqualToString:@""] || usernameStr == nil || usernameStr.length == 0 ){
            usernameStr = [dicTmp objectForKey:@"USERNAME"];
            passwordStr = [dicTmp objectForKey:@"PASSWORDAES"];
        }
        [dic setObject:usernameStr forKey:@"username"];
        [dic setObject:passwordStr forKey:@"password"];
        [dic setObject:@"" forKey:@"brand"];
        [dic setObject:@"" forKey:@"devmodel"];
        
        aUrl = @"login/commit.jhtml";
        
        
    }else if ([strcheck isEqualToString:@"2"]){
        
        
       
        NSString *unionidStr = [GlobalCommon AESDecodeWithString:[dicTmp valueForKey:@"UNIONID"]];
        if([unionidStr isEqualToString:@""] || unionidStr == nil || unionidStr.length == 0 ){
            unionidStr = [dicTmp valueForKey:@"UNIONID"];
        }
        [dic setObject:unionidStr forKey:@"unionid"];
        [dic setObject:[dicTmp valueForKey:@"SCREENNAME"] forKey:@"screen_name"];
        [dic setObject:[dicTmp valueForKey:@"GENDER"] forKey:@"gender"];
        [dic setObject:[dicTmp valueForKey:@"PROFILEIMAGEURL"] forKey:@"profile_image_url"];
        
        
        
        aUrl = @"weiq/weiq/weix/authlogin.jhtml";
        
    }else if ([strcheck isEqualToString:@"3"]){
        NSString *phoneStr = [GlobalCommon AESDecodeWithString:[dicTmp valueForKey:@"PhoneShortMessage"]];
        if([phoneStr isEqualToString:@""] || phoneStr == nil || phoneStr.length == 0 ){
            phoneStr = [dicTmp valueForKey:@"PhoneShortMessage"];
        }
        aUrl = @"weiq/sms/relogin.jhtml";
        NSString *hhhh = [GlobalCommon getNowTimeTimestamp];
        NSString *iPoneNumber = [NSString stringWithFormat:@"%@%@ky3h.com",phoneStr,hhhh];
        NSString *iPoneNumberMD5 = [GlobalCommon md5:iPoneNumber].uppercaseString;
        
        [dic setObject:phoneStr forKey:@"phone"];
        [dic setObject:iPoneNumberMD5 forKey:@"token"];
        [dic setObject:hhhh forKey:@"timestamp"];
        
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",URL_PRE,aUrl];
    
    AFHTTPSessionManager *manager = [self sharedAFManager];
    
    __weak typeof(self) weakSelf = self;
    
    [manager POST:urlStr parameters:dic  progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if([[responseObject objectForKey:@"status"] intValue] == 100){
            
            UserShareOnce *userShare = [UserShareOnce shareOnce];
            
            userShare.JSESSIONID = [[(NSDictionary *)responseObject objectForKey:@"data"] objectForKey:@"JSESSIONID"];
            userShare.token = [[(NSDictionary *)responseObject objectForKey:@"data"] objectForKey:@"token"];
            
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"loginAgain" object:nil];
            
        }
        if(!isTwo){
            callBack(@"success");
        }
       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if(isTwo){
            [weakSelf loginAgainWithTwo:NO withBlock:nil];
        }else{
            callBack(@"error");
        }
        
    }];
    
}

@end
