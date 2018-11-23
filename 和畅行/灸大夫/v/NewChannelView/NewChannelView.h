//
//  NewChannelView.h
//  MoxaYS
//
//  Created by xuzengjun on 16/10/19.
//  Copyright © 2016年 jiudaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <moxibustion/DeviceModel.h>

@protocol NewChannelViewGestureDelegate;
#define MODE_I9  1
#define MODE_68  2

@interface NewChannelView : UIView
@property (nonatomic, retain) id<NewChannelViewGestureDelegate> mGestureDelegate;
@property (assign, nonatomic) int states;
@property (assign, nonatomic) int shiJian;
@property (assign ,nonatomic) int wendu;        //实际温度
@property (assign ,nonatomic) int waitSetwendu;  //将要设置的温度
@property (assign ,nonatomic) int tempSetwendu;  //预设置的温度
@property (assign, nonatomic) int electricity;
@property (retain, nonatomic) NSString *mochinUUid;
//@property (assign, nonatomic) BOOL IsWaveing;
@property (assign, nonatomic) BOOL mHasFirstWork;
@property (assign, nonatomic) int  channelmode;
//@property (retain,nonatomic) DeviceModel *deviceitem;
//@property (assign, nonatomic) BOOL mHasReadChannelData; //判断是否加载过数据 防止丢包的时候没有加载数据
@property (retain, nonatomic) NSMutableArray *tempArry;

//@property (nonatomic, retain) UIView *referView;
//@property (nonatomic, retain) UIView *parentView;

- (NewChannelView *)instanceWithFrame:(CGRect)frame channelNo:(int)no Mode:(int)mode;

//动画效果的方法
//-(void)StartWave;
//-(void)StopWave;
//-(void)setNeedStop:(BOOL)tag;
-(void)ShowWarnning;
-(void)StopWarnning;
-(void)showFocse;
-(void)hideFocse;
-(void)resetAnimation;


//操作流程的方法
- (int)getWenDu;
- (int)getShiJian;
- (int)getStates;
- (void)setStates:(int)s;
- (void)updateShiJian:(int)sec;
- (void)updateWenDu:(int)du;
- (void)updateElectricity:(int)electry;
- (void)setChannelNum:(int)num;
@end

@protocol NewChannelViewGestureDelegate
@required
-(void)singleClick:(NewChannelView *)view;
-(void)longPress:(NewChannelView *)view;
@optional
-(void)OneSwitchBtnOnclink:(NewChannelView *)view;
-(BOOL) isTrackIntersect:(NewChannelView *)view;
@end
