//
//  OGA530Respond.h
//  OGAChair-530
//
//  Created by ogawa on 2019/8/2.
//  Copyright © 2019 Hlin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 按摩程序
 
 - kProgrameDefault: 无
 - kProgrameMaster: 大师精选
 - kProgrameRelease: 轻松自在
 - kProgrameKneeCare: 关节呵护
 - kProgrameSpinalReleasePressure: 脊柱支持
 - kProgrameSedentary: 上班族
 - kProgrameTextNeck: 低头族
 - kProgrameTraceller: 驾车族
 - kProgrameAthlete: 运动派
 - kProgrameCosyComfort: 御宅派
 - kProgrameShopping: 爱购派
 - kProgrameBalinese: 巴黎式
 - kProgrameChinese: 中式
 - kProgrameThai: 泰式
 - kProgrameDeepTissue: 深层按摩
 - kProgrameBloodCirculation: 活血循环
 - kProgrameMotionRecovery: 活力唤醒
 - kProgrameHipsShapping:  美臀塑形
 - kProgrameEnergyRecovery: 元气复苏
 - kProgrameBalanceMind: 绽放魅力
 - kProgrameAMRoutine: 清晨唤醒
 - kProgrameMiddayRest: 瞬间补眠
 - kProgrameSweetDreams: 夜间助眠

 */
typedef NS_ENUM(NSUInteger, kPrograme) {
    
    
    kProgrameDefault = 0,
    
    kProgrameMaster,
    kProgrameRelease,
    kProgrameKneeCare,
    kProgrameSpinalReleasePressure,
    
    kProgrameSedentary,
    kProgrameTextNeck,
    kProgrameTraceller,
    kProgrameAthlete,
    kProgrameCosyComfort,
    kProgrameShopping,
    
    kProgrameBalinese,
    kProgrameChinese,
    kProgrameThai,
    
    kProgrameDeepTissue,
    kProgrameBloodCirculation,
    kProgrameMotionRecovery,
    kProgrameHipsShapping,
    kProgrameEnergyRecovery,
    kProgrameBalanceMind,
    
    kProgrameAMRoutine,
    kProgrameMiddayRest,
    kProgrameSweetDreams,

};


/**
 酸痛检测部位

 - kAchePartDefault: 无酸痛检测；
 - kAchePartNeck: 颈部
 - kAchePartShoulderIn: 肩内
 - kAchePartShoulderOut: 肩外
 - kAchePartShoulderBlade: 肩胛骨
 - kAchePartBack: 背部
 - kAchePartWaist: 腰部
 */
typedef NS_ENUM(NSUInteger, kAchePart) {
    
    kAchePartDefault = 0,
    
    kAchePartNeck,
    kAchePartShoulderIn,
    kAchePartShoulderOut,
    kAchePartShoulderBlade,
    kAchePartBack,
    kAchePartWaist
};

/**
 酸痛检测中和判定结果

 - kAcheResultDefalut: 无酸痛检测
 - kAcheResultAcheIng: 酸痛检测中
 - kAcheResultLight: 轻度酸痛
 - kAcheResultHeavy: 重度酸痛
 - kAcheResultNone: 无酸痛
 */
typedef NS_ENUM(NSUInteger, kAcheResult) {
    
    kAcheResultDefalut = 0,
    
    kAcheResultAcheIng,
    kAcheResultLight,
    kAcheResultHeavy,
    kAcheResultNone,
};


/**
 人体检测状态
 
 - kDetectionStatusUnknown: 未知
 - kDetectionStatusDetecting: 人体检测中
 - kDetectionStatusDetectionCompleted: 人体检测完成
 - kDetectionStatusAllowManualAdjustment: 允许肩部位置手动微调
 - kDetectionStatusPostureIsWrong: 坐姿有误
 */
typedef NS_ENUM(NSInteger, kDetectionStatus) {
    
    kDetectionStatusUnknown = 0,
    
    kDetectionStatusDetecting = 1,
    kDetectionStatusDetectionCompleted = 2,
    kDetectionStatusAllowManualAdjustment = 3,
    kDetectionStatusPostureIsWrong = 4,
};

