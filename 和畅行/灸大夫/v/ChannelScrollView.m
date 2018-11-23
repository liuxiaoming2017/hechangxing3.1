//
//  ChannelScrollView.m
//  MoxaYS
//
//  Created by xuzengjun on 16/11/19.
//  Copyright © 2016年 jiudaifu. All rights reserved.
//

#import "ChannelScrollView.h"
#import "PubFunc.h"


@implementation ChannelScrollView
@synthesize viewArry = _viewArry;

-(void)addChannelView:(NewChannelView *)view{
//    NSLog(@"---view,size = %@",NSStringFromCGRect(view.frame));
//    NSArray *varry = _viewArry.count;
//    NSLog(@"---view.count = %d",_viewArry.count);
    if(_viewArry.count == 1){
        [PubFunc ViewClearChildView:self];
        [self addSubview:view];
    }else{
        NewChannelView *lastview = [_viewArry objectAtIndex:_viewArry.count - 2];
        if(_viewArry.count%2 == 1){
            CGRect frame = view.frame;
            frame.origin.x = 0;
            frame.origin.y = lastview.frame.origin.y + lastview.frame.size.height + 1;
            view.frame = frame;
        }else{
            CGRect frame = view.frame;
            frame.origin.x = lastview.frame.origin.x + lastview.frame.size.width + 1;
            frame.origin.y = lastview.frame.origin.y;
            view.frame = frame;
        }
        [self addSubview:view];
    }
    [self ResetScrollContentSize];
}

-(void)freshChannelView{
    CGFloat x = 0, y = 0;
    [PubFunc ViewClearChildView:self];
    for (int i = 0; i < _viewArry.count;i++) {
        NewChannelView *view = [_viewArry objectAtIndex:i];
        if(i != 0 && i%2 == 0){
            x = 0;
            y += view.frame.size.height + 1;
        }
        CGRect frame = view.frame;
        frame.origin.x = x;
        frame.origin.y = y;
        view.frame = frame;
        [self addSubview:view];
        x += view.frame.size.width + 1;
    }
    [self ResetScrollContentSize];
}

-(void)ResetScrollContentSize{
    if(_viewArry.count >0){
        NewChannelView *view = [_viewArry objectAtIndex:0];
        int linenum = _viewArry.count/2;
        if(_viewArry.count%2 > 0){
            linenum ++;
        }
        CGFloat height = (view.frame.size.height + 1)*linenum;
        self.contentSize = CGSizeMake(self.frame.size.width, height);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
