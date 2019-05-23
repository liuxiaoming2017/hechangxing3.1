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
#import "FMDatabaseQueue.h"
#import "HCY_ConsultingModel.h"
#import "RemindModel.h"

#import "HealthTipsModel.h"

@interface CacheManager()

@property(nonatomic, retain) FMDatabase *db;
@property(nonatomic, strong) FMDatabaseQueue *queue;

@end

static CacheManager *__cacheManager = nil;

@implementation CacheManager
@synthesize db = _db;

- (void)dealloc
{
    [self.db close];
    self.db = nil;
    
}

//- (id)initManage
//{
//    self = [super init];
//    if (self) {
//        NSString *docuPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
//        NSString *dbPath = [NSString string];
//        if([UserShareOnce shareOnce].languageType){
//            dbPath = [docuPath stringByAppendingPathComponent:@"questionEn.db"];
//        }else{
//            dbPath = [docuPath stringByAppendingPathComponent:@"question.db"];
//        }
//        self.db = [FMDatabase databaseWithPath:dbPath];
//        [self.db open];
//    }
//    return self;
//}

+ (CacheManager *)sharedCacheManager
{
    if (__cacheManager == nil)
        __cacheManager = [[self alloc] init];
    return __cacheManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSString *docuPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *dbPath = [NSString string];
        if([UserShareOnce shareOnce].languageType){
            dbPath = [docuPath stringByAppendingPathComponent:@"questionEn2.db"];
        }else{
            dbPath = [docuPath stringByAppendingPathComponent:@"question2.db"];
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
        dbPath = [docuPath stringByAppendingPathComponent:@"questionEn2.db"];
    }else{
        dbPath = [docuPath stringByAppendingPathComponent:@"question2.db"];
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
    NSString *questionSql = @"create table if not exists questionTable ('question_id' integer,'order_num' integer, 'createDate' text,'modifyDate' text,'name' text,'reverse' bool,'typeName' text,'allIDStr' text,'classifyId' text)";
    //首页提醒
    NSString *remindSql = @"create table if not exists homeRemindTable ('custid' integer,'advice' text,'action' text, 'isDone' bool,'confId' integer)";
    //首页新闻
    NSString *healthArticleSql = @"create table if not exists healthArticleTable ('picture' text,'title' text,'path' text,'createDate' text)";
    
    //健康档案
   // NSString *archiveSql = @"create table if not exists archiveTable ('custid' integer,'sn' text,'link' text,'date' text,'name' text,'typeName' text,'type' text,'year' text,'time' text,'createTime' text)";
    
    //5.执行更新操作 此处database直接操作，不考虑多线程问题，多线程问题，用FMDatabaseQueue 每次数据库操作之后都会返回bool数值，YES，表示success，NO，表示fail,可以通过 @see lastError @see lastErrorCode @see lastErrorMessage
    BOOL result = [_db executeUpdate:questionSql];
    result  &= [_db executeUpdate:remindSql];
    result  &= [_db executeUpdate:healthArticleSql];
   // result  &= [_db executeUpdate:archiveSql];
    return result;
}
# pragma mark - 往表中插入数据
- (void)insertQuestionModel:(QuestionModel *)model
{
    FMResultSet *set = [_db executeQuery:@"select question_id from questionTable where question_id = ?",[NSNumber numberWithInteger:model.uid]];
    if(![set next]){
        [_db executeUpdate:@"insert into questionTable(question_id,order_num,createDate,modifyDate,name,reverse,typeName,allIDStr,classifyId) values (?,?,?,?,?,?,?,?,?)",[NSNumber numberWithInteger:model.uid],[NSNumber numberWithInteger:model.order],model.createDate,model.modifyDate,model.name,[NSNumber numberWithBool:model.reverse],model.type,model.allIDStr,model.classifyId];
    }
    [set close];
}

- (void)updateOrinsertRemindModel:(RemindModel *)model withCustId:(NSNumber *)custId
{
    FMResultSet *set = [_db executeQuery:@"select custid from homeRemindTable where custid = ? and advice = ? and action = ?",custId,model.advice,model.action];
    if(![set next]){
        [_db executeUpdate:@"insert into homeRemindTable(custid,advice,action,isDone,confId) values (?,?,?,?,?)",custId,model.advice,model.action,[NSNumber numberWithBool:model.isDone],[NSNumber numberWithInteger:model.confId]];
    }
    [set close];
}

- (void)inserthealthArticleModel:(HCY_ConsultingModel *)model
{
    FMResultSet *set = [_db executeQuery:@"select * from healthArticleTable where title = ?",model.title];
    if(![set next]){
        [_db executeUpdate:@"insert into healthArticleTable(picture,title,path,createDate) values (?,?,?,?)",model.picture,model.title,model.path,model.createDate];
    }
    [set close];
}



- (void)insertQuestionModels:(NSArray *)arr
{
    for(QuestionModel *model in arr){
        [self insertQuestionModel:model];
    }
}

- (void)updateOrinsertRemindModels:(NSArray *)arr withCustId:(NSNumber *)custId
{
    FMResultSet *set = [_db executeQuery:@"select custid from homeRemindTable where custid = ?",custId];
    if([set next]){
        [_db executeUpdate:@"delete from homeRemindTable where custid = ?",custId];
    }
    for(RemindModel *model in arr){
        [self updateOrinsertRemindModel:model withCustId:custId];
    }
}

- (void)inserthealthArticleModels:(NSArray *)arr
{
    for(HCY_ConsultingModel *model in arr){
        [self inserthealthArticleModel:model];
    }
}

- (void)insertArchiveModel:(HealthTipsModel *)model
{
    
    FMResultSet *set = [_db executeQuery:@"select * from archiveTable where custid = ? and typeName = ? and createTime = ?",[MemberUserShance shareOnce].idNum,model.typeName,model.createTime];
    if(![set next]){
        [_db executeUpdate:@"insert into archiveTable(custid,sn,link,date,name,typeName,type,year,time,createTime) values (?,?,?,?,?,?,?,?,?,?)",[MemberUserShance shareOnce].idNum,model.sn,model.link,model.date,model.name,model.typeName,model.type,model.year,model.time,model.createTime];
    }
    [set close];
}

- (void)insertArchiveModels:(NSArray *)arr
{
    for(HealthTipsModel *model in arr){
        [self insertArchiveModel:model];
    }
}

# pragma mark - 更新表中数据
- (void)updateQuestionModel:(QuestionModel *)model
{
    
    FMResultSet *set = [_db executeQuery:@"select question_id from questionTable where question_id = ?",[NSNumber numberWithInteger:model.uid]];
    if([set next]){
        [_db executeUpdate:@"update questionTable set question_id = ?,order_num = ?,createDate = ?,modifyDate = ?,name = ?,reverse = ?,typeName = ?,allIDStr = ?,classifyId ?",[NSNumber numberWithInteger:model.uid],[NSNumber numberWithInteger:model.order],model.createDate,model.modifyDate,model.name,[NSNumber numberWithBool:model.reverse],model.type,model.allIDStr,model.classifyId];
    }
    [set close];
}

- (void)updateRemindModel:(RemindModel *)model
{
    
    FMResultSet *set = [_db executeQuery:@"select custid from homeRemindTable where custid = ? and confId = ?",[NSNumber numberWithInteger:model.custid],[NSNumber numberWithInteger:model.confId]];
    if([set next]){
        [_db executeUpdate:@"update homeRemindTable set custid = ?,advice = ?,action = ?,isDone = ?,confId = ?",[NSNumber numberWithInteger:model.custid],model.advice,model.action,[NSNumber numberWithBool:model.isDone],[NSNumber numberWithInteger:model.confId]];
    }
    [set close];
}

- (void)updateQuestionModels:(NSArray *)arr
{
    for(QuestionModel *model in arr){
        [self updateQuestionModel:model];
    }
}

- (void)updateRemindModels:(NSArray *)arr
{
    for(RemindModel *model in arr){
        [self updateRemindModel:model];
    }
}




# pragma mark - 获取表中数据
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
        model.classifyId = [set stringForColumn:@"classifyId"];
        
        [mutabArr addObject:model];
        
    
    }
    [set close];

    return mutabArr;
    
}

