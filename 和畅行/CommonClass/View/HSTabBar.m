//
//  HSTabBar.m
//  和畅行
//
//  Created by 刘晓明 on 2018/7/2.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "HSTabBar.h"

@implementation HSTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 添加一个按钮到tabbar中
        UIButton *plusBtn = [[UIButton alloc] init];
        //[plusBtn setImage:[UIImage imageNamed:@"MySelect"] forState:UIControlStateNormal];
        plusBtn.backgroundColor = UIColorFromHex(0x1e82d2);
        plusBtn.frame = CGRectMake(0, 3, 43, 43);
        plusBtn.layer.cornerRadius = 5.0;
        [plusBtn setTitle:@"+" forState:UIControlStateNormal];
        plusBtn.titleLabel.font = [UIFont systemFontOfSize:30];
        [plusBtn addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:plusBtn];
        self.plusBtn = plusBtn;
    }
    return self;
}

- (void)plusClick
{
    // 通知代理
    if ([self.tabBarDelegate respondsToSelector:@selector(tabBarDidClickPlusButton:)]) {
        [self.tabBarDelegate tabBarDidClickPlusButton:self];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 1.设置加号按钮的位置
    CGPoint temp = self.plusBtn.center;
    temp.x=self.frame.size.width/2;
    temp.y=self.frame.size.height/2;
    if(iPhoneX111){
        temp.y = self.frame.size.height/2.0-(83-49)/2.0;
    }
    self.plusBtn.center=temp;
  
    // 2.设置其它UITabBarButton的位置和尺寸
    CGFloat tabbarButtonW = self.frame.size.width / 5;
    CGFloat tabbarButtonIndex = 0;
    for (UIView *child in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            // 设置宽度
            CGRect temp1=child.frame;
            temp1.size.width=tabbarButtonW;
            temp1.origin.x=tabbarButtonIndex * tabbarButtonW;
            child.frame=temp1;
            // 增加索引
            tabbarButtonIndex++;
            if (tabbarButtonIndex == 2) {
                tabbarButtonIndex++;
            }
        }
    }
}

@end
