//
//  TestBaseViewController.m
//  和畅行
//
//  Created by 刘晓明 on 2018/8/21.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "TestBaseViewController.h"

@interface TestBaseViewController ()

@end

@implementation TestBaseViewController
@synthesize progressView;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, ScreenWidth, ScreenHeight-kNavBarHeight)];
    [backImageView setImage:[UIImage imageNamed:@"深色背景"]];
    [self.view addSubview:backImageView];
    
}

- (void)showPreogressView
{
    progressView = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progressView];
    [self.view bringSubviewToFront:progressView];
    progressView.label.text = @"加载中...";
    [progressView showAnimated:YES];

}

- (void)hidePreogressView
{
    [progressView removeFromSuperview];
    progressView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
