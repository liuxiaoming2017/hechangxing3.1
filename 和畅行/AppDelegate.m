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

#import "NSBundle+Language.h"

#import "AFNetworking.h"

#if !FIRST_FLAG
    #import <FBSDKCoreKit/FBSDKCoreKit.h>
    #import <GoogleSignIn/GoogleSignIn.h>
#endif

@interface AppDelegate ()<WXApiDelegate>

@property (nonatomic, strong) NSURLSessionDataTask * dataTask;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    

   
    if(FIRST_FLAG){
        //强制中文
        [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:@"Language"];
        [NSBundle setLanguage:@"zh-Hans"];
        [UserShareOnce shareOnce].languageType  = nil;
    }else{
         //强制英文
        [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:@"Language"];
        [NSBundle setLanguage:@"en"];
        [UserShareOnce shareOnce].languageType  = @"us-en";
    }

    
    
    
     [[UIButton appearance] setExclusiveTouch:YES];
    NSString *fontStr = [[NSUserDefaults standardUserDefaults]valueForKey:@"YHFont"];
    if(![GlobalCommon stringEqualNull:fontStr]){
        [UserShareOnce shareOnce].multipleFontSize = [fontStr floatValue];
    }else{
        [UserShareOnce shareOnce].multipleFontSize = 1;
    }
    [UserShareOnce shareOnce].canChageSize = YES;
    
    

    [UserShareOnce shareOnce].isOnline = NO;
    [UserShareOnce shareOnce].yueYaoBuyArr = [NSMutableArray arrayWithCapacity:0];
    [UserShareOnce shareOnce].allYueYaoPrice = 0;
    
    [[UITabBar appearance] setTranslucent:NO];
    
    //和缓医疗SDK注册,是和缓分配给的productId
    #if TARGET_IPHONE_SIMULATOR || !FIRST_FLAG
    
    #else
        HHSDKOptions *hhSdk = [[HHSDKOptions alloc] initWithProductId:HHSDK_id isDebug:NO isDevelop:NO];
        hhSdk.cerName = @"2cDevTest";
        [[HHMSDK alloc] startWithOption:hhSdk];
    #endif
   

    [UMCommonLogManager setUpUMCommonLogManager];
    [UMConfigure setLogEnabled:NO];
    [UMConfigure initWithAppkey:Youmeng_id channel:@"App Store"];
    
    [WXApi registerApp:APP_ID withDescription:@"demo 2.0"];
    
    //网络状态监测
    [self networkStateCheck];
    
    [self returnMainPage2];
    
   // [self.window makeKeyAndVisible];
    
   
    //埋点注册  AeKAfeKr4YGknb2kPxd8d4xqxFcbjhg0
    [[BuredPoint sharedYHBuriedPoint]setTheSignatureWithSignStr:BuBuredPointKey withOpenStr:@"1" withLacationKey:@"AeKAfeKr4YGknb2kPxd8d4xqxFcbjhg0"];
    
    //创建本地数据库
    [[CacheManager sharedCacheManager] createDataBase];
    
    
#if FIRST_FLAG
    //奥佳华按摩椅530
    [OGAConfiguration setAppkey:OGA530AppKey appSecret:OGA530AppSecret];
//    [[OGA530BluetoothManager shareInstance] setAppkey:OGA530AppKey appSecret:OGA530AppSecret];
    [[OGA530BluetoothManager shareInstance] setIsLog:YES];

#else
    //奥佳华按摩椅730B
    [[OGABluetoothManager_730B shareInstance] setAppkey:OGA530AppKey appSecret:OGA530AppSecret];
    [[OGABluetoothManager_730B shareInstance] setIsLog:YES];
    
    //facebook
    [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
           [FBSDKSettings setAppID:@"604788230127907"];
    
    //谷歌 @"com.googleusercontent.apps.958024855386-so3o6i5o1adrpjjkt4o5bt2ajjqjv94i"
    [GIDSignIn sharedInstance].clientID = @"958024855386-so3o6i5o1adrpjjkt4o5bt2ajjqjv94i.apps.googleusercontent.com";
   // [GIDSignIn sharedInstance].delegate = self;

   
#endif
    
   [self.window makeKeyAndVisible];
    
    if(@available(iOS 11.0,*)){
        
        UITableView.appearance.estimatedRowHeight = 0;
        
        UITableView.appearance.estimatedSectionFooterHeight = 0;
        
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
        
    }
    
    
    //获取埋点token
    [self buriedDataPoints];
    [self requestUI];
    return YES;
}

