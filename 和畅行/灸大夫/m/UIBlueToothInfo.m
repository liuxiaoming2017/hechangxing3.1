//
//  UIBlueToothInfo.m
//  caj68
//
//  Created by wangdong on 14-8-3.
//  Copyright (c) 2014年 wangdong. All rights reserved.
//

#import "UIBlueToothInfo.h"

@implementation UIBlueToothInfo
@synthesize bluetoothIconBtn = _bluetoothIconBtn;
@synthesize indicatorLab = _indicatorLab;
@synthesize searchIndicator = _searchIndicator;
@synthesize bluetoothListbtn = _bluetoothListbtn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UIBlueToothInfo *)instanceWithFrame:(CGRect)frame
{
    UIBlueToothInfo *view = (UIBlueToothInfo *)[[NSBundle mainBundle] loadNibNamed:@"bluetoothinfo" owner:nil options:nil][0];
    view.frame = frame;

    return view;
}

-(void)setBlueToothStatus:(int)xstatus hintText:(NSString*)txt
{
    status = xstatus;
    if(xstatus == 1)
    {
        _indicatorLab.text = txt;
        [_searchIndicator setHidden:NO];
        [_searchIndicator startAnimating];
    }
    else if(xstatus == 2)
    {
        [_searchIndicator setHidden:YES];
        _indicatorLab.text = txt;
    }
    else if(xstatus == 3)
    {
        [_searchIndicator setHidden:YES];
        _indicatorLab.text = txt;
    }
}

- (IBAction)onClickBluetoothListBtn:(id)sender {
}

- (IBAction)onClickBlueToothIconBtn:(id)sender {
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
