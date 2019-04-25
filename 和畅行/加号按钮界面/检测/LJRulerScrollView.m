//
//  LJRulerScrollView.m
//  LJRulerDemo
//
//  Created by liujun on 2018/7/13.
//  Copyright © 2018年 liujun. All rights reserved.
//

#import "LJRulerScrollView.h"

@interface LJRulerScrollView ()

@property (nonatomic, assign) CGFloat rulerHeight;
@property (nonatomic, assign) CGFloat rulerWidth;
@property (nonatomic, strong) CAShapeLayer *dividingScaleLayer;
@property (nonatomic, strong) CAShapeLayer *averageScaleLayer;
@property (nonatomic, strong) CAShapeLayer *baseLineLayer;
@property (nonatomic, strong) NSMutableArray *scaleValueLabels;

@end

@implementation LJRulerScrollView

#pragma mark - drawRect

- (void)drawRect:(CGRect)rect {
    if (self.currentValue > self.scaleCount * self.scaleAverage || self.currentValue < 0) {
        return;
    }
    [self removeObject];
    self.rulerWidth = self.bounds.size.width;
    self.rulerHeight = self.bounds.size.height;
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    
    CGMutablePathRef averageScalePathRef = CGPathCreateMutable();
    CAShapeLayer *averageScaleLayer = [CAShapeLayer layer];
    averageScaleLayer.strokeColor = UIColorFromHex(0XC6C6C6).CGColor; //self.scaleAverageLineColor.CGColor;
//    averageScaleLayer.fillColor = [UIColor redColor].CGColor;
    averageScaleLayer.lineWidth = self.lineWidth;
    averageScaleLayer.lineCap = kCALineCapButt;
    self.averageScaleLayer = averageScaleLayer;
    
    NSInteger nuber;
    int value;
    if (self.scaleAverage == 1){
        nuber = self.currentValue;
        value = (int)(self.currentValue + self.mixscaleCount);
    }else{
        nuber = (self.currentValue*10);
        value = (int)((self.currentValue+ self.mixscaleCount/10)*10);
    }
    for (NSInteger i = self.mixscaleCount; i <= self.scaleCount; i++) {
      
        if (i % 10 == 0) {
            UILabel *scaleValueLabel = [[UILabel alloc] init];
            
            scaleValueLabel.text = [NSString stringWithFormat:@"%.0f", i * self.scaleAverage];
            CGSize textSize = [scaleValueLabel.text sizeWithAttributes:@{ NSFontAttributeName : scaleValueLabel.font}];
            scaleValueLabel.frame = CGRectMake(self.scaleSpacing *  (i - self.mixscaleCount +1 ) - textSize.width / 2-3, self.rulerHeight / 2 - textSize.height - self.scaleValueMargin+2, 0, 0);
            [scaleValueLabel sizeToFit];
            [self addSubview:scaleValueLabel];
            [self.scaleValueLabels addObject:scaleValueLabel];
            
            if(value/10 == (int)i/10&&value% 10 == 0){
                scaleValueLabel.textColor = UIColorFromHex(0Xffa200);
                scaleValueLabel.font = [UIFont systemFontOfSize:12];
            }else{
                scaleValueLabel.textColor = UIColorFromHex(0XC6C6C6);
                scaleValueLabel.font = [UIFont systemFontOfSize:9];
            }
           
        }
       
        if (  (i - self.mixscaleCount )  >  nuber - 4 &&  (i - self.mixscaleCount )  <  nuber + 4  ) {
            CGFloat viey = 22  + 2 * (abs((int)nuber - (int) (i - self.mixscaleCount )));
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.scaleSpacing *  (i - self.mixscaleCount ),viey - 5, 1,self.rulerHeight - viey )];
            [self addSubview:view];
            view.backgroundColor = UIColorFromHex(0Xffa200);
        }else {
            CGPathMoveToPoint(averageScalePathRef, NULL, self.scaleSpacing * (i - self.mixscaleCount ) , self.rulerHeight -5 );
            CGPathAddLineToPoint(averageScalePathRef, NULL, self.scaleSpacing * (i - self.mixscaleCount ), 23);
        }
        
       
        
    }
    
    
    averageScaleLayer.path = averageScalePathRef;
    [self.layer addSublayer:averageScaleLayer];
    [self resetContentOffset];
    self.contentSize = CGSizeMake((self.scaleCount - self.mixscaleCount) * self.scaleSpacing, self.rulerHeight);
}

- (void)removeObject {
    [self.dividingScaleLayer removeFromSuperlayer];
    [self.averageScaleLayer removeFromSuperlayer];
    [self.baseLineLayer removeFromSuperlayer];
    [self.scaleValueLabels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.scaleValueLabels removeAllObjects];
}

#pragma mark - 重置contentOffset

- (void)resetContentOffset {
    UIEdgeInsets edge = UIEdgeInsetsMake(0, self.rulerWidth / 2, 0, self.rulerWidth / 2);
    self.contentInset = edge;
    self.contentOffset = CGPointMake(self.scaleSpacing * (self.currentValue / self.scaleAverage) - self.rulerWidth + (self.rulerWidth / 2), 0);
}

#pragma mark - 懒加载

- (NSMutableArray *)scaleValueLabels {
    if (!_scaleValueLabels) {
        _scaleValueLabels = [[NSMutableArray alloc] init];
    }
    return _scaleValueLabels;
}

#pragma mark - setter方法

- (void)setCurrentValue:(CGFloat)currentValue {
    _currentValue = currentValue;
    
    if (self.rulerWidth == 0 || self.rulerHeight == 0) {
        [self setNeedsDisplay];
    } else {
        [self resetContentOffset];
    }
}

- (void)setScaleDividing:(NSInteger)scaleDividing {
    _scaleDividing = scaleDividing;

    [self setNeedsDisplay];
}



- (void)setScaleCount:(NSInteger)scaleCount {
    _scaleCount = scaleCount;

    [self setNeedsDisplay];
}

- (void)setScaleAverage:(CGFloat)scaleAverage {
    _scaleAverage = scaleAverage;

    [self setNeedsDisplay];
}

- (void)setScaleAverageLineHeight:(CGFloat)scaleAverageLineHeight {
    _scaleAverageLineHeight = scaleAverageLineHeight;

    [self setNeedsDisplay];
}

- (void)setScaleSpacing:(CGFloat)scaleSpacing {
    _scaleSpacing = scaleSpacing;

    [self setNeedsDisplay];
}

- (void)setScaleValueMargin:(CGFloat)scaleValueMargin {
    _scaleValueMargin = scaleValueMargin;

    [self setNeedsDisplay];
}

- (void)setScaleValueFont:(UIFont *)scaleValueFont {
    _scaleValueFont = scaleValueFont;

    [self setNeedsDisplay];
}

- (void)setScaleValueColor:(UIColor *)scaleValueColor {
    _scaleValueColor = scaleValueColor;

    [self setNeedsDisplay];
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;

    [self setNeedsDisplay];
}

- (void)setScaleDividingLineColor:(UIColor *)scaleDividingLineColor {
    _scaleDividingLineColor = scaleDividingLineColor;

    [self setNeedsDisplay];
}

- (void)setScaleAverageLineColor:(UIColor *)scaleAverageLineColor {
    _scaleAverageLineColor = scaleAverageLineColor;

    [self setNeedsDisplay];
}

- (void)setBaseLineColor:(UIColor *)baseLineColor {
    _baseLineColor = baseLineColor;

    [self setNeedsDisplay];
}
-(void)update;
{
    [self setNeedsDisplay];

}
@end
