//
//  MassageArmchairVC.m
//  和畅行
//
//  Created by 刘晓明 on 2019/8/20.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "MassageArmchairVC.h"
#import <OGABluetooth530/OGA530BluetoothManager.h>
@interface MassageArmchairVC ()

@end

@implementation MassageArmchairVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[OGA530BluetoothManager shareInstance] setAppkey:OGA530AppKey appSecret:OGA530AppSecret];
    
    BOOL hh = [[OGA530BluetoothManager shareInstance] isBlueToothPoweredOn];
    
    
    [[OGA530BluetoothManager shareInstance] bluetoothStatusChange:^(BOOL enable) {
        
    }];
    
    
    
    [[OGA530BluetoothManager shareInstance] scanPeripheral:^(NSMutableArray * _Nonnull array) {
        if(array.count>0){
            
            CBPeripheral *cbPeripheral = nil;
            for(CBPeripheral *peripheral in array){
                NSLog(@"hhhhhh:%@",peripheral.identifier.UUIDString);
                if([peripheral.name isEqualToString:@"KANGMEI-1903190108"]){
                    NSLog(@"#######:%@",peripheral.identifier.UUIDString);
                    cbPeripheral = peripheral;
                    break;
                }
            }
            
            [[OGA530BluetoothManager shareInstance] connectPeripheral:cbPeripheral connect:^{
                
            }];
            
        }
        
    } timeoutSacn:^{
        
    }];
    
    [[OGA530BluetoothManager shareInstance] queryChairSn:^(NSString * _Nonnull sn) {
        NSLog(@"sn:%@",sn);
    }];
    
    
    NSArray *dataArr = @[@"数据",@"序列号",@"运行时长"];
    for(NSInteger i =0;i<3;i++){
        UIButton *dataBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        dataBtn.frame = CGRectMake(20+100*i, NaviBarHeight, 80, 40);
        dataBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        dataBtn.tag = 1+i;
        [dataBtn setTitle:[dataArr objectAtIndex:i] forState:UIControlStateNormal];
        dataBtn.backgroundColor = [UIColor blueColor];
        [dataBtn addTarget:self action:@selector(dataBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:dataBtn];
    }
    
    
    
    NSArray *arr1 = @[@"开机",@"暂停",@"定时",@"关机",@"酸疼检测"];
    for(NSInteger i =0;i<arr1.count;i++){
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(10+(60+5)*i, 120, 60, 60);
        rightBtn.tag = 10+i;
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [rightBtn setTitle:[arr1 objectAtIndex:i] forState:UIControlStateNormal];
        rightBtn.backgroundColor = [UIColor redColor];
        [rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:rightBtn];
    }
    
    
    
    NSArray *nameArr = @[@"⼤师精选",@"轻松⾃在",@"关节呵护",@"脊柱⽀柱",@"上班族",@"低头族",@"驾车族",@"运动派",@"御宅派",@"爱购派",@"巴黎式",@"中式",@"泰式",@"深层按摩",@"活血循环",@"活⼒唤醒",@"美臀塑性",@"元⽓复苏",@"绽放魅⼒",@"清晨唤醒",@"瞬间补眠",@"夜晚助眠"];
    UIButton *hhbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    for(NSInteger i =0;i<nameArr.count;i++){
        UIButton *shoufaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSInteger j = i % 6;
        NSInteger h = i / 6;
        shoufaBtn.frame = CGRectMake(10+(55+5)*j, 120+60+20+(h*60), 55, 55);
        shoufaBtn.layer.cornerRadius = 8;
        shoufaBtn.clipsToBounds = YES;
        shoufaBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        shoufaBtn.tag = 100+i;
        if(i==nameArr.count-1){
            hhbtn = shoufaBtn;
        }
        [shoufaBtn setTitle:[nameArr objectAtIndex:i] forState:UIControlStateNormal];
        shoufaBtn.backgroundColor = [UIColor orangeColor];
        [shoufaBtn addTarget:self action:@selector(shoufangAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:shoufaBtn];
    }
    
    UIView *addOrReduceV = [[UIView alloc] initWithFrame:CGRectMake(0, hhbtn.bottom+5, ScreenWidth, 65)];
//    addOrReduceV.backgroundColor = [UIColor blueColor];
    [self.view addSubview:addOrReduceV];
    
    NSArray *colorArr = @[[UIColor brownColor],[UIColor redColor],[UIColor purpleColor]];
    
    for(NSInteger i =0;i<3;i++){
        UIButton *reduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        reduceBtn.frame = CGRectMake(10+(120+5)*i, 25, 30, 30);
        reduceBtn.tag = 20+i;
        reduceBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [reduceBtn setTitle:@"-" forState:UIControlStateNormal];
        reduceBtn.backgroundColor = [colorArr objectAtIndex:i];
        [reduceBtn addTarget:self action:@selector(reduceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [addOrReduceV addSubview:reduceBtn];
    }
    
    NSArray *titleArr = @[@"按摩强度",@"揉捏速度",@"敲击速度"];
    for(NSInteger i =0;i<3;i++){
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40+(120+5)*i, 25, 58, 30)];
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.text = [titleArr objectAtIndex:i];
        [addOrReduceV addSubview:titleLabel];
    }
    
    
    for(NSInteger i =0;i<3;i++){
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.frame = CGRectMake(95+(120+5)*i, 25, 30, 30);
        addBtn.tag = 30+i;
        addBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [addBtn setTitle:@"+" forState:UIControlStateNormal];
        addBtn.backgroundColor = [colorArr objectAtIndex:i];
        [addBtn addTarget:self action:@selector(addBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [addOrReduceV addSubview:addBtn];
    }
    
    NSArray *shoudongArr = @[@"定点",@"区间",@"全背",@"推拿",@"揉捏",@"拍打",@"指压",@"敲击",@"瑞典",@"倒背",@"抬腿",@"零重力"];
    for(NSInteger i =0;i<shoudongArr.count;i++){
        UIButton *shoufaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSInteger j = i % 6;
        NSInteger h = i / 6;
        shoufaBtn.frame = CGRectMake(10+(45+5)*j, addOrReduceV.bottom+20+(h*60), 45, 45);
        shoufaBtn.layer.cornerRadius = 6;
        shoufaBtn.clipsToBounds = YES;
        shoufaBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        shoufaBtn.tag = 200+i;
        [shoufaBtn setTitle:[shoudongArr objectAtIndex:i] forState:UIControlStateNormal];
        shoufaBtn.backgroundColor = [UIColor redColor];
        
        [shoufaBtn addTarget:self action:@selector(shoudongAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:shoufaBtn];
    }
    
    
}



- (void)dataBtnAction:(UIButton *)button
{
    if(button.tag == 1){
        OGA530Respond *respond = [OGA530BluetoothManager shareInstance].respondModel;
        NSLog(@"开机了吗:%d",respond.powerOn);
    NSLog(@"按摩强度:%ld,揉捏速度:%ld,敲击速度:%ld",respond.status4DStrength,respond.statusKneadSpeed,respond.statusKnockSpeed);
    }else if (button.tag == 2){
        [[OGA530BluetoothManager shareInstance] queryChairSn:^(NSString * _Nonnull sn) {
            NSLog(@"序列号：%@",sn);
        }];
    }else{
//        [[OGA530BluetoothManager shareInstance] queryChairRuntime:^(NSInteger time) {
//            NSLog(@"运行时长：%ld",time);
//        }];
        [[OGA530BluetoothManager shareInstance] sendCommand:k530Command_MovementAllBack success:^(BOOL success) {
            NSLog(@"机芯收到程序全背:%d",success);
        }];
    }
    
}

- (void)rightBtnAction:(UIButton *)button
{
    NSInteger index = button.tag - 10;
    NSArray *arr = @[k530Command_PowerOn,k530Command_Pause,k530Command_Timing,k530Command_PowerOff,k530Command_MassageIntellect];
    if(index == 4){
        [[OGA530BluetoothManager shareInstance] acheAndFatigue:1 shoulderIn:1 shoulderOut:1 shoulderBlade:1 back:1 waist:1
                                                         result:^(NSMutableArray * _Nonnull acheArray, NSInteger acheResult, NSInteger fatigueResult) {
                                                             NSLog(@"arr:%@",acheArray);
                                                         }];
        return;
    }
    [[OGA530BluetoothManager shareInstance] sendCommand:[arr objectAtIndex:index] success:^(BOOL success) {
        NSLog(@"success:%d",success);
        
    }];
}

- (void)shoufangAction:(UIButton *)button
{
    NSInteger index = button.tag - 100;
    NSArray *arr = @[k530Command_MassageMaster,k530Command_MassageRelease,k530Command_KneeCare,k530Command_SpinalReleasePressure,k530Command_Sedentary,k530Command_TextNeck,k530Command_Traceller,k530Command_Athlete,k530Command_CosyComfort,k530Command_Shopping,k530Command_Balinese,k530Command_MassageChinese,k530Command_MassageThai,k530Command_MassageDeepTissue,k530Command_MassageBloodCirculation,k530Command_MassageMotionRecovery,k530Command_MassageHipsShapping,k530Command_MassageEnergyRecovery,k530Command_MassageBalanceMind,k530Command_MassageAMRoutine,k530Command_MassageMiddayRest,k530Command_MassageSweetDreams];
    NSLog(@"count:%ld",arr.count);
    [[OGA530BluetoothManager shareInstance] sendCommand:[arr objectAtIndex:index] success:^(BOOL success) {
        NSLog(@"success:%d",success);
    }];
}

- (void)reduceBtnAction:(UIButton *)button
{
    NSLog(@"----------");
    NSInteger index = button.tag - 20;
    NSArray *arr = @[k530Command_MassageStrength,k530Command_KneadSpeed,k530Command_KnockSpeed];
    [[OGA530BluetoothManager shareInstance] sendCommand:[arr objectAtIndex:index] success:^(BOOL success) {
        NSLog(@"强度减少:%d",success);
        OGA530Respond *respond = [OGA530BluetoothManager shareInstance].respondModel;
        NSLog(@"减少哈哈哈按摩强度:%ld,揉捏速度:%ld,敲击速度:%ld",respond.status4DStrength,respond.statusKneadSpeed,respond.statusKnockSpeed);
    }];
}

- (void)addBtnAction:(UIButton *)button
{
    NSLog(@"++++++++++");
    NSInteger index = button.tag - 30;
    NSArray *arr = @[k530Command_MassageStrengthAdd,k530Command_KneckSpeedAdd,k530Command_KnockSpeedAdd];
    [[OGA530BluetoothManager shareInstance] sendCommand:[arr objectAtIndex:index] success:^(BOOL success) {
        NSLog(@"强度增大:%d",success);
        OGA530Respond *respond = [OGA530BluetoothManager shareInstance].respondModel; NSLog(@"增大哈哈哈按摩强度:%ld,揉捏速度:%ld,敲击速度:%ld",respond.status4DStrength,respond.statusKneadSpeed,respond.statusKnockSpeed);
    }];
}


- (void)shoudongAction:(UIButton *)button
{
    NSInteger index = button.tag - 200;
    NSArray *arr = @[k530Command_MovementPoint,k530Command_MovementInterval,k530Command_MovementAllBack,k530Command_MovementRoll,k530Command_MovementKnead,k530Command_MovementClap,k530Command_MovementShiatsu,k530Command_MovementKnock,k530Command_MovementSweden,k530Command_Backdown,k530Command_legUp,k530Command_AngleZero];
    [[OGA530BluetoothManager shareInstance] sendCommand:[arr objectAtIndex:index] success:^(BOOL success) {
        NSLog(@"手动成功回调:%d",success);
    }];
}

- (void)bluetoothStatusChange:(void(^__nullable)(BOOL enable))status
{
    
}

- (void)acheAndFatigue:(NSInteger)neck
            shoulderIn:(NSInteger)shoulderIn
           shoulderOut:(NSInteger)shoulderOut
         shoulderBlade:(NSInteger)shoulderBlade
                  back:(NSInteger)back
                 waist:(NSInteger)waist
                result:(void(^__nullable)(NSMutableArray *acheArray, NSInteger acheResult, NSInteger fatigueResult))result
{
    NSLog(@"hhh");
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