/**
 穴位未知
 
 - kAcupTypeUnknown: 未知
 - kAcupTypeFengchiTianzhu: 风池天柱
 - kAcupTypeJianJingJianZhong: 肩井肩中
 - kAcupTypeFeiYu: 肺俞
 - kAcupTypeXinYu: 心俞
 - kAcupTypeGangYu: 肝俞
 - kAcupTypePiYu: 脾俞
 - kAcupTypeShengYu: 肾俞
 - kAcupTypePangGuangYu: 膀胱俞
 - kAcupTypeBaLiaoXue: 八髎穴
 - EXAcupTypeHuanZhongHuanTiao: 环中环跳
 */
typedef NS_ENUM(NSInteger, kAcupType) {
    kAcupTypeUnknown = -1,
    kAcupTypeFengchiTianzhu,
    kAcupTypeJianJingJianZhong,
    kAcupTypeFeiYu,
    kAcupTypeXinYu,
    kAcupTypeGangYu,
    kAcupTypePiYu,
    kAcupTypeShengYu,
    kAcupTypePangGuangYu,
    kAcupTypeBaLiaoXue,
    kAcupTypeHuanZhongHuanTiao,
};



@interface OGA530Respond : NSObject

#pragma ------ 按摩椅状态 ------

/** 系统开关机状态，NO：关机 YES：开机 */
@property (nonatomic, assign) BOOL powerOn;
/** 暂停状态，YES：暂停 */
@property (nonatomic, assign) BOOL pause;
/** 按摩定时到状态，YES：定时 */
@property (nonatomic, assign) BOOL timing;

#pragma mark ------- 手法执行 ------
/** 揉捏1手法(向内)  执行中 */
@property (nonatomic, assign) BOOL executeKnead1;
/** 揉捏2手法(向外)  执行中 */
@property (nonatomic, assign) BOOL executeKnead2;
/** 敲击1手法执行中 */
@property (nonatomic, assign) BOOL executeKnock1;
/** 敲击2手法执行中 */
@property (nonatomic, assign) BOOL executeKnock2;
/** 拍打1手法执行中 */
@property (nonatomic, assign) BOOL executeClap1;
/** 拍打2手法执行中 */
@property (nonatomic, assign) BOOL executeClap2;

/** 指压1手法执行中 */
@property (nonatomic, assign) BOOL executeShiatsu1;
/** 指压2手法执行中 */
@property (nonatomic, assign) BOOL executeShiatsu2;
/** 推拿(滚动)手法执行中手法执行中 */
@property (nonatomic, assign) BOOL executeRoll;
/** 瑞典1手法执行中 */
@property (nonatomic, assign) BOOL executeSweden1;
/** 瑞典2手法执行中 */
@property (nonatomic, assign) BOOL executeSweden2;
/** 座部震动 */
@property (nonatomic, assign) BOOL seatShake;

/** 背部加热IO状态 */
@property (nonatomic, assign) BOOL executeWarmBack;
/** 脚底滚轮IO状态 */
@property (nonatomic, assign) BOOL executeRollFoot;

/** 肩部充气IO状态 */
@property (nonatomic, assign) BOOL executeAirShoulder;
/** 手臂充气IO状态 */
@property (nonatomic, assign) BOOL executeAirArm;
/** 座恻充气IO状态 */
@property (nonatomic, assign) BOOL executeAirSeat;
/** 膝盖充气IO状态 */
@property (nonatomic, assign) BOOL executeAirKnee;
/** 脚侧充气IO状态 */
@property (nonatomic, assign) BOOL executeAirFootSide;
/** 脚踝充气IO状态 */
@property (nonatomic, assign) BOOL executeAirAnkle;

#pragma mark ------- 推杆执行 ------
/** 靠背推杆上升中 */
@property (nonatomic, assign) BOOL executePostBackUp;
/** 靠背推杆下降中 */
@property (nonatomic, assign) BOOL executePostBackDown;
/** 小腿推杆上升中 */
@property (nonatomic, assign) BOOL executePostLegUp;
/** 小腿推杆下降中 */
@property (nonatomic, assign) BOOL executePostLegDown;
/** 上小腿1推杆伸中 */
@property (nonatomic, assign) BOOL executePostUpLegStretch;
/** 上小腿1推杆缩中 */
@property (nonatomic, assign) BOOL executePostUpLegShrink;
/** 下小腿2推杆伸中 */
@property (nonatomic, assign) BOOL executePostDownLegStretch;
/** 下小腿2推杆缩中 */
@property (nonatomic, assign) BOOL executePostDownLegShrink;

