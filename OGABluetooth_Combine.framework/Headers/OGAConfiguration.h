//
//  OGAConfiguration.h
//  OGABluetooth_Combine
//
//  Created by ogawa on 2019/11/13.
//  Copyright © 2019 Hlin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OGAConfiguration : NSObject

/**
 验证

 @param appKey appkey
 @param appSecret appSecret
 */
+ (void)setAppkey:(NSString *)appKey appSecret:(NSString *)appSecret;

@end

NS_ASSUME_NONNULL_END
