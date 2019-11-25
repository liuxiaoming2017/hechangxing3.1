//
//  730BArmchairCommonVC.h
//  和畅行
//
//  Created by 刘晓明 on 2019/11/18.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "NavBarViewController.h"
#import "ArmChairModel.h"
#import <OGABluetooth730B/OGABluetooth730B.h>

NS_ASSUME_NONNULL_BEGIN

#define margin ((ScreenWidth-Adapter(107)*3)/4.0)

#define startDevice @"Boot Chair"
#define connectDevice @"Connecting Chair"
#define scanDevice @"Searching"
#define noneDevice @"No connectable bluetooth device was found"
#define failDevice @"Chair connection failed"

@interface OGA730BCommonVC : NavBarViewController

@property (nonatomic, strong) ArmChairModel *armchairModel;

- (NSArray *)loadMoreProgramsData;

- (NSArray *)loadHomeData;

- (void)DidBecomeActive;

- (NSString *)resultStringWithStatus;

- (NSArray *)loadDataPlistWithStr:(NSString *)str;

- (BOOL)chairIsPowerOn;

- (BOOL)chairPowerOnWithRespond:(OGARespond_730B *)respond;
@end

NS_ASSUME_NONNULL_END
