//
//  moxibustion.h
//  moxaDemo
//
//  Created by xuzengjun on 2018/3/12.
//  Copyright © 2018年 xuzengjun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "i9_BluetoothUtil.h"
#import "BTDevItem.h"

@protocol moxibustionDelegate <NSObject>

@required
-(void)commendReturn:(int)cmd Device_Address:(uint32_t) address ExeStru:(i9_JaExecuteStru *)exeStru;

-(void)scanfedToinitView:(NSString *)meshname;

-(void) findBtDeviceStateChange:(int) findState;

-(void) btOpenDeviceStateChange:(int) state;

-(void) btConnectDeviceStateChange:(int)state DeviceModel:(DeviceModel *)deviceitem;

-(BOOL) btConnectDeviceAndloginSuccess;

-(void) btConnectDeviceReturnLogin:(BOOL)clearView;

-(void)trackCommunicationfresh;

-(void)trackCommunicationMoxaComplete;

-(void)UpdateChannalNew:(i9_JaExecuteStru *)stru NeedAnim:(BOOL)flag;

@optional
-(void)errorMessge:(error_type)msgType _Messge:(NSString *)msg;

-(void)moxibustInfo:(NSMutableArray *)infoData;

@end

@interface moxibustion : NSObject
@property(weak, nonatomic) id<moxibustionDelegate> mDataDelegate;
@property (assign, nonatomic) bool bCompleteAuthentication;   //验证完成才算真正的连接，否则断开
@property (assign, nonatomic) BOOL isSetPwd;

+(moxibustion *)getInstance;

-(void)work;

-(NSMutableArray *)getExecuteStruLst;

-(BTDevItem *)getSearchedDevice;

-(BTDevItem *)getConnectDevice;

-(NSMutableArray *)getDiscoveredDevices;

-(NSMutableArray *)getDiscoveredDevicesName;

-(int)getBluetoothSupportState;

-(int)getBluetoothConnectState;

-(int)getBluetoothOpenState;

-(BOOL)checkDoneedPwd:(BTDevItem *)item;

-(void)atuoDiscoverConnect;

-(void)discoverDevice;

-(void)disConnect;

-(void)connectOneDevices:(BTDevItem *)item;

-(void)joinOneDevicesMesh:(BTDevItem *)item;

-(void) recordStartTimePoint:(uint32_t)address EXEStru:(i9_JaExecuteStru *)stru NeedCheck:(bool) bCheck;

-(void)sendCommend:(int)comm JaExecuteStru_:(i9_JaExecuteStru *)stru ISUserComm_:(BOOL)isUserComm;

-(void)clearAllCommend;

-(void)setPassWord:(NSString *)pwd;

-(NSString *)getDevicePassWord:(BTDevItem *)device;

-(NSString *)getPassWord:(NSString *)name;

-(BOOL)isValidMachineCode:(NSString *)str;

-(void)releaseRes;
@end
