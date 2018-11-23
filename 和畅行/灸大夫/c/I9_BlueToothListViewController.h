//
//  I9_BlueToothListViewController.h
//  MoxaYS
//
//  Created by xuzengjun on 16/9/19.
//  Copyright © 2016年 jiudaifu. All rights reserved.
//

#import "NavBarViewController.h"
#import <moxibustion/moxibustion.h>

@interface I9_BlueToothListViewController : NavBarViewController<UITableViewDelegate, UITableViewDataSource>
@property (retain,nonatomic) NSString *deviceNetName;

-(void)updateDeviceList;

-(void)ConnectResult:(NSString *)uuid;

-(void)disConnectResult:(NSString *)uuid;

-(void)ChangeNameSuccess;
@end
