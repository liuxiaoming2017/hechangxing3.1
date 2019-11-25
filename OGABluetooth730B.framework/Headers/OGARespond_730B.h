//
//  OGARespond_730B.h
//  OGAChair-730B
//
//  Created by ogawa on 2019/10/21.
//  Copyright © 2019 Hlin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, kFaultStatus) {
    kFaultStatusDefault,
    
    kFaultStatus1          = 1,    /// 按摩力度检测过负荷异常
    kFaultStatus2          = 2,    /// 按摩力度检测无负荷异常
    kFaultStatus3          = 3,    /// 通信错误
    kFaultStatus4          = 4,    /// 座下MPU周波数检测不良
    kFaultStatus7          = 7,    /// 温热加热故障
    kFaultStatus8          = 8,    /// 温热热敏电阻断线
    kFaultStatus9          = 9,    /// 温热热敏电阻短路
    kFaultStatus10         = 10,   /// 温热双向可控硅短路
    kFaultStatus17         = 17,   /// 敲击检测不良
    kFaultStatus18,                /// 小腿检测不良
    kFaultStatus19,                /// 升降检测不良
    kFaultStatus20,                /// 宽度检测不良
    kFaultStatus21,                /// 上下检测不良
    kFaultStatus22,                /// 强弱检测不良
    kFaultStatus23,                /// 小腿锁死
    kFaultStatus24,                /// 推杆锁死
    kFaultStatus25,                /// 小腿连续ON
    kFaultStatus26,                /// 升降连续ON
    kFaultStatus27,                /// 敲击马达锁死
    kFaultStatus28,                /// 宽度马达锁死
    kFaultStatus29,                /// 上下马达锁死
    kFaultStatus30,                /// 强弱宽度马达锁死
    kFaultStatus31,                /// 着座检知
    kFaultStatus32,                /// 小腿伸缩检测不良
    kFaultStatus33,                /// 小腿伸缩锁死
    kFaultStatus34,                /// 小腿伸缩连续ON
    kFaultStatus35,                /// 酸痛检测通信异常
    kFaultStatus36,                /// 足底滚轮检测不良
    kFaultStatus37,                /// 足底滚轮锁死
    kFaultStatus38,                /// 足底滚轮连续ON
};

typedef NS_ENUM(NSUInteger, kDetectionAche) {
    
    kDetectionAcheNone,     /// 酸痛感-无
    kDetectionAcheSamll,    /// 酸痛感-小
    kDetectionAcheBig,      /// 酸痛感-大
};

typedef NS_ENUM(NSUInteger, kDetectionAchePart) {
    kDetectionAchePartDefault,
    
    kDetectionAchePartNeck              = 1, /// 颈部
    kDetectionAchePartShoulderIn        = 2, /// 肩内
    kDetectionAchePartShoulderOut       = 3, /// 肩外
    kDetectionAchePartShoulderBlade     = 4, /// 肩胛骨
    kDetectionAchePartBack              = 8, /// 背部
    kDetectionAchePartWaist             = 12,/// 腰部
    
    kDetectionAchePartOther             = 63,/// 除外
};

typedef NS_ENUM(NSUInteger, kDetectionAcheStatus) {
    
    kDetectionAcheStatusNone,            /// 未进行过酸痛检测
    kDetectionAcheStatusDoing,           /// 酸痛检测中
    kDetectionAcheStatusDone,            /// 酸痛检测完成
};

typedef NS_ENUM(NSUInteger, kLedStatus) {
    
    kLedStatusOff,           /// LED-关
    kLedStatusRed,           /// LED-红
    kLedStatusGreen,         /// LED-绿
    kLedStatusBlue,          /// LED-蓝
    kLedStatusOrange,        /// LED-橙
    kLedStatusPurple,        /// LED-紫
    kLedStatusCyan,          /// LED-青
    kLedStatusWhite,         /// LED-白
};

/// 自动按摩模式
typedef NS_ENUM(NSUInteger, kAutoMassage) {
    kAutoMassageDefalut,
    
    kAutoMassageVigorous       = 7, /// 揉按解乏
    kAutoMassageRelax,              /// 揉抚放松
    kAutoMassageStretch,            /// 身体伸展
    kAutoMassageUpperBack,          /// 颈部重点
    kAutoMassageLowerBack,          /// 腰部重点
    kAutoMassageGentle,             /// 电脑一族
    kAutoMassageNeckShoulder,       /// 开车一族
    kAutoMassageFeetCalves,         /// 逛街一族
    kAutoMassageAltheltic,          /// 手机一族
    kAutoMassageJapanese,           /// 养肾按摩
    kAutoMassageChinese,            /// 养肝按摩
    kAutoMassageBalinese,           /// 和胃按摩
    kAutoMassageThai,               /// 泰式按摩
    kAutoMassageAcheRecommend,      /// 酸痛推荐
    kAutoMassageTryme,              /// Tryme
    kAutoMassageUserExclusive,      /// 用户专属
};

