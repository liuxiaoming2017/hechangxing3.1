//
//  GlobalDefine.h
//  CustomNavigationBarDemo
//
//  Created by jimple on 14-1-6.
//  Copyright (c) 2014年 Jimple Chen. All rights reserved.
//

#ifndef CustomNavigationBarDemo_GlobalDefine_h
#define CustomNavigationBarDemo_GlobalDefine_h



#ifdef DEBUG

#define ENABLE_ASSERT_STOP          1
#define ENABLE_DEBUGLOG             1

#endif

#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
//#define NSLog(...) {}
#endif

// 颜色日志
#define XCODE_COLORS_ESCAPE_MAC @"\033["
#define XCODE_COLORS_ESCAPE_IOS @"\xC2\xA0["
#define XCODE_COLORS_ESCAPE  XCODE_COLORS_ESCAPE_MAC
#define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color
#define LogBlue(frmt, ...) NSLog((XCODE_COLORS_ESCAPE @"fg0,150,255;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define LogRed(frmt, ...) NSLog((XCODE_COLORS_ESCAPE @"fg250,0,0;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define LogGreen(frmt, ...) NSLog((XCODE_COLORS_ESCAPE @"fg0,235,30;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)

// debug log
#ifdef ENABLE_DEBUGLOG
#define APP_DebugLog(...) NSLog(__VA_ARGS__)
#define APP_DebugLogBlue(...) LogBlue(__VA_ARGS__)
#define APP_DebugLogRed(...) LogRed(__VA_ARGS__)
#define APP_DebugLogGreen(...) LogGreen(__VA_ARGS__)
#else
#define APP_DebugLog(...) do { } while (0);
#define APP_DebugLogBlue(...) do { } while (0);
#define APP_DebugLogRed(...) do { } while (0);
#define APP_DebugLogGreen(...) do { } while (0);
#endif

// log
#define APP_Log(...) NSLog(__VA_ARGS__)

// assert
#ifdef ENABLE_ASSERT_STOP
#define APP_ASSERT_STOP                     {LogRed(@"APP_ASSERT_STOP"); NSAssert1(NO, @" \n\n\n===== APP Assert. =====\n%s\n\n\n", __PRETTY_FUNCTION__);}
#define APP_ASSERT(condition)               {NSAssert(condition, @" ! Assert");}
#else
#define APP_ASSERT_STOP                     do {} while (0);
#define APP_ASSERT(condition)               do {} while (0);
#endif


/////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Redefine

#define ApplicationDelegate                 ((BubblyAppDelegate *)[[UIApplication sharedApplication] delegate])
#define UserDefaults                        [NSUserDefaults standardUserDefaults]
#define SharedApplication                   [UIApplication sharedApplication]
#define Bundle                              [NSBundle mainBundle]
#define MainScreen                          [UIScreen mainScreen]
#define ShowNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
#define HideNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO
#define NetworkActivityIndicatorVisible(x)  [UIApplication sharedApplication].networkActivityIndicatorVisible = x
#define SelfNavBar                          self.navigationController.navigationBar
#define SelfTabBar                          self.tabBarController.tabBar
#define SelfNavBarHeight                    self.navigationController.navigationBar.bounds.size.height
#define SelfTabBarHeight                    self.tabBarController.tabBar.bounds.size.height
#define ScreenRect                          [[UIScreen mainScreen] bounds]
#define kScreenSize                         [UIScreen mainScreen].bounds.size
#define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height
#define TouchHeightDefault                  44
#define TouchHeightSmall                    32
#define ViewWidth(v)                        v.frame.size.width
#define ViewHeight(v)                       v.frame.size.height
#define ViewX(v)                            v.frame.origin.x
#define ViewY(v)                            v.frame.origin.y
#define SelfViewHeight                      self.view.bounds.size.height
#define RectX(f)                            f.origin.x
#define RectY(f)                            f.origin.y
#define RectWidth(f)                        f.size.width
#define RectHeight(f)                       f.size.height
#define RectSetWidth(f, w)                  CGRectMake(RectX(f), RectY(f), w, RectHeight(f))
#define RectSetHeight(f, h)                 CGRectMake(RectX(f), RectY(f), RectWidth(f), h)
#define RectSetX(f, x)                      CGRectMake(x, RectY(f), RectWidth(f), RectHeight(f))
#define RectSetY(f, y)                      CGRectMake(RectX(f), y, RectWidth(f), RectHeight(f))
#define RectSetSize(f, w, h)                CGRectMake(RectX(f), RectY(f), w, h)
#define RectSetOrigin(f, x, y)              CGRectMake(x, y, RectWidth(f), RectHeight(f))
#define Rect(x, y, w, h)                    CGRectMake(x, y, w, h)
#define DATE_COMPONENTS                     NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
#define TIME_COMPONENTS                     NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
#define FlushPool(p)                        [p drain]; p = [[NSAutoreleasePool alloc] init]
#define RGB(r, g, b)                        [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]
#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define StatusBarHeight                     [UIApplication sharedApplication].statusBarFrame.size.height
#define SelfDefaultToolbarHeight            self.navigationController.navigationBar.frame.size.height
#define IOSVersion                          [[[UIDevice currentDevice] systemVersion] floatValue]
#define IsiOS7Later                         !(IOSVersion < 7.0)

