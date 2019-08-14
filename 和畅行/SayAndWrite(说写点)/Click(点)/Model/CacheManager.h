//
//  CacheManager.h
//  和畅行
//
//  Created by 刘晓明 on 2018/7/13.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QuestionModel;
@class RemindModel;
@interface CacheManager : NSObject

- (void)insertQuestionModel:(QuestionModel *)model;
- (void)updateQuestionModel:(QuestionModel *)model;
- (void)insertQuestionModels:(NSArray *)arr;
- (void)updateQuestionModels:(NSArray *)arr;
- (NSMutableArray *)getQuestionModels;
- (BOOL)createDataBase;
+ (CacheManager *)sharedCacheManager;



- (void)updateOrinsertRemindModels:(NSArray *)arr withCustId:(NSNumber *)custId;
- (NSMutableArray *)getRemindModelsWith:(NSNumber *)custID;

- (void)inserthealthArticleModels:(NSArray *)arr;
- (NSMutableArray *)gethealthArticleModels;

- (void)updateRemindModel:(RemindModel *)model;


- (void)insertArchiveModels:(NSArray *)arr;
- (NSMutableArray *)gethealthArchivesModelsWithIndex:(NSInteger)index andRows:(NSInteger)row;
@end
