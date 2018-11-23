//
//  ShareProcessPoll.m
//  壳子代码
//
//  Created by 黄柳姣 on 2018/4/9.
//  Copyright © 2018年 Liuxiaoming. All rights reserved.
//

#import "ShareProcessPoll.h"

@implementation ShareProcessPoll

+ (ShareProcessPoll *)shareOnce
{
    static ShareProcessPoll *shareOnce = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        shareOnce = [[ShareProcessPoll alloc] init];
    });
    return shareOnce;
}
@end
