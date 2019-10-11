//
//  ArmchairCommonVC.m
//  和畅行
//
//  Created by 刘晓明 on 2019/9/11.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "ArmchairCommonVC.h"



@interface ArmchairCommonVC ()

@end

@implementation ArmchairCommonVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navTitleLabel.text = @"推拿";
    
    self.preBtn.hidden = NO;
    self.leftBtn.hidden = YES;
    
    [self.rightBtn setImage:[UIImage imageNamed:@"按摩开关_关"] forState:UIControlStateNormal];
    [self.rightBtn setImage:[UIImage imageNamed:@"按摩开关_开"] forState:UIControlStateSelected];
    self.rightBtn.hidden = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DidBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)DidBecomeActive
{
    BOOL isBlueToothPoweredOn = [[OGA530BluetoothManager shareInstance] isBlueToothPoweredOn];
    if(!isBlueToothPoweredOn){
        self.rightBtn.selected = NO;
        [UserShareOnce shareOnce].ogaConnected = NO;
    }
}

- (NSString *)resultStringWithStatus
{
    BOOL isBlueToothPoweredOn = [[OGA530BluetoothManager shareInstance] isBlueToothPoweredOn];
    if(!isBlueToothPoweredOn){
        return @"请先打开蓝牙";
    }
    if(![UserShareOnce shareOnce].ogaConnected){
        return @"设备未连接";
    }
    
    return @"";
}


- (NSArray *)loadDataPlistWithStr:(NSString *)str
{
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"armChair" ofType:@"plist"];
//    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
//    if(dic){
//        NSArray *arr = [ArmChairModel mj_objectArrayWithKeyValuesArray:[dic objectForKey:str]];
//        return arr;
//    }
//    return NULL;
    NSArray *arr = [ArmChairModel mj_objectArrayWithKeyValuesArray:[self arrayWithStr:str]];
    return arr;
    
}

- (NSArray *)loadHomeData
{
    NSArray *arr2 = @[
                      @{@"name":@"大师精选",@"command":k530Command_MassageMaster},
                      @{@"name":@"活血循环",@"command":k530Command_MassageBloodCirculation},
                      @{@"name":@"美臀塑型",@"command":k530Command_MassageHipsShapping},
                      @{@"name":@"肩颈4D",@"command":k530Command_NeckShoulder4D},
                      @{@"name":@"运动派",@"command":k530Command_Athlete},
                      @{@"name":@"低头族",@"command":k530Command_TextNeck},
                      ];
    NSArray *arr = [ArmChairModel mj_objectArrayWithKeyValuesArray:arr2];
    return arr;
}


