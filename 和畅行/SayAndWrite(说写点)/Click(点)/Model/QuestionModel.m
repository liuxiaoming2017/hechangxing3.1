//
//  QuestionModel.m
//  和畅行
//
//  Created by 刘晓明 on 2018/7/12.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "QuestionModel.h"

@implementation QuestionModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"uid" : @"id" //前边的是你想用的key，后边的是返回的key
             };
}



@end
