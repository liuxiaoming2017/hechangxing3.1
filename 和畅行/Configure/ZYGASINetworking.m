//
//  ZYGASINetworking.m
//  ASINetworking
//
//  Created by ZhangYunguang on 15/11/23.
//  Copyright (c) 2015年 ZhangYunguang. All rights reserved.
//

#import "ZYGASINetworking.h"
/************* 需注意kAPI_BASE_URL与path的格式（是否带/）    *************/
/************* 若要使用此封装实际需要根据需要更改kAPI_BASE_URL *************/
//NSString * kAPI_BASE_URL = URL_PRE;
//static BOOL sg_shouldAutoEncode = YES;
static NSDictionary *sg_httpHeaders = nil;

@implementation ZYGASINetworking
+(ZYGASINetworking* )shareInstance
{
    static ZYGASINetworking *net = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        net = [[ZYGASINetworking alloc]init];
    });
    return net;
}
//+ (void)updateBaseUrl:(NSString *)baseUrl {
//    kAPI_BASE_URL = baseUrl;
//}
//+ (void)shouldAutoEncodeUrl:(BOOL)shouldAutoEncode {
//    sg_shouldAutoEncode = shouldAutoEncode;
//}
//
//+ (BOOL)shouldEncode {
//    return sg_shouldAutoEncode;
//}

+ (void)configCommonHttpHeaders:(NSDictionary *)httpHeaders {
    sg_httpHeaders = httpHeaders;
}

+ (ASIHTTPRequest *)GET_Path:(NSString *)path completed:(KKCompletedBlock )completeBlock failed:(KKFailedBlock )failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",URL_PRE,path];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlStr];
    __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.requestMethod = @"GET";
    
    //为网络请求添加请求头
    NSDictionary *headers = @{@"version":@"ios_hcy-yh-1.0",@"token":[UserShareOnce shareOnce].token,@"Cookie":[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]};
    [self configCommonHttpHeaders:headers];
    for (NSString *key in sg_httpHeaders.allKeys) {
        if (sg_httpHeaders[key] != nil) {
            [request addRequestHeader:key value:sg_httpHeaders[key]];
        }
    }
    
    [request setCompletionBlock:^{
        NSError *errorForJSON = [NSError errorWithDomain:@"请求数据解析为json格式，发出错误" code:2014 userInfo:@{@"请求数据json解析错误": @"中文",@"serial the data to json error":@"English"}];
        id jsonData = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&errorForJSON];
        completeBlock(jsonData,request.responseString);
    }];
    
    [request setFailedBlock:^{
        failed([request error]);
    }];
    
    [request startAsynchronous];
    
    //NSLog(@"ASIClient GET: %@",[request url]);
    
    return request;
}

+ (ASIHTTPRequest *)GET_Path:(NSString *)path params:(NSDictionary *)paramsDic completed:(KKCompletedBlock )completeBlock failed:(KKFailedBlock )failed
{
    NSMutableString *paramsString = [NSMutableString stringWithCapacity:1];
    [paramsDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [paramsString appendFormat:@"%@=%@",key,obj];
        [paramsString appendString:@"&"];
    }];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@?%@",URL_PRE,path,paramsString];
    urlStr = [urlStr substringToIndex:urlStr.length-1];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.requestMethod = @"GET";
    //为网络请求添加请求头
    NSDictionary *headers = @{@"version":@"ios_hcy-yh-1.0",@"token":[UserShareOnce shareOnce].token,@"Cookie":[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]};
    [self configCommonHttpHeaders:headers];
    for (NSString *key in sg_httpHeaders.allKeys) {
        if (sg_httpHeaders[key] != nil) {
           // [request addRequestHeader:key value:sg_httpHeaders[key]];
        }
    }
    
    [request setCompletionBlock:^{
        NSError *errorForJSON = [NSError errorWithDomain:@"请求数据解析为json格式，发出错误" code:2014 userInfo:@{@"请求数据json解析错误": @"中文",@"serial the data to json error":@"English"}];
        id jsonData = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&errorForJSON];
        completeBlock(jsonData,request.responseString);
    }];
    
    [request setFailedBlock:^{
        failed([request error]);
    }];
    
    [request startAsynchronous];
    
    //NSLog(@"ASIClient GET: %@",[request url]);
    
    return request;
}


+ (ASIHTTPRequest *)POST_Path:(NSString *)path params:(NSDictionary *)paramsDic completed:(KKCompletedBlock )completeBlock failed:(KKFailedBlock )failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",URL_PRE,path];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlStr];
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.requestMethod = @"POST";
    //为网络请求添加请求头
    NSDictionary *headers = @{@"version":@"ios_hcy-yh-1.0",@"token":[UserShareOnce shareOnce].token,@"Cookie":[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID],
                              @"language" :[UserShareOnce shareOnce].languageType
                              };
    [self configCommonHttpHeaders:headers];
    for (NSString *key in sg_httpHeaders.allKeys) {
        if (sg_httpHeaders[key] != nil) {
            [request addRequestHeader:key value:sg_httpHeaders[key]];
        }
    }
    
    [paramsDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [request setPostValue:obj forKey:key];
    }];
    
    [request setCompletionBlock:^{
        NSError *errorForJSON = [NSError errorWithDomain:@"请求数据解析为json格式，发出错误" code:2014 userInfo:@{@"请求数据json解析错误": @"中文",@"serial the data to json error":@"English"}];
        id jsonData = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&errorForJSON];
        completeBlock(jsonData,request.responseString);
    }];
    
    [request setFailedBlock:^{
        failed([request error]);
    }];
    
    [request startAsynchronous];
    
    //NSLog(@"ASIClient POST: %@ %@",[request url],paramsDic);
    
    return request;
}