- (NSArray *)arrayWithStr:(NSString *)str
{
    NSArray *arr1 = @[@{@"name":@"大师精选",@"command":k530Command_MassageMaster},
                      @{@"name":@"轻松自在",@"command":k530Command_MassageRelease},
                      @{@"name":@"关节呵护",@"command":k530Command_KneeCare},
                      @{@"name":@"脊柱支柱",@"command":k530Command_SpinalReleasePressure},
                      ];
    NSArray *arr2 = @[@{@"name":@"上班族",@"command":k530Command_Sedentary},
                      @{@"name":@"驾车族",@"command":k530Command_Traceller},
                      @{@"name":@"低头族",@"command":k530Command_TextNeck},
                      @{@"name":@"御宅派",@"command":k530Command_CosyComfort},
                      @{@"name":@"运动派",@"command":k530Command_Athlete},
                      @{@"name":@"爱购派",@"command":k530Command_Shopping},
                      ];
    NSArray *arr3 = @[@{@"name":@"巴黎式",@"command":k530Command_Balinese},
                      @{@"name":@"中式",@"command":k530Command_MassageChinese},
                      @{@"name":@"泰式",@"command":k530Command_MassageThai}
                
                      ];
    NSArray *arr4 = @[@{@"name":@"深层按摩",@"command":k530Command_MassageDeepTissue},
                      @{@"name":@"美臀塑型",@"command":k530Command_MassageHipsShapping},
                      @{@"name":@"活血循环",@"command":k530Command_MassageBloodCirculation},
                      @{@"name":@"元气复苏",@"command":k530Command_MassageEnergyRecovery},
                      @{@"name":@"活力唤醒",@"command":k530Command_MassageMotionRecovery},
                      @{@"name":@"绽放魅力",@"command":k530Command_MassageBalanceMind}
                    
                      ];
    NSArray *arr5 = @[@{@"name":@"清晨唤醒",@"command":k530Command_MassageAMRoutine},
                      @{@"name":@"瞬间补眠",@"command":k530Command_MassageMiddayRest},
                      @{@"name":@"夜晚助眠",@"command":k530Command_MassageSweetDreams}
                      
                      ];
    NSArray *arr6 = @[@{@"name":@"零重力",@"command":k530Command_AngleZero},
                      @{@"name":@"收纳",@"command":k530Command_AngleAdmission},
                      @{@"name":@"展开",@"command":k530Command_AngleOpen},
                      @{@"name":@"倒背",@"command":k530Command_Backdown},
                      @{@"name":@"抬腿",@"command":k530Command_legUp},
                      @{@"name":@"升背",@"command":k530Command_BackUp},
                      @{@"name":@"降腿",@"command":k530Command_legDown}
                      ];
    
    NSArray *arr7 = @[@{@"name":@"揉捏",@"command":k530Command_MovementKnead},
                      @{@"name":@"敲击",@"command":k530Command_MovementKnock},
                      @{@"name":@"指压",@"command":k530Command_MovementShiatsu},
                      @{@"name":@"推拿",@"command":k530Command_MovementRoll},
                      @{@"name":@"拍打",@"command":k530Command_MovementClap}
                      ];
    
    NSArray *arr8 = @[@{@"name":@"肩颈4D",@"command":k530Command_NeckShoulder4D},
                      @{@"name":@"腰部滚压",@"command":k530Command_WaistRoll},
                      @{@"name":@"膝盖按摩",@"command":k530Command_MassageKnee},
                      @{@"name":@"小腿加热",@"command":k530Command_LegWarm},
                      @{@"name":@"瑞典",@"command":k530Command_MovementSweden}
                      ];
    
    NSArray *arr9 = @[@{@"name":@"气压_全身",@"command":k530Command_AirAllBody},
                      @{@"name":@"气压_肩颈",@"command":k530Command_AirShoulder},
                      @{@"name":@"气压_手臂",@"command":k530Command_AirArm},
                      @{@"name":@"气压_腰臂",@"command":k530Command_AirSeat},
                      @{@"name":@"气压_小腿",@"command":k530Command_AirLeg}
                      ];
    
    NSArray *arr10 = @[@{@"name":@"背部加热",@"command":k530Command_BackWarm},
                      @{@"name":@"脚底滚轮",@"command":k530Command_FootRoll}
                      ];
    NSDictionary *allDic = [NSDictionary dictionaryWithObjectsAndKeys:
                            arr1,@"专属",
                            arr2,@"主题",
                            arr3,@"区域",
                            arr4,@"功效",
                            arr5,@"场景",
                            arr6,@"姿势",
                            arr7,@"基础",
                            arr8,@"特殊",
                            arr9,@"气压",
                            arr10,@"背部脚底",
                            nil];
    NSArray *arr = [allDic objectForKey:str];
    //NSLog(@"arr:%@",arr);
    return arr;
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
        [[OGA530BluetoothManager shareInstance] sendCommand:k530Command_PowerOn success:^(BOOL success) {
            if (success) {
                weakSelf.rightBtn.selected = NO;
            }
        }];
        
    }else{
        __weak typeof(self) weakSelf = self;
        [[OGA530BluetoothManager shareInstance] sendCommand:k530Command_PowerOff success:^(BOOL success) {
            if (success) {
                weakSelf.rightBtn.selected = YES;
            }
        }];
    }
}

@end