@interface OGARespond_730B : NSObject

#pragma mark ------ 状态

/// 停止模式，【急停止】按键按完后5秒间的模式
@property (nonatomic, assign) BOOL modeStop;

/// 异常模式，各错误产生的情况下，对错误表示的模式 (LCD,LED闪光)
@property (nonatomic, assign) BOOL modeAbnormal;

/// 弱停止模式，气压动作选择时等移动到按摩球最弱的动作模式
@property (nonatomic, assign) BOOL modeWeakStop;

/// 收纳中模式（靠背），「开/关」按键引起的收纳动作 或者 「定时到时」引起的收纳动作
@property (nonatomic, assign) BOOL modeAcceptBack;

/// 收纳中模式（机芯和小腿），「开/关」按键引起的收纳动作 或者 「定时到时」引起的收纳动作
@property (nonatomic, assign) BOOL modeAcceptMovmentAndLeg;

/// 程序选择模式，「开/关」按键被按下、 移动到各动作模式前的选择模式
@property (nonatomic, assign) BOOL modeProgrameSelect;

#pragma mark ------ 自动按摩
/// 自动按摩模式
@property (nonatomic, assign) kAutoMassage autoMassage;

/// 酸痛检测程序动作模式
@property (nonatomic, assign) BOOL modeDetectionAche;

/// 上位的动作模式
@property (nonatomic, assign) BOOL modeUpperAction;

/// 操作器旋钮按键状态信息，1:升降动作中 0:无升降动作
@property (nonatomic, assign) BOOL modeRotaryKnob;

/// 自动程序伴随功能按键开启与否，1:允许“充气” “伸展”伴随功能按键使用 0:禁止“充气”“伸展”伴随功能按键使用
@property (nonatomic, assign) BOOL modeAllowAirAndStrength;

#pragma mark ------ 按摩动作执行状态
/// 揉按手法被选择
@property (nonatomic, assign) BOOL massage_ExecuteKnead1;
/// 揉抚手法被选择
@property (nonatomic, assign) BOOL massage_ExecuteKnead2;
/// 揉捏手法被选择
@property (nonatomic, assign) BOOL massage_ExecuteKnead3;
/// 指压手法被选择
@property (nonatomic, assign) BOOL massage_ExecuteShiatsu;
/// 部分滚动手法被选择
@property (nonatomic, assign) BOOL massage_ExecuteRollPart;
/// 背部滚动手法被选择
@property (nonatomic, assign) BOOL massage_ExecuteRollBack;
/// 敲击手法被选择，1。独立开启的执行状态 2.伴随其他五种手动手法
@property (nonatomic, assign) BOOL massage_ExecuteKnock1;
/// 敲击手法被选择，1.独立开启的按键状态 2.自动程序伴随的动作
@property (nonatomic, assign) BOOL massage_ExecuteKnock2;

/// 「自动程序动作模式」、「随心动作模式」、「拉伸动作模式」中机芯的强度：0-5
@property (nonatomic, assign) NSUInteger massage_MovmentGears;
/// 「自动程序动作模式」、「气压 动作模式」中，通知气压强度阶 段(3阶段)：1-3
@property (nonatomic, assign) NSUInteger massage_AirGears;

/// 机芯X轴坐标：范围1-10，1最窄，10最宽
@property (nonatomic, assign) NSUInteger massage_MovementXLoca;
/// 机芯Z轴坐标：范围1-10，1最弱，10最强
@property (nonatomic, assign) NSUInteger massage_MovementZLoca;
/// 机芯Y轴坐标：范围0-52，0最顶部，52最底部
@property (nonatomic, assign) NSUInteger massage_MovementYLoca;

///  表示「剩余时间」，「自动程序」「随心气压」「随心拉伸」动作在体型检测终了后定时开始，「随心气压」不用进行体型检测直接开始动作，动作开始后计时开始
@property (nonatomic, assign) NSUInteger massage_SurplusTime;

/// 气压动作模式」、「随心拉伸动作模式」
/// 座前/座横 气压动作 状态
@property (nonatomic, assign) BOOL massage_ExecuteAirSeat;
/// 腰部 气压动作 状态
@property (nonatomic, assign) BOOL massage_ExecuteAirWaist;


