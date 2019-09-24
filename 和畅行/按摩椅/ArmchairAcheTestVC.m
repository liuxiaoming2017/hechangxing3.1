//
//  ArmchairAcheTestVC.m
//  和畅行
//
//  Created by 刘晓明 on 2019/9/17.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "ArmchairAcheTestVC.h"
#import "ArmchairTestResultVC.h"

@interface ArmchairAcheTestVC ()

@property (nonatomic, strong) OGA530Subscribe *subscribe;

@property (nonatomic,strong) UILabel *remindLabel;

@property (nonatomic, assign) BOOL acheStatus;
@end

@implementation ArmchairAcheTestVC
@synthesize remindLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleLabel.text = @"酸疼检测";
    
    [self initUI];
    
    self.subscribe = [[OGA530Subscribe alloc] init];
    
    __weak typeof(self) weakSelf = self;
    [self.subscribe setRespondBlock:^(OGA530Respond * _Nonnull respond) {
        
        [weakSelf valueChange:respond];
    }];
    [[OGA530BluetoothManager shareInstance] addSubscribe:self.subscribe];
    
    
    [[OGA530BluetoothManager shareInstance] sendCommand:k530Command_MassageIntellect success:nil];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [[OGA530BluetoothManager shareInstance] removeSubscribe:self.subscribe];
}

- (void)DidBecomeActive
{
    
    BOOL isBlueToothPoweredOn = [[OGA530BluetoothManager shareInstance] isBlueToothPoweredOn];
    if(!isBlueToothPoweredOn){
        self.rightBtn.selected = NO;
        [UserShareOnce shareOnce].ogaConnected = NO;
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)valueChange:(OGA530Respond *)respond
{
    
    self.rightBtn.selected = respond.powerOn;
    
    if(!respond.powerOn){
        [self.navigationController popViewControllerAnimated:NO];
    }
    
    if (respond.statusAcheIng) {
        self.acheStatus = YES;
    }else if (respond.statusAcheDone) {
        
    }
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:@[@(0),@(0),@(0),@(0),@(0),@(0)]];
    if (respond.achePart > 0 && respond.achePart < 7) {
        [array replaceObjectAtIndex:respond.achePart - 1 withObject:@(respond.acheResult)];
    }
    
    //    1，颈部；2，肩内；3，肩外；4，肩胛骨；5，背部；6，腰部
    if (respond.statusAcheDone && self.acheStatus == YES) {
        
        self.acheStatus = NO;
        
        __weak typeof(self) weakSelf = self;
        [[OGA530BluetoothManager shareInstance] acheAndFatigue:[array[0] integerValue]
                                                    shoulderIn:[array[1] integerValue]
                                                   shoulderOut:[array[2] integerValue]
                                                 shoulderBlade:[array[3] integerValue]
                                                          back:[array[4] integerValue]
                                                         waist:[array[5] integerValue]
                                                        result:^(NSMutableArray * _Nonnull acheArray, NSInteger acheResult, NSInteger fatigueResult) {
                                                        
                    ArmchairTestResultVC *vc = [[ArmchairTestResultVC alloc] initWithacheResult:(int)acheResult withfatigueResult:(int)fatigueResult];
                    [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        
    }
}

- (void)initUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    remindLabel = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-116)/2.0, kNavBarHeight+35, 116, 35)];
    remindLabel.font = [UIFont fontWithName:@"PingFang SC" size:17];
    remindLabel.textColor = [UIColor colorWithRed:30/255.0 green:130/255.0 blue:210/255.0 alpha:1.0];
    remindLabel.text = @"酸疼检测中…";
    remindLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:remindLabel];
    
    CGFloat height = 251/677.0*(ScreenWidth-40);
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(20, remindLabel.bottom+55, ScreenWidth-40, height)];
    imageV.image = [UIImage imageNamed:@"体测图"];
    [self.view addSubview:imageV];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(imageV.left,imageV.bottom+55,124.5,22.5);
    label.numberOfLines = 0;
    [self.view addSubview:label];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"手心握住电极片"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 17],NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]}];
    
    label.attributedText = string;
    label.textAlignment = NSTextAlignmentLeft;
   
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.frame = CGRectMake(imageV.left,label.bottom+15,245,120);
    label2.numberOfLines = 0;
    [self.view addSubview:label2];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.lineSpacing = 5;
    
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:@"①静坐并背靠在按摩椅上 \n②上肢自然放于两侧，掌心向下 \n③左手握住金属电极 \n④保持安静"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 16],NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0],NSParagraphStyleAttributeName:paragraphStyle.copy}];
    
    label2.attributedText = string2;
    label2.textAlignment = NSTextAlignmentLeft;
}



@end
