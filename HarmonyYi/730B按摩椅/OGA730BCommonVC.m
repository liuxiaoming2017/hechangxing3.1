//
//  730BArmchairCommonVC.m
//  和畅行
//
//  Created by 刘晓明 on 2019/11/18.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "OGA730BCommonVC.h"

@interface OGA730BCommonVC ()

@end

@implementation OGA730BCommonVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navTitleLabel.text = @"Massage";
    
    self.preBtn.hidden = NO;
    self.leftBtn.hidden = YES;
    
    [self.rightBtn setImage:[UIImage imageNamed:@"按摩开关_关"] forState:UIControlStateNormal];
    [self.rightBtn setImage:[UIImage imageNamed:@"按摩开关_开"] forState:UIControlStateSelected];
    self.rightBtn.hidden = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DidBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (NSArray *)loadHomeData
{
    NSArray *arr2 = @[
                      @{@"name":@"Feet&Calves",@"command":k730Command_FeetCalves},
                      @{@"name":@"Thai",@"command":k730Command_Thai},
                      @{@"name":@"Japanese",@"command":k730Command_Japanese},
                      @{@"name":@"Gentle",@"command":k730Command_Gentle},
                      @{@"name":@"Vigorous",@"command":k730Command_Vigorous},
                      @{@"name":@"Chair Doctor",@"command":k730Command_DetectionAche},
                      @{@"name":@"Custom",@"command":@""},
                       @{@"name":@"More",@"command":@""},
                      ];
    
    NSArray *arr = [ArmChairModel mj_objectArrayWithKeyValuesArray:arr2];
    return arr;
}

- (NSArray *)loadMoreProgramsData
{
    NSArray *arr2 = @[
                      @{@"name":@"Relax",@"command":k730Command_Relax},
                      @{@"name":@"Stretch",@"command":k730Command_Stretch},
                      @{@"name":@"Upper Back",@"command":k730Command_UpperBack},
                      @{@"name":@"Chinese",@"command":k730Command_Chinese},
                      @{@"name":@"Altheletic",@"command":k730Command_Altheltic},
                      @{@"name":@"Lower Back",@"command":k730Command_LowerBack},
                      @{@"name":@"Neck&Shoulder",@"command":k730Command_NeckShoulder},
                      @{@"name":@"Balinese",@"command":k730Command_Balinese},
                      ];
    NSArray *arr = [ArmChairModel mj_objectArrayWithKeyValuesArray:arr2];
    return arr;
}

- (NSArray *)loadDataPlistWithStr:(NSString *)str
{
    NSArray *arr = [ArmChairModel mj_objectArrayWithKeyValuesArray:[self arrayWithStr:str]];
    return arr;
    
}

