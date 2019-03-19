//
//  CacheManager.m
//  和畅行
//
//  Created by 刘晓明 on 2018/7/13.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "CacheManager.h"
#import "QuestionModel.h"
#import "FMDatabase.h"
#import "AnwerModel.h"

@interface CacheManager()

@property(nonatomic, retain) FMDatabase *db;

@end

@implementation CacheManager
@synthesize db = _db;

- (void)dealloc
{
    [self.db close];
    self.db = nil;
    
}

- (id)initManage
{
    self = [super init];
    if (self) {
        NSString *docuPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *dbPath = [NSString string];
        if([UserShareOnce shareOnce].languageType){
            dbPath = [docuPath stringByAppendingPathComponent:@"questionEn.db"];
        }else{
            dbPath = [docuPath stringByAppendingPathComponent:@"question.db"];
        }
        self.db = [FMDatabase databaseWithPath:dbPath];
        [self.db open];
    }
    return self;
}

- (BOOL)createDataBase
{
    NSString *docuPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbPath = [NSString string];
    if([UserShareOnce shareOnce].languageType){
        dbPath = [docuPath stringByAppendingPathComponent:@"questionEn.db"];
    }else{
        dbPath = [docuPath stringByAppendingPathComponent:@"question.db"];
    }
    //2.创建对应路径下数据库
    _db = [FMDatabase databaseWithPath:dbPath];
    //3.在数据库中进行增删改查操作时，需要判断数据库是否open，如果open失败，可能是权限或者资源不足，数据库操作完成通常使用close关闭数据库
    BOOL res = [_db open];
    if (!res) {
        NSLog(@"db open fail");
        return NO;
    }
    //4.数据库中创建表（可创建多张）
    NSString *sql = @"create table if not exists questionTable ('question_id' integer,'order_num' integer, 'createDate' text,'modifyDate' text,'name' text,'reverse' bool,'typeName' text,'allIDStr' text)";
    //NSString *sql2 = @"create table if not exists answerTable ('answer_id' integer,'type_id' integer,'order_num' integer, 'content' text,'question_name' text)";
    //5.执行更新操作 此处database直接操作，不考虑多线程问题，多线程问题，用FMDatabaseQueue 每次数据库操作之后都会返回bool数值，YES，表示success，NO，表示fail,可以通过 @see lastError @see lastErrorCode @see lastErrorMessage
    BOOL result = [_db executeUpdate:sql];
//    BOOL result2 = NO;
//    if (result) {
//        result2 = [_db executeUpdate:sql2];
//        if(result2){
//             NSLog(@"create table success");
//        }
//    }
    //[_db close];
    return result;
}

- (void)insertQuestionModel:(QuestionModel *)model
{
    FMResultSet *set = [_db executeQuery:@"select question_id from questionTable where question_id = ?",[NSNumber numberWithInteger:model.uid]];
    if(![set next]){
        [_db executeUpdate:@"insert into questionTable(question_id,order_num,createDate,modifyDate,name,reverse,typeName,allIDStr) values (?,?,?,?,?,?,?,?)",[NSNumber numberWithInteger:model.uid],[NSNumber numberWithInteger:model.order],model.createDate,model.modifyDate,model.name,[NSNumber numberWithBool:model.reverse],model.type,model.allIDStr];
    }
    [set close];
}



- (void)insertQuestionModels:(NSArray *)arr
{
    for(QuestionModel *model in arr){
        [self insertQuestionModel:model];
    }
}


- (void)updateQuestionModel:(QuestionModel *)model
{
    
    FMResultSet *set = [_db executeQuery:@"select question_id from questionTable where question_id = ?",[NSNumber numberWithInteger:model.uid]];
    if([set next]){
        [_db executeUpdate:@"update questionTable set question_id = ?,order_num = ?,createDate = ?,modifyDate = ?,name = ?,reverse = ?,typeName = ?,allIDStr = ?",[NSNumber numberWithInteger:model.uid],[NSNumber numberWithInteger:model.order],model.createDate,model.modifyDate,model.name,[NSNumber numberWithBool:model.reverse],model.type,model.allIDStr];
    }
    [set close];
}

- (void)updateQuestionModels:(NSArray *)arr
{
    for(QuestionModel *model in arr){
        [self updateQuestionModel:model];
    }
}

- (void)insertAnswerModel:(AnwerModel *)model
{
    //@"create table if not exists answerTable ('answer_id' integer,'type_id' integer,'order_num' integer, 'content' text,'question_name' text)"
    FMResultSet *set = [_db executeQuery:@"select answer_id from answerTable where answer_id = ?",[NSNumber numberWithInteger:model.answer_id]];
    if(![set next]){
        [_db executeUpdate:@"insert into answerTable(answer_id,type_id,order_num,content,question_name) values (?,?,?,?,?,?)",[NSNumber numberWithInteger:model.answer_id],[NSNumber numberWithInteger:model.type_id],[NSNumber numberWithInteger:model.order],model.content,model.name];
    }
    [set close];
}

- (void)insertAnswerModels:(NSArray *)arr
{
    for(AnwerModel *model in arr){
        [self insertAnswerModel:model];
    }
}
- (void)updateAnswerModel:(AnwerModel *)model
{
    FMResultSet *set = [_db executeQuery:@"select answer_id from answerTable where answer_id = ?",[NSNumber numberWithInteger:model.answer_id]];
    if([set next]){
        [_db executeUpdate:@"update questionTable set answer_id = ?,type_id = ?,order_num = ?,content = ?,question_name = ?",[NSNumber numberWithInteger:model.answer_id],[NSNumber numberWithInteger:model.type_id],[NSNumber numberWithBool:model.order],model.content,model.name];
    }
    [set close];
}

- (void)updateAnswerModels:(NSArray *)arr
{
    for(AnwerModel *model in arr){
        [self updateAnswerModel:model];
    }
}


- (NSMutableArray *)getQuestionModels
{
    NSMutableArray *mutabArr = [[NSMutableArray alloc] init];
    //FMResultSet *set = [_db executeQuery:@"select *,count(distinct order_num) from questionTable group by order_num order by order_num limit 20"];
    FMResultSet *set = [_db executeQuery:@"select * from questionTable order by order_num"];
    while ([set next]) {
        QuestionModel *model = [[QuestionModel alloc] init];
        model.uid = [set intForColumn:@"question_id"];
        model.order = [set intForColumn:@"order_num"];
        model.createDate = [set stringForColumn:@"createDate"];
        model.modifyDate = [set stringForColumn:@"modifyDate"];
        model.name = [set stringForColumn:@"name"];
        model.reverse = [set boolForColumn:@"reverse"];
        model.type = [set stringForColumn:@"typeName"];
        model.allIDStr = [set stringForColumn:@"allIDStr"];
        [mutabArr addObject:model];
    }
    [set close];
    return mutabArr;
    
}

- (NSArray *)getAnswerModelsWithName:(NSString *)nameStr
{
    NSMutableArray *mutabArr = [[NSMutableArray alloc] init];
    FMResultSet *set = [_db executeQuery:@"select * from answerTable group by question_name"];
    while ([set next]) {
        AnwerModel *model = [[AnwerModel alloc] init];
        model.answer_id = [set intForColumn:@"answer_id"];
        model.type_id = [set intForColumn:@"type_id"];
        model.order = [set intForColumn:@"order_num"];
        model.content = [set stringForColumn:@"content"];
        model.name = [set stringForColumn:@"question_name"];
        [mutabArr addObject:model];
    }
    return mutabArr;
}

@end