#define Size(w, h)                          CGSizeMake(w, h)
#define Point(x, y)                         CGPointMake(x, y)

#define proportion ScreenWidth/320.0

#define TabBarHeight                        49.0f
#define NaviBarHeight                       44.0f
#define HeightFor4InchScreen                568.0f
#define HeightFor3p5InchScreen              480.0f

#define ViewCtrlTopBarHeight                (IsiOS7Later ? (NaviBarHeight + StatusBarHeight) : NaviBarHeight)
#define IsUseIOS7SystemSwipeGoBack          (IsiOS7Later ? YES : NO)

#define UIColorFromHex(ss)                  [UIColor colorWithRed:(((ss & 0xFF0000) >> 16))/255.0 green:(((ss &0xFF00) >>8))/255.0 blue:((ss &0xFF))/255.0 alpha:1.0]

#define UIColorAlpha(ss,al)                  [UIColor colorWithRed:(((ss & 0xFF0000) >> 16))/255.0 green:(((ss &0xFF00) >>8))/255.0 blue:((ss &0xFF))/255.0 alpha:al]

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_6P (IS_IPHONE && [[UIScreen mainScreen] bounds].size.width == 414.0f)
#define IS_IPHONE_6 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.width == 375.0f)

#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)

#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhoneX111 (IS_IPHONE_X || IS_IPHONE_Xr || IS_IPHONE_Xs_Max)
#define kTabBarHeight (iPhoneX111 ? 83 : 44)
#define kNavBarHeight (iPhoneX111 ? 88 : 64)
#define kNavHeight 44
#define kStatusBarHeight (iPhoneX111 ? 44 : 20)

#define leYaoStatus @"leYaoStatus"

#pragma mark - app define


#define Is4Inch                                 [UtilityFunc is4InchScreen]

#define RGB_AppWhite                            RGB(252.0f, 252.0f, 252.0f)

#define RGB_TextLightGray                       RGB(200.0f, 200.0f, 200.0f)
#define RGB_TextMidLightGray                    RGB(127.0f, 127.0f, 127.0f)
#define RGB_TextDarkGray                        RGB(100.0f, 100.0f, 100.0f)
#define RGB_TextLightDark                       RGB(50.0f, 50.0f, 50.0f)
#define RGB_TextDark                            RGB(10.0f, 10.0f, 10.0f)
#define RGB_TextAppOrange                       RGB(224.0f, 83.0f, 51.0f)
#define RGB_TextAppBlue                         RGB( 88, 147, 219)
#define RGB_TextOrange                       UIColorFromHex(0Xffa200)

#define RGB_TextAppGray                        RGB( 135, 135, 135)

#define RGB_TextGray                       UIColorFromHex(0x8e8e93)
#define RGB_ButtonBlue                          RGB(30, 130, 210)


#define SIZE_TextSmall                          10.0f
#define SIZE_TextContentNormal                  13.0f
#define SIZE_TextTitleMini                      15.0f
#define SIZE_TextTitleNormal                    17.0f
#define SIZE_TextLarge                          16.0f
#define SIZE_TextHuge                           18.0f

//////////////蓝牙
#define kPERIPHERAL_NAME        @"yueluoyi"
#define KUUID_SERVICE           @"FFE0"
#define kUUID_CHARACTER_RECEIVE @"FFE1"
#define kUUID_CHARACTER_CONFIG  @"FFE2"
#define kUUID_CHARACTER_SEND    @"2AF1"

#define blood_kPERIPHERAL_NAME        @"BPM-188"
#define blood_KUUID_SERVICE           @"18F0"
#define blood_kUUID_CHARACTER_RECEIVE @"2AF0"
#define blood_kUUID_CHARACTER_CONFIG  @"2AF0"
#define blood_kUUID_CHARACTER_SEND    @"2AF1"

#define kLoginSuccessNotification @"loginSuccsess"

/*
 *  检测耳诊仪是否链接上
 */
