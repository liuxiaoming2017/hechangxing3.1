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

#import <PgySDK/PgyManager.h>
#import <PgyUpdate/PgyUpdateManager.h>

#import <OGABluetooth530/OGABluetooth530.h>
#import "NSBundle+Language.h"
//#import "ArmchairHomeVC.h"

@interface AppDelegate ()<WXApiDelegate>
@property (nonatomic, strong) NSURLSession * session;
@property (nonatomic, strong) NSURLSessionDataTask * dataTask;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
   // self.window.rootViewController = [self tabBar];

    //强制英文
//    [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:@"Language"];
//    [NSBundle setLanguage:@"en"];
//     [UserShareOnce shareOnce].languageType  = @"us-en";
//    [NSBundle getLanguage];
    //强制中文
    [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:@"Language"];
    [NSBundle setLanguage:@"zh-Hans"];
    [UserShareOnce shareOnce].languageType  = nil;
    
     [[UIButton appearance] setExclusiveTouch:YES];
    NSString *fontStr = [[NSUserDefaults standardUserDefaults]valueForKey:@"YHFont"];
    if(![GlobalCommon stringEqualNull:fontStr]){
        [UserShareOnce shareOnce].fontSize = [fontStr floatValue];
    }else{
        [UserShareOnce shareOnce].fontSize = 1;
    }
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:&error];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:&error];
    
    [UserShareOnce shareOnce].isOnline = NO;
    [UserShareOnce shareOnce].yueYaoBuyArr = [NSMutableArray arrayWithCapacity:0];
    [UserShareOnce shareOnce].allYueYaoPrice = 0;
    
    [[UITabBar appearance] setTranslucent:NO];
    
    //和缓医疗SDK注册,是和缓分配给的productId ffff
    #if TARGET_IPHONE_SIMULATOR
    
    #else
        HHSDKOptions *hhSdk = [[HHSDKOptions alloc] initWithProductId:HHSDK_id isDebug:NO isDevelop:NO];
        hhSdk.cerName = @"2cDevTest";
        [[HHMSDK alloc] startWithOption:hhSdk];
    #endif
   

    [UMCommonLogManager setUpUMCommonLogManager];
    [UMConfigure setLogEnabled:YES];
    [UMConfigure initWithAppkey:Youmeng_id channel:@"App Store"];
    
    [WXApi registerApp:APP_ID withDescription:@"demo 2.0"];
     [self returnMainPage2];
     [self.window makeKeyAndVisible];
    
    [ChangeLanguageObject initUserLanguage];
    
     self.session = [NSURLSession sharedSession];
   
    //埋点注册
    [[BuredPoint sharedYHBuriedPoint]setTheSignatureWithSignStr:BuBuredPointKey  withOpenStr:@"1"];
    
    //创建本地数据库
    [[CacheManager sharedCacheManager] createDataBase];
    
    for (int i = 0; i < 20; ++i) {
        NSLog(@"%d",i);
    }
    
    NSLog(@"%@,%@,%@",APP_ID,APP_SECRET,URL_PRE);
    
//    蒲公英SDK
    //启动基本SDK
    [[PgyManager sharedPgyManager] startManagerWithAppId:@"da15cba9ecb9d085233da45a1422f52c"];
    //启动更新检查SDK
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:@"da15cba9ecb9d085233da45a1422f52c"];
    
    //奥佳华按摩椅
    [[OGA530BluetoothManager shareInstance] setAppkey:OGA530AppKey appSecret:OGA530AppSecret];
    [[OGA530BluetoothManager shareInstance] setIsLog:YES];
    
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
//    ArmchairHomeVC *homeVc = [[ArmchairHomeVC alloc] init];

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
    
     [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14/[UserShareOnce shareOnce].fontSize]} forState:UIControlStateNormal];
    
    UIEdgeInsets edgeInset = UIEdgeInsetsMake(-1, 0, 1, 0);
    UIOffset offSet = UIOffsetMake(0, 1);
    
    homeVC.tabBarItem.title = ModuleZW(@"首页");
    homeVC.tabBarItem.image = [[UIImage imageNamed:@"HomeNormal"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    homeVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"HomeSelect"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [homeVC.tabBarItem setImageInsets:edgeInset];
    homeVC.tabBarItem.titlePositionAdjustment =offSet;
    
    ArchivesController *ArchiveVC = [[ArchivesController alloc] init];
    CustomNavigationController *ArchiveNav = [[CustomNavigationController alloc] initWithRootViewController:ArchiveVC];
    ArchiveVC.tabBarItem.title = ModuleZW(@"档案");
    ArchiveVC.tabBarItem.image = [UIImage imageNamed:@"docNormal"];
    ArchiveVC.tabBarItem.selectedImage = [UIImage imageNamed:@"docSelect"];
    [ArchiveVC.tabBarItem setImageInsets:edgeInset];
    ArchiveVC.tabBarItem.titlePositionAdjustment = offSet;
    
    
    EDWKWebViewController *mallVC = [[EDWKWebViewController alloc] initWithUrlString:[NSString stringWithFormat:@"%@mobileIndex.html",URL_PRE]];
    CustomNavigationController *mallNav = [[CustomNavigationController alloc] initWithRootViewController:mallVC];
    mallVC.tabBarItem.title = ModuleZW(@"商城");
    mallVC.tabBarItem.image = [UIImage imageNamed:@"MallNormal"];
    mallVC.tabBarItem.selectedImage = [UIImage imageNamed:@"MallSelect"];
    [mallVC.tabBarItem setImageInsets:edgeInset];
    mallVC.tabBarItem.titlePositionAdjustment = offSet;
    
    MineViewController *mineVC = [[MineViewController alloc] init];
    CustomNavigationController *mineNav = [[CustomNavigationController alloc] initWithRootViewController:mineVC];
    mineVC.tabBarItem.title = ModuleZW(@"我的");
    mineVC.tabBarItem.image = [UIImage imageNamed:@"MyNormal"];
   
   
    mineVC.tabBarItem.selectedImage = [UIImage imageNamed:@"MySelect"];
    [mineVC.tabBarItem setImageInsets:edgeInset];
    mineVC.tabBarItem.titlePositionAdjustment = offSet;
    
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
    if([GlobalCommon stringEqualNull:[UserShareOnce shareOnce].uid]) return;
    NSString *userSign = [UserShareOnce shareOnce].uid;
    NSString *startTimeStr = [UserShareOnce shareOnce].startTime;
    NSString *endTimeStr = [GlobalCommon getCurrentTimes];

    NSString *accessurlStr = [NSString stringWithFormat:@"%@user/access",DATAURL_PRE];
    NSDictionary *accessDic = @{ @"body":@{@"channel":@"1",
                                           @"remark":@"1",
                                           @"userSign":userSign,
                                           @"startTime":startTimeStr,
                                           @"userSource":@"1",
                                           @"quitTime":endTimeStr,
                                           @"flag":@"1"}
                                 };
    [[BuredPoint sharedYHBuriedPoint] mainThreadRequestWithUrl:accessurlStr dic:accessDic resultBlock:^(id  _Nonnull response) {
        NSLog(@"%@",response);
    }];
   
}

@end
