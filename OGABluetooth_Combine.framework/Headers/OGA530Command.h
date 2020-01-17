//
//  OGA530Command.h
//  OGAChair-530
//
//  Created by ogawa on 2019/7/23.
//  Copyright © 2019 Hlin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark ------ 系统
// 指令-开机
UIKIT_EXTERN NSString * _Nonnull const k530Command_PowerOn;
// 指令-暂停
UIKIT_EXTERN NSString * _Nonnull const k530Command_Pause;
// 指令-定时
UIKIT_EXTERN NSString * _Nonnull const k530Command_Timing;
// 指令-关机
UIKIT_EXTERN NSString * _Nonnull const k530Command_PowerOff;
// 指令-酸痛检测
UIKIT_EXTERN NSString * _Nonnull const k530Command_MassageIntellect;


// 指令-专属-1-大师精选
UIKIT_EXTERN NSString * _Nonnull const k530Command_MassageMaster;
// 指令-专属-2-轻松自在
UIKIT_EXTERN NSString * _Nonnull const k530Command_MassageRelease;
// 指令-专属-3-关节呵护
UIKIT_EXTERN NSString * _Nonnull const k530Command_KneeCare;
// 指令-专属-4-脊柱支柱
UIKIT_EXTERN NSString * _Nonnull const k530Command_SpinalReleasePressure;
// 指令-主题-1-上班族
UIKIT_EXTERN NSString * _Nonnull const k530Command_Sedentary;
// 指令-主题-2-低头族
UIKIT_EXTERN NSString * _Nonnull const k530Command_TextNeck;
// 指令-主题-3-驾车族
UIKIT_EXTERN NSString * _Nonnull const k530Command_Traceller;
// 指令-主题-4-运动派
UIKIT_EXTERN NSString * _Nonnull const k530Command_Athlete;
// 指令-主题-5-御宅派
UIKIT_EXTERN NSString * _Nonnull const k530Command_CosyComfort;
// 指令-主题-6-爱购派
UIKIT_EXTERN NSString * _Nonnull const k530Command_Shopping;
// 指令-区域-1-巴黎式
UIKIT_EXTERN NSString * _Nonnull const k530Command_Balinese;
// 指令-区域-2-中式
UIKIT_EXTERN NSString * _Nonnull const k530Command_MassageChinese;
// 指令-区域-3-泰式
UIKIT_EXTERN NSString * _Nonnull const k530Command_MassageThai;
// 指令-女士-1-深层按摩
UIKIT_EXTERN NSString * _Nonnull const k530Command_MassageDeepTissue;
// 指令-女士-2-活血循环
UIKIT_EXTERN NSString * _Nonnull const k530Command_MassageBloodCirculation;
// 指令-女士-3-活力唤醒
UIKIT_EXTERN NSString * _Nonnull const k530Command_MassageMotionRecovery;
// 指令-女士-4-美臀塑性
UIKIT_EXTERN NSString * _Nonnull const k530Command_MassageHipsShapping;
// 指令-女士-5-元气复苏
UIKIT_EXTERN NSString * _Nonnull const k530Command_MassageEnergyRecovery;
// 指令-女士-6-绽放魅力
UIKIT_EXTERN NSString * _Nonnull const k530Command_MassageBalanceMind;
// 指令-场景-1-清晨唤醒
UIKIT_EXTERN NSString * _Nonnull const k530Command_MassageAMRoutine;
// 指令-场景-2-瞬间补眠
UIKIT_EXTERN NSString * _Nonnull const k530Command_MassageMiddayRest;
// 指令-场景-3-夜晚助眠
UIKIT_EXTERN NSString * _Nonnull const k530Command_MassageSweetDreams;

// 指令-按摩强度-
UIKIT_EXTERN NSString * _Nonnull const k530Command_MassageStrength;
// 指令-揉捏速度-
UIKIT_EXTERN NSString * _Nonnull const k530Command_KneadSpeed;
// 指令-敲击速度-
UIKIT_EXTERN NSString * _Nonnull const k530Command_KnockSpeed;

// 指令-按摩强度+
UIKIT_EXTERN NSString * _Nonnull const k530Command_MassageStrengthAdd;
// 指令-揉捏速度+
UIKIT_EXTERN NSString * _Nonnull const k530Command_KneckSpeedAdd;
// 指令-敲击速度+
UIKIT_EXTERN NSString * _Nonnull const k530Command_KnockSpeedAdd;


// 指令-机芯手动程序定点
UIKIT_EXTERN NSString * _Nonnull const k530Command_MovementPoint;
// 指令-机芯手动程序区间
UIKIT_EXTERN NSString * _Nonnull const k530Command_MovementInterval;
// 指令-机芯手动程序全背
UIKIT_EXTERN NSString * _Nonnull const k530Command_MovementAllBack;
// 指令-机芯调窄
UIKIT_EXTERN NSString * _Nonnull const k530Command_MovementNarrow;
// 指令-机芯调宽
UIKIT_EXTERN NSString * _Nonnull const k530Command_MovementWide;
// 指令-机芯上行
UIKIT_EXTERN NSString * _Nonnull const k530Command_MovementUp;
// 指令-机芯下行
UIKIT_EXTERN NSString * _Nonnull const k530Command_MovementDown;
// 指令-机芯 3D前伸
UIKIT_EXTERN NSString * _Nonnull const k530Command_MovementFront;
// 指令-机芯 3D后缩
UIKIT_EXTERN NSString * _Nonnull const k530Command_MovementAfter;
// 指令-机芯手动程序推拿/滚动
UIKIT_EXTERN NSString * _Nonnull const k530Command_MovementRoll;
// 指令-机芯手动程序揉捏
UIKIT_EXTERN NSString * _Nonnull const k530Command_MovementKnead;
// 指令-机芯手动程序拍打
UIKIT_EXTERN NSString * _Nonnull const k530Command_MovementClap;
// 指令-机芯手动程序指压
UIKIT_EXTERN NSString * _Nonnull const k530Command_MovementShiatsu;
// 指令-机芯手动程序敲击
UIKIT_EXTERN NSString * _Nonnull const k530Command_MovementKnock;
// 指令-机芯手动程序瑞典
UIKIT_EXTERN NSString * _Nonnull const k530Command_MovementSweden;

