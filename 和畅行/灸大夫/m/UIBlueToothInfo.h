//
//  UIBlueToothInfo.h
//  caj68
//
//  Created by wangdong on 14-8-3.
//  Copyright (c) 2014年 wangdong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBlueToothInfo : UIView
{
    int status;
}

@property (weak, nonatomic) IBOutlet UIButton *bluetoothIconBtn;
@property (weak, nonatomic) IBOutlet UILabel *indicatorLab;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *searchIndicator;
@property (weak, nonatomic) IBOutlet UIButton *bluetoothListbtn;

- (UIBlueToothInfo *)instanceWithFrame:(CGRect)frame;
-(void)setBlueToothStatus:(int)xstatus hintText:(NSString*)txt;

@end
