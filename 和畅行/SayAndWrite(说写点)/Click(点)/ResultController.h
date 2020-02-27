//
//  ResultController.h
//  和畅行
//
//  Created by 刘晓明 on 2018/7/18.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "WKWebviewController.h"


@interface ResultController : WKWebviewController

@property (nonatomic,copy) NSString *TZBSstr;
@property (nonatomic,assign) NSInteger subCatId;//评估结论分类表的id
@property (nonatomic,copy) NSString *typePointStr;
@end
