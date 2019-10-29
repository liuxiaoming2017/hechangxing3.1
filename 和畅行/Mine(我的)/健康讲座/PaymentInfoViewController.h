//
//  PaymentInfoViewController.h
//  Voicediagno
//
//  Created by Mymac on 15/10/26.
//  Copyright (c) 2015年 Mymac. All rights reserved.
//

#import "SayAndWriteController.h"
#import "HealthLectureModel.h"

@interface PaymentInfoViewController : SayAndWriteController

@property (nonatomic,retain) HealthLectureModel *model;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,assign) CGFloat price;
@property (nonatomic,assign) NSInteger orderId;
@property (nonatomic, copy ) NSString *sn;

@end
