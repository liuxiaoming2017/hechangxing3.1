//
//  CommonTabBarController.m
//  和畅行
//
//  Created by 刘晓明 on 2018/7/2.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "CommonTabBarController.h"
#import "HSTabBar.h"
#import "ZKIndxView.h"
#import "MySportController.h"
#import "CustomNavigationController.h"
#import "YueYaoController.h"
#import "AdvisorysViewController.h"
#import "BloodGuideViewController.h"
#import "PressureViewController.h"
#import "i9_MoxaMainViewController.h"
#import "HCY_CallController.h"
#import "WXPhoneController.h"

#import "ArmchairHomeVC.h"



@interface CommonTabBarController ()<HSTabBarDelegate,ZKIndexViewDelegate>

@property (nonatomic,strong) ZKIndxView *zkView;

@property (nonatomic,copy) NSString *startTimeStr;

@property (nonatomic,copy) NSString *endTimeStr;

@end

@implementation CommonTabBarController
@synthesize zkView;

- (void)viewDidLoad {
    [super viewDidLoad];
    HSTabBar *tabBar = [[HSTabBar alloc] init];
    tabBar.tabBarDelegate = self;
    [self setValue:tabBar forKeyPath:@"tabBar"];
    
    self.startTimeStr = [GlobalCommon getCurrentTimes];
}

# pragma mark - HSTabBarDelegate
- (void)tabBarDidClickPlusButton:(HSTabBar *)tabBar
{
    zkView = [[ZKIndxView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    zkView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    zkView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:zkView];
}



# pragma mark - ZKIndexViewDelegate
- (void)indexClickWitbNumber:(NSInteger)tag
{
    [zkView removeFromSuperview];
    
//    [self test2];
//    return;
    
    UIViewController *vc = nil;
    
    NSInteger index = tag - 100;
    switch (index) {
        case 0:
        {
            vc = [[YueYaoController alloc] initWithType:NO];
            //vc = [YueYaoController sharePlayerController];
            
        }
            
            break;
        case 1:
        {
            if(![UserShareOnce shareOnce].languageType&&![[UserShareOnce shareOnce].bindCard isEqualToString:@"1"]){
                [self weiGouMaiMessage];
            }else{
                NSString *physicalStr = [[NSUserDefaults standardUserDefaults]valueForKey:@"Physical"];
                //11.22
                physicalStr = [GlobalCommon getStringWithSubjectSn:physicalStr];
                
                NSString *yueyaoIndex = [GlobalCommon getSportTypeFrom:physicalStr];
                if(yueyaoIndex == nil){
                    vc = [[MySportController alloc] initWithAllSport];
                    
                }else{
                    vc = [[MySportController alloc] initWithSportType:[yueyaoIndex integerValue]];
                }
            }
        }
            
            break;
        case 2:
            
        {
            i9_MoxaMainViewController * vc1 = [[i9_MoxaMainViewController alloc] init];
            vc1.hidesBottomBarWhenPushed = YES;
            [[self selectedViewController] pushViewController:vc1 animated:YES];
            return ;
        }
           
           
            break;
        case 3:
        {
            
            if(![UserShareOnce shareOnce].languageType){
                if ([UserShareOnce shareOnce].username.length != 11) {
                    [self showAlerVC];
                    return;
                }
            }
            
            if (![UserShareOnce shareOnce].languageType) {
                UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:ModuleZW(@"温馨提示") message:ModuleZW(@"请在法定工作日AM9:00-PM17:00拨打") preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *cabcekAction  = [UIAlertAction actionWithTitle:ModuleZW(@"取消") style:(UIAlertActionStyleCancel) handler:nil];
                UIAlertAction *sureAction  = [UIAlertAction actionWithTitle:ModuleZW(@"确定") style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:4006776668"]];
                }];
                [alerVC addAction:cabcekAction];
                [alerVC addAction:sureAction];
                [self presentViewController:alerVC animated:YES completion:nil];
            }else{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:4006776668"]];
            }
            
            //拨打电话埋点
            self.startTimeStr = [GlobalCommon getCurrentTimes];
            [GlobalCommon pageDurationWithpageId:@"29" withstartTime:self.startTimeStr withendTime:self.startTimeStr];

        }
            
            break;
        case 4:
         
                if ([UserShareOnce shareOnce].username.length != 11) {
                    [self showAlerVC];
                    return;
                }
                vc = [[HCY_CallController alloc] init];
           
            
            break;
        case 5:
        {
            
                if([[[NSUserDefaults standardUserDefaults] objectForKey:@"bloodNeverCaution"] isEqualToString:@"1"]){
                    PressureViewController *vc = [[PressureViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [[self selectedViewController] pushViewController:vc animated:YES];
                }else{
                    BloodGuideViewController * vc1 = [[BloodGuideViewController alloc] init];
                    vc1.isBottom = YES;
                    vc1.hidesBottomBarWhenPushed = YES;
                    [[self selectedViewController] pushViewController:vc1 animated:YES];
                }
            
        }
            
            break;
        case 6:{
            
                vc = [[AdvisorysViewController alloc] init];
            
        }
            break;
        case 7:
            
            
                vc = [[ArmchairHomeVC alloc] init];
            
           
            
            break;
        case 8:
            vc = [[YueYaoController alloc] initWithType:YES];
            break;
        default:
            break;
    }
    
    
    vc.hidesBottomBarWhenPushed = YES;
    [[self selectedViewController] pushViewController:vc animated:YES];
    
    self.endTimeStr = [GlobalCommon getCurrentTimes];
    [GlobalCommon pageDurationWithpageId:@"3" withstartTime:self.startTimeStr withendTime:self.endTimeStr];

    
}

- (void)weiGouMaiMessage
{
    VersionUpdateView *updateView = [VersionUpdateView showWeiGouMaiViewWithContent:weiGouMai];
    [GlobalCommon addMaskView];
    __weak __typeof(updateView)wupdateView = updateView;
    updateView.versionUpdateBlock = ^(BOOL isUpdate){
        
        if(isUpdate){
            UITabBarController *main = [(AppDelegate*)[UIApplication sharedApplication].delegate tabBar];
            main.selectedIndex = 2;
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            window.rootViewController = main;
        }
        
        [GlobalCommon removeMaskView];
        [wupdateView removeFromSuperview];
    };
    [[UIApplication sharedApplication].keyWindow addSubview:updateView];
}

- (void)indexDissmiss
{
    [zkView removeFromSuperview];
}

- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
        // 根视图为非导航类
        
        currentVC = rootVC;
    }
    
    return currentVC;
}
-(void)showAlerVC {
    UIAlertController *alVC= [UIAlertController alertControllerWithTitle:ModuleZW(@"提示") message:ModuleZW(@"您还没有绑定手机号码,绑定后才能享受服务,是否绑定?") preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:ModuleZW(@"确定") style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        WXPhoneController *vc = [[WXPhoneController alloc]init];
        vc.pushType = 0;
        [self presentViewController:vc animated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:ModuleZW(@"取消") style:(UIAlertActionStyleCancel) handler:nil];
    [alVC addAction:sureAction];
    [alVC addAction:cancelAction];
    [self presentViewController:alVC animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