- (NSMutableArray *)getRemindModelsWith:(NSNumber *)custID
{
    NSMutableArray *mutabArr = [NSMutableArray arrayWithCapacity:0];
    FMResultSet *set = [_db executeQuery:@"select * from homeRemindTable where custid = ?",custID];
    
    while ([set next]) {
        RemindModel *model = [[RemindModel alloc] init];
        model.custid = [set intForColumn:@"custid"];
        model.advice = [set stringForColumn:@"advice"];
        model.action = [set stringForColumn:@"action"];
        model.isDone = [set boolForColumn:@"isDone"];
        model.confId = [set intForColumn:@"confId"];
        [mutabArr addObject:model];
        
        
    }
    [set close];
    
    return mutabArr;
}

- (NSMutableArray *)gethealthArticleModels
{
    NSMutableArray *mutabArr = [NSMutableArray arrayWithCapacity:0];
    
    FMResultSet *set = [_db executeQuery:@"select * from healthArticleTable limit 20"];
    
    while ([set next]) {
        HCY_ConsultingModel *model = [[HCY_ConsultingModel alloc] init];
        model.picture = [set stringForColumn:@"picture"];
        model.title = [set stringForColumn:@"title"];
        model.path = [set stringForColumn:@"path"];
        model.createDate = [set stringForColumn:@"createDate"];
        [mutabArr addObject:model];
        
        
    }
    [set close];
    
    return mutabArr;
}

- (NSMutableArray *)gethealthArchivesModelsWithIndex:(NSInteger)index andRows:(NSInteger)row
{
    NSMutableArray *mutabArr = [NSMutableArray arrayWithCapacity:0];
    NSString *sqlStr = [NSString stringWithFormat:@"select * from archiveTable where custid = %@ limit %ld,%ld",[MemberUserShance shareOnce].idNum,index,row];
    FMResultSet *set = [_db executeQuery:sqlStr];
    
    while ([set next]) {
        HealthTipsModel *model = [[HealthTipsModel alloc] init];
        model.sn = [set stringForColumn:@"sn"];
        model.link = [set stringForColumn:@"link"];
        model.date = [set stringForColumn:@"date"];
        model.name = [set stringForColumn:@"name"];
        model.typeName = [set stringForColumn:@"typeName"];
        model.type = [set stringForColumn:@"type"];
        model.year = [set stringForColumn:@"year"];
        model.time = [set stringForColumn:@"time"];
        model.createTime = [set stringForColumn:@"createTime"];
        [mutabArr addObject:model];
        
        
    }
    [set close];
    
    return mutabArr;
}

@end
