//
//  RemindModel.h
//  和畅行
//
//  Created by 刘晓明 on 2018/7/10.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemindModel : NSObject

@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *action;
@property (nonatomic,copy) NSString *advice;
@property (nonatomic,assign) BOOL isDone;
@property (nonatomic,assign) NSInteger confId;

@property (nonatomic,assign) NSInteger custid;
@end
