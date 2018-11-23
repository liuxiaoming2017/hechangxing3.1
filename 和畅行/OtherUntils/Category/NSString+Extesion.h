//
//  NSString+Extesion.h
//  hechangyi
//
//  Created by HMac on 16/5/11.
//  Copyright © 2016年 HMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extesion)
/**
 *  身份证号校验
 *
 *  @param idCard 身份证号
 *
 *  @return 校验结果
 */
+ (BOOL)stringWithIDCardValidate:(NSString *)idCard;
@end
