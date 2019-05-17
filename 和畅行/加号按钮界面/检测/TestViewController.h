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

//血压高压
@property (nonatomic,copy) NSString *highPressure;
//血压低压
@property (nonatomic,copy) NSString *lowPressure;
//血糖
@property (nonatomic,copy) NSString *levels;
//心跳
@property (nonatomic,copy) NSString *pulse;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,assign) long inputDate;
@end
