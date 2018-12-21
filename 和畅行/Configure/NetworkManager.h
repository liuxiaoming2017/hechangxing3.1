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
    /*! put请求 */
    BAHttpRequestTypePut,
    /*! delete请求 */
    BAHttpRequestTypeDelete
};


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
- (void)requestWithType:(BAHttpRequestType)type
              urlString:(NSString *)urlString
         headParameters:(NSDictionary *)headerDic
             parameters:(NSDictionary *)parameters
           successBlock:(BAResponseSuccess)successBlock
           failureBlock:(BAResponseFail)failureBlock;



@end
