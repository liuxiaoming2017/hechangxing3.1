//
//  AnwerModel.m
//  和畅行
//
//  Created by 刘晓明 on 2018/7/13.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "AnwerModel.h"

@implementation AnwerModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"answer_id" : @"id" //前边的是你想用的key，后边的是返回的key
             };
}

@end
