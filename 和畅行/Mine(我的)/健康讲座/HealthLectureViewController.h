//
//  HealthLectureViewController.h
//  Voicediagno
//
//  Created by Mymac on 15/10/23.
//  Copyright (c) 2015年 Mymac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthLectureViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate,MBProgressHUDDelegate>

@property (nonatomic,retain) UITableView *tableView;
@property (nonatomic,retain) NSMutableArray *dataArr;


@end
