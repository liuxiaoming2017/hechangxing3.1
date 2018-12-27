//
//  UserShareOnce.m
//  和畅行
//
//  Created by 刘晓明 on 2018/7/5.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "UserShareOnce.h"

static UserShareOnce *shareOnce = nil;
static dispatch_once_t onceToken;

@implementation UserShareOnce

+ (UserShareOnce *)shareOnce
{
    
    dispatch_once(&onceToken,^{
        shareOnce = [[UserShareOnce alloc] init];
    });
    return shareOnce;
}

+(id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareOnce = [super allocWithZone:zone];
    });
    
    return shareOnce;
}

-(id)mutableCopyWithZone:(NSZone *)zone
{
    return shareOnce;
}

-(id)copyWithZone:(NSZone *)zone
{
    return shareOnce;
}


+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"uid" : @"id"//前边的是你想用的key，后边的是返回的key
             };
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    
    if (oldValue == [NSNull null]) {
        
        if ([oldValue isKindOfClass:[NSArray class]]) {
            
            return  @[];
            
        }else if([oldValue isKindOfClass:[NSDictionary class]]){
            
            return @{};
            
        }else{
            
            return @"";
            
        }
        
    }
    
    return oldValue;
    
}

+(void)attemptDealloc{
     onceToken=0l;
}

@end