+ (ASIHTTPRequest *)DownFile_Path:(NSString *)path writeTo:(NSString *)destination fileName:(NSString *)name setProgress:(KKProgressBlock)progressBlock completed:(ASIBasicBlock)completedBlock failed:(KKFailedBlock )failed
{
//    if ([self shouldEncode]) {
//        path = [self encodeUrl:path];
//    }
    __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:path]];
    //为网络请求添加请求头
    NSDictionary *headers = @{@"version":@"ios_hcy-yh-1.0",@"token":[UserShareOnce shareOnce].token,@"Cookie":[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]};
    [self configCommonHttpHeaders:headers];
    for (NSString *key in sg_httpHeaders.allKeys) {
        if (sg_httpHeaders[key] != nil) {
            [request addRequestHeader:key value:sg_httpHeaders[key]];
        }
    }
    NSString *filePath = nil;
    if ([destination hasSuffix:@"/"]) {
        filePath = [NSString stringWithFormat:@"%@%@",destination,name];
    }
    else
    {
        filePath = [NSString stringWithFormat:@"%@/%@",destination,name];
    }
    [request setDownloadDestinationPath:filePath];
    
    __block float downProgress = 0;
    [request setBytesReceivedBlock:^(unsigned long long size, unsigned long long total) {
        downProgress += (float)size/total;
        progressBlock(downProgress);
    }];
    
    [request setCompletionBlock:^{
        downProgress = 0;
        completedBlock();
    }];
    
    [request setFailedBlock:^{
        failed([request error]);
    }];
    
    [request startAsynchronous];
    
    //NSLog(@"ASIClient 下载文件：%@ ",path);
    //NSLog(@"ASIClient 保存路径：%@",filePath);
    
    return request;
}


+ (ASIHTTPRequest *)UploadFile_Path:(NSString *)path file:(NSString *)filePath forKey:(NSString *)fileKey params:(NSDictionary *)params SetProgress:(KKProgressBlock )progressBlock completed:(KKCompletedBlock )completedBlock failed:(KKFailedBlock )failed
{
//    if ([self shouldEncode]) {
//        path = [self encodeUrl:path];
//    }
    NSURL *url = [NSURL URLWithString:path];
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    //为网络请求添加请求头
    NSDictionary *headers = @{@"version":@"ios_hcy-yh-1.0",@"token":[UserShareOnce shareOnce].token,@"Cookie":[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID],@"language" :[UserShareOnce shareOnce].languageType };
    [self configCommonHttpHeaders:headers];
    for (NSString *key in sg_httpHeaders.allKeys) {
        if (sg_httpHeaders[key] != nil) {
            [request addRequestHeader:key value:sg_httpHeaders[key]];
        }
    }
    [request setFile:filePath forKey:fileKey];
    if (params.count > 0) {
        [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [request setPostValue:obj forKey:key];
        }];
    }
    
    __block float upProgress = 0;
    [request setBytesSentBlock:^(unsigned long long size, unsigned long long total) {
        upProgress += (float)size/total;
        progressBlock(upProgress);
    }];
    
    [request setCompletionBlock:^{
        upProgress=0;
        NSError *errorForJSON = [NSError errorWithDomain:@"请求数据解析为json格式，发出错误" code:2014 userInfo:@{@"请求数据json解析错误": @"中文",@"serial the data to json error":@"English"}];
        id jsonData = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&errorForJSON];
        completedBlock(jsonData,[request responseString]);
    }];
    
    [request setFailedBlock:^{
        failed([request error]);
    }];
    
    [request startAsynchronous];
    
    //NSLog(@"ASIClient 文件上传：%@ file=%@ key=%@",path,filePath,fileKey);
    //NSLog(@"ASIClient 文件上传参数：%@",params);
    
    return request;
}


