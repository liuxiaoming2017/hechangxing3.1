//
//  HealthTipsModel.h
//  Voicediagno
//
//  Created by ZhangYunguang on 16/1/6.
//  Copyright © 2016年 ZhangYunguang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HealthTipsModel : NSObject

@property (nonatomic,strong) NSNumber *totalPages;
@property (nonatomic,strong) NSNumber *tipId;
@property (nonatomic,strong) NSNumber *createDate;
@property (nonatomic,strong) NSNumber *modifyDate;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *content;

@end
