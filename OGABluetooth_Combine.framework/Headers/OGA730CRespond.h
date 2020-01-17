//
//  OGA730CRespond.h
//  OGABluetooth730C
//
//  Created by apple on 2019/10/22.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 「自动程序动作模式」、
 「随心动作模式」、
 「拉伸动作模式」中，机芯位置在哪里，对此进行通知的情报
 */
typedef NS_ENUM(NSInteger,  k730CRepSide) {
    k730CRepSideNone = 0,     // 没有部位
    k730CRepSideNeck,         // 颈部
    k730CRepSideShoulder,     // 肩部
    k730CRepSideShoulderOut,  // 肩外
    k730CRepSideBack,         // 背部
    k730CRepSideBackOut,      // 背外
    k730CRepSideWaist,        // 腰
    k730CRepSideWaistOut,     // 腰外
    k730CRepSideWaistDown,    // 腰下
    k730CRepSideWaistDownOut, // 腰外下
};
/**
 「随心动作模式」中、通知哪个部位
 （颈部、肩、背、腰、上半身）被选择的情报
 */
typedef NS_ENUM(NSInteger,  k730CRepSelectSide) {
    k730CRepSelectSideNone = 0, // 没有部位选择
    k730CRepSelectSideNeck,     // 颈部选择
    k730CRepSelectSideBack,     // 背部选择
    k730CRepSelectSideWaist,    // 腰选择
    k730CRepSideUpperBody       // 上半身选择
};

/**
 「在酸痛检测程序程序动作模式下，通知正在进行的各部位的检测动作的情报
 */
typedef NS_ENUM(NSInteger,  k730CRepAcheDetectSide) {
    k730CRepAcheDetectSideNone = 0,   // 没有部位酸痛检测动作中
    k730CRepAcheDetectSideNeck,       // 颈部酸痛检测动作中
    k730CRepAcheDetectSideShoulderIn, // 肩内酸痛检测动作中
    k730CRepAcheDetectSideShoulderOut,// 肩外酸痛检测动作中
    k730CRepAcheDetectSideScapula,    // 肩甲骨酸痛检测动作中
    k730CRepAcheDetectSideBack,       // 背部酸痛检测动作中
    k730CRepAcheDetectSideWaist       // 腰部酸痛检测动作中
};

/**
  酸痛检测状态
 */
typedef NS_ENUM(NSInteger,  k730CRepAcheDetectState) {
    k730CRepAcheDetectStateNone = 0,   // 没有
    k730CRepAcheDetectStateIng,        // 酸痛检测中
    k730CRepAcheDetectStateFeedbacking // 酸痛反馈程序中
};

/**
 自动程序动作模式」、「随心动作模式」中，通知哪个系统的手法
 （揉捏・指圧・按摩・搓揉・部分拉伸、背部拉伸）正在被实行的情报
 */
typedef NS_ENUM(NSInteger,  k730CRepSkill) {
    k730CRepSkillNone = 0,    // 没有手法
    k730CRepSkillKnead,       // 揉捏手法被选择
    k730CRepSkillFingerPress, // 指压手法被选择
    k730CRepSkillKneadPress,  // 揉按手法被选择
    k730CRepSkillKneadComfort,// 揉抚手法被选择
    k730CRepSkillRoll,        // 滚动手法被选择
    k730CRepSkillRoll2        // 滚动手法被选择-（随心上下身的滚动手法）
};

/**
 各错误发生时通知有线操作器错误种类的情报
 */
