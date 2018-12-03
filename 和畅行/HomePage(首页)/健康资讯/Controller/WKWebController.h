//
//  WKWebviewController.h
//  和畅行
//
//  Created by 刘晓明 on 2018/7/20.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "SayAndWriteController.h"
#import <WebKit/WebKit.h>

typedef enum : NSUInteger {
    progress1,
    progress2,
} progressType;

@interface WKWebController :SayAndWriteController

@property (nonatomic ,retain) NSString *dataStr;
@property (nonatomic ,retain) NSString *titleStr;

@property (nonatomic,strong) WKWebView *wkwebview;
@property (nonatomic,assign) NSInteger progressType;
- (void)customeViewWithStr:(NSString *)urlStr;
- (NSString*)readCurrentCookieWith:(NSDictionary*)dic;
@end
