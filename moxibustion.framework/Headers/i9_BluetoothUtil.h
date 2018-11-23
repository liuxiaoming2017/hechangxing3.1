//
//  i9_BluetoothUtil.h
//  MoxaYS
//
//  Created by xuzengjun on 16/9/28.
//  Copyright © 2016年 jiudaifu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlueToothCommon.h"
#import "DeviceModel.h"

#pragma mark -
#pragma mark JaExecuteCommClass
@interface i9_JaExecuteCommClass : NSObject

@property (assign, nonatomic) Byte  strucHead;
@property (assign, nonatomic) Byte  strucCmd;
@property (assign, nonatomic) Byte  strucDataL;
@property (assign, nonatomic) Byte  strucDataM;
@property (assign, nonatomic) Byte  strucDataH;
@property (assign, nonatomic) Byte  strucDataHH;
@property (assign, nonatomic) Byte  strucSumL;
@property (assign, nonatomic) Byte  strucSumH;
@property (assign, nonatomic) Byte  strucAddressH;
@property (assign, nonatomic) Byte  strucAddressL;

@property (assign, nonatomic) int sentCount;
@property (assign, nonatomic) int ageCount;
@property (assign, nonatomic) int discardCount;
@property (assign, nonatomic) bool bTimeChecked;

//@property (retain, nonatomic) NSString *uuid;
@property (assign,nonatomic) BOOL hasSend;

//获取命令的串行数据, 返回的内存需要free释放 commpackage 需要7个字节内存
-(void) JaComm_GetCmdSerail:(Byte *)commpackage;

//转本地温度到目标机温度
+(Byte) JaComm_ConvertLocalTempToTarget:(int)temp;

//转目标机温度到本地温度
+(int) JaComm_ConvertTargetTempToLocal:(Byte)temp;

//转目标机电量到本地电量
+(int) JaComm_ConvertTargetElectryToLocal:(Byte)temp;

//转化密码password到byte[]
//+(Byte*) JaComm_FormatePasswordStr:(NSString*) password;
+(void) JaComm_FormatePasswordStr:(NSString*) password reByte:(Byte*)ecode;

//获得结构密码，转化String
+(NSString *)JaComm_GetPasswordStr:(i9_JaExecuteCommClass*)commC;

//获得命令结构
+(i9_JaExecuteCommClass*)JaComm_GetCommClassBySerial:(Byte*)commpackage;

//获得命令结构：设置灸头温度
+(i9_JaExecuteCommClass*) JaComm_GetSetChannelTempCmd:(int)channel Temp:(int)temp All_:(BOOL)flag;

//获得命令结构：设置灸头时间
+(i9_JaExecuteCommClass*) JaComm_GetSetChannelTimeCmd:(int)channel Time:(int)time All_:(BOOL)flag;

//获得命令结构： 获取某路灸头的状态数据
+(i9_JaExecuteCommClass *) JaComm_GetReadChannelCmd:(int)channel All_:(BOOL)flag;

//获得命令结构：打开某路灸头
+(i9_JaExecuteCommClass*) JaComm_GetOpenChannelCmd:(int)channel Temp:(int)temp Time:(int)time All:(BOOL)flag;

//获得命令结构：关闭某路灸头
+(i9_JaExecuteCommClass*) JaComm_GetCloseChannelCmd:(int)channel ALL:(BOOL)flag;

//获得命令结构：回复状态变化
+(i9_JaExecuteCommClass*) JaComm_GetRevChangeCmd:(Byte)datal DataM:(Byte) datam DataH:(Byte)datah DataHH:(Byte)datahh;

//获得设置密码的命令
+(i9_JaExecuteCommClass*) JaComm_GetSetPasswordCmd:(int)channel Password_:(NSString*)password ALL:(BOOL)flag;

//获得读取密码的命令
+(i9_JaExecuteCommClass*) JaComm_GetReadPasswordCmd:(int)channel ALL:(BOOL)flag;

