//
//  YueYaoController.h
//  和畅行
//
//  Created by 刘晓明 on 2018/7/27.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "SayAndWriteController.h"

@interface YueYaoController : SayAndWriteController

@property (assign, nonatomic) BOOL isYueLuoyi;

- (id)initWithType:(BOOL )isYueLuoyi;

+ (instancetype)sharePlayerController;

@end
