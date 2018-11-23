//
//  TemperNonDeviceViewController.h
//  Voicediagno
//
//  Created by Mymac on 15/9/28.
//  Copyright (c) 2015年 Mymac. All rights reserved.
//

#import "TestBaseViewController.h"

@interface TemperNonDeviceViewController : TestBaseViewController

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic ,strong) UILabel *nameLabel;
@property (nonatomic ,strong) UILabel *sexLabel;

@property (nonatomic ,strong) UIView *personView;
@property (nonatomic ,strong) UIView *showView;


@end