/** 机芯手动程序定点 */
@property (nonatomic, assign) BOOL executeMovementPoint;
/** 机芯手动程序区间 */
@property (nonatomic, assign) BOOL executeMovementInterval;
/** 机芯手动程序全背 */
@property (nonatomic, assign) BOOL executeMovementAllback;

/** 全身充气按钮状态 */
@property (nonatomic, assign) BOOL executeAirFullbody;
/** 颈肩4D 按钮状态 */
@property (nonatomic, assign) BOOL executeNeckShoulder4D;
/** 腰背滚压按钮状态 */
@property (nonatomic, assign) BOOL executeWaistBackRoll;

/** 按摩程序 */
@property (nonatomic, assign) kPrograme mssagePrograme;

#pragma ------ 按摩状态 ------
/** 充气强度 1-5 档 */
@property (nonatomic, assign) NSUInteger statusAirStrength;
/** 按摩3D强度 1-5 档 */
@property (nonatomic, assign) NSUInteger status4DStrength;
/** 敲击速度 1-5 档 */
@property (nonatomic, assign) NSUInteger statusKnockSpeed;
/** 揉捏速度 1-5 档 */
@property (nonatomic, assign) NSUInteger statusKneadSpeed;

/** 斜方-风池显示状态 */
@property (nonatomic, assign) BOOL statusXieFangFengChi;
/** 斜方-肩中显示状态 */
@property (nonatomic, assign) BOOL statusXieFangJianZhong;
/** 斜方-肩井显示状态 */
@property (nonatomic, assign) BOOL statusXieFangJianJing;
/** 阔背-心俞显示状态 */
@property (nonatomic, assign) BOOL statusKuoBeiXinShu;
/** 腰背-肾俞显示状态 */
@property (nonatomic, assign) BOOL statusYaoBeiShenShu;
/** 臀大肌-环中显示状态 */
@property (nonatomic, assign) BOOL statusTunDaJiHuanZhong;
/** 臀大肌-环跳显示状态 */
@property (nonatomic, assign) BOOL statusTunDaJiHuanTiao;
/** 膝盖按摩按键状态 */
@property (nonatomic, assign) BOOL statusKneeMassage;
/** 小腿加热显示状态 */
@property (nonatomic, assign) BOOL executeLegWarm;
/** 小腿加热按键状态 */
@property (nonatomic, assign) BOOL statusLegWarm;

/** 人体检测状态 */
@property (nonatomic, assign) kDetectionStatus detectionStatus;
/** 高级手动脚底滚轮标志位 */
@property (nonatomic, assign) BOOL statusAdvanceMassageFootRoll;
/** 背部加热 */
@property (nonatomic, assign) BOOL statusWramBack;
/** 脚底滚轮 */
@property (nonatomic, assign) BOOL statusFootRoll;

/** 肩部充气 */
@property (nonatomic, assign) BOOL statusAirShoulder;
/** 手臂充气 */
@property (nonatomic, assign) BOOL statusAirArm;
/** 座恻充气 */
@property (nonatomic, assign) BOOL statusAirSeat;
/** 膝盖充气 */
@property (nonatomic, assign) BOOL statusAirKnee;
/** 脚侧充气 */
@property (nonatomic, assign) BOOL statusAirFootSide;
/** 脚踝充气 */
@property (nonatomic, assign) BOOL statusAirAnkle;

/** 机芯手动程序 揉捏1 */
@property (nonatomic, assign) BOOL statusKnead1;
/** 机芯手动程序 揉捏2 */
@property (nonatomic, assign) BOOL statusKnead2;
/** 机芯手动程序 敲击1 */
@property (nonatomic, assign) BOOL statusKnock1;
/** 机芯手动程序 敲击2 */
@property (nonatomic, assign) BOOL statusKnock2;
/** 机芯手动程序 拍打1 */
@property (nonatomic, assign) BOOL statusClap1;
/** 机芯手动程序 拍打2 */
@property (nonatomic, assign) BOOL statusClap2;

/** 机芯手动程序 指压1*/
@property (nonatomic, assign) BOOL statusShiatsu1;
/** 机芯手动程序 指压2 */
@property (nonatomic, assign) BOOL statusShiatsu2;
/** 机芯手动程序 推拿/滚动 */
@property (nonatomic, assign) BOOL statusRoll;
/** 机芯手动程序 瑞典1 */
@property (nonatomic, assign) BOOL statusSweden1;
/** 机芯手动程序 瑞典2 */
@property (nonatomic, assign) BOOL statusSweden2;

