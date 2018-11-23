//
//  ChildMemberModel.h
//  和畅行
//
//  Created by 刘晓明 on 2018/7/6.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChildMemberModel : NSObject

@property (nonatomic,copy) NSString *birthday;
@property (nonatomic,strong) NSNumber *createDate;
@property (nonatomic,copy) NSString *gender;
@property (nonatomic,strong) NSNumber *idNum;
@property (nonatomic,strong) NSNumber *idcard;
@property (nonatomic,assign) BOOL isMedicare;
@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,strong) NSNumber *modifyDate;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *weight;

@end
