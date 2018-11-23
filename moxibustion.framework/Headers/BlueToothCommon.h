//
//  BlueToothCommon.h
//  MoxaYS
//
//  Created by xuzengjun on 16/9/29.
//  Copyright © 2016年 jiudaifu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IS_IOS_7        ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define SCREEN_WID      ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEI      ([[UIScreen mainScreen] bounds].size.height)
#define STATUS_HEI      ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define NAVBAR_HEI      (self.navigationController.navigationBar.frame.size.height)
#define SCREEN_TOP_BAR_HEI  (STATUS_HEI+NAVBAR_HEI)

// 其它
// 其它
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define RGB(r,g,b)                [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]


#define WPASSWORD_CHECK     0
#define WPASSWORD_MODIFY    1
#define WPASSWORD_HIDE      2

#define WARNNING_WENDU      48

//颜色和透明度设置
#define RGBA(r,g,b,a)   [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]
#define NORMAL_BTN_COLOR    RGBA(0x00, 0x97, 0xea, 1)
#define PRESSED_BTN_COLOR   RGBA(0xd0, 0xcf, 0xcf, 1)
#define BTN_BORDER_COLOR    RGBA(0xaa, 0xaa, 0xaa, 1)
#define random(x) (rand()%x)




typedef NS_OPTIONS(int, Channel_status) {
    CHANNEL_NOLINK,
    CHANNEL_LINKING,
    CHANNEL_STOP,
    CHANNEL_WORK
};

typedef NS_OPTIONS(int, error_type) {
    TEMPERATURE_ABNORMAL = 1,
    BATTERY_ABNORMAL,
    FIRMWARECODE_ABNORMAL,
    CONNECT_ABNORMAL,
    DEVICEINFO_ABNORMAL
};

//蓝牙支持情况
extern  const int SUPPORT_YES;
extern  const int SUPPORT_NOBLE;
extern  const int SUPPORT_NOAPP;

//搜索状态
extern const int FIND_STATE_START;
extern const int FIND_STATE_NEW;
extern const int FIND_STATE_END;

//蓝牙打开关闭状态
extern const int STATE_OFF;
extern const int STATE_ON;
extern const int STATE_ONING;

//蓝牙连接状态
extern const int CONNECT_OFF;
extern const int CONNECT_ON;
extern const int CONNECT_ONING;
extern const int CONNECT_TIMEOUT;

//长过程定义
extern const int PROCESS_NULL;
extern const int PROCESS_STATEON_AUTO;

extern const int RECEIVEBUF_LEN;


extern const Byte STRUCHEAD;                    //包头
extern const int  STRUCSERIALLEN;               //包长度

extern const int  CMD_SETTEMP;                  //设置温度
extern const int  CMD_ACKSETTEMP;

extern const int   CMD_SETTIME;                 //设置时间
extern const int   CMD_ACKSETTIME;

extern const int   CMD_READCHANNEL;             //读取通道数据
extern const int   CMD_ACKREAD_NOSET;
extern const int   CMD_ACKREAD_WORK;
extern const int   CMD_ACKREAD_ON;

extern const int   CMD_CLOSECHANNEL;            //关闭通道
extern const int   CMD_ACKCLOSE;

extern const int   CMD_OPENCHANNEL;             //打开通道
extern const int   CMD_ACKOPENSUCESS;
extern const int   CMD_ACKOPENNOSET;

extern const int   CMD_SETPASSWORD;             //设置密码
extern const int   CMD_ACKSETPASSWORD;          //回复设置密码

extern const int   CMD_GETPASSWORD;             //获取密码
extern const int   CMD_ACKGETPASSWORD;          //回复获取密码

extern const int   CMD_HASCHANNELD;             //获取是否存在灸头
extern const int   CMD_ACKHASCHANNELD;          //回复是否存在灸头

extern const int   CMD_GETCHANNELCOUNT;         //获取通道数
extern const int   CMD_ACKGETCHANNELCOUNT;      //回复获取通道数

extern const int   CMD_GETELECTRICITY;          //获取电量
extern const int   CMD_ACKELECTRICITY;          //读取电量

extern const int   CMD_GETSHAKEMOTOR;          //震动马达
extern const int   CMD_ASKSHAKEMOTOR;          //读取震动马达

extern const int   CMD_GETDEVICENAME;          //获取设备名称
extern const int   CMD_ASKGETDEVICENAME;       //读取获取设备名称

extern const int   CMD_SETDEVICENUMBER;          //设置灸头编号
extern const int   CMD_ASKSETDEVICENUMBER;       //读取设置灸头编号

extern const int   CMD_READREALYTEMP;
extern const int   CMD_ACKREALYTEMP;

extern const int   CMD_CHANNELCHANGE;           //灸头的插拔状态改变
extern const int   CMD_ACKCHANGE;
extern const int   CMD_RENAME;          // 改名
extern const int   CMD_GETNAME;         // 改名 ack

extern const int   CMD_LIGHT;           // 点灯
extern const int   CMD_GETLIGHT;		// 点灯 ack

extern const int   CMD_DATAS98;
extern const int   CMD_DATAS98ACK;
extern const int   CMD_NODATAS98ACK;

extern const int  JAEXECUTE_STATE_IDLE;            //灸头连接，未工作状态
extern const int  JAEXECUTE_STATE_RUN;             //灸头连接，工作状态
extern const int  JAEXECUTE_STATE_NOSET;           //灸头未连接
extern const int  JAEXECUTE_STATE_UNKNOWN;         //蓝牙未连接远端设备，初始状态， 不知道当前灸头的状态
extern const int  JAEXECUTE_STATE_WAIT;            //灸头等待连接

extern const int  JAEXECUTE_TEMP_MIN;
extern const int  JAEXECUTE_TEMP_MAX;

extern const int  JAEXECUTE_TIME_MIN;
extern const int  JAEXECUTE_TIME_MAX;

extern const int  DATAPARSE_BUFFLEN;

@interface BlueToothCommon : NSObject

+ (NSString*)getLastConnectMesh;

+ (void)setConnectMesh:(NSString*)meshname;

+ (NSString *)getMoxaLastTime;
//
+ (void)setMoxaLastTime:(NSString *)time;

+ (NSString *)getMoxaLastTemp;

+ (BOOL)getMoxaVoiceEn;

+ (void)setMoxaVoiceEn:(BOOL)b;

//
+ (void)setMoxaLastTemp:(NSString *)temp;

+ (NSString *)string16FromHexString:(NSString *)hexString ;

+(BOOL)isEmpty:(NSString *)str;
@end
