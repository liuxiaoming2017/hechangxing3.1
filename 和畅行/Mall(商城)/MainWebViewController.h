//
//  MainWebViewController.h
//  和畅行
//
//  Created by 刘晓明 on 2019/11/13.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "NavBarViewController.h"
#import <WebKit/WebKit.h>


NS_ASSUME_NONNULL_BEGIN


//typedef enum : NSUInteger {
//    progress1,
//    progress2
//} progressType;

@interface MainWebViewController : NavBarViewController

@property (nonatomic,strong) WKWebView *wkwebview;

@property (nonatomic,assign) int popInt;
@property (nonatomic,assign) NSInteger progressType;
- (void)customeViewWithStr:(NSString *)urlStr;
- (NSString*)readCurrentCookieWith:(NSDictionary*)dic;
- (NSMutableString*)getCookieValue;
- (void)hahaAction;
@end

NS_ASSUME_NONNULL_END
