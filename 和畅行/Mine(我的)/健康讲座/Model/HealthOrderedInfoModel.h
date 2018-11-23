//
//  HealthOrderedInfoModel.h
//  Voicediagno
//
//  Created by Mymac on 15/10/30.
//  Copyright (c) 2015年 Mymac. All rights reserved.
//

#import "BaseModel.h"

@interface HealthOrderedInfoModel : BaseModel

@property (nonatomic,retain) NSNumber *id;
@property (nonatomic,retain) NSNumber *createDate;
@property (nonatomic,retain) NSNumber *modifyDate;
@property (nonatomic,copy  ) NSString *sn;
@property (nonatomic,copy  ) NSString *orderStatus;
@property (nonatomic,copy  ) NSString *paymentStatus;
@property (nonatomic,copy  ) NSString *shippingStatus;
@property (nonatomic,retain) NSNumber *fee;
@property (nonatomic,retain) NSNumber *freight;
@property (nonatomic,retain) NSNumber *totalAmount;//订单总金额
@property (nonatomic,retain) NSNumber *amountPaid;//已付款金额
@property (nonatomic,retain) NSNumber *refundPay;//已退款金额
@property (nonatomic,retain) NSNumber *amountPayable;//剩余付款金额
@property (nonatomic,retain) NSNumber *point;
@property (nonatomic,copy  ) NSString *consignee;
@property (nonatomic,copy  ) NSString *areaName;
@property (nonatomic,copy  ) NSString *address;
@property (nonatomic,copy  ) NSString *zipCode;
@property (nonatomic,copy  ) NSString *phone;
@property (nonatomic,copy  ) NSString *memo;
@property (nonatomic,copy  ) NSString *paymentMethodName;
@property (nonatomic,copy  ) NSString *shippingMethodName;

@property (nonatomic,copy  ) NSString *status;

@end
/*
     id": ​828,
     "createDate": ​1446170114000,
     "modifyDate": ​1446192845000,
     "sn": "2015103011860",
     "orderStatus": "cancelled",
     "paymentStatus": "unpaid",
     "shippingStatus": "unshipped",
     "fee": ​0.000000,
     "freight": ​0.000000,
     "totalAmount": ​0.010000,
     "point": ​0,
     "consignee": "18637436067",
     "areaName": null,
     "address": null,
     "zipCode": null,
     "phone": "18637436067",
     "memo": null,
     "paymentMethodName": "网上支付",
     "shippingMethodName": null,
 */