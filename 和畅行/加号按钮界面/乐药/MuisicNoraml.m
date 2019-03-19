//
//  MuisicNoraml.m
//  hechangyi
//
//  Created by Longma on 16/11/3.
//  Copyright © 2016年 Longma. All rights reserved.
//

#import "MuisicNoraml.h"
#import "UtilityFunc.h"

//屏幕比例
#define SCREEN_WIDTH_Size ([UIScreen mainScreen].bounds.size.width)/375
#define SCREEN_HEIGHT_Size ([UIScreen mainScreen].bounds.size.height)/667

@interface MuisicNoraml ()<UIAlertViewDelegate>

@property (nonatomic,assign) BOOL isBluetoonState;

@property (nonatomic,assign) BOOL isLeyaoPlayState;


@end

@implementation MuisicNoraml


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LeyaoBluetoothOFF object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:LeyaoBluetoothON object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LeyaoPlayON object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LeyaoPlayOFF object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        self.isStatus = NO;
    }
    return self;
}

- (void)createUI{
    self.isBluetoonState = NO;
    self.isLeyaoPlayState = NO;
    [[NSNotificationCenter defaultCenter] addObserverForName:LeyaoBluetoothON object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        
        self.isBluetoonState = YES;
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:LeyaoBluetoothOFF object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        self.isBluetoonState = NO;
    
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:LeyaoPlayON object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        
        self.isLeyaoPlayState = YES;
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:LeyaoPlayOFF object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        self.isLeyaoPlayState = NO;
        
    }];

    
    
    
    self.backgroundColor = [UIColor clearColor];
    
    
    self.bluetoothBg = [[UIImageView alloc] initWithFrame:CGRectMake(115/2 *SCREEN_WIDTH_Size, 34/2*SCREEN_HEIGHT_Size, 45*SCREEN_WIDTH_Size, 45*SCREEN_HEIGHT_Size)];
    self.bluetoothBg.image = [UIImage imageNamed:@"关蓝牙"];
    
    //[self addSubview:self.bluetoothBg];
    
    self.strengthBg = [UIImageView new];
    self.strengthBg.image = [UIImage imageNamed:@"按钮背景"];
    CGFloat width = CGRectGetMaxX(self.bluetoothBg.frame)+ 50*SCREEN_WIDTH_Size ;
    self.strengthBg.frame = CGRectMake(width, 24/2*SCREEN_HEIGHT_Size, 180*SCREEN_WIDTH_Size, 100/2*SCREEN_WIDTH_Size);
    self.strengthBg.userInteractionEnabled = YES;
    [self addSubview:self.strengthBg];
    
    
    /**
     增加强度指令
     */
    self.addbutton = [[UIButton alloc]init];
  //  [self.addbutton setImage:[UIImage imageNamed:@"+"] forState:(UIControlStateNormal)];

    [self.addbutton setTitle:ModuleZW(@"强") forState:(UIControlStateNormal)];
    self.addbutton.titleLabel.textColor = [UIColor whiteColor];
    //self.addbutton.frame = CGRectMake(0, 0, 100/2*SCREEN_WIDTH_Size, 100/2*SCREEN_HEIGHT_Size);
    self.addbutton.frame =CGRectMake(125*SCREEN_WIDTH_Size,0 , 55*SCREEN_WIDTH_Size, 100/2*SCREEN_HEIGHT_Size);
    [self.strengthBg addSubview:_addbutton];
    
    _accordLabel = [[UILabel alloc]init];
    _accordLabel.text = @"00";
    _accordLabel.textAlignment = NSTextAlignmentCenter;
    _accordLabel.textColor = [UIColor whiteColor];
    _accordLabel.frame = CGRectMake(75*SCREEN_WIDTH_Size,0, 30*SCREEN_WIDTH_Size, 100/2*SCREEN_HEIGHT_Size);
    [self.strengthBg addSubview:_accordLabel];

    
    /**
     *  减小强度指令
     */
    self.downButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
   // [self.downButton setImage:[UIImage imageNamed:@"jian"] forState:(UIControlStateNormal)];
    
    [self.downButton setTitle:ModuleZW(@"弱") forState:(UIControlStateNormal)];
    self.downButton.titleLabel.textColor = [ UIColor whiteColor];
   // self.downButton.frame = CGRectMake(100*SCREEN_WIDTH_Size,0 , 100/2*SCREEN_WIDTH_Size, 100/2*SCREEN_HEIGHT_Size);
    self.downButton.frame = CGRectMake(0, 0, 75*SCREEN_WIDTH_Size, 110/2*SCREEN_HEIGHT_Size);

    [self.strengthBg addSubview:self.downButton];
    self.addbutton.tag = 101;
   self.downButton.tag = 102;
    [self.addbutton addTarget:self action:@selector(accordLabelNormal:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.downButton addTarget:self action:@selector(accordLabelNormal:) forControlEvents:(UIControlEventTouchUpInside)];
    

    
}