/** led 开关 */
@property (nonatomic, assign) BOOL LedSwitch;
/** LED -朦胧 */
@property (nonatomic, assign) BOOL ledStatusObscure;
/** LED -(加热)活力 */
@property (nonatomic, assign) BOOL ledStatusHot;
/** LED -松弛 */
@property (nonatomic, assign) BOOL ledStatusRelease;
/** LED -LED -彩虹 */
@property (nonatomic, assign) BOOL ledStatusRainBow;
/** LED -波浪 */
@property (nonatomic, assign) BOOL ledStatusWave;
/** LED -呼吸 */
@property (nonatomic, assign) BOOL ledStatusBreath;
/** LED -呼吸 */
@property (nonatomic, assign) BOOL ledStatusAwaken;


#pragma ------ 按摩角度机芯状态 ------
/** 角度1 收纳 */
@property (nonatomic, assign) BOOL chairAngleStatus1;
/** 角度2 零重力 */
@property (nonatomic, assign) BOOL chairAngleStatus2;
/** 角度2  展开 */
@property (nonatomic, assign) BOOL chairAngleStatus3;

/** 靠背推杆上升中 */
@property (nonatomic, assign) BOOL statusPostBackUp;
/** 靠背推杆下降中 */
@property (nonatomic, assign) BOOL statusPostBackDown;
/** 小腿推杆上升中 */
@property (nonatomic, assign) BOOL statusPostLegUp;
/** 小腿推杆下降中 */
@property (nonatomic, assign) BOOL statusPostLegDown;
/** 上小腿1推杆伸中 */
@property (nonatomic, assign) BOOL statusPostUpLegStretch;
/** 上小腿1推杆缩中 */
@property (nonatomic, assign) BOOL statusPostUpLegShrink;
/** 下小腿2推杆伸中 */
@property (nonatomic, assign) BOOL statusPostDownLegStretch;
/** 下小腿2推杆缩中 */
@property (nonatomic, assign) BOOL statusPostDownLegShrink;
/** 机芯上行 */
@property (nonatomic, assign) BOOL statusMovementUp;
/** 机芯下行 */
@property (nonatomic, assign) BOOL statusMovementDown;
/** 机芯 调窄 */
@property (nonatomic, assign) BOOL statusMovementNarrow;
/** 机芯 调宽 */
@property (nonatomic, assign) BOOL statusMovementWide;
/** 机芯 3D伸 */
@property (nonatomic, assign) BOOL statusMovement3DStretch;
/** 机芯 3D缩 */
@property (nonatomic, assign) BOOL statusMovement3DShrink;

/** 自动检测 */
@property (nonatomic, assign) BOOL statusTestAuto;
/** 手动检测 */
@property (nonatomic, assign) BOOL statusTestManual;
/** 包装程序 */
@property (nonatomic, assign) BOOL statusTestPack;

/** 机芯Y轴坐标 颈肩：9-13；腰背：4-8；臀部：0-3 */
@property (nonatomic, assign) int statusMovmentYCoor;
/** 机芯Z轴坐标(0-5) */
@property (nonatomic, assign) int statusMovmentZCoor;
/** 机芯X轴坐标(1-3) 1：窄  2：中  3：宽 */
@property (nonatomic, assign) int statusMovmentXCoor;

/** 酸痛检测部位：0，无酸痛检测；1，颈部；2，肩内；3，肩外；4，肩胛骨；5，背部；6，腰部。 */
@property (nonatomic, assign) kAchePart achePart;
/** 酸痛检测中和判定结果：0，无酸痛检测；1，酸痛检测中；2，轻度酸痛；3，重度酸痛；4，无酸痛。 */
@property (nonatomic, assign) kAcheResult acheResult;
/** 启动酸痛检测功能 */
@property (nonatomic, assign) BOOL statusLaunchAcheTest;
/** 酸痛手柄手握状态，握住：1，放开：0 */
@property (nonatomic, assign) BOOL statusAcheHold;

/** 定时时间（分） */
@property (nonatomic, assign) int timeMinute;
/** 定时时间（秒）*/
@property (nonatomic, assign) int timeSecond;

/** 酸痛检测中 */
@property (nonatomic, assign) BOOL statusAcheIng;
/** 酸痛检测完成 */
@property (nonatomic, assign) BOOL statusAcheDone;


@end

NS_ASSUME_NONNULL_END