typedef NS_ENUM(NSInteger,  k730CRepAbnormal) {
    k730CRepAbnormalNone = 0,               // 没有异常
    k730CRepAbnormalMsgStrengthOverload = 1,// 按摩力度检测过负荷异常
    k730CRepAbnormalMsgStrengthNoload = 2,  // 按摩力度检测无负荷异常
    k730CRepAbnormalCommunicationError = 3, // 通信错误
    k730CRepAbnormalSeatMPU = 4,            // 座下MPU周波数检测不良
    k730CRepAbnormalWarmHot = 7,            // 温热加热故障
    k730CRepAbnormalWarmResistanceBeak = 8, // 温热热敏电阻断线
    k730CRepAbnormalWarmResistanceShort = 9,// 温热热敏电阻短路
    k730CRepAbnormalWarmThyristorShort = 10, // 温热双向可控硅短路
    k730CRepAbnormalKnock = 17,              // 敲击检测不良
    k730CRepAbnormalCalf = 18,               // 小腿检测不良
    k730CRepAbbnormalGoUpDown = 19,          // 升降检测不良
    k730CRepAbnormalWidth = 20,              // 宽度检测不良
    k730CRepAbnormalUpDown = 21,             // 上下检测不良
    k730CRepAbnormalStrongWeak = 22,         // 强弱检测不良
    k730CRepAbnormalCalfLock = 23,           // 小腿锁死
    k730CRepAbnormalPushRodLock = 24,        // 推杆锁死
    k730CRepAbnormalCalfSerialNo = 25,       // 小腿连续ON
    k730CRepAbnormalUpDownSerialNo = 26,     // 升降连续ON
    k730CRepAbnormalKnockMotorLock = 27,     // 敲击马达锁死
    k730CRepAbnormalWidthMotorLock = 28,     // 宽度马达锁死
    k730CRepAbnormalUpDownMotorLock = 29,    // 上下马达锁死
    k730CRepAbnormalStrongWeakUpDownMotorLock = 30, // 强弱宽度马达锁死
    k730CRepAbnormalStandInspection = 31,    // 着座检知
    k730CRepAbnormalCalfTension = 32,        // 小腿伸缩检测不良
    k730CRepAbnormalCalfTensionLock = 33,    // 小腿伸缩锁死
    k730CRepAbnormalCalfTensionSerialNo = 34,// 小腿伸缩连续ON
    k730CRepAbnormalAcheDetect = 35,         // 酸痛检测通信异常
    k730CRepAbnormalFootRoll = 36,           // 足底滚轮检测不良
    k730CRepAbnormalFootRollLock = 37,       // 足底滚轮锁死
    k730CRepAbnormalFootRollSerialNo = 38,   // 足底滚轮连续ON
};


@interface OGA730CRespond : NSObject

#pragma ------ 按摩椅状态 ------

#pragma mark ------ 系统状态
// 系统开关机状态，NO：关机 YES：开机
@property (nonatomic, assign) BOOL isSysPowerOn;
// 是否停止模式（急停止）
@property (nonatomic, assign) BOOL isSysStrongStop;
// 是否弱停止模式
@property (nonatomic, assign) BOOL isSysWeakStop;
// 是否异常表示模式
@property (nonatomic, assign) BOOL isSysAbnormal;
// 错误与异常类型
@property (nonatomic, assign) k730CRepAbnormal sysAbnormalType;
// 通知有线操作器现在被选择的音量的情报 音量(0-3)档次
@property (nonatomic, assign) NSInteger sysVolume;

#pragma mark ------ 椅子功能开关
// 按键[A]被按下的信息传达给APP
@property (nonatomic, assign) BOOL isChairButtonA;
// 按键[B]被按下的信息传达给APP(一键按摩)
@property (nonatomic, assign) BOOL isChairButtonB;
// 按键[C]被按下的信息传达给APP（语音控制）
@property (nonatomic, assign) BOOL isChairButtonC;
// 语音播放和语音识别使能标志 是否开关
@property (nonatomic, assign) BOOL isChairPlayAndVoice;
// LED灯开关状态
@property (nonatomic, assign) BOOL isChairLED;
// 语音交互回答，0:无回应或识别不了 1:不同意 2:同意
@property (nonatomic, assign) NSInteger voiceAnswer;

#pragma mark ------ 按摩程序状态
// 是否收纳中模式（靠背）
@property (nonatomic, assign) BOOL isMsgBackTakeIn;
// 是否机芯收纳中模式（机芯跟小腿）
@property (nonatomic, assign) BOOL isMsgMovemontTakeIn;
// 是否程序选择模式
@property (nonatomic, assign) BOOL isMsgSelectMode;
// 是否酸痛检测程序动作模式
@property (nonatomic, assign) BOOL isMsgAcheDetectMode;
// 是否拉筋程序动作模式
@property (nonatomic, assign) BOOL isMsgStretchMode;
// 是否自选程序动作模式
@property (nonatomic, assign) BOOL isMsgOptionalMode;
// 是否自动程序A实行模式
@property (nonatomic, assign) BOOL isAutoMsg1;
// 是否(揉按解乏)自动程序
@property (nonatomic, assign) BOOL isAutoMsgPressRelax;
// 是否(揉抚放松)自动程序
@property (nonatomic, assign) BOOL isAutoMsgKneakRelax;
// 是否(身体伸展)自动程序
@property (nonatomic, assign) BOOL isAutoMsgBodyStretch;
// 是否(颈部重点)自动程序
@property (nonatomic, assign) BOOL isAutoMsgNeckFocus;
// 是否(腰部重点)自动程序
@property (nonatomic, assign) BOOL isAutoMsgWaistFocus;

