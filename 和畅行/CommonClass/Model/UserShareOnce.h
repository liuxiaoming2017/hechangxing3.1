//
//  UserShareOnce.h
//  和畅行
//
//  Created by 刘晓明 on 2018/7/5.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChildMemberModel.h"
#import <AVFoundation/AVFoundation.h>

@interface UserShareOnce : NSObject

@property (nonatomic,copy) NSString *isMarried;
@property (nonatomic,copy) NSString *birthday;
@property (nonatomic,copy) NSString *isMedicare;
@property (nonatomic,copy) NSString *memberImage;
@property (nonatomic,copy) NSString *lockedDate;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *isBind;
@property (nonatomic,copy) NSString *nation;
@property (nonatomic,copy) NSString *gender;
@property (nonatomic,copy) NSString *identityType;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *idNumber;
@property (nonatomic,copy) NSString *serviceLevel;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *modifyDate;
@property (nonatomic,copy) NSString *createDate;
@property (nonatomic,copy) NSString *loginDate;

@property (nonatomic,copy) NSString *JSESSIONID;
@property (nonatomic,copy) NSString *token;

@property (nonatomic,copy) NSString *marryState;

@property (nonatomic,copy) NSString * mengberchildId;

@property( nonatomic,strong) AVAudioPlayer* mp3;

@property (nonatomic,copy) NSString *passWord;


@property (nonatomic,copy) NSString *uuid; //和缓id
@property (nonatomic,copy) NSString *userToken; //和缓token
@property (nonatomic,assign) BOOL isOnline;
@property (nonatomic,copy) NSString *wxName;

@property (nonatomic,assign) BOOL isRefresh; //一点一说一写 返回首页 刷新和畅提醒判断

@property (nonatomic,copy) NSString *wherePop; //从哪里pop回来的
@property (nonatomic,copy) NSString *bloodMemberID; //血压ID

@property (nonatomic,strong) NSMutableArray *yueYaoBuyArr;

@property (nonatomic,assign) float allYueYaoPrice;

@property (nonatomic,copy) NSString * languageType;
@property (nonatomic,copy) NSString * loginType;

@property (copy, nonatomic) NSString  *startTime;
//字体大小设置倍数
@property (assign, nonatomic) CGFloat  fontSize;
//
@property (copy, nonatomic) NSString  *bindCard;
+ (UserShareOnce *)shareOnce;
+(void)attemptDealloc;
@end
