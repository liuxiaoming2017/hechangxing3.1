//
//  OGA730CCmd.h
//  OGABluetooth730C
//
//  Created by apple on 2019/10/22.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark ------ 短按指令：系统
// 开机
UIKIT_EXTERN NSString * _Nonnull const k730CCmd_Sys_PowerOn;
// 关机
UIKIT_EXTERN NSString * _Nonnull const k730CCmd_Sys_PowerOff;
// 停止—(紧急停止)
UIKIT_EXTERN NSString * _Nonnull const k730CCmd_Sys_Stop;

#pragma mark ------ 短按指令：自动程序
// 揉按解乏
UIKIT_EXTERN NSString * _Nonnull const k730CCmd_AutoMsg_PressRelax;
// 揉抚放松
UIKIT_EXTERN NSString * _Nonnull const k730CCmd_AutoMsg_KneakRelax;
// 身体伸展
UIKIT_EXTERN NSString * _Nonnull const k730CCmd_AutoMsg_BodyStretch;
// 颈部重点
UIKIT_EXTERN NSString * _Nonnull const k730CCmd_AutoMsg_NeckFocus;
// 腰部重点
UIKIT_EXTERN NSString * _Nonnull const k730CCmd_AutoMsg_WaistFocus;


#pragma mark ------ 短按指令：椅子功能开关
// LED开
UIKIT_EXTERN NSString * _Nonnull const k730CCmd_Chair_LEDOpen;
// LED关
UIKIT_EXTERN NSString * _Nonnull const k730CCmd_Chair_LEDShut;
// 温热开
UIKIT_EXTERN NSString * _Nonnull const k730CCmd_Chair_WarmOpen;
// 温热关
UIKIT_EXTERN NSString * _Nonnull const k730CCmd_Chair_WarmShut;
// 开语音播放和识别
UIKIT_EXTERN NSString * _Nonnull const k730CCmd_Chair_VoiceOpen;
// 关语音播放和识别
UIKIT_EXTERN NSString * _Nonnull const k730CCmd_Chair_VoiceShut;

#pragma mark ------ 短按指令：高级功能
// 体型检测
UIKIT_EXTERN NSString * _Nonnull const k730CCmd_HighF_ShapeDetect;
// 酸痛检测
UIKIT_EXTERN NSString * _Nonnull const k730CCmd_HighF_AcheDetect;
// 捶拍
UIKIT_EXTERN NSString * _Nonnull const k730CCmd_HighF_Pound;
// 颈部拉伸—(伸展--滚动)
UIKIT_EXTERN NSString * _Nonnull const k730CCmd_HighF_StretchNeck;
// 肩胛骨拉伸
UIKIT_EXTERN NSString * _Nonnull const k730CCmd_HighF_StretchScapula;
// 骨盆拉伸
UIKIT_EXTERN NSString * _Nonnull const k730CCmd_HighF_Stretchpelvis;
// 腿部拉伸
UIKIT_EXTERN NSString * _Nonnull const k730CCmd_HighF_StretchLeg;
// 肩部气压
UIKIT_EXTERN NSString * _Nonnull const k730CCmd_HighF_PressShoulder;
// 手臂气压
UIKIT_EXTERN NSString * _Nonnull const k730CCmd_HighF_PressArm;
// 腰部气压
UIKIT_EXTERN NSString * _Nonnull const k730CCmd_HighF_PressWaist;
// 脚部气压
UIKIT_EXTERN NSString * _Nonnull const k730CCmd_HighF_PressLeg;
// 强（气压）
UIKIT_EXTERN NSString * _Nonnull const k730CCmd_HighF_PressStrong;
// 弱（气压）
UIKIT_EXTERN NSString * _Nonnull const k730CCmd_HighF_PressWeak;
// 快速体验
UIKIT_EXTERN NSString * _Nonnull const k730CCmd_HighF_FastExperience;
// 脚底滚轮
UIKIT_EXTERN NSString * _Nonnull const k730CCmd_HighF_FootRoller;

#pragma mark ------ 短按指令：机芯
// 上  （机芯和肩位置）
UIKIT_EXTERN NSString * _Nonnull const k730CCmd_Movement_Up;
// 下  （机芯和肩位置）
UIKIT_EXTERN NSString * _Nonnull const k730CCmd_Movement_Down;
// 宽度 变宽
UIKIT_EXTERN NSString * _Nonnull const k730CCmd_Movement_Wide;
// 宽度 变窄
UIKIT_EXTERN NSString * _Nonnull const k730CCmd_Movement_Narrow;
// 强（机芯）
UIKIT_EXTERN NSString * _Nonnull const k730CCmd_Movement_Strong;
// 弱（机芯）
UIKIT_EXTERN NSString * _Nonnull const k730CCmd_Movement_Weak;

#pragma mark ------ 长按指令（200ms发一次无需回应）
// 靠背立起
UIKIT_EXTERN NSString * _Nonnull const k730CCmd_LongPress_BackUp;
// 靠背倒下
UIKIT_EXTERN NSString * _Nonnull const k730CCmd_LongPress_BackDown;
// 小腿抬起
UIKIT_EXTERN NSString * _Nonnull const k730CCmd_LongPress_LegUp;
// 小腿下降
UIKIT_EXTERN NSString * _Nonnull const k730CCmd_LongPress_LegDown;
// 小腿伸出
UIKIT_EXTERN NSString * _Nonnull const k730CCmd_LongPress_LegStretch;
// 小腿收缩
UIKIT_EXTERN NSString * _Nonnull const k730CCmd_LongPress_LegDraw;

// 按摩部位
typedef NS_ENUM(NSInteger,  k730CCmdSideType) {
    k730CCmdSideNeck = 0,     // 颈部
    k730CCmdSideShoulder = 1, // 肩部
    k730CCmdSideBack = 2,     // 背部
    k730CCmdSideWaist = 3,    // 腰部
    k730CCmdSideUpperBody = 4,// 上半身
};

// 按摩手法
typedef NS_ENUM(NSInteger,  k730CCmdHandWayType) {
    k730CCmdHandWayKnead = 0,       // 揉捏
    k730CCmdHandWayFingerPress = 1, // 指压
    k730CCmdHandWayKneadPress = 2,  // 揉按
    k730CCmdHandWayKneadComfort = 3,// 揉抚
    k730CCmdHandWayRoll = 4,        // 滚动
};

@interface OGA730CCmd : NSObject

/**
 * 随心程度
 *
 * param level 档位 0-24
 *
 * return 返回相应短按指令, 如果没有相应指令返回nil
 */
+ (NSString *)cmdLevelOfMind:(NSInteger)level;

/**
 * 随心 按摩组合
 *
 * param sideType 按摩部位
 * param handWayTypeb 手法
 * param isPound 是否捶拍
 *
 * return 返回相应“随心 按摩组合”短按指令, 如果没有相应指令返回nil
*/
+ (NSString *)cmdCombineWithSideType:(k730CCmdSideType)sideType handWayType:(k730CCmdHandWayType)handWayType isPound:(BOOL)isPound;

/**
 * 酸痛推荐 （1- 81）
 *
 * param index 酸痛推荐数 （1- 81）
 *
 * return 返回相应短按指令, 如果没有相应指令返回nil
*/
+ (NSString *)cmdAcheRecommendWithIndex:(NSInteger) index;


@end

NS_ASSUME_NONNULL_END
