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
    self.preBtn.hidden = NO;
    self.leftBtn.hidden = YES;
//    [self.rightBtn setImage:[UIImage imageNamed:@"message_01"] forState:UIControlStateNormal];
    self.view.backgroundColor = RGB_AppWhite;
    
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
