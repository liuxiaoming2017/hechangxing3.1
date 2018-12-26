//
//  HYC_CardsModel.h
//  和畅行
//
//  Created by 出神入化 on 2018/12/17.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYC_CardsModel : NSObject

/*
 "memberId": "729",
 "card_no": "LDXPLR3UC1MFSWXRDKO",
 "card_name": null,
 "description": null,
 "status": "1",
 "service_name": "测试服务卡1217"
 */

@property (nonatomic,copy)   NSString *memberId;
@property (nonatomic,copy)   NSString *card_no;
@property (nonatomic,copy)   NSString *card_name;
@property (nonatomic,copy)   NSString *cardDescription;
@property (nonatomic,copy)   NSString *status;
@property (nonatomic,copy)   NSString *service_name;
@property (nonatomic,copy)   NSString *exprise_time;
@end

NS_ASSUME_NONNULL_END
