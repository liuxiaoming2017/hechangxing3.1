//
//  DBManager.h
//  Voicediagno
//
//  Created by ZhangYunguang on 15/12/7.
//  Copyright © 2015年 ZhangYunguang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "OrganDiseaseModel.h"

@interface DBManager : NSObject

//非标准单例
+ (DBManager *)sharedManager;
//查找所有的记录
- (NSArray *)readAllModels;
//根据关键字查找models
- (NSArray *)readModelsWith:(NSString *)keyWords;

@end
