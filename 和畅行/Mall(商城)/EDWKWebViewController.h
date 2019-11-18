//
//  EDWKWebViewController.h
//  CookieStorageDemo
//
//  Created by Ella on 2018/5/21.
//  Copyright © 2018年 com.dove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavBarViewController.h"

@interface EDWKWebViewController : NavBarViewController
@property (nonatomic,assign) BOOL isCollect;
@property (nonatomic,copy) NSString *titleStr;
@property (nonatomic,copy) NSString *pageIDStr;
- (instancetype)initWithUrlString:(NSString *)url;

@end
