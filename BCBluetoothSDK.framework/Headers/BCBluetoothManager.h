//
//  BCBluetoothManager.h
//  BCBluetoothSDK
//
//  Created by baichuan on 2019/11/19.
//  Copyright © 2019 baichuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCDeviceModel.h"


#define scanRSSIstrength    -60    //过滤的信号强度 如60，即过滤掉信号强度小于60的设备

typedef NS_ENUM(NSInteger,BCBluetoothOperateCheckType) {
    BCBluetoothOperateCheckTypeSuccess = 1,
    BCBluetoothOperateCheckTypeNilPeripheral,
    BCBluetoothOperateCheckTypeNilCharacteristic
};


typedef NS_ENUM(NSInteger,BCBluetoothOperatestatusCode) {
    BCBluetoothOperatestatusCodeSuccess = 1000,
    BCBluetoothOperatestatusCodeSystemError = 1001,
    BCBluetoothOperatestatusCodeDeviceOrCharacteristicNil = 1002,
    BCBluetoothOperatestatusCodeAuthenticationing = 1003,
    BCBluetoothOperatestatusCodeAuthenticationFail = 1004,
    BCBluetoothOperatestatusCodeNoAuthentication = 1005,
    BCBluetoothOperatestatusCodeAuthenticationSuccess = 1006,
    BCBluetoothOperatestatusCodeTimeOut = 2001
};


typedef NS_ENUM(NSInteger,BCBluetoothOperateFeedbackType) {
    BCBluetoothOperateFeedbackTypeInfo = 1,
    BCBluetoothOperateFeedbackTypeBindDevice,
    BCBluetoothOperateFeedbackTypeUnBindDevice,
    BCBluetoothOperateFeedbackTypeTurnOn,
    BCBluetoothOperateFeedbackTypeTurnOff,
    BCBluetoothOperateFeedbackTypeSetTempreture,
    BCBluetoothOperateFeedbackTypeReadTempreture,
    BCBluetoothOperateFeedbackTypeSetTime,
    BCBluetoothOperateFeedbackTypeReadTime,
    BCBluetoothOperateFeedbackTypeAuthentication,
    BCBluetoothOperateFeedbackTypeOther
};

@protocol BCBluetoothManagerDelegate <NSObject>

- (void)didUpdateDatasWithDevice:(BCDeviceModel *_Nullable)device statusCode:(BCBluetoothOperatestatusCode)code feedBackType:(BCBluetoothOperateFeedbackType)type;

@end



NS_ASSUME_NONNULL_BEGIN

@interface BCBluetoothManager : NSObject

+ (instancetype)shared;

/**
扫描到的设备是否可用
 */
- (BOOL)scanDevice:(CBPeripheral*)bluetoothDevice withAdvertisementData:(NSDictionary*)advertisementData rssi : (NSNumber *)RSSI;


/**
 扫描到的设备是否被绑定
 */
- (BOOL)scanDeviceIsBind:(CBPeripheral*)bluetoothDevice withAdvertisementData:(NSDictionary*)advertisementData;

/**
鉴定权限
 */
- (BCBluetoothOperateCheckType)authenticationDevice:(BCDeviceModel*)device;


/**
 绑定设备
 */
- (BCBluetoothOperateCheckType)bindDevice:(BCDeviceModel*)device;


/**
 解绑设备
 */
- (BCBluetoothOperateCheckType)unbindDevice:(BCDeviceModel*)device;

/**
 打开设备
 */
- (BCBluetoothOperateCheckType)turnOnDevice:(BCDeviceModel*)device;

/**
 关闭设备
 */
- (BCBluetoothOperateCheckType)turnOffDevice:(BCDeviceModel*)device;

/**
 设置温度
 */
- (BCBluetoothOperateCheckType)setDeviceTempreture:(NSInteger)temp withDevice:(BCDeviceModel*)device;

/**
 读取温度
 */
- (BCBluetoothOperateCheckType)readDeviceTempreture:(BCDeviceModel*)device;

/**
 设置时间
 */
- (BCBluetoothOperateCheckType)setDeviceTime:(NSInteger)time withDevice:(BCDeviceModel*)device;

/**
 读取时间
 */
- (BCBluetoothOperateCheckType)readDeviceTime:(BCDeviceModel*)device;

@property (nonatomic , weak) id<BCBluetoothManagerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
