//
//  SidebarViewController.h
//  LLBlurSidebar
//
//  Created by Lugede on 14/11/20.
//  Copyright (c) 2014年 lugede.cn. All rights reserved.
//

#import "LLBlurSidebar.h"

@protocol SidebarViewDelegate<NSObject>

- (void)selectIndexWithString:(NSString *)str withButton:(UIButton *)button;

@end

@interface SidebarViewController : LLBlurSidebar

@property (weak, nonatomic) id <SidebarViewDelegate> delegate;

@end
