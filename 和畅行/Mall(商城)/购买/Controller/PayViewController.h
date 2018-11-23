//
//  PayViewController.h
//  Voicediagno
//
//  Created by 李传铎 on 15/9/23.
//  Copyright (c) 2015年 李传铎. All rights reserved.
//

#import "NavBarViewController.h"
#import "WXApi.h"
//#import "WXApiObject.h"

//@protocol sendMsgToWeChatViewDelegate <NSObject>
//- (void) changeScene:(NSInteger)scene;
//- (void) sendTextContent;
//- (void) sendImageContent;
//- (void) sendPay;
//- (void) sendPay_demoName:(NSString *)name Dictionary:(NSMutableDictionary *)dictionary;
//@end
@interface PayViewController : NavBarViewController<WXApiDelegate>
@property (nonatomic ,retain) NSString *dingdanStr;
@property (nonatomic ,retain) NSString *idStr;//订单id
@property (nonatomic ,retain) NSString *priceStr;//卡支付部分
@property (nonatomic ,retain) NSString *priceAPPStr;//第三方支付部分
@property (nonatomic ,retain) NSMutableArray *nameArr;
//@property (nonatomic, assign) id<sendMsgToWeChatViewDelegate,NSObject> delegate;
@end
