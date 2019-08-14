//
//  QuestionModel.h
//  和畅行
//
//  Created by 刘晓明 on 2018/7/12.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionModel : NSObject

/**
 reverse = 0
 description = 您精力充沛吗？
 name = 您精力充沛吗？
 id = 1
 order = 1
 createDate = 1437382312000
 modifyDate = 1437382312000
 **/

@property (nonatomic,assign) NSInteger uid;
@property (nonatomic,assign) NSInteger order;
@property (nonatomic,copy) NSString *createDate;
@property (nonatomic,copy) NSString *modifyDate;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) BOOL reverse;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,assign) NSInteger selectNum;
@property (nonatomic,assign) NSInteger grade;

@property (nonatomic,assign) NSInteger styleID;//题目类型id
@property (nonatomic,assign) NSInteger answerID;//答案ID

@property (nonatomic,copy) NSString *allIDStr;

@property (nonatomic,assign) BOOL isSelected;
//新增
@property (nonatomic,copy) NSString *classifyId;

@property (nonatomic,copy) NSString *selectAnswer;

@end
