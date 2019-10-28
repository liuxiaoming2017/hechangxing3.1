//
//  HCY_CallController.m
//  和畅行
//
//  Created by 出神入化 on 2018/12/12.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "HCY_CallController.h"
#import "HCY_CallCell.h"
#import "AdvisorysViewController.h"
#import "AppDelegate.h"
#import "WXPhoneController.h"

//#import <HHDoctorSDK/HHDoctorSDK-Swift.h>

@interface HCY_CallController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation HCY_CallController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navTitleLabel.text = ModuleZW(@"视频医生");
    
    UILabel *label = [Tools creatLabelWithFrame:CGRectMake(10,kNavBarHeight + 10, ScreenWidth - 10, 40) text:ModuleZW(@"在线咨询") textSize:24];
//    [self.view addSubview:label];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavBarHeight + 10, ScreenWidth, ScreenHeight - label.bottom) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.rowHeight = 170;
    [self.view addSubview:tableView];
    [tableView registerNib:[UINib nibWithNibName:@"HCY_CallCell" bundle:nil] forCellReuseIdentifier:@"HCY_CallCell"];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([UserShareOnce shareOnce].languageType){
        return 1;
    }else{
        return 2;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HCY_CallCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HCY_CallCell"];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    [cell cellsetAttributewithIndexPath:indexPath];
    
    __weak typeof(self) weakSelf = self;
    cell.comeToNextBlock = ^(HCY_CallCell * cell) {
        static NSTimeInterval time = 0.0;
        NSTimeInterval currentTime = [NSDate date].timeIntervalSince1970;
        if (currentTime - time > 2) {
            [weakSelf comeToNextBlockCellwithIndex:indexPath];
        }
        time = currentTime;
        
    };
    
    return cell;
    
}


-(void)comeToNextBlockCellwithIndex:(NSIndexPath *)index {
    
    if ([UserShareOnce shareOnce].languageType){
        AdvisorysViewController *adVC = [[AdvisorysViewController alloc]init];
        [self.navigationController pushViewController:adVC animated:YES];
        return;
    }

    #if TARGET_IPHONE_SIMULATOR
    
    #else
        HHMSDK *hhmSdk = [[HHMSDK alloc] init];
        __weak typeof(self) weakSelf = self;
        if(index.row==0||index.row==1){
            if([GlobalCommon stringEqualNull:[UserShareOnce shareOnce].uuid]){
                [self messageHintView];
                return;
            }
        }
    
        if(kPlayer.playerState == 2){
            [kPlayer stop];
        }
    
        NSInteger uuid = [[UserShareOnce shareOnce].uuid integerValue];
        if(index.row == 0) {
            if ([UserShareOnce shareOnce].username.length != 11) {
                [self showAlerVC];
                return;
            }
            [hhmSdk loginWithUuid:uuid completion:^(NSError * _Nullable error) {
                if(error){
                    [weakSelf showAlertWarmMessage:@"进入失败,重新登录"];
                }else{
                    [hhmSdk startCall:HHCallTypeChild];
                }
            }];
            
            
        }else if (index.row == 1) {
            if ([UserShareOnce shareOnce].username.length != 11) {
                [self showAlerVC];
                return;
            }
            [hhmSdk loginWithUuid:uuid completion:^(NSError * _Nullable error) {
                if(error){
                    [weakSelf showAlertWarmMessage:@"进入失败,重新登录"];
                }else{
                    [hhmSdk startCall:HHCallTypeAdult];
                }
            }];
            
        }else {
            
            AdvisorysViewController *adVC = [[AdvisorysViewController alloc]init];
            [self.navigationController pushViewController:adVC animated:YES];
            
        }
    #endif
    
    
 
    
}
-(void)showAlerVC {
    UIAlertController *alVC= [UIAlertController alertControllerWithTitle:ModuleZW(@"提示") message:ModuleZW(@"您还没有绑定手机号码,绑定后才能享受服务,是否绑定?") preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:ModuleZW(@"确定") style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        WXPhoneController *vc = [[WXPhoneController alloc]init];
        vc.pushType = 1;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:ModuleZW(@"取消") style:(UIAlertActionStyleCancel) handler:nil];
    [alVC addAction:sureAction];
    [alVC addAction:cancelAction];
    [self presentViewController:alVC animated:YES completion:nil];
}
- (void)messageHintView
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没有购买视频咨询服务，是否前去购买？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAct1 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITabBarController *main = [(AppDelegate*)[UIApplication sharedApplication].delegate tabBar];
        main.selectedIndex = 2;
        //UINavigationController *nav = main.selectedViewController;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        window.rootViewController = main;
    }];
    UIAlertAction *alertAct12 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:alertAct1];
    [alertVC addAction:alertAct12];
    [self presentViewController:alertVC animated:YES completion:NULL];
}


@end
