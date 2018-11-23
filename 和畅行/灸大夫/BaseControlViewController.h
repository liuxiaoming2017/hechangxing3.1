//
//  BaseControlViewController.h
//  MoxaAdvisor
//
//  Created by qiuweixuan on 15/5/5.
//  Copyright (c) 2015年 jiudaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseControlViewController.h"
@interface BaseControlViewController : UIViewController

+(void)recordStayTime:(NSString *)pagename InterTime_:(NSString *)interTime BlackTime_:(NSString *)blackTime;

-(UIViewController *)getViewControlByclass:(Class)classname;

@end