#define LeyaoBluetoothON @"ZKLeyaoBluetoothON"
#define LeyaoBluetoothOFF @"ZKLeyaoBluetoothOFF"
/**
 *  播放乐药
 */
#define LeyaoPlayON @"ZKLeyaoPlayON"
#define LeyaoPlayOFF @"ZKLeyaoPlayOFF"

//蓝牙连接状态的定义
#define kCONNECTED_UNKNOWN_STATE @"BLEStateUnknown"
#define kCONNECTED               @"BLEConnected"
#define kCONNECTED_RESET         @"BLEStateResetting"
#define kCONNECTED_UNSUPPORTED   @"BLEUnSupported"
#define kCONNECTED_UNAUTHORIZED  @"BLEStateUnauthorized"
#define kCONNECTED_POWERED_OFF   @"BLEStatePoweredOff"
#define kCONNECTED_POWERD_ON     @"BLEStatePoweredOn"
#define kCONNECTED_ERROR         @"BLEConnectdError"
//蓝牙(连接)状态的通知
#define kCONNECTED_STATE_CHANGED @"BLEConnectStateChanged"//蓝牙状态改变
#define kPERIPHERAL_CONNECTED    @"BLEPeripheralConnected"//成功连接外设
#define kPERIPHERAL_CONNECT_FAILED    @"BLEPeripheralConnectFaild"//连接外设失败
#define kPERIPHERAL_DISCONNECTED @"BLEPeripheralDisConnected"//断开连接
#define kPERIPHERAL_BEGIN @"BLEPeripheralBegin"//开始检测
#define kPERIPHERAL_DATA @"BLEPeripheralData"//血压数据

#define kOXYGEN_DATA @"BLEOxygenData"//血氧数据

#define exchangeMemberChildNotify @"exchangeMemberChildNotify"

#define Adapter(d)                         ((CGFloat)d/375)*ScreenWidth

// com.ky3h.test
//#define OGA530AppKey @"sdk_530w_yhdf4"
//#define OGA530AppSecret @"MIIBUwIBADANBgkqhkiG9w0BAQEFAASCAT0wggE5AgEAAkEAk/iaz03xc3uNn9E1TcOeQ2NInQnN0+YiZnAGGuEkfYqBqp1Cl4mi/f0AvKagck3ShCQrSZgeS/9eVtPpKQMpmQIDAQABAkBwsCWFtsAoyHFEwtirTkya2WOVZMABngOYq7uagNd/Wu28zVo54Pmm5b9qbM2W6jL4QqS7oX8RLpGHLkYLiniZAiEA5HuQF5ElWs8Z1tNqKDXRMfMwOeHwyh3u11Z0w5flWPsCIQClysJTySm9Q3/r9ZYWabpNO/6I7mhb2YwD3mgq+/nrewIgSh57Y+nGAGtmqnXy3hB3SIjngB93iVmkfV6iikDgObkCIGs4hhTJtETCsqhXW4mDNwlcE3FbPgKo3vRhkdy6uRahAiBfeGnlyvdBI5dg+WCzzovuKVkxmdYR8F2p8WN1p7zxGw=="


// com.ky3h.hechangxing
#define OGA530AppKey @"sdk_530w_yhdf3"
#define OGA530AppSecret @"MIIBVQIBADANBgkqhkiG9w0BAQEFAASCAT8wggE7AgEAAkEAjLb+eiyJlXGpXDFY5mgH/aXHrJnv+eGUE+/TRTrswe9pnQ/w+JjcEOnLHH9KIr/f3ibqTGOto0m/hWXQZ2G/swIDAQABAkA2VarpzizKMftth/iF74G2Zb82XLKXUI13LVHtF5W4RH1J8d/M39c+MOChorsAnC9fu/YsgBHRLIeg6xxPj6JhAiEA8M6SoBpzvrb9+cFU6myVOzTryj4kY5wHgrwksKusKBkCIQCVl8T7QdAtk8jT5nOWm8/hioE2BfhACo2YSE5dHIWPqwIgSjQtpJ5iGlvDSYoUw6QwHC2Dly+tAPDcs6GMYNCV3UkCIQCB3xZ70GJs/02ucfdN/Q3YUIfnH/2rk73kRHoMKlPmKwIhAMehTMwoJdAVcNrRZziv6IlpSCE2cupYMeuh7+qWB2fi"

#define OGADeviceUUID @"OGADeviceUUID"

//档案cell的类型
typedef enum {
    cellType_new = 0,
    cellType_jingLuo = 1,
    cellType_tiZhi = 2,
    cellType_zangFu = 3,
    cellType_xinlv = 4,
} cellType;

#endif