# pragma mark - 活动数据的请求
-(void)requestUI {
    
    NSString *urlStr = @"mobile/index/indexpic.jhtml";
   // __weak typeof(self) weakSelf = self;
    [[NetworkManager sharedNetworkManager] requestWithType:0 urlString:urlStr parameters:nil successBlock:^(id response) {
        
        
        if([[response objectForKey:@"status"] integerValue] == 100){
            
            
     
            
        }else{
            
        }
        
        
    } failureBlock:^(NSError *error) {
        
   
    }];
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;
}
- (void)networkStateCheck {
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [UserShareOnce shareOnce].networkState = @"wwan";
                if([UserShareOnce shareOnce].uid && ![[UserShareOnce shareOnce].uid isEqualToString:@""]){
                    //[GlobalCommon networkStatusChange];
                    [[NetworkManager sharedNetworkManager] loginAgainWithTwo:YES withBlock:nil];
                }
                NSLog(@"4G");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [UserShareOnce shareOnce].networkState = @"wifi";
                if([UserShareOnce shareOnce].uid && ![[UserShareOnce shareOnce].uid isEqualToString:@""]){
                    //[GlobalCommon networkStatusChange];
                    [[NetworkManager sharedNetworkManager] loginAgainWithTwo:YES withBlock:nil];
                }
                NSLog(@"wifi:%@",[UserShareOnce shareOnce].uid);
                break;
            case AFNetworkReachabilityStatusNotReachable:
                [UserShareOnce shareOnce].networkState = @"none";
                NSLog(@"无网络");
                break;
            case AFNetworkReachabilityStatusUnknown:
                [UserShareOnce shareOnce].networkState = @"none";
                NSLog(@"无网络");
                break;
                
            default:
                break;
        }
    }];
    
    [manager startMonitoring];
    
//    if([[UserShareOnce shareOnce].networkState isEqualToString:@"wwan"] || [[UserShareOnce shareOnce].networkState isEqualToString:@"wifi"]){
  //  }
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
    
     [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14/[UserShareOnce shareOnce].multipleFontSize]} forState:UIControlStateNormal];
    
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
    

    MineViewController *mineVC = [[MineViewController alloc] init];
    CustomNavigationController *mineNav = [[CustomNavigationController alloc] initWithRootViewController:mineVC];
    mineVC.tabBarItem.title = ModuleZW(@"我的");
    mineVC.tabBarItem.image = [UIImage imageNamed:@"MyNormal"];
    
    NSLog(@"frame:%@,frame2",NSStringFromCGSize(mineVC.tabBarItem.image.size));
    
    //NSLog(@"haha:%@",NSStringFromUIEdgeInsets(mineVC.tabBarItem.imageInsets));
    //NSLog(@"****:%@",NSStringFromUIEdgeInsets(mineVC.tabBarItem.tit));
   //MyNormal
   
    mineVC.tabBarItem.selectedImage = [UIImage imageNamed:@"MySelect"];
    [mineVC.tabBarItem setImageInsets:edgeInset];
    mineVC.tabBarItem.titlePositionAdjustment = offSet;
    
    CommonTabBarController *tabBar = [[CommonTabBarController alloc] init];
    if(FIRST_FLAG){
        EDWKWebViewController *mallVC = [[EDWKWebViewController alloc] initWithUrlString:[NSString stringWithFormat:@"%@mobileIndex.html",URL_PRE]];
        CustomNavigationController *mallNav = [[CustomNavigationController alloc] initWithRootViewController:mallVC];
        mallVC.tabBarItem.title = ModuleZW(@"商城");
        mallVC.tabBarItem.image = [UIImage imageNamed:@"MallNormal"];
        mallVC.tabBarItem.selectedImage = [UIImage imageNamed:@"MallSelect"];
        [mallVC.tabBarItem setImageInsets:edgeInset];
        mallVC.tabBarItem.titlePositionAdjustment = offSet;
        tabBar.viewControllers = @[homeNav,ArchiveNav,mallNav,mineNav];
    }else{
        tabBar.viewControllers = @[homeNav,ArchiveNav,mineNav];
    }
    
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
    
    #if !FIRST_FLAG
    if([url.host isEqualToString:@"authorize"]){
            BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:app
                                                                           openURL:url
                                                                 sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                                        annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
                             ];
            
             // Add any custom logic here.
             return handled;
    }else{
//        return [[GIDSignIn sharedInstance] handleURL:url
//        sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
//               annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
        return [[GIDSignIn sharedInstance] handleURL:url];
    }
    #endif
    
    
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

