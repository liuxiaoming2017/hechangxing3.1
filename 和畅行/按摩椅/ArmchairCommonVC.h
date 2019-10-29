//
//  ArmchairCommonVC.h
//  和畅行
//
//  Created by 刘晓明 on 2019/9/11.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "NavBarViewController.h"
#import "ArmChairModel.h"

#import <OGABluetooth530/OGABluetooth530.h>

NS_ASSUME_NONNULL_BEGIN



@interface ArmchairCommonVC : NavBarViewController



@property (nonatomic, strong) ArmChairModel *armchairModel;

//获取本地plist数据
- (NSArray *)loadDataPlistWithStr:(NSString *)str;

- (NSArray *)loadHomeData;

- (void)DidBecomeActive;

- (NSString *)resultStringWithStatus;

@end

NS_ASSUME_NONNULL_END
