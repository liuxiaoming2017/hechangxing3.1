//
//  OGACommand_730B.h
//  OGAChair-730B
//
//  Created by ogawa on 2019/10/21.
//  Copyright © 2019 Hlin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

 
#pragma mark ------ ON/OFF
// 指令-开机
UIKIT_EXTERN NSString * _Nonnull const k730Command_PowerOn;
// 指令-暂停
UIKIT_EXTERN NSString * _Nonnull const k730Command_Stop;

#pragma mark ------ 自动程序
// 指令-开机
UIKIT_EXTERN NSString * _Nonnull const k730Command_DetectionBody;
// 指令-揉按解乏
UIKIT_EXTERN NSString * _Nonnull const k730Command_Vigorous;
// 指令-揉抚放松
UIKIT_EXTERN NSString * _Nonnull const k730Command_Relax;
// 指令-身体伸展
UIKIT_EXTERN NSString * _Nonnull const k730Command_Stretch;
// 指令-颈部重点
UIKIT_EXTERN NSString * _Nonnull const k730Command_UpperBack;
// 指令-腰部重点
UIKIT_EXTERN NSString * _Nonnull const k730Command_LowerBack;
// 指令-电脑一族
UIKIT_EXTERN NSString * _Nonnull const k730Command_Gentle;
// 指令-开车一族
UIKIT_EXTERN NSString * _Nonnull const k730Command_NeckShoulder;
// 逛街一族
UIKIT_EXTERN NSString * _Nonnull const k730Command_FeetCalves;
// 手机一族
UIKIT_EXTERN NSString * _Nonnull const k730Command_Altheltic;
// 养肾按摩
UIKIT_EXTERN NSString * _Nonnull const k730Command_Japanese;
// 养肝按摩
UIKIT_EXTERN NSString * _Nonnull const k730Command_Chinese;
// 和胃按摩
UIKIT_EXTERN NSString * _Nonnull const k730Command_Balinese;
// 泰式按摩
UIKIT_EXTERN NSString * _Nonnull const k730Command_Thai;

// 指令-酸痛检测
UIKIT_EXTERN NSString * _Nonnull const k730Command_DetectionAche;

#pragma mark ------ 加热
// 加热
UIKIT_EXTERN NSString * _Nonnull const k730Command_Warm;

#pragma mark ------ 手动伸展程序
// 颈部-拉伸
UIKIT_EXTERN NSString * _Nonnull const k730Command_StrengthNeck;
// 肩胛骨-拉伸
UIKIT_EXTERN NSString * _Nonnull const k730Command_StrengthShoulder;
// 骨盆-拉伸
UIKIT_EXTERN NSString * _Nonnull const k730Command_StrengthPelvis;
// 腿部-拉伸
UIKIT_EXTERN NSString * _Nonnull const k730Command_StrengthLeg;

#pragma mark ------ 手动充气程序
// 肩部-气压
UIKIT_EXTERN NSString * _Nonnull const k730Command_AirShoulder;
// 手臂-气压
UIKIT_EXTERN NSString * _Nonnull const k730Command_AirArm;
// 腰部-气压
UIKIT_EXTERN NSString * _Nonnull const k730Command_AirWaist;
// 脚部-气压
UIKIT_EXTERN NSString * _Nonnull const k730Command_AirFoot;

#pragma mark ------ 辅助调节
// 宽度-宽
UIKIT_EXTERN NSString * _Nonnull const k730Command_BreadthWide;
// 宽度-窄
UIKIT_EXTERN NSString * _Nonnull const k730Command_BreadthNarrow;
// 机芯3D-强
UIKIT_EXTERN NSString * _Nonnull const k730Command_MovementStrong;
// 机芯3D-弱
UIKIT_EXTERN NSString * _Nonnull const k730Command_MovementWeak;
// 气压-强
UIKIT_EXTERN NSString * _Nonnull const k730Command_AirStrong;
// 气压-弱
UIKIT_EXTERN NSString * _Nonnull const k730Command_AirWeak;
// 肩位置 上
UIKIT_EXTERN NSString * _Nonnull const k730Command_ShoulderUp;
// 肩位置 下
UIKIT_EXTERN NSString * _Nonnull const k730Command_ShoulderDown;
// 手动 上
UIKIT_EXTERN NSString * _Nonnull const k730Command_ManualUp;
// 手动 下
UIKIT_EXTERN NSString * _Nonnull const k730Command_ManualDown;

#pragma mark ------ 舒缓灯
// 头罩 LED-关
UIKIT_EXTERN NSString * _Nonnull const k730Command_LedSwitch;
// 头罩 LED-红
UIKIT_EXTERN NSString * _Nonnull const k730Command_LedRed;
// 头罩 LED-绿
UIKIT_EXTERN NSString * _Nonnull const k730Command_LedGreen;
// 头罩 LED-蓝
UIKIT_EXTERN NSString * _Nonnull const k730Command_LedBlue;
// 头罩 LED-黄
UIKIT_EXTERN NSString * _Nonnull const k730Command_LedYellow;
// 头罩 LED-紫
UIKIT_EXTERN NSString * _Nonnull const k730Command_LedPurple;
// 头罩 LED-青
UIKIT_EXTERN NSString * _Nonnull const k730Command_LedCyan;
// 头罩 LED-白
UIKIT_EXTERN NSString * _Nonnull const k730Command_LedWhite;

