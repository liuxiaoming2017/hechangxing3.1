//
//  HomeViewController.h
//  MoxaAdvisor
//
//  Created by wangdong on 14/11/25.
//  Copyright (c) 2014年 jiudaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavBarViewController.h"

@interface i9_MoxaMainViewController : NavBarViewController {
}

@property (assign, nonatomic) bool isFirstIn;
@property (assign, nonatomic) bool isSwitching;
@property (assign, nonatomic) int channeSum;
@property (assign, nonatomic) int mPassword_state;          //蓝牙窗口状态
@property (assign, nonatomic) int  mCurrChannel;
@property (assign, nonatomic) int  mCurrWenDu;
@property (assign, nonatomic) long  mPrevTime;
@property (assign, nonatomic) int  mPopListViewFrom;

@property (assign, nonatomic) bool bVoiceOn;
@property (assign, nonatomic) bool bIsFirstPlay;
@property (assign, nonatomic) bool bLampState;
@property (assign,nonatomic) BOOL settingsBoudIsShow;


-(void)controlSound;

//-(void)showRecipelList;

-(void)SetPassWord:(NSString *)pwd ISsetpwd_:(BOOL)flag;

-(BOOL)checkHasMoxaWork;

@end
