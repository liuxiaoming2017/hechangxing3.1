//
//  SugerViewController.h
//  Voicediagno
//
//  Created by Mymac on 15/9/23.
//  Copyright (c) 2015年 Mymac. All rights reserved.
//

#import "TestBaseViewController.h"

@interface SugerViewController : TestBaseViewController

@property (nonatomic,assign) UITableView *tableView;
@property (nonatomic ,retain) NSMutableArray *headArray;
@property (nonatomic ,retain) UILabel *nameLabel;
@property (nonatomic ,retain) UILabel *sexLabel;
@property (nonatomic ,copy) NSString *memberChildId;
@property (nonatomic ,retain) UIView *personView;
@property (nonatomic ,retain) UIView *showView;
@property (nonatomic,strong) NSMutableArray *dataArr;

@end
