//
//  TYWaterWaveView.h
//  TYWaveProgressDemo
//
//  Created by tanyang on 15/4/14.
//  Copyright (c) 2015 tanyang. All rights reserved.
//  核心波浪view

#import <UIKit/UIKit.h>

@interface TYWaterWaveView : UIView

@property (nonatomic, strong)   UIColor *firstWaveColor;    // 第一个波浪颜色
@property (nonatomic, strong)   UIColor *secondWaveColor;   // 第二个波浪颜色

@property (nonatomic, assign)   CGFloat percent;            // 百分比
@property (nonatomic, assign)   CGFloat Heightpercent;      // 最高百分比

@property (nonatomic ,assign)   BOOL    needStop;            // 当波浪达到最高时是否需要暂停动画

@property (assign, nonatomic) BOOL IsWaveing;

-(void) startWave;

-(void) stopWave;

-(void) reset;

-(void)setIsWaveing:(BOOL)flag;

-(BOOL)getIsWaveing;

-(BOOL)getIsHeighest;

@end
