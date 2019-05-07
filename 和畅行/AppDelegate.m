//
//  AppDelegate.m
//  和畅行
//
//  Created by 刘晓明 on 2018/7/2.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "AppDelegate.h"
#import "CustomNavigationController.h"
#import "HomePageController.h"
#import "ArchivesController.h"
#import "MallViewController.h"
#import "EDWKWebViewController.h"
#import "MineViewController.h"
#import "CommonTabBarController.h"
#import "LoginViewController.h"
#import "RootRequestController.h"


#import "WXApi.h"
#import "AlipayHeader.h"
//APP端签名相关头文件

#import "payRequsestHandler.h"

//服务端签名只需要用到下面一个头文件
#import "ApiXml.h"
#import <QuartzCore/QuartzCore.h>

#import <UMShare/UMShare.h>
#import <UMCommon/UMCommon.h>


#import <UMCommonLog/UMCommonLogManager.h>

#import "SBJson.h"
#import "ChangeLanguageObject.h"



@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
   // self.window.rootViewController = [self tabBar];
    
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:&error];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:&error];
    
    [UserShareOnce shareOnce].isOnline = NO;
    [UserShareOnce shareOnce].yueYaoBuyArr = [NSMutableArray arrayWithCapacity:0];
    [UserShareOnce shareOnce].allYueYaoPrice = 0;
    
    [[UITabBar appearance] setTranslucent:NO];
    
    //和缓医疗SDK注册,8248是和缓分配给的productId 9001
//    HHSDKOptions *hhSdk = [[HHSDKOptions alloc] initWithProductId:@"9001" isDebug:NO isDevelop:YES];
//    hhSdk.cerName = @"2cDevTest";
//    [[HHMSDK alloc] startWithOption:hhSdk];

    [UMCommonLogManager setUpUMCommonLogManager];
    [UMConfigure setLogEnabled:YES];
    [UMConfigure initWithAppkey:@"5bbacd04b465f5db4c000073" channel:@"App Store"];
    
    [WXApi registerApp:APP_ID withDescription:@"demo 2.0"];
    
     [self returnMainPage2];
    [self.window makeKeyAndVisible];
    
    [ChangeLanguageObject initUserLanguage];
    
    
    NSArray *languages = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppleLanguages"];
    NSLog(@"%@",languages);
    if ([languages.firstObject isEqualToString:@"en-US"]||[languages.firstObject isEqualToString:@"ja-US"]||[languages.firstObject isEqualToString:@"en-CN"]||[languages.firstObject isEqualToString:@"en"]){
        [UserShareOnce shareOnce].languageType = @"us-en";
//        [UserShareOnce shareOnce].languageType  = nil;
    }else{
        [UserShareOnce shareOnce].languageType  = nil;
    }
    
//    URL_PRE

    for (int i = 0; i < 20; ++i) {
        NSLog(@"%d",i);
    }
    
    return YES;
}




-(void)returnMainPage{
    
    LoginViewController *login=[[LoginViewController alloc] init];
    login.view.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    CustomNavigationController *nav=[[CustomNavigationController alloc]initWithRootViewController:login];
    self.window.rootViewController =nav;
}

-(void)returnMainPage2{
    RootRequestController *homeVc = [[RootRequestController alloc] init];
    self.window.rootViewController = homeVc;
    
}

- (void)loadFasterStart
{
    HomePageController *homeVc = [[HomePageController alloc] init];
    CustomNavigationController *nav=[[CustomNavigationController alloc]initWithRootViewController:homeVc];
    self.window.rootViewController =nav;
}