+ (ASIHTTPRequest *)UploadData_Path:(NSString *)path fileData:(NSData *)fData forKey:(NSString *)dataKey params:(NSDictionary *)params SetProgress:(KKProgressBlock )progressBlock completed:(KKCompletedBlock )completedBlock failed:(KKFailedBlock )failed
{
//    if ([self shouldEncode]) {
//        path = [self encodeUrl:path];
//    }
    NSURL *url = [NSURL URLWithString:path];
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setData:fData forKey:dataKey];
    //为网络请求添加请求头
    NSDictionary *headers = @{@"version":@"ios_hcy-yh-1.0",@"token":[UserShareOnce shareOnce].token,@"Cookie":[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID],@"language" :[UserShareOnce shareOnce].languageType };
    [self configCommonHttpHeaders:headers];
    for (NSString *key in sg_httpHeaders.allKeys) {
        if (sg_httpHeaders[key] != nil) {
            [request addRequestHeader:key value:sg_httpHeaders[key]];
        }
    }
    if (params.count > 0) {
        [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [request setPostValue:obj forKey:key];
        }];
    }
    
    __block float upProgress = 0;
    [request setBytesSentBlock:^(unsigned long long size, unsigned long long total) {
        upProgress += (float)size/total;
        progressBlock(upProgress);
    }];
    
    [request setCompletionBlock:^{
        upProgress=0;
        NSError *errorForJSON = [NSError errorWithDomain:@"请求数据解析为json格式，发出错误" code:2014 userInfo:@{@"请求数据json解析错误": @"中文",@"serial the data to json error":@"English"}];
        id jsonData = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&errorForJSON];
        completedBlock(jsonData,[request responseString]);
    }];
    
    [request setFailedBlock:^{
        failed([request error]);
    }];
    
    [request startAsynchronous];
    
    //NSLog(@"ASIClient 文件上传：%@ size=%.2f MB  key=%@",path,fData.length/1024.0/1024.0,dataKey);
    //NSLog(@"ASIClient 文件上传参数：%@",params);
    
    return request;
}


+ (ASIHTTPRequest *)ResumeDown_Path:(NSString *)path writeTo:(NSString *)destinationPath tempPath:(NSString *)tempPath fileName:(NSString *)name setProgress:(KKProgressBlock )progressBlock completed:(ASIBasicBlock )completedBlock failed:(KKFailedBlock )failed
{
//    if ([self shouldEncode]) {
//        path = [self encodeUrl:path];
//    }
    __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:path]];
    //为网络请求添加请求头
    NSDictionary *headers = @{@"version":@"ios_hcy-yh-1.0",@"token":[UserShareOnce shareOnce].token,@"Cookie":[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]};
    [self configCommonHttpHeaders:headers];
    for (NSString *key in sg_httpHeaders.allKeys) {
        if (sg_httpHeaders[key] != nil) {
            [request addRequestHeader:key value:sg_httpHeaders[key]];
        }
    }
    NSString *filePath = nil;
    if ([destinationPath hasSuffix:@"/"]) {
        filePath = [NSString stringWithFormat:@"%@%@",destinationPath,name];
    }
    else
    {
        filePath = [NSString stringWithFormat:@"%@/%@",destinationPath,name];
    }
    
    [request setDownloadDestinationPath:filePath];
    
    NSString *tempForDownPath = nil;
    if ([tempPath hasSuffix:@"/"]) {
        tempForDownPath = [NSString stringWithFormat:@"%@%@.download",tempPath,name];
    }
    else
    {
        tempForDownPath = [NSString stringWithFormat:@"%@/%@.download",tempPath,name];
    }
    
    [request setTemporaryFileDownloadPath:tempForDownPath];
    [request setAllowResumeForFileDownloads:YES];
    
    __block float downProgress = 0;
    downProgress = [[NSUserDefaults standardUserDefaults] floatForKey:@"ASIClient_ResumeDOWN_PROGRESS"];
    [request setBytesReceivedBlock:^(unsigned long long size, unsigned long long total) {
        downProgress += (float)size/total;
        if (downProgress >1.0) {
            downProgress=1.0;
        }
        [[NSUserDefaults standardUserDefaults] setFloat:downProgress forKey:@"ASIClient_ResumeDOWN_PROGRESS"];
        progressBlock(downProgress);
    }];
    
    [request setCompletionBlock:^{
        downProgress = 0;
        [[NSUserDefaults standardUserDefaults] setFloat:downProgress forKey:@"ASIClient_ResumeDOWN_PROGRESS"];
        completedBlock();
        if ([[NSFileManager defaultManager] fileExistsAtPath:tempForDownPath]) {
            //NSError *errorForDelete = [NSError errorWithDomain:@"删除临时文件发生错误！" code:2015 userInfo:@{@"删除临时文件发生错误": @"中文",@"delete the temp fife error":@"English"}];
            //[[NSFileManager defaultManager] removeItemAtPath:tempForDownPath error:&errorForDelete];
            //NSLog(@"l  %d> %s",__LINE__,__func__);
        }
    }];
    
    [request setFailedBlock:^{
        failed([request error]);
    }];
    
    [request startAsynchronous];
    
    //NSLog(@"ASIClient 下载文件：%@ ",path);
    //NSLog(@"ASIClient 保存路径：%@",filePath);
    if (downProgress >0 && downProgress) {
        if (downProgress >=1.0) downProgress = 0.9999;
        //NSLog(@"ASIClient 上次下载已完成：%.2f/100",downProgress*100);
    }
    return request;
}

//+ (NSString *)encodeUrl:(NSString *)url {
//    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//}
@end
