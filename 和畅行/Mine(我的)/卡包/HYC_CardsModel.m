//
//  HYC_CardsModel.m
//  和畅行
//
//  Created by 出神入化 on 2018/12/17.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "HYC_CardsModel.h"

@implementation HYC_CardsModel


- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if([key isEqualToString:@"description"])
        self.cardDescription = value;
}


+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"name" : @"n",
             @"page" : @"p",
             @"desc" : @"ext.desc",
             @"cardDescription" : @"description"};
}


@end
