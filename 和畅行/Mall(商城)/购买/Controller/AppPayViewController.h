//
//  AppPayViewController.h
//  Voicediagno
//
//  Created by 李传铎 on 15/10/27.
//  Copyright (c) 2015年 李传铎. All rights reserved.
//

#import "NavBarViewController.h"

@interface AppPayViewController : NavBarViewController
@property (nonatomic ,retain) NSString *idStr;//订单id
@property (nonatomic ,retain) NSString *priceStr;//卡支付部分
@property (nonatomic ,retain) NSString *priceAPPStr;//第三方支付部分

@end
