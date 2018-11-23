//
//  ChannelScrollView.h
//  MoxaYS
//
//  Created by xuzengjun on 16/11/19.
//  Copyright © 2016年 jiudaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewChannelView.h"

@interface ChannelScrollView : UIScrollView

@property (retain ,nonatomic) NSMutableArray *viewArry;

-(void)addChannelView:(NewChannelView *)view;

-(void)freshChannelView;

@end