#pragma mark ------ 随心程序
// 手动 捶拍，可独立开启不选择部位，也可以伴随其他五种手动手法开启
UIKIT_EXTERN NSString * _Nonnull const k730Command_ManualTap;

// 手动 颈部-指压
UIKIT_EXTERN NSString * _Nonnull const k730Command_ManualNeckShiatsu;
// 手动 颈部-揉按
UIKIT_EXTERN NSString * _Nonnull const k730Command_ManualNeckKnead1;
// 手动 颈部-揉抚
UIKIT_EXTERN NSString * _Nonnull const k730Command_ManualNeckKnead2;
// 手动 颈部-揉捏
UIKIT_EXTERN NSString * _Nonnull const k730Command_ManualNeckKnead3;
// 手动 颈部-滚动
UIKIT_EXTERN NSString * _Nonnull const k730Command_ManualNeckRoll;

// 手动 肩部-指压
UIKIT_EXTERN NSString * _Nonnull const k730Command_ManualShoulerShiatsu;
// 手动 肩部-揉按
UIKIT_EXTERN NSString * _Nonnull const k730Command_ManualShoulerKnead1;
// 手动 肩部-揉抚
UIKIT_EXTERN NSString * _Nonnull const k730Command_ManualShoulerKnead2;
// 手动 肩部-揉捏
UIKIT_EXTERN NSString * _Nonnull const k730Command_ManualShoulerKnead3;
// 手动 肩部-滚动
UIKIT_EXTERN NSString * _Nonnull const k730Command_ManualShoulerRoll;

// 手动 背部-指压
UIKIT_EXTERN NSString * _Nonnull const k730Command_ManualBackShiatsu;
// 手动 背部-揉按
UIKIT_EXTERN NSString * _Nonnull const k730Command_ManualBackKnead1;
// 手动 背部-揉抚
UIKIT_EXTERN NSString * _Nonnull const k730Command_ManualBackKnead2;
// 手动 背部-揉捏
UIKIT_EXTERN NSString * _Nonnull const k730Command_ManualBackKnead3;
// 手动 背部-滚动
UIKIT_EXTERN NSString * _Nonnull const k730Command_ManualBackRoll;

// 手动 腰部-指压
UIKIT_EXTERN NSString * _Nonnull const k730Command_ManualWaistShiatsu;
// 手动 腰部-揉按
UIKIT_EXTERN NSString * _Nonnull const k730Command_ManualWaistKnead1;
// 手动 腰部-揉抚
UIKIT_EXTERN NSString * _Nonnull const k730Command_ManualWaistKnead2;
// 手动 腰部-揉捏
UIKIT_EXTERN NSString * _Nonnull const k730Command_ManualWaistKnead3;
// 手动 腰部-滚动
UIKIT_EXTERN NSString * _Nonnull const k730Command_ManualWaistRoll;

// 手动 上半身-指压
UIKIT_EXTERN NSString * _Nonnull const k730Command_ManualUpperBodyShiatsu;
// 手动 上半身-揉按
UIKIT_EXTERN NSString * _Nonnull const k730Command_ManualUpperBodyKnead1;
// 手动 上半身-揉抚
UIKIT_EXTERN NSString * _Nonnull const k730Command_ManualUpperBodyKnead2;
// 手动 上半身-揉捏
UIKIT_EXTERN NSString * _Nonnull const k730Command_ManualUpperBodyKnead3;
// 手动 上半身-滚动
UIKIT_EXTERN NSString * _Nonnull const k730Command_ManualUpperBodyRoll;

#pragma mark ------ 手动姿态 调节
// 调节停止
UIKIT_EXTERN NSString * _Nonnull const k730Command_AdjustStop;
// 靠背升+小腿降
UIKIT_EXTERN NSString * _Nonnull const k730Command_BackUpLegDown;
// 靠背降+小腿升
UIKIT_EXTERN NSString * _Nonnull const k730Command_BackDownLegUp;
// 小腿 升
UIKIT_EXTERN NSString * _Nonnull const k730Command_LegUp;
// 小腿 降
UIKIT_EXTERN NSString * _Nonnull const k730Command_LegDown;
// 小腿 伸
UIKIT_EXTERN NSString * _Nonnull const k730Command_LegStretch;
// 小腿 缩
UIKIT_EXTERN NSString * _Nonnull const k730Command_LegShrink;


@interface OGACommand_730B : NSObject

@end

NS_ASSUME_NONNULL_END
