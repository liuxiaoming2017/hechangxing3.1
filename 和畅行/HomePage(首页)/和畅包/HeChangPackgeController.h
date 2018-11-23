//
//  HeChangPackgeController.h
//  和畅行
//
//  Created by 刘晓明 on 2018/8/1.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "WKWebviewController.h"

@interface HeChangPackgeController : WKWebviewController

@property (nonatomic,copy) NSString *urlStr;
@property (nonatomic,copy) NSString *titleStr;
@property (nonatomic,assign) BOOL noWebviewBack;
@end
