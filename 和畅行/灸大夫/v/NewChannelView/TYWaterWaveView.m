//
//  TYWaterWaveView.m
//  TYWaveProgressDemo
//
//  Created by tanyang on 15/4/14.
//  Copyright (c) 2015 tanyang. All rights reserved.
//
#import "TYWaterWaveView.h"

@interface TYWaterWaveView ()

@property (nonatomic, strong) CADisplayLink *waveDisplaylink;

@property (nonatomic, strong) CAShapeLayer  *firstWaveLayer;
@property (nonatomic, strong) CAShapeLayer  *secondWaveLayer;
@property (nonatomic, assign) BOOL isHeightest;//已经到达最高

@end

@implementation TYWaterWaveView{

    CGFloat waveAmplitude;  // 波纹振幅
    CGFloat waveCycle;      // 波纹周期
    CGFloat waveSpeed;      // 波纹速度
    CGFloat waveGrowth;     // 波纹上升速度
    
    CGFloat waterWaveHeight;
    CGFloat waterWaveWidth;
    CGFloat offsetX;           // 波浪x位移
    CGFloat currentWavePointY; // 当前波浪上市高度Y（高度从大到小 坐标系向下增长）
    
    float variable;     //可变参数 更加真实 模拟波纹
    BOOL increase;      // 增减变化
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds  = YES;
        [self setUp];
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds  = YES;
        [self setUp];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    waterWaveHeight = self.frame.size.height/2;
    waterWaveWidth  = self.frame.size.width;
    if (waterWaveWidth > 0) {
        waveCycle =  1.00 * M_PI / waterWaveWidth;
    }
    
    if (currentWavePointY <= 0) {
        currentWavePointY = self.frame.size.height;
    }
}

- (void)setUp
{
    waterWaveHeight = self.frame.size.height/2;
    waterWaveWidth  = self.frame.size.width;
    _secondWaveColor = [UIColor colorWithRed:105/255.0 green:166/255.0 blue:225/255.0 alpha:1];
    _firstWaveColor = [UIColor colorWithRed:63/255.0f green:117/255.0f blue:202/255.0f alpha:1];
    
    waveGrowth = 0.85;
    waveSpeed = 0.15/M_PI;
    
    [self resetProperty];
}

- (void)resetProperty
{
    currentWavePointY = self.frame.size.height;
    
    variable = 1.6;
    increase = NO;
    
    offsetX = 0;
}

- (void)setFirstWaveColor:(UIColor *)firstWaveColor
{
    _firstWaveColor = firstWaveColor;
    _firstWaveLayer.fillColor = firstWaveColor.CGColor;
}

- (void)setSecondWaveColor:(UIColor *)secondWaveColor
{
    _secondWaveColor = secondWaveColor;
    _secondWaveLayer.fillColor = secondWaveColor.CGColor;
}

- (void)setPercent:(CGFloat)percent
{
    if (percent < _percent) {
        // 下降
        waveGrowth = waveGrowth > 0 ? -waveGrowth : waveGrowth;
    }else if (percent > _percent) {
        // 上升
        waveGrowth = waveGrowth > 0 ? waveGrowth : -waveGrowth;
        _Heightpercent = percent;
        _isHeightest = NO;
    }
    _percent = percent;
}

