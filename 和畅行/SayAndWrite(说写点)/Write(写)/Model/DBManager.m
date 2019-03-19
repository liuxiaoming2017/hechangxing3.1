//
//  DBManager.m
//  Voicediagno
//
//  Created by ZhangYunguang on 15/12/7.
//  Copyright © 2015年 ZhangYunguang. All rights reserved.
//

#import "DBManager.h"

@implementation DBManager
{
    //数据库对象
    FMDatabase *_database;
}
+ (DBManager *)sharedManager{
    static DBManager *manager = nil;
    @synchronized(self) {
        if (manager == nil) {
            manager = [[self alloc] init];
        }
    }
    return manager;
}



- (id)init {
    if (self = [super init]) {
        /**
         *  在这个部分中我么进行一下操作：（要把数据库文件存放到储存的位置中）
         *  1.获取应用程序的路径，在手机中就是应用程序存储数据的地方
         *  2.把数据库文件的名称拼接到上面得到的路径上
         *  3.根据拼接好的路径去寻找，并判断这个文件是否存在
         */
        
        NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
        NSString *doc = [searchPaths objectAtIndex:0];
        NSString *dbFilePath = [doc stringByAppendingPathComponent:@"ICD10.db"];
        NSFileManager *fm = [NSFileManager defaultManager];
        BOOL isExist = [fm fileExistsAtPath:dbFilePath];
        if (!isExist) {
            //拷贝数据库
            //NSString *backupDbPath =[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ICD10.db"];
            NSString *backupDbPath = [[NSBundle mainBundle] pathForResource:@"ICD10" ofType:@"db"];
            NSError *error = [[NSError alloc] init];
            BOOL cp = [fm copyItemAtPath:backupDbPath toPath:dbFilePath error:&error];
            if (cp) {
                NSLog(@"数据库拷贝成功");
            }else{
                NSLog(@"数据库拷贝失败： %@",[error localizedDescription]);
            }
        }

        _database = [[FMDatabase alloc] initWithPath:dbFilePath];
        if ([_database open]) {
            NSLog(@"数据库打开成功");
        }else {
            NSLog(@"database open failed:%@",_database.lastErrorMessage);
        }
    }
    return self;
}
#pragma mark-读所有的数据
-(NSArray *)readAllModels{
    if([_database close]){
        [_database open];
    }
    NSString *sql = @"select * from ICD10";
    FMResultSet *rs = [_database executeQuery:sql];
    NSMutableArray *marr = [NSMutableArray arrayWithCapacity:0];
    while ([rs next]) {
        OrganDiseaseModel *model = [[OrganDiseaseModel alloc] init];
        if ([UserShareOnce shareOnce].languageType){
            model.content = [rs stringForColumn:@"content_en"];
        }else{
            model.content = [rs stringForColumn:@"content"];
        }
        
        model.MICD = [rs stringForColumn:@"MICD"];
        model.MTJI = [rs stringForColumn:@"MTJI"];
        model.SEX = [rs intForColumn:@"SEX"];
        [marr addObject:model];
    }
    [_database close];
    return marr;
}
#pragma mark-根据查找关键字读数据
-(NSArray *)readModelsWith:(NSString *)keyWords{
    if([_database close]){
        [_database open];
    }
     NSString *sql = @"select * from ICD10 where content like ?";
    if ([UserShareOnce shareOnce].languageType){
        sql = @"select * from ICD10 where content_en like ?";
    }
   
    FMResultSet *rs = [_database executeQuery:sql,[NSString stringWithFormat:@"%%%@%%",keyWords]];
    NSMutableArray *marr = [NSMutableArray arrayWithCapacity:0];
    while ([rs next]) {
        OrganDiseaseModel *model = [[OrganDiseaseModel alloc] init];
        if ([UserShareOnce shareOnce].languageType){
            model.content = [rs stringForColumn:@"content_en"];
        }else{
            model.content = [rs stringForColumn:@"content"];
        }
        model.MICD = [rs stringForColumn:@"MICD"];
        model.MTJI = [rs stringForColumn:@"MTJI"];
        model.SEX = [rs intForColumn:@"SEX"];
        [marr addObject:model];
    }
    [_database close];
    return marr;
}

@end
