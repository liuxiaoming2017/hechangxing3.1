//
//  BloodOxyNonDeviceViewController.h
//  Voicediagno
//
//  Created by Mymac on 15/9/28.
//  Copyright (c) 2015年 Mymac. All rights reserved.
//

#import "TestBaseViewController.h"
typedef void (^zqqBlock)();
@interface BloodOxyNonDeviceViewController : TestBaseViewController

@property (nonatomic, copy) zqqBlock abock;
@property (nonatomic ,retain) NSMutableArray *headArray;
@property (nonatomic ,retain) UILabel *nameLabel;
@property (nonatomic ,retain) UILabel *sexLabel;
@property (nonatomic ,retain) NSString *memberChildId;
@property (nonatomic ,retain) UIView *personView;
@property (nonatomic ,retain) UIView *showView;
@property (nonatomic,retain) NSMutableArray *dataArr;

@end
