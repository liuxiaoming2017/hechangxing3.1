//
//  MyView.h
//  Hechangyi
//
//  Created by Mymac on 15/9/17.
//  Copyright (c) 2015年 ZhangYunguang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyView : UIImageView
@property (nonatomic,assign)BOOL isClick;
-(void)addTarget:(id)target action:(SEL)action;
@end
