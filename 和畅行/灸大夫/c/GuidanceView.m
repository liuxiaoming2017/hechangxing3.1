//
//  GuidanceView.m
//  和畅行
//
//  Created by 刘晓明 on 2018/11/14.
//  Copyright © 2018 刘晓明. All rights reserved.
//

#import "GuidanceView.h"

@implementation GuidanceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 50, 300, 40)];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = ModuleZW(@"艾灸仪没有连接上?\n取出艾灸头，此时设备会振动");
    [self addSubview:titleLabel];
    
    CGFloat width1 = 210;
    UIImageView *imgV1 = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-width1)/2.0, titleLabel.bottom+30, width1, 60)];
    imgV1.image = [UIImage imageNamed:@"jiutou1"];
    imgV1.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:imgV1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.left, imgV1.bottom+30, 200, 20)];
    label2.font = [UIFont systemFontOfSize:16];
    label2.textAlignment = NSTextAlignmentLeft;
    label2.textColor = [UIColor blackColor];
    label2.text = ModuleZW(@"打开蓝牙");
    [self addSubview:label2];
    
    CGFloat width2 = 90;
    UIImageView *imgV2 = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-width2)/2.0, label2.bottom+30, width2, 100)];
    imgV2.image = [UIImage imageNamed:@"lanya1"];
    imgV2.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:imgV2];
}

@end