- (void)btnClick:(UIButton *)btn{
    
    if (self.isBluetoonState == NO) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ModuleZW(@"提示") message:ModuleZW(@"请先连接设备") delegate:self cancelButtonTitle:ModuleZW(@"确定") otherButtonTitles: nil];
        [alert show];
        
        
    }else{
        if (self.isLeyaoPlayState == NO) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ModuleZW(@"提示") message:ModuleZW(@"请选择一首乐药进行播放") delegate:self cancelButtonTitle:ModuleZW(@"确定") otherButtonTitles: nil];
            [alert show];
            
            
        }else{
            
            if (!self.isStatus) {
                [btn setImage:[UIImage imageNamed:@"开"] forState:(UIControlStateNormal)];
                self.isStatus = YES;
                
            }else{
                [btn setImage:[UIImage imageNamed:@"关"] forState:(UIControlStateNormal)];
                self.isStatus = NO;
                
            }
            if ([self.delegate respondsToSelector:@selector(commandWithONandOFF:)]) {
                [self.delegate commandWithONandOFF:self.isStatus];
                
            }
            

        }
        
    }
    
    }



/**
 *  开始 停止命令
 *
 *  @param sw 0 ---> 停止 1 ---> 开始
 */
- (void)switchAction:(UISwitch *)sw{
    
    NSLog(@"%d",sw.on);
    if (self.isBluetoonState == NO) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ModuleZW(@"提示") message:ModuleZW(@"请先连接设备") delegate:self cancelButtonTitle:ModuleZW(@"确定") otherButtonTitles: nil];
        [alert show];

    }else{
        if (self.isLeyaoPlayState == NO) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ModuleZW(@"提示") message:ModuleZW(@"请选择一首乐药进行播放") delegate:self cancelButtonTitle:ModuleZW(@"确定") otherButtonTitles: nil];
            [alert show];

            
        }else{
            if ([self.delegate respondsToSelector:@selector(commandWithONandOFF:)]) {
                [self.delegate commandWithONandOFF:sw.on];
                
            }

        }

    }
    
    
   
    
    
}

/**
 *  暂停 恢复 命令
 *
 *  @param sw 0 ---> 暂停 1 ----> 恢复
 */

- (void)switchActionOff:(UISwitch *)sw{
    NSLog(@"%d",sw.on);
    if ([self.delegate respondsToSelector:@selector(commandWithSuspendedAndRestore:)]) {
        [self.delegate commandWithSuspendedAndRestore:sw.on];
        
    }

    
    
}

- (void)accordLabelNormal:(UIButton *)btn{
    NSLog(@"%ld",(long)btn.tag);
    
    
    static NSInteger number = 0;
    
    
    if (self.isBluetoonState == NO) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ModuleZW(@"提示") message:ModuleZW(@"请先连接设备") delegate:self cancelButtonTitle:ModuleZW(@"确定") otherButtonTitles: nil];
        [alert show];
        number = 0;
        self.accordLabel.text = @"00";
    }else{
        if (self.isLeyaoPlayState != NO) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ModuleZW(@"提示") message:ModuleZW(@"请选择一首乐药进行播放") delegate:self cancelButtonTitle:ModuleZW(@"确定") otherButtonTitles: nil];
            [alert show];

            number = 0;
            self.accordLabel.text = @"00";
        }else{
            
            
            /**
             当显示值为0 将静态变量 number 同步置为0 
             */
            if([_accordLabel.text isEqualToString:@"00"]){
                number = 0;
            }
            
            switch (btn.tag) {
                case 101:{
                    if ([_accordLabel.text isEqualToString:@"60"]) {
                        number = 60;
                    }else{
                        number ++;
                    }
                    _accordLabel.text = [NSString stringWithFormat:@"%.2ld",(long)number];
                    if ([self.delegate respondsToSelector:@selector(volumeWithIncreaseAndReduce:)]) {
                        [self.delegate volumeWithIncreaseAndReduce:_accordLabel.text];
                    }
                    
                }
                    
                    break;
                case 102:{
                    
                    if ([_accordLabel.text isEqualToString:@"00"]) {
                        number = 0;
                    }else{
                        btn.userInteractionEnabled = YES;
                        number --;
                    }
                    _accordLabel.text = [NSString stringWithFormat:@"%.2ld",(long)number];
                    if ([self.delegate respondsToSelector:@selector(volumeWithReduce:)]) {
                        [self.delegate volumeWithReduce:_accordLabel.text];
                    }
                    
                }
                default:
                    break;
            }
            
        }

    }
        
    
}
@end
