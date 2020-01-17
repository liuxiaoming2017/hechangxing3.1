//
//  OGA730CBluetoothManager.h
//  OGABluetooth730C
//
//  Created by apple on 2019/10/22.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OGA730CRespond.h"
#import "OGA730CCmd.h"
#import "OGA730CSubscribe.h"
#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface OGA730CBluetoothManager : NSObject

// 数据内容
@property (nonatomic, strong) OGA730CRespond * respondModel;
// 是否打印
@property (nonatomic, assign) BOOL isLog;
// 扫描外设时长，默认10S
@property (nonatomic, assign) float maxScanTime;
// 停止心跳包响应
@property (nonatomic, assign) BOOL stopResponse;

+ (instancetype)shareInstance;

/**
 * 添加订阅
 *
 * param subscribe 订阅
 */
- (void)addSubscribe:(OGA730CSubscribe *)subscribe;

/**
 * 删除订阅
 *
 * param subscribe 订阅
 */
- (void)removeSubscribe:(OGA730CSubscribe *)subscribe;


/**
 * 蓝牙是否关闭状态
 *
 * return 蓝牙是否关闭
 */
- (BOOL)isBlueToothPoweredOff;

/**
 * 蓝牙是否开启状态
 *
 * return 蓝牙是否开启
 */
- (BOOL)isBlueToothPoweredOn;

/**
 * 蓝牙是否连接
 *
 * return 蓝牙是否连接
 */
- (BOOL)isBlueToothConnected;

/**
 * 重连设备
 *
 * param peripheralIdentifier 设备ID
 * return 连接状态
 */
- (BOOL)autoConnectDevice:(NSString *)peripheralIdentifier;

/**
 * 蓝牙可用状态
 *
 * param status 状态回调
 */
- (void)bluetoothStatusChange:(void(^__nullable)(BOOL enable))status;

/**
 * 搜索设备
 *
 * param scan 搜索设备列表
 * param timeoutScan 搜索超时
 */
- (void)scanPeripheral:(void(^__nullable)(NSMutableArray *array))scan timeoutSacn:(void (^__nullable)(void))timeoutScan;

/**
 * 停止搜索
 *
 * param stopScan 停止搜索
 */
- (void)stopSacnPeripheral:(void(^__nullable)(void))stopScan;

/**
 * 连接设备
 *
 * param peripheral 设备
 * param connect 回调
 */
- (void)connectPeripheral:(CBPeripheral *)peripheral connect:(void(^__nullable)(void))connect;

/**
 * 断开设备
 *
 * param peripheral 设备
 * param disConnect 回调
 */
- (void)disconnectPeripheral:(CBPeripheral *)peripheral disConnect:(void(^__nullable)(CBPeripheral * _Nonnull device))disConnect;

/**
 * 下发指令
 *
 * param command 指令
 * param success 回复
 */
- (void)sendCommand:(NSString *)command success:(void(^__nullable)(BOOL success))success;

/**
 * 清除指令
 */
- (void)clearCommand;

/**
 * 酸痛疲劳值
 *
 * param neck 颈部
 * param shoulderIn 肩内
 * param shoulderOut 肩外
 * param shoulderBlade 肩胛骨
 * param back 背部
 * param waist 腰部
 * param result 回调数据
 */
- (void)acheAndFatigue:(NSInteger)neck
            shoulderIn:(NSInteger)shoulderIn
           shoulderOut:(NSInteger)shoulderOut
         shoulderBlade:(NSInteger)shoulderBlade
                  back:(NSInteger)back
                 waist:(NSInteger)waist
                result:(void(^__nullable)(NSMutableArray *acheArray, NSInteger acheResult, NSInteger fatigueResult))result;

/**
 * 根据各个部位酸痛获取酸痛推荐几（1-81）
 *
 * param neck 颈部
 * param shoulderIn 肩内
 * param shoulderOut 肩外
 * param shoulderBlade 肩胛骨
 * param back 背部
 * param waist 腰部
 *
 * return 返回酸痛推荐几（1-81），如果数据错误返回 -1
 */
- (NSInteger )aceRecommendWithFatigue:(NSInteger)neck
                           shoulderIn:(NSInteger)shoulderIn
                          shoulderOut:(NSInteger)shoulderOut
                        shoulderBlade:(NSInteger)shoulderBlade
                                 back:(NSInteger)back
                                waist:(NSInteger)waist;
@end

NS_ASSUME_NONNULL_END