/// 骨盆 气压动作 状态，「自动程序动作模式」、「随心气压动作模式」、「随心拉伸动作模式」
@property (nonatomic, assign) BOOL massage_ExecuteAirPelvis;
/// 肩部 气压动作 状态，「自动程序动作模式」、「随心气压动作模式」、「随心拉伸动作模式」
@property (nonatomic, assign) BOOL massage_ExecuteAirShoulder;
/// 手部 气压动作 状态，「自动程序动作模式」、「随心气压动作模式」、「随心拉伸动作模式」
@property (nonatomic, assign) BOOL massage_ExecuteAirTebe;
/// 手臂 气压动作 状态，「自动程序动作模式」、「随心气压动作模式」、「随心拉伸动作模式」
@property (nonatomic, assign) BOOL massage_ExecuteAirArm;
/// 脚部 气压动作 状态，「自动程序动作模式」、「随心气压动作模式」、「随心拉伸动作模式」
@property (nonatomic, assign) BOOL massage_ExecuteAirFoot;
/// 腿部 气压动作 状态，「自动程序动作模式」、「随心气压动作模式」、「随心拉伸动作模式」
@property (nonatomic, assign) BOOL massage_ExecuteAirLeg;

/// 脚底滚轮动作，1:动作 0:不动作
@property (nonatomic, assign) BOOL massage_ExecuteFootRoll;

#pragma mark ------ 按键状态
/// 脚部充气按键状态
@property (nonatomic, assign) BOOL massage_StatusAirFoot;
/// 腰部充气按键状态
@property (nonatomic, assign) BOOL massage_StatusAirWaist;
/// 手部充气按键状态
@property (nonatomic, assign) BOOL massage_StatusAirArm;
/// 肩部充气按键状态
@property (nonatomic, assign) BOOL massage_StatusAirShoulder;


/// 手动-颈部伸展按键状态
@property (nonatomic, assign) BOOL massage_StatusStrengthNeck;
/// 手动-腿部伸展按键状态
@property (nonatomic, assign) BOOL massage_StatusStrengthLeg;
/// 手动-骨盆伸展按键状态
@property (nonatomic, assign) BOOL massage_StatusStrengthPelvis;
/// 手动-肩胛骨伸展按键状态
@property (nonatomic, assign) BOOL massage_StatusStrengthShoulder;

/// 手动机芯部位选择按键状态（颈部）
@property (nonatomic, assign) BOOL massage_StatusNeck;
/// 手动机芯部位选择按键状态（肩部）
@property (nonatomic, assign) BOOL massage_StatusShoulder;
/// 手动机芯部位选择按键状态（背部）
@property (nonatomic, assign) BOOL massage_StatusBack;
/// 手动机芯部位选择按键状态（腰部）
@property (nonatomic, assign) BOOL massage_StatusWaist;
/// 手动机芯部位选择按键状态（上半身）
@property (nonatomic, assign) BOOL massage_StatusUpperBody;

/// 加热按键状态
@property (nonatomic, assign) BOOL massage_StatusWarm;

/// 酸痛检测(A)按键状态
@property (nonatomic, assign) BOOL massage_StatusAkey;
/// 一键启动(B)按键状态，1按下，0未被按下
@property (nonatomic, assign) BOOL massage_StatusBkey;
/// 开启语音(C)按键状态，1按下，0未被按下
@property (nonatomic, assign) BOOL massage_StatusCkey;


#pragma mark ------ 酸痛检测状态
/// 各个部位进行酸痛检测时，通知酸痛判定结果
@property (nonatomic, assign) kDetectionAche ache;
/// 在酸痛检测程序程序动作模式下，记录当前正在检测的部位
@property (nonatomic, assign) kDetectionAchePart achePart;
/// 酸痛检测状态
@property (nonatomic, assign) kDetectionAcheStatus acheStatus;

/// 各个部位进行酸痛检测时，记录上个检测完成的部位
@property (nonatomic, assign) kDetectionAchePart achePart2;
/// 酸痛检测接触有无的情报 1:有接触 0:没有接触
@property (nonatomic, assign) BOOL acheTouchStatus;


#pragma mark ------ 体型检测
/// 体型检测中状态，1 检测中，0 其他状态
@property (nonatomic, assign) BOOL detectBodyStatus;
/// 肩部位置检测结果，是否检测到肩膀位置，1检测到 0未检测到
@property (nonatomic, assign) BOOL haveShoulderDetect;
/// 肩位置检测结果，肩位置0-20
@property (nonatomic, assign) NSUInteger detectShoulderLoca;


#pragma mark ------ LED状态
/// 酸痛手柄LED灯状态信息
@property (nonatomic, assign) kLedStatus ledAcheStatus;
/// 头罩灯LED状态
@property (nonatomic, assign) kLedStatus ledHoodStatus;

#pragma mark ------ 各错误发生时通知
/// 错误状态
@property (nonatomic, assign) kFaultStatus faultStatus;

@end

NS_ASSUME_NONNULL_END
