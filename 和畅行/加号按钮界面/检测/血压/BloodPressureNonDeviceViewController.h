//
//  BloodPressureNonDeviceViewController.h
//  Voicediagno
//
//  Created by Mymac on 15/9/25.
//  Copyright (c) 2015年 Mymac. All rights reserved.
//

#import "SayAndWriteController.h"

@interface BloodPressureNonDeviceViewController : SayAndWriteController

@property (nonatomic,assign) UITableView *tableView;
@property (nonatomic ,retain) NSMutableArray *headArray;
@property (nonatomic ,retain) UILabel *nameLabel;
@property (nonatomic ,retain) UILabel *sexLabel;
@property (nonatomic ,retain) NSString *memberChildId;
@property (nonatomic ,retain) UIView *showView;
@property (nonatomic,strong) NSMutableArray *dataArr;

@end