//获取设备名称
+(i9_JaExecuteCommClass *)JaComm_GetReadDeviceNameCmd:(int)channel ALL:(BOOL)flag;

//获得设置灸头编号命令
+(i9_JaExecuteCommClass *)JaComm_GetSetDeviceNumberCmd:(int)channel Number_:(int)num ALL:(BOOL)flag;

//获得是否存在灸头状态命令
+(i9_JaExecuteCommClass*) JaComm_GetReadHasChannelCmd;

//获得读取通道数的命令
+(i9_JaExecuteCommClass*) JaComm_GetGetChannelCountCmd;

//获取电量的命令
+(i9_JaExecuteCommClass*) JaComm_GetElectricityCmd:(int)channel ALL:(BOOL)flag;

//震动马达的命令
+(i9_JaExecuteCommClass*) JaComm_MotorShakeCmd:(int)channel ALL:(BOOL)flag;

+(i9_JaExecuteCommClass*) JaComm_GetRealyTempCmd:(int)channel ALL:(BOOL)flag;
//
+(i9_JaExecuteCommClass*) JaComm_LightOn:(BOOL)on;

+(i9_JaExecuteCommClass*) JaComm_GetDatas98;

@end


#pragma mark -
#pragma mark JaExecuteReceiveDataParse

@interface i9_JaExecuteReceiveDataParse : NSObject
{
    Byte *recBuf;
    int  validateLen;
}

//push 新的数据
-(bool) pushNewReceiveData: (Byte*) rvData Length: (int) len;

//获取一个命令结构，如果没有完整的返回nil
-(i9_JaExecuteCommClass*) parseOneCommClass;

@end


#pragma mark -
#pragma mark JaExecuteStru

@interface i9_JaExecuteStru : NSObject
@property(assign, nonatomic) int  mSendTemp;        //打包命令的温度
@property(assign, nonatomic) int  mSendTime;        //打包命令的时间
@property(assign, nonatomic) int  mSendElectricity; //打包命令的电量
@property(retain, nonatomic) NSString  *mSendPassword;    //打包命令的电量需要设置的密码

@property(assign, nonatomic) int  mCtrlTemp;        //控制温度
@property(assign, nonatomic) int  mCtrlTime;        //控制时间
@property(assign, nonatomic) int  mCtrlState;       //控制状态

@property(assign, nonatomic) int  mSetTemp;         //设备温度
@property(assign, nonatomic) int  mSetTime;         //设备时间
@property(assign, nonatomic) int  mSetState;        //设备上的状态

@property(assign, nonatomic) int  mInitTime;        //初始化时间

@property(assign, nonatomic) int  mCtrlElectricity;  //控制电量
@property(assign, nonatomic) int  mSetElectricity;  //控制电量



@property(assign, nonatomic) NSTimeInterval mStartTimePoint;    //开始工作的时间点           只有工作状态才有效
@property(assign, nonatomic) int  mTotalSec;                    //开始工作的总秒数           只有工作状态才有效
@property(assign, nonatomic) int  mRemainSec;                   //剩余的秒数                只有工作状态才有效
@property(retain, nonatomic) NSString *muuid;                   //uuid
//@property(assign, nonatomic) int  mInitialSettingTime;          //初始设定时间

@property (assign ,nonatomic) int channalNum;

@property (assign, nonatomic) BOOL mHasReadChannelData; //判断是否加载过数据 防止丢包的时候没有加载数据

@property (retain,nonatomic) DeviceModel *deviceitem;

@property (retain, nonatomic) NSMutableArray *tempArry;
//设置显示状态值
-(void) setContrlStateTempv:(int) temp Timev:(int) time Statev:(int) state;

//设置小机状态值
-(void) setSetBakStateTempv:(int) temp Timev:(int) time Statev:(int) state;

//设置工作时间开始计时
-(void) setStartTimePoint;

@end
