//
//  PressureViewController.h
//  Voicediagno
//
//  Created by Mymac on 15/9/23.
//  Copyright (c) 2015年 Mymac. All rights reserved.
//

#import "TestBaseViewController.h"

@interface PressureViewController : TestBaseViewController
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *headArray;
@property (nonatomic ,strong) UILabel *nameLabel;
@property (nonatomic ,strong) UILabel *sexLabel;
@property (nonatomic ,strong) NSString *memberChildId;
@property (nonatomic ,strong) UIView *personView;
@property (nonatomic ,strong) UIView *showView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@end