#pragma mark ------ 高级功能状态
// 手法选择类型
@property (nonatomic, assign)  k730CRepSkill skillType;
// 是否联络脚部气压有效的信号
@property (nonatomic, assign) BOOL isPressureFeet;
// 是否联络腰部气压有效的信号
@property (nonatomic, assign) BOOL isPressureWaist;
// 是否联络手臂气压有效的信号
@property (nonatomic, assign) BOOL isPressureArm;
// 是否联络肩部气压有效的信号
@property (nonatomic, assign) BOOL isPressureShoulder;
// 是否捶拍选择
@property (nonatomic, assign) BOOL isPoundSelect;
// 是否捶拍实施
@property (nonatomic, assign) BOOL isPoundCarryOut;
// 体型检测中情報
@property (nonatomic, assign) BOOL isBodyShapeDetecting;
// 肩位置取得完成
@property (nonatomic, assign) BOOL isBodyShapeNeckFinish;
//「自动程序动作模式」、「气压动作模式」中，通知气压强度阶段（3阶段）的情报
@property (nonatomic, assign) NSInteger pressureStrength;

// 脚底滚轮的方向通知给座下微机的情报 正传
@property (nonatomic, assign) BOOL isRollForward;
// 脚底滚轮的方向通知给座下微机的情报 反转
@property (nonatomic, assign) BOOL isRollBackward;
// 脚底滚轮的回转速度设定（3阶段）在操作器上表示的情报 (回转速度设定1-3)
@property (nonatomic, assign) NSInteger rollSlewSpeed;
// 是否脚底滚轮动作
@property (nonatomic, assign) BOOL isRollAction;

#pragma mark ------ 动作状态
// 是否背筋拉伸动作
@property (nonatomic, assign) BOOL isActionBackTension;
// 通知肩部拉伸有效/无效的情报
@property (nonatomic, assign) BOOL isActionNeckTension;
// 腿部拉伸动作有效/无效
@property (nonatomic, assign) BOOL isActionFootTension;
// 骨盆拉伸动作有效/无效
@property (nonatomic, assign) BOOL isActionPelvisTension;
// 肩胛骨拉伸动作有效/无效
@property (nonatomic, assign) BOOL isActionScapulaTension;

// 座前，座横气压动作状态
@property (nonatomic, assign) BOOL isPressureActionSeat;
// 腰部气压动作状态
@property (nonatomic, assign) BOOL isPressureActionWaist;
// 骨盆气压动作状态
@property (nonatomic, assign) BOOL isPressureActionPelvis;
// 肩部气压动作状态
@property (nonatomic, assign) BOOL isPressureActionNeck;
// 手部气压动作状态
@property (nonatomic, assign) BOOL isPressureActionHand;
// 手臂气压动作状态
@property (nonatomic, assign) BOOL isPressureActionArm;
// 脚部气压动作状态
@property (nonatomic, assign) BOOL isPressureActionFoot;
// 腿部气压动作状态
@property (nonatomic, assign) BOOL isPressureActionLeg;

// 座下气泵动作状态
@property (nonatomic, assign) BOOL isActionSeatAirPump;
// 脚底滚轮动作状态
@property (nonatomic, assign) BOOL isActionFootRoll;


#pragma mark ------ 机芯和部位状态
// 机芯位置在那个部位
@property (nonatomic, assign) k730CRepSide movementSideType;
// 机芯强度 等级指数（0-5）
@property (nonatomic, assign) NSInteger movementStrongIndex;
// 选择部位类型
@property (nonatomic, assign) k730CRepSelectSide sideTypeSelect;
// 肩部位置（L0-L31）
@property (nonatomic, assign) NSInteger positionNeckL;
// 宽度位置（XL0-15）
@property (nonatomic, assign) NSInteger positionWidthXL;
// 强弱位置（ZL0-15）
@property (nonatomic, assign) NSInteger positionStrongWeakZL;
// 上下位置（YL0-52）
@property (nonatomic, assign) NSInteger positionUpDownYL;

#pragma mark ------ 酸痛检测状态
// 酸痛时时判定部位
@property (nonatomic, assign) k730CRepAcheDetectSide acheDetectConstantSide;
// 酸痛检测状态
@property (nonatomic, assign) k730CRepAcheDetectState acheDetectState;
// 酸痛最终判定部位
@property (nonatomic, assign) k730CRepAcheDetectSide acheDetectSide;
// 酸痛检测部位结果程度（1-3） 1：轻 2：中 3：重
@property (nonatomic, assign) NSInteger acheDetectLevel;
// 酸痛检测接触有无
@property (nonatomic, assign) BOOL isAcheDetectTouch;

@end

