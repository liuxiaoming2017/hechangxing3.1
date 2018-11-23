//
//  HSTabBar.h
//  和畅行
//
//  Created by 刘晓明 on 2018/7/2.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSTabBar;

@protocol HSTabBarDelegate <UITabBarDelegate>

@optional

- (void)tabBarDidClickPlusButton:(HSTabBar *)tabBar;

@end

@interface HSTabBar : UITabBar

@property (nonatomic, strong) UIButton *plusBtn;
@property (nonatomic, weak) id <HSTabBarDelegate> tabBarDelegate;

@end