- (UITabBarController *)tabBar
{
    HomePageController *homeVC = [[HomePageController alloc] init];
    CustomNavigationController *homeNav = [[CustomNavigationController alloc] initWithRootViewController:homeVC];
    //homeVC.tabBarItem.title = @"首页";
    homeVC.tabBarItem.image = [[UIImage imageNamed:ModuleZW(@"HomeNormal")] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeVC.tabBarItem.selectedImage = [[UIImage imageNamed:ModuleZW(@"HomeSelect")] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [homeVC.tabBarItem setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];
    
    ArchivesController *ArchiveVC = [[ArchivesController alloc] init];
    CustomNavigationController *ArchiveNav = [[CustomNavigationController alloc] initWithRootViewController:ArchiveVC];
    //ArchiveVC.tabBarItem.title = @"档案";
    ArchiveVC.tabBarItem.image = [UIImage imageNamed:ModuleZW(@"docNormal")];
    ArchiveVC.tabBarItem.selectedImage = [UIImage imageNamed:ModuleZW(@"docSelect")];
    [ArchiveVC.tabBarItem setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];
    
    //MallViewController *mallVC = [[MallViewController alloc] init];
    EDWKWebViewController *mallVC = [[EDWKWebViewController alloc] initWithUrlString:[NSString stringWithFormat:@"%@mobileIndex.html",URL_PRE]];
    CustomNavigationController *mallNav = [[CustomNavigationController alloc] initWithRootViewController:mallVC];
    //mallVC.tabBarItem.title = @"商城";
    mallVC.tabBarItem.image = [UIImage imageNamed:ModuleZW(@"MallNormal")];
    mallVC.tabBarItem.selectedImage = [UIImage imageNamed:ModuleZW(@"Mallelect")];
    [mallVC.tabBarItem setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];
    
    MineViewController *mineVC = [[MineViewController alloc] init];
    CustomNavigationController *mineNav = [[CustomNavigationController alloc] initWithRootViewController:mineVC];
    //mineVC.tabBarItem.title = @"我的";
    mineVC.tabBarItem.image = [UIImage imageNamed:ModuleZW(@"MyNormal")];
    mineVC.tabBarItem.title = @"哈哈";
    mineVC.tabBarItem.selectedImage = [UIImage imageNamed:ModuleZW(@"Myelect")];
    [mineVC.tabBarItem setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];
    
    CommonTabBarController *tabBar = [[CommonTabBarController alloc] init];
    tabBar.viewControllers = @[homeNav,ArchiveNav,mallNav,mineNav];
    return tabBar;
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    //开启后台处理多媒体事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    AVAudioSession *session=[AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    //后台播放
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    //这样做，可以在按home键进入后台后 ，播放一段时间，几分钟吧。但是不能持续播放网络歌曲，若需要持续播放网络歌曲，还需要申请后台任务id，具体做法是：
    _bgTaskId=[AppDelegate backgroundPlayerID:_bgTaskId];
}

+(UIBackgroundTaskIdentifier)backgroundPlayerID:(UIBackgroundTaskIdentifier)backTaskId
{
    //设置并激活音频会话类别
    AVAudioSession *session=[AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    //允许应用程序接收远程控制
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    //设置后台任务ID
    UIBackgroundTaskIdentifier newTaskId=UIBackgroundTaskInvalid;
    newTaskId=[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    if(newTaskId!=UIBackgroundTaskInvalid&&backTaskId!=UIBackgroundTaskInvalid)
    {
        [[UIApplication sharedApplication] endBackgroundTask:backTaskId];
    }
    return newTaskId;
}

-(void) onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle = nil;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
            {
                strMsg = @"支付结果：成功！";
                NSDictionary * dic = @{@"count":@"1"};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"count" object:self userInfo:dic];
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
            }
               
                
            default:
            {
                strMsg = [NSString stringWithFormat:@"支付结果：失败！"];
                NSDictionary * dicc = @{@"count":@"0"};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"count" object:self userInfo:dicc];
                //NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
            }
                
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    
}
- (void)sendPay_demoName:(NSString *)name Dictionary:(NSMutableDictionary *)dictionary
{
    
    //{{{
    //本实例只是演示签名过程， 请将该过程在商户服务器上实现
    
    //创建支付签名对象
    payRequsestHandler *req = [payRequsestHandler alloc];
    //初始化支付签名对象
    [req init:APP_ID mch_id:MCH_ID];
    //设置密钥
    [req setKey:PARTNER_ID];
    
    //}}}
    
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary *dict = [req sendPay_demoName:name dictionary:dictionary];
    
    if(dict == nil){
        //错误提示
        NSString *debug = [req getDebugifo];
        
        [self alert:@"提示信息" msg:debug];
        
        NSLog(@"%@\n\n",debug);
    }else{
        NSLog(@"%@\n\n",[req getDebugifo]);
        //[self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];
        
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [dict objectForKey:@"appid"];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        
        [WXApi sendReq:req];
    }
}

//客户端提示信息
- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alter show];
   
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
        return  [WXApi handleOpenURL:url delegate:self];
    }
    return result;
    
}

//- (void)application:(UIApplication *)application handleOpenURL:(NSURL * _Nonnull)url
//{
//
//}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",[resultDic objectForKey:@"memo"]);
           
            if ([[resultDic objectForKey:@"resultStatus"]integerValue] == 9000 ) {
                
                NSDictionary * dic = @{@"count":@"1"};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"count" object:self userInfo:dic];
                
            }else{
                NSDictionary * dic = @{@"count":@"0"};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"count" object:self userInfo:dic];
            }
            
        }];
    } else if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            NSString *str = [NSString stringWithFormat:@"%@",[resultDic objectForKey:@"memo"]];
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            [av show];
            
            if ([[resultDic objectForKey:@"resultStatus"]integerValue] == 9000 ) {
                NSDictionary * dic = @{@"count":@"1"};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"count" object:self userInfo:dic];
            }else{
                NSDictionary * dic = @{@"count":@"0"};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"count" object:self userInfo:dic];
            }
        }];
        
        return YES;
    }else{
        
        return  [WXApi handleOpenURL:url delegate:self];
    }
}
    return YES;
}

/*
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",[resultDic objectForKey:@"memo"]);
            NSString *str = [NSString stringWithFormat:@"%@",[resultDic objectForKey:@"memo"]];
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            [av show];
            
            if ([[resultDic objectForKey:@"resultStatus"]integerValue] == 9000 ) {
                
                NSDictionary * dic = @{@"count":@"1"};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"count" object:self userInfo:dic];
                
            }else{
                NSDictionary * dic = @{@"count":@"0"};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"count" object:self userInfo:dic];
            }
            
        }];
    } else if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            NSString *str = [NSString stringWithFormat:@"%@",[resultDic objectForKey:@"memo"]];
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            [av show];
           
            if ([[resultDic objectForKey:@"resultStatus"]integerValue] == 9000 ) {
                NSDictionary * dic = @{@"count":@"1"};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"count" object:self userInfo:dic];
            }else{
                NSDictionary * dic = @{@"count":@"0"};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"count" object:self userInfo:dic];
            }
        }];
        
        return YES;
    }else{
        
        return  [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}
 */

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
