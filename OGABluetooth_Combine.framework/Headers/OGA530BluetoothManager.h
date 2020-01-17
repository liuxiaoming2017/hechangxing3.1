//
//  OGA530BluetoothManager.h
//  OGAChair-530
//
//  Created by ogawa on 2019/8/7.
//  Copyright © 2019 Hlin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OGA530Respond.h"
#import "OGA530Command.h"
#import "OGA530Subscribe.h"
#import <CoreBluetooth/CoreBluetooth.h>


NS_ASSUME_NONNULL_BEGIN

@interface OGA530BluetoothManager : NSObject

/**
 数据内容
 */
@property (nonatomic, strong) OGA530Respond *respondModel;

/**
 数据内容
 */
@property (nonatomic, strong) OGA530Respond *respondPowerOffModel;

/**
 是否打印
 */
@property (nonatomic, assign) BOOL isLog;

/**
 扫描外设时长，默认10S
 */
@property (nonatomic, assign) float maxScanTime;

/**
 停止心跳包响应
 */
@property (nonatomic, assign) BOOL stopResponse;

+ (instancetype)shareInstance;

/// 蓝牙设备信息

/**
 蓝牙是否关闭状态
 
 @return 蓝牙是否关闭
 */
- (BOOL)isBlueToothPoweredOff;

/**
 蓝牙是否开启状态
 
 @return 蓝牙是否开启
 */
- (BOOL)isBlueToothPoweredOn;

/**
 蓝牙是否连接
 
 @return 蓝牙是否连接
 */
- (BOOL)isBlueToothConnected;

/**
 重连设备
 
 @param peripheralIdentifier 设备ID
 @return 连接状态
 */
- (BOOL)autoConnectDevice:(NSString *)peripheralIdentifier;

/**
 蓝牙可用状态
 
 @param status 状态回调
 */
- (void)bluetoothStatusChange:(void(^__nullable)(BOOL enable))status;

/**
 搜索设备
 
 @param scan 搜索设备列表
 @param timeoutScan 搜索超时
 */
- (void)scanPeripheral:(void(^__nullable)(NSMutableArray *array))scan timeoutSacn:(void (^__nullable)(void))timeoutScan;

/**
 停止搜索
 
 @param stopScan 停止搜索
 */
- (void)stopSacnPeripheral:(void(^__nullable)(void))stopScan;

/**
 连接设备
 
 @param peripheral 设备
 @param connect 回调
 @param timeoutConnect 连接超时
 */
- (void)connectPeripheral:(CBPeripheral *)peripheral connect:(void(^__nullable)(void))connect timeoutConnect:(void (^__nullable)(void))timeoutConnect;

/**
 断开设备
 
 @param peripheral 设备
 @param disConnect 回调
 */
- (void)disconnectPeripheral:(CBPeripheral *)peripheral disConnect:(void(^__nullable)(CBPeripheral * _Nonnull device))disConnect;

/**
 断开设备 - 监听
 @param disConnect 回调
 */
- (void)bleDisconnect:(void(^__nullable)(CBPeripheral * _Nonnull device))disConnect;

/**
 偶然断开设备 - 监听
 @param disConnect 回调
 */
- (void)bleSuddenDisconnect:(void(^__nullable)(CBPeripheral * _Nonnull device))disConnect;


/// 按摩椅交互
/**
 添加订阅
 
 @param subscribe 订阅
 */
- (void)addSubscribe:(OGA530Subscribe *)subscribe;

/**
 删除订阅
 
 @param subscribe 订阅
 */
- (void)removeSubscribe:(OGA530Subscribe *)subscribe;

/**
 下发指令
 
 @param command 指令
 @param success 回复
 */
- (void)sendCommand:(NSString *)command success:(void(^__nullable)(BOOL success))success;

/**
 清除指令
 */
- (void)clearCommand;


/**
 查询椅子序列号
 
 @param sn 椅子序列号
 */
- (void)queryChairSn:(void(^__nullable)(NSString *sn))sn;

/**
 查询椅子运行时长
 
 @param runtime 椅子运行时长
 */
- (void)queryChairRuntime:(void(^__nullable)(NSInteger time))runtime;

/**
 酸痛疲劳值
 
 @param neck 颈部
 @param shoulderIn 肩内
 @param shoulderOut 肩外
 @param shoulderBlade 肩胛骨
 @param back 背部
 @param waist 腰部
 @param result 回调数据
 */
- (void)acheAndFatigue:(NSInteger)neck
            shoulderIn:(NSInteger)shoulderIn
           shoulderOut:(NSInteger)shoulderOut
         shoulderBlade:(NSInteger)shoulderBlade
                  back:(NSInteger)back
                 waist:(NSInteger)waist
                result:(void(^__nullable)(NSMutableArray *acheArray, NSInteger acheResult, NSInteger fatigueResult))result;

@end

NS_ASSUME_NONNULL_END
