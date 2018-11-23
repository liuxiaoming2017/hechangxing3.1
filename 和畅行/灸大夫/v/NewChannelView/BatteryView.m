//
//  BatteryView.m
//  tts_test_demo
//
//  Created by xuzengjun on 17/3/17.
//  Copyright © 2017年 xuzengjun. All rights reserved.
//

#import "BatteryView.h"

@interface BatteryView()

@end


@implementation BatteryView

- (void)drawRect:(CGRect)rect {
    
    CGContextRef bgContextRef = UIGraphicsGetCurrentContext();
    
    CGRect frame = CGRectMake(1 , 1, rect.size.width/10*9, rect.size.height - 2);
    
    CGContextAddRect(bgContextRef, frame);
    
    CGContextSetLineWidth(bgContextRef, 1);
    
    CGContextStrokePath(bgContextRef);
    
    
    CGContextMoveToPoint(bgContextRef, rect.size.width/10*9+1, rect.size.height/2);
    
    CGContextAddLineToPoint(bgContextRef, rect.size.width, rect.size.height/2);
    
    CGContextSetLineWidth(bgContextRef, rect.size.height/3);
    
    CGContextStrokePath(bgContextRef);
    
    
    CGContextMoveToPoint(bgContextRef, 1.5, rect.size.height/2);
    
    CGContextAddLineToPoint(bgContextRef, 1.5+_currentNum*(rect.size.width/10*9 - 1)/100, rect.size.height/2);
    
    if(_currentNum > 20){
        CGContextSetRGBStrokeColor(bgContextRef, 104.0 / 255.0, 215.0 / 255.0, 29.0 / 255.0, 1.0);
    }else{
        CGContextSetRGBStrokeColor(bgContextRef, 255.0 / 255.0, 65.0 / 255.0, 14.0 / 255.0, 1.0);
    }
    
    
    CGContextSetLineWidth(bgContextRef, rect.size.height - 3);
    
    CGContextStrokePath(bgContextRef);
    
}

-(void)setCurrentNum:(int)currentNum{
    _currentNum = currentNum;
    [self setNeedsDisplay];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
