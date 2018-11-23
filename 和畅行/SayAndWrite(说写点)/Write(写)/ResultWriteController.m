//
//  ResultWriteController.m
//  和畅行
//
//  Created by 刘晓明 on 2018/7/20.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "ResultWriteController.h"

@interface ResultWriteController ()

@end

@implementation ResultWriteController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleLabel.text = @"健康档案";
    [self customeViewWithStr:self.urlStr];
}

- (void)goBack:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
