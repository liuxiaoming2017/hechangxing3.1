//
//  BloodSugerModel.h
//  Voicediagno
//
//  Created by Mymac on 15/10/22.
//  Copyright (c) 2015年 Mymac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BloodSugerModel : NSObject

@property (nonatomic,assign) NSNumber *createDate;
@property (nonatomic,assign) NSNumber *idNum;
@property (nonatomic,assign) NSNumber *isAbnormity;
@property (nonatomic,assign) NSInteger levels;
@property (nonatomic,assign) NSNumber *modifyDate;
@property (nonatomic,copy) NSString *type;

@end
/*
     {
         createDate = 1445494308000;
         id = 162;
         isAbnormity = 1;
         levels = 76;
         modifyDate = 1445494308000;
         type = empty;
     }
 
 */
