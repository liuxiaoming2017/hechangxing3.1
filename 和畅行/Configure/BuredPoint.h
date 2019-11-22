//
//  BuredPoint.h
//  YHBuriedPoint
//
//  Created by Wei Zhao on 2019/6/21.
//  Copyright © 2019 Wei Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*! 定义请求成功的 block */
typedef void( ^ BAResponseSuccess)(id response);
/*! 定义请求失败的 block */
typedef void( ^ BAResponseFail)(NSError *error);

/*! 定义请求结果的 block */
typedef void( ^ BAResponseResult)(id response);

@interface BuredPoint : NSObject
+ (BuredPoint *)sharedYHBuriedPoint;


//算年龄
+(NSString *)calculateAgeStr:(NSString *)str;

//获取手机型号
+(NSString *)getCurrentDeviceModel;

//获取屏幕分辨率
+(NSString *)getScreenPix;

//获取本机运营商名称
+(NSString *)getOperator;



//设置key
-(void)setTheSignatureWithSignStr:(NSString *)signString
                      withOpenStr:(NSString *)openStr
                  withLacationKey:(NSString *)lacationKey;

//获取埋点token
-(void)getTokenWithUrl:(NSString *)myUrl  dic:(NSDictionary *)dic successBlock:(BAResponseSuccess)successBlock failureBlock:(BAResponseFail)failureBlock;
//无定位异步请求
-(void)submitWithUrl:(NSString *)url  dic:(NSDictionary *)dic successBlock:(BAResponseSuccess)successBlock failureBlock:(BAResponseFail)failureBlock;

//无定位同步请求
-(void)mainThreadRequestWithUrl:(NSString *)myUrl  dic:(NSDictionary *)dic resultBlock:(BAResponseResult)resultBlock;

//有定位的同步请求
-(void)mainLocationThreadRequestWithUrl:(NSString *)myUrl dic:(NSDictionary *)dic resultBlock:(BAResponseResult)resultBlock;
//有定位的异步请求
-(void)submitLocationWithUrl:(NSString *)myUrl Dic:(NSDictionary *)dic successBlock:(BAResponseSuccess)successBlock failureBlock:(BAResponseFail)failureBlock;

@end

NS_ASSUME_NONNULL_END
