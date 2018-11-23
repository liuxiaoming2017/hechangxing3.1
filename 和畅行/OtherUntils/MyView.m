//
//  MyView.m
//  Hechangyi
//
//  Created by Mymac on 15/9/17.
//  Copyright (c) 2015年 ZhangYunguang. All rights reserved.
//

#import "MyView.h"

@interface MyView()
@property (nonatomic,assign) id target;
@property (nonatomic,assign) SEL action;

@end

@implementation MyView

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if ([self.target respondsToSelector:self.action]) {
        [self.target performSelector:self.action withObject:self];
    }else{
        NSLog(@"没有实现");
    }
}
-(void)addTarget:(id)target action:(SEL)action{
    self.userInteractionEnabled = YES;
    self.action = action;
    self.target = target;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
