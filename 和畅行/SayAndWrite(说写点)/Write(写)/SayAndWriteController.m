//
//  SayAndWriteController.m
//  和畅行
//
//  Created by 刘晓明 on 2018/7/12.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "SayAndWriteController.h"

@interface SayAndWriteController ()

@end

@implementation SayAndWriteController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topView.backgroundColor = UIColorFromHex(0x1e82d2);
    self.navTitleLabel.textColor = [UIColor whiteColor];
    self.preBtn.hidden = NO;
    [self.leftBtn setImage:[UIImage imageNamed:@"user_01"] forState:UIControlStateNormal];
    [self.rightBtn setImage:[UIImage imageNamed:@"message_01"] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
}

@end
