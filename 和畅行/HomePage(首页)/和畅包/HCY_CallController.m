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

//#import <HHDoctorSDK/HHDoctorSDK-Swift.h>

@interface HCY_CallController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation HCY_CallController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    UILabel *label = [Tools creatLabelWithFrame:CGRectMake(10,kNavBarHeight + 10, ScreenWidth - 10, 40) text:@"在线咨询" textSize:24];
    [self.view addSubview:label];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, label.bottom, ScreenWidth, ScreenHeight - label.bottom) style:UITableViewStylePlain];
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
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HCY_CallCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HCY_CallCell"];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    [cell cellsetAttributewithIndexPath:indexPath];
    
    __weak typeof(self) weakSelf = self;
    cell.comeToNextBlock = ^(HCY_CallCell * cell) {
        [weakSelf comeToNextBlockCellwithIndex:indexPath];
    };
    
    return cell;
    
}


-(void)comeToNextBlockCellwithIndex:(NSIndexPath *)index {
    
    /*
     HHMSDK *hhmSdk = [[HHMSDK alloc] init];
    __weak typeof(self) weakSelf = self;
    if(index.row==0||index.row==1){
        if([GlobalCommon stringEqualNull:[UserShareOnce shareOnce].uuid]){
            [self messageHintView];
            return;
        }
    }
    NSInteger uuid = [[UserShareOnce shareOnce].uuid integerValue];
    //uuid = 100002514;
    if(index.row == 0) {
        [hhmSdk loginWithUuid:uuid completion:^(NSError * _Nullable error) {
            if(error){
                [weakSelf showAlertWarmMessage:@"进入失败,重新登录"];
            }else{
                [hhmSdk startCall:HHCallTypeChild];
            }
        }];
        
    }else if (index.row == 1) {
        
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
    */
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
