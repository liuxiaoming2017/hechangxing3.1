//
//  i9_UISetTTViewForRollerController.h
//  MoxaYS
//
//  Created by xuzengjun on 17/8/9.
//  Copyright © 2017年 jiudaifu. All rights reserved.
//

#import "BaseControlViewController.h"
#import "NewChannelView.h"

#define MAX_WENDU 56

@protocol i9_UISetTTRollerDelegate
@optional
-(void)wheni9SetTT:(NewChannelView*)view WenDu:(int)wdVal shiJian:(int)sjVal allset:(int)forall;
@end

@interface i9_UISetTTViewForRollerController : BaseControlViewController<UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, weak) id<i9_UISetTTRollerDelegate> setTTDelegate;

-(void)seti9ChannelView:(NewChannelView*)view BlurView:(UIViewController*)blueView;
-(void)setWenDuVal:(int)wdVal setShiJianVal:(int)sjVal _channal:(int)channal;

@end

