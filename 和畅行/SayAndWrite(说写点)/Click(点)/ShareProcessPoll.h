//
//  ShareProcessPoll.h
//  壳子代码
//
//  Created by 黄柳姣 on 2018/4/9.
//  Copyright © 2018年 Liuxiaoming. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface ShareProcessPoll : WKProcessPool

+ (ShareProcessPoll *)shareOnce;

@end
