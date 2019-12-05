//
//  BCDeviceModel.h
//  BCBluetoothSDK
//
//  Created by baichuan on 2019/11/19.
//  Copyright © 2019 baichuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface BCDeviceModel : NSObject

/**
蓝牙设备
 */
@property (nonatomic , strong) CBPeripheral *BCDevice; 

/**
 蓝牙设备特征
 */
@property (nonatomic , strong) CBCharacteristic *deviceCharact;


/**
名字
 */
@property (nonatomic , copy) NSString *deviceName;

/**
是否验证过密码
 */
@property (nonatomic , assign) BOOL isCheckPassword;

/**
Mac地址
 */
@property (nonatomic , copy) NSString *macAddress;

/**
版本号
 */
@property (nonatomic , assign) NSInteger deviceVersion;

/**
s蓝牙设备开关
 */
@property (nonatomic , assign) BOOL onOff;

/**
电量
 */
@property (nonatomic , assign) NSInteger voltameter;

/**
设置的总时间
 */
@property (nonatomic , assign) NSInteger totalDuration;

/**
剩余时间
 */
@property (nonatomic , assign) NSInteger residueDuration;

/**
温度
 */
@property (nonatomic , assign) NSInteger temperature;

/**
 设备UUID
 */
@property (nonatomic , copy) NSString *deviceID;

- (instancetype)initWithDevice:(CBPeripheral*)device;


/**
 获取设备信息
 */
- (void)dispatchReadDataWithDevice:(CBPeripheral*)deviice characteristic:(CBCharacteristic*)characteristic;

- (void)writeValue:(NSData*)value withDevice:(CBPeripheral *)device characteristic:(CBCharacteristic*)characteristic;

@end

NS_ASSUME_NONNULL_END
