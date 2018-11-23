//
//  i9_UISetTTViewController.h
//  MoxaYS
//
//  Created by xuzengjun on 17/6/7.
//  Copyright © 2017年 jiudaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewChannelView.h"

@protocol i9_UISetTTDelegate
@optional
-(void)wheni9SetTT:(NewChannelView*)view WenDu:(int)wdVal shiJian:(int)sjVal allset:(int)forall NeedWork_:(BOOL)flag;
@end

@interface i9_UISetTTViewController : UIViewController
@property (nonatomic, weak) id<i9_UISetTTDelegate> setTTDelegate;

-(void)seti9ChannelView:(NewChannelView*)view BlurView:(UIViewController*)blueView;
-(void)setWenDuVal:(int)wdVal setShiJianVal:(int)sjVal _channal:(int)channal;
@end