-(void)startWave{
    
    if (_firstWaveLayer == nil) {
        // 创建第一个波浪Layer
        _firstWaveLayer = [CAShapeLayer layer];
        _firstWaveLayer.fillColor = _firstWaveColor.CGColor;
        [self.layer addSublayer:_firstWaveLayer];
    }
    
    if (_secondWaveLayer == nil) {
        // 创建第二个波浪Layer
        _secondWaveLayer = [CAShapeLayer layer];
        _secondWaveLayer.fillColor = _secondWaveColor.CGColor;
        [self.layer addSublayer:_secondWaveLayer];
    }
    
    if (_waveDisplaylink == nil) {
        // 启动定时调用
        _waveDisplaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(getCurrentWave:)];
        [_waveDisplaylink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    
}

- (void)reset
{
    [self stopWave];
    [self resetProperty];
    
    if (_firstWaveLayer) {
        [_firstWaveLayer removeFromSuperlayer];
        _firstWaveLayer = nil;
    }
    
    if (_secondWaveLayer) {
        [_secondWaveLayer removeFromSuperlayer];
        _secondWaveLayer = nil;
    }
}

-(void)animateWave
{
    if (increase) {
        variable += 0.01;
    }else{
        variable -= 0.01;
    }
    
    if (variable<=1) {
        increase = YES;
    }
    
    if (variable>=1.6) {
        increase = NO;
    }
    
    waveAmplitude = variable*3;
}

-(void)getCurrentWave:(CADisplayLink *)displayLink{
    [self animateWave];
//    NSLog(@"------waveGrowth = %f-currentWavePointY = %f,waterWaveHeight = %f _percent = %f",waveGrowth,currentWavePointY,waterWaveHeight,_percent);
    if(!_isHeightest){// 在上涨没到达最高点时不让它执行下降操作
        if (currentWavePointY > 2 * waterWaveHeight *(1-_Heightpercent)){
            if(waveGrowth > 0){
                currentWavePointY -= waveGrowth;
            }else{
                currentWavePointY -= -waveGrowth;
            }
        }else{
//            NSLog(@"----已到达最高点");
            _isHeightest = YES;
            if(_needStop == YES){
//                 NSLog(@"----已到达最高点 stop");
                [self stopWave];
                _IsWaveing = NO;
            }
        }
    }else{
//        NSLog(@"----在下降");
        if (waveGrowth < 0 && currentWavePointY < 2 * waterWaveHeight *(1-_percent)){ //下降
            currentWavePointY -= waveGrowth;
        }
    }
//    if ( waveGrowth > 0 && currentWavePointY > 2 * waterWaveHeight *(1-_percent)) { //上涨
//        // 波浪高度未到指定高度 继续上涨
//        currentWavePointY -= waveGrowth;
//    }else if (waveGrowth < 0 && currentWavePointY < 2 * waterWaveHeight *(1-_percent)){ //下降
//        currentWavePointY -= waveGrowth;
//    }else{
//        if(_needStop == YES){
//            [self stopWave];
//        }
//    }
    // 波浪位移
    offsetX += waveSpeed;
    
    [self setCurrentFirstWaveLayerPath];

    [self setCurrentSecondWaveLayerPath];
}

-(void)setCurrentFirstWaveLayerPath{

    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = currentWavePointY;
    CGPathMoveToPoint(path, nil, 0, y);
    for (float x = 0.0f; x <=  waterWaveWidth ; x++) {
        // 正弦波浪公式
        y = waveAmplitude * sin(waveCycle * x + offsetX) + currentWavePointY;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, waterWaveWidth, self.frame.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.frame.size.height);
    CGPathCloseSubpath(path);
    
    _firstWaveLayer.path = path;
    CGPathRelease(path);
}

-(void)setCurrentSecondWaveLayerPath{

    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = currentWavePointY;
    CGPathMoveToPoint(path, nil, 0, y);
    for (float x = 0.0f; x <=  waterWaveWidth ; x++) {
        // 余弦波浪公式
        y = waveAmplitude * cos(waveCycle * x + offsetX) + currentWavePointY;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, waterWaveWidth, self.frame.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.frame.size.height);
    CGPathCloseSubpath(path);
    
    _secondWaveLayer.path = path;
    CGPathRelease(path);
}

-(void)setIsWaveing:(BOOL)flag{
    _IsWaveing = flag;
}

-(BOOL)getIsWaveing{
    return _IsWaveing;
}

-(BOOL)getIsHeighest{
    return _isHeightest;
}

-(void)stopWave{
    if (_waveDisplaylink) {
        [_waveDisplaylink invalidate];
        _waveDisplaylink = nil;
    }
}


- (void)dealloc{
    [self reset];
}

@end
