//
//  CacheManager.h
//  和畅行
//
//  Created by 刘晓明 on 2018/7/13.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QuestionModel;
//@class AnwerModel;
@interface CacheManager : NSObject

- (void)insertQuestionModel:(QuestionModel *)model;
- (void)updateQuestionModel:(QuestionModel *)model;
- (void)insertQuestionModels:(NSArray *)arr;
- (void)updateQuestionModels:(NSArray *)arr;
- (NSMutableArray *)getQuestionModels;
- (BOOL)createDataBase;
- (id)initManage;

//- (void)insertAnswerModel:(AnwerModel *)model;
- (void)insertAnswerModels:(NSArray *)arr;
- (void)updateAnswerModels:(NSArray *)arr;
- (NSArray *)getAnswerModelsWithName:(NSString *)nameStr;
@end
