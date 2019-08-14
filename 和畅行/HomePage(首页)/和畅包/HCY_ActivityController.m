//
//  HCY_ActivityController.m
//  和畅行
//
//  Created by 出神入化 on 2018/12/13.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "HCY_ActivityController.h"

@interface HCY_ActivityController ()
@property (nonatomic,strong) UIProgressView *progressView;
@end

@implementation HCY_ActivityController

- (void)viewDidLoad {    
    [super viewDidLoad];
    self.navTitleLabel.text = self.titleStr;
    [self customeViewWithStr:self.urlStr];
}



@end
