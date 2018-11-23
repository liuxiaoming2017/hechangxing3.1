//
//  BloodSugerModel.m
//  Voicediagno
//
//  Created by Mymac on 15/10/22.
//  Copyright (c) 2015年 Mymac. All rights reserved.
//

#import "BloodSugerModel.h"

@implementation BloodSugerModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"idNum" : @"id"//前边的是你想用的key，后边的是返回的key
             };
}

@end
