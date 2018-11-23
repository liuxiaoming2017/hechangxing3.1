//
//  TestViewController.h
//  和畅行
//
//  Created by 刘晓明 on 2018/8/16.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "SayAndWriteController.h"

@interface TestViewController : SayAndWriteController

@end

@interface TestValueModel:NSObject

@property (nonatomic,assign) long createDate;

@property (nonatomic,copy) NSString *valueStr;

@end