- (NSArray *)arrayWithStr:(NSString *)str
{
    NSArray *arr6 = @[@{@"name":@"Back Ascend",@"command":k730Command_BackUpLegDown},
                      @{@"name":@"Back Descend",@"command":k730Command_BackDownLegUp},
                      @{@"name":@"Leg Ascend",@"command":k730Command_LegUp},
                      @{@"name":@"Leg Descend",@"command":k730Command_LegDown},
                      @{@"name":@"Leg Extend",@"command":k730Command_LegStretch},
                      @{@"name":@"Leg Retract",@"command":k730Command_LegShrink}
                      ];
    
    NSArray *arr9 = @[
                      @{@"name":@"Shoulder",@"command":k730Command_AirShoulder},
                      @{@"name":@"Hand",@"command":k730Command_AirArm},
                      @{@"name":@"Pelvis",@"command":k730Command_AirWaist},
                      @{@"name":@"Foot",@"command":k730Command_AirFoot}
                    ];
    
    //NSArray *arr7 = @[@"颈部",@"肩部",@"背部",@"腰部",@"上半身"];
    
    
    NSArray *arr5 = @[
                      @{@"name":@"Light",@"command":k730Command_Warm},
                      @{@"name":@"Heat",@"command":k730Command_Warm}
                      ];
    NSArray *arr4 = @[
                      @{@"name":@"Neck",@"command":k730Command_Warm},
                      @{@"name":@"Shoulder",@"command":k730Command_Warm},
                      @{@"name":@"Back",@"command":k730Command_Warm},//UpperBack
                      @{@"name":@"Waist",@"command":k730Command_Warm},//LowerBack
                      @{@"name":@"UpperBody",@"command":k730Command_Warm} //WholeBack
                      ];
    NSArray *arr3 = @[
                      @{@"name":@"Shiatsu",@"command":k730Command_Warm},//指压
                      @{@"name":@"Swedish",@"command":k730Command_Warm},//揉捏
                      @{@"name":@"UltraKnead",@"command":k730Command_Warm},
                      @{@"name":@"Knead",@"command":k730Command_Warm},
                      @{@"name":@"Roll",@"command":k730Command_Warm}
                      
                      ];
    NSDictionary *allDic = [NSDictionary dictionaryWithObjectsAndKeys:
                            
                            arr6,@"姿势",
                            
                            arr9,@"气压",
                            arr5,@"加热",
                            arr4,@"基础",
                            arr3,@"特殊",
                            nil];
    NSArray *arr = [allDic objectForKey:str];
    
    return arr;
    return nil;
}

- (void)DidBecomeActive
{
    BOOL isBlueToothPoweredOn = [[OGABluetoothManager_730B shareInstance] isBlueToothPoweredOn];
    if(!isBlueToothPoweredOn){
        self.rightBtn.selected = NO;
        [UserShareOnce shareOnce].ogaConnected = NO;
    }
}

- (NSString *)resultStringWithStatus
{
    BOOL isBlueToothPoweredOn = [[OGABluetoothManager_730B shareInstance] isBlueToothPoweredOn];
    if(!isBlueToothPoweredOn){
        return @"Please turn on bluetooth";
    }
    if(![UserShareOnce shareOnce].ogaConnected){
        return @"Device not connected";
    }
    
    return @"";
}

- (BOOL)chairIsPowerOn
{
    OGARespond_730B *respond = [OGABluetoothManager_730B shareInstance].respondModel;
    if(respond.modeProgrameSelect || respond.modeWeakStop || respond.modeDetectionAche || respond.autoMassage > 0 || respond.massage_StatusNeck || respond.massage_StatusShoulder || respond.massage_StatusBack || respond.massage_StatusWaist || respond.massage_StatusUpperBody){
        return YES;
    }
    return NO;
}

- (BOOL)chairPowerOnWithRespond:(OGARespond_730B *)respond
{
    if(respond.modeProgrameSelect || respond.modeWeakStop || respond.modeDetectionAche || respond.autoMassage > 0 || respond.massage_StatusNeck || respond.massage_StatusShoulder || respond.massage_StatusBack || respond.massage_StatusWaist || respond.massage_StatusUpperBody){
        return YES;
    }
    return NO;
}

- (void)messageBtnAction:(UIButton *)btn
{
    NSString *statusStr = [self resultStringWithStatus];
    if(![statusStr isEqualToString:@""]){
        [GlobalCommon showMessage2:statusStr duration2:1.0];
        return;
    }
    
    if (btn.selected == YES) {
        
        __weak typeof(self) weakSelf = self;
        [[OGABluetoothManager_730B shareInstance] sendShortCommand:k730Command_PowerOn success:^(BOOL success) {
            if (success) {
                weakSelf.rightBtn.selected = NO;
            }
        }];
        
    }else{
        __weak typeof(self) weakSelf = self;
        [[OGABluetoothManager_730B shareInstance] sendShortCommand:k730Command_PowerOn success:^(BOOL success) {
            if (success) {
                weakSelf.rightBtn.selected = YES;
            }
        }];
    }
}


@end
