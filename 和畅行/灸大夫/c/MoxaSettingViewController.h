//
//  MoxaSettingViewController.h
//  MoxaAdvisor
//
//  Created by wangdong on 15/6/11.
//  Copyright (c) 2015年 jiudaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavBarViewController.h"

@interface MoxaSettingViewController : NavBarViewController <UITableViewDataSource, UITableViewDelegate>
@property (assign, nonatomic) bool bVoiceOn;
@property (weak,nonatomic) UIViewController *fatherVC;
@end