#pragma mark ------ 推杆角度调节
// 指令-倒背
UIKIT_EXTERN NSString * _Nonnull const k530Command_Backdown;
// 指令-升背
UIKIT_EXTERN NSString * _Nonnull const k530Command_BackUp;
// 指令-抬腿
UIKIT_EXTERN NSString * _Nonnull const k530Command_legUp;
// 指令-降腿
UIKIT_EXTERN NSString * _Nonnull const k530Command_legDown;
// 指令-小腿1伸(上小腿)
UIKIT_EXTERN NSString * _Nonnull const k530Command_UpperLegStretch;
// 指令-小腿1缩(上小腿)
UIKIT_EXTERN NSString * _Nonnull const k530Command_UpperLegShrink;
// 指令-小腿2伸(下小腿)
UIKIT_EXTERN NSString * _Nonnull const k530Command_LowerLegStretch;
// 指令-小腿2缩(下小腿)
UIKIT_EXTERN NSString * _Nonnull const k530Command_LowerLegShrink;
// 指令-角度1（收纳）
UIKIT_EXTERN NSString * _Nonnull const k530Command_AngleAdmission;
// 指令-角度2（零重力）
UIKIT_EXTERN NSString * _Nonnull const k530Command_AngleZero;
// 指令-角度3（展开）
UIKIT_EXTERN NSString * _Nonnull const k530Command_AngleOpen;

#pragma mark ------ 充气
// 指令-充气强度
UIKIT_EXTERN NSString * _Nonnull const k530Command_AirStrength;
// 指令-充气强度+
UIKIT_EXTERN NSString * _Nonnull const k530Command_AirStrengthAdd;
// 指令-肩部充气
UIKIT_EXTERN NSString * _Nonnull const k530Command_AirShoulder;
// 指令-座部充气
UIKIT_EXTERN NSString * _Nonnull const k530Command_AirSeat;
// 指令-手臂充气
UIKIT_EXTERN NSString * _Nonnull const k530Command_AirArm;
// 指令-小腿充气
UIKIT_EXTERN NSString * _Nonnull const k530Command_AirLeg;

// 指令-高级程序脚底滚轮
UIKIT_EXTERN NSString * _Nonnull const k530Command_AdvanceFootRoll;
// 指令-全身充气
UIKIT_EXTERN NSString * _Nonnull const k530Command_AirAllBody;

#pragma mark ------ 加热/滚轮/Led
// 指令-颈肩4D
UIKIT_EXTERN NSString * _Nonnull const k530Command_NeckShoulder4D;
// 指令-腰部滚压
UIKIT_EXTERN NSString * _Nonnull const k530Command_WaistRoll;
// 指令-背部加热
UIKIT_EXTERN NSString * _Nonnull const k530Command_BackWarm;
// 指令-脚底滚轮
UIKIT_EXTERN NSString * _Nonnull const k530Command_FootRoll;
// 指令-膝盖按摩
UIKIT_EXTERN NSString * _Nonnull const k530Command_MassageKnee;
// 指令-小腿加热
UIKIT_EXTERN NSString * _Nonnull const k530Command_LegWarm;
// 指令-LED -开关
UIKIT_EXTERN NSString * _Nonnull const k530Command_LedSwitch;
// 指令-LED-波浪
UIKIT_EXTERN NSString * _Nonnull const k530Command_LedWave;
// 指令-LED-呼吸
UIKIT_EXTERN NSString * _Nonnull const k530Command_LedBreath;
// 指令-LED-唤醒
UIKIT_EXTERN NSString * _Nonnull const k530Command_LedAwaken;
// 指令-LED -朦胧
UIKIT_EXTERN NSString * _Nonnull const k530Command_LedObscure;
// 指令-LED -热量
UIKIT_EXTERN NSString * _Nonnull const k530Command_LedHot;
// 指令-LED -松弛
UIKIT_EXTERN NSString * _Nonnull const k530Command_LedRelax;
// 指令-LED -彩虹
UIKIT_EXTERN NSString * _Nonnull const k530Command_LedRainbow;

#pragma mark ------ 肩部检测
// 指令-结束肩部位置调节
UIKIT_EXTERN NSString * _Nonnull const k530Command_ShouldeAdjustEnd;
// 指令-肩部重新检测
UIKIT_EXTERN NSString * _Nonnull const k530Command_ShouldeAdjustRestart;

// 指令-酸痛检测完功能确认开启
UIKIT_EXTERN NSString * _Nonnull const k530Command_AcheDone;


#pragma mark ------ 工程模式
// 指令-自检测
UIKIT_EXTERN NSString * _Nonnull const k530Command_TestAuto;
// 指令-手检测
UIKIT_EXTERN NSString * _Nonnull const k530Command_TestManual;
// 指令-包装
UIKIT_EXTERN NSString * _Nonnull const k530Command_TestPack;

@interface OGA530Command : NSObject

@end

NS_ASSUME_NONNULL_END