//- (void)signIn:(GIDSignIn *)signIn
//didSignInForUser:(GIDGoogleUser *)user
//     withError:(NSError *)error {
//  if (error != nil) {
//    if (error.code == kGIDSignInErrorCodeHasNoAuthInKeychain) {
//      NSLog(@"The user has not signed in before or they have since signed out.");
//    } else {
//      NSLog(@"%@", error.localizedDescription);
//    }
//    return;
//  }
//  // Perform any operations on signed in user here.
//  NSString *userId = user.userID;                  // For client-side use only!
//  NSString *idToken = user.authentication.idToken; // Safe to send to the server
//  NSString *fullName = user.profile.name;
//  NSString *givenName = user.profile.givenName;
//  NSString *familyName = user.profile.familyName;
//  NSString *email = user.profile.email;
//  // ...
//}

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
    
    NSString *accessurlStr = [NSString stringWithFormat:@"%@v1/user/start",DATAURL_PRE];
    NSDictionary *accessDic = @{ @"body":@{
                                         @"id":@"",
                                         @"userId":userSign,
                                         @"version":@"3.1.3",
                                         @"channel":@"Appstore",
                                         @"province":@"",
                                         @"city":@"",
                                         @"startTime":startTimeStr,
                                         @"quitTime":endTimeStr,
                                         @"remark":@"1"}
                                 };

    [[BuredPoint sharedYHBuriedPoint] mainLocationThreadRequestWithUrl:accessurlStr dic:accessDic resultBlock:^(id  _Nonnull response) {
        NSLog(@"%@",response);
    }];
    
}



-(void)buriedDataPoints {
    //获取买点token
    NSString *appSignStr = [[NSBundle mainBundle] bundleIdentifier];
    NSDictionary *downloadDic = @{@"username":appSignStr,
                                  @"password":@"ky3h" };
    [[BuredPoint sharedYHBuriedPoint]getTokenWithUrl:DATAURL_PRE1 dic:downloadDic successBlock:^(id  _Nonnull response) {
        [self versionContrast];
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];
    
}

//版本对比
-(void )versionContrast {
    //该接口用于记录用户使用app下载网站资源记录
    NSString *userSign = [UserShareOnce shareOnce].uid;
    if ([GlobalCommon stringEqualNull:userSign]) {
        userSign = @"";
    }
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow(CFBridgingRetain(infoDictionary));
    NSString *versionStr = [infoDictionary objectForKey:@"CFBundleShortVersionString"];//版本
    
    if (![[[NSUserDefaults standardUserDefaults]valueForKey:@"versionSave"] isEqualToString:@"11111"]) {
        [[NSUserDefaults standardUserDefaults]setValue:versionStr forKey:@"version11"];
        [[NSUserDefaults standardUserDefaults]setValue:@"11111" forKey:@"versionSave"];
    }
    
    NSString *oldversionStr = [[NSUserDefaults standardUserDefaults]valueForKey:@"version11"];
    
    if (![GlobalCommon stringEqualNull:oldversionStr]) {
        if (![oldversionStr isEqualToString:versionStr]) {
            NSString *down_timeStr = [GlobalCommon getCurrentTimes];;//下载时间
            
            NSString *downloadStr = [NSString stringWithFormat:@"%@v1/user/download",DATAURL_PRE];
            NSDictionary *downloadDic = @{ @"body":@{
                                                   @"id":@"",
                                                   @"userId":@"",
                                                   @"channel":@"AppStore",
                                                   @"version":versionStr,
                                                   @"downTime":down_timeStr,
                                                   @"remark":@""}
                                           };
            
            [[BuredPoint sharedYHBuriedPoint] submitWithUrl:downloadStr dic:downloadDic successBlock:^(id  _Nonnull response) {
                NSLog(@"%@",response);
                NSString *codeStr = [NSString stringWithFormat:@"%@",[response valueForKey:@"code"]];
                if ([codeStr isEqualToString:@"200"]) {
                    [[NSUserDefaults standardUserDefaults]setValue:versionStr forKey:@"version11"];
                }
            } failureBlock:^(NSError * _Nonnull error) {

            }];
        }
    }
    
    
    
   
}


@end
