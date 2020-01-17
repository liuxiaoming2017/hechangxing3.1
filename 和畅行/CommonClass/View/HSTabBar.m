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
        plusBtn.frame = CGRectMake(0, 3, 43, 43);
        if(FIRST_FLAG){
            plusBtn.backgroundColor = UIColorFromHex(0x1e82d2);
            plusBtn.layer.cornerRadius = 5.0;
            [plusBtn setTitle:@"+" forState:UIControlStateNormal];
            plusBtn.titleLabel.font = [UIFont systemFontOfSize:30];
        }else{
            //CGFloat buttonW = ISPaid ? 113 : 93;
            CGFloat buttonW = ScreenWidth / 4;
            plusBtn.frame = CGRectMake(0, 5, buttonW, 48);
            [plusBtn setImage:[UIImage imageNamed:@"moreNormal"] forState:UIControlStateNormal];
            [plusBtn setTitle:@"More" forState:UIControlStateNormal];
            [plusBtn setTitleColor:UIColorFromHex(0x999999) forState:UIControlStateNormal];
            CGFloat fontSize = 14/[UserShareOnce shareOnce].multipleFontSize;
            plusBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
            
            if(ISNotPaid){
                [self changeButtonType:plusBtn];
            }else{
                [plusBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 0)];
//                [button setTitleEdgeInsets:UIEdgeInsetsMake(0, - button.imageView.image.size.width, 0, button.imageView.image.size.width)];
//                [button setImageEdgeInsets:UIEdgeInsetsMake(0, button.titleLabel.bounds.size.width, 0, -button.titleLabel.bounds.size.width)];
            }
        }
        
        [plusBtn addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:plusBtn];
        self.plusBtn = plusBtn;
    }
    return self;
}

- (void)changeButtonType:(UIButton *)button {
    CGFloat interval = 1.0;
    CGSize imageSize = button.imageView.bounds.size;
    [button setTitleEdgeInsets:UIEdgeInsetsMake(imageSize.height + interval, -(imageSize.width), 0, 0)];
    CGSize titleSize = button.titleLabel.bounds.size;
    [button setImageEdgeInsets:UIEdgeInsetsMake(0,0, titleSize.height + interval, -(titleSize.width))];
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
    
    CGFloat tabbarButtonW = FIRST_FLAG ? self.frame.size.width / 5 : self.frame.size.width / 4;
    
    // 1.设置加号按钮的位置
    CGPoint temp = self.plusBtn.center;
    
    if(FIRST_FLAG){
        temp.x = self.frame.size.width/2;
    }else{
        //temp.x = self.frame.size.width*0.75-43;
        temp.x = self.frame.size.width/4 * 2 + tabbarButtonW / 2;
    }
    
    temp.y=self.frame.size.height/2;
    if(iPhoneX111){
        temp.y = self.frame.size.height/2.0-(83-49)/2.0;
    }
    
    if(!FIRST_FLAG&&ISNotPaid){
        temp.y = temp.y + 2;
    }
    self.plusBtn.center=temp;
  
    NSLog(@"frame:%@,frame2:%@",NSStringFromCGSize(self.plusBtn.imageView.image.size),NSStringFromCGRect(self.plusBtn.frame));
    
    // 2.设置其它UITabBarButton的位置和尺寸
    
    
    CGFloat tabbarButtonIndex = 0;
    for (UIView *child in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            // 设置宽度
            CGRect temp1=child.frame;
            temp1.size.width=tabbarButtonW;
            temp1.origin.x=tabbarButtonIndex * tabbarButtonW;
            child.frame=temp1;
            
            NSLog(@"frame****:%@",NSStringFromCGRect(temp1));
            // 增加索引
            tabbarButtonIndex++;
            if (tabbarButtonIndex == 2) {
                tabbarButtonIndex++;
            }
        }
    }
}

@end
