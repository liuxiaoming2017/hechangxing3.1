//
//  NetworkManager.h
//  和畅行
//
//  Created by 刘晓明 on 2018/7/5.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BAWeak  __weak __typeof(self) weakSelf = self

/*！定义请求类型的枚举 */
typedef NS_ENUM(NSUInteger, BAHttpRequestType)
{
    /*! get请求 */
    BAHttpRequestTypeGet = 0,
    /*! post请求 */
    BAHttpRequestTypePost,
    
    BAHttpRequestTypeHeadGet,
    /*post请求 返回格式不一样*/
    BAHttpRequestTypeCookiePost,
    /*post请求 提交文件*/
    BAHttpRequestTypeFilePost,
    /*! put请求 */
    BAHttpRequestTypePut,
    /*! delete请求 */
    BAHttpRequestTypeDelete
    
};
/*! formDataBlock */
typedef void( ^ BAResponseForm)(id request);

/*! 定义请求成功的 block */
typedef void( ^ BAResponseSuccess)(id response);
/*! 定义请求失败的 block */
typedef void( ^ BAResponseFail)(NSError *error);

/*! 定义上传进度 block */
typedef void( ^ BAUploadProgress)(int64_t bytesProgress,
                                  int64_t totalBytesProgress);
/*! 定义下载进度 block */
typedef void( ^ BADownloadProgress)(int64_t bytesProgress,
                                    int64_t totalBytesProgress);

typedef NSURLSessionTask BAURLSessionTask;

@interface NetworkManager : NSObject

+ (NetworkManager *)sharedNetworkManager;

- (void)requestWithType:(BAHttpRequestType)type
                               urlString:(NSString *)urlString
                              parameters:(NSDictionary *)parameters
                            successBlock:(BAResponseSuccess)successBlock
                            failureBlock:(BAResponseFail)failureBlock;

- (void)requestWithCookieType:(BAHttpRequestType)type
                    urlString:(NSString *)urlString
               headParameters:(NSDictionary *)headerDic
                   parameters:(NSMutableDictionary *)parameters
                 successBlock:(BAResponseSuccess)successBlock
                 failureBlock:(BAResponseFail)failureBlock;

- (void)loginAgainWithTwo:(BOOL)isTwo withBlock:(void(^)(NSString * blockParam))callBack;

-(void)mainThreadRequestWithUrl:(NSString *)myUrl token:(NSString *)token dic:(NSDictionary *)dic;

+ (void)dataGetMethod:(NSString *)urlString withParams:(NSDictionary *)params withBlock:(void (^)(NSURLResponse *response, id responseObject, NSError * error))block;
@end
