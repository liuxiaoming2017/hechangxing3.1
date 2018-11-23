//
//  MoxiHeadInfView_i9.h
//  MoxaYS
//
//  Created by xuzengjun on 17/6/3.
//  Copyright © 2017年 jiudaifu. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MoxiHeadInfView_i9_Delegate <NSObject>

- (void)SwitchBtnOnclink:(id)sender;

- (void)choosePlanBtnOnclink:(id)sender;

- (void)moxaRecodeOnclink:(id)sender;

@end

@interface MoxiHeadInfView_i9 : UIView
@property (weak, nonatomic) IBOutlet UIButton *mSwitch;
@property (weak, nonatomic) IBOutlet UIButton *mChoosePlanBtn;
@property (weak, nonatomic) IBOutlet UIButton *mMoxaRecode;
@property (nonatomic,weak)id<MoxiHeadInfView_i9_Delegate> delegate;

@end
