//
//  ResultWriteController.h
//  和畅行
//
//  Created by 刘晓明 on 2018/7/20.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "WKWebviewController.h"

@interface ResultWriteController : WKWebviewController
@property (nonatomic,copy) NSString *urlStr;
@property (nonatomic,assign) BOOL isReturnTop;
@end
