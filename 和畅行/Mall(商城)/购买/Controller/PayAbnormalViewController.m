//
//  PayAbnormalViewController.m
//  Voicediagno
//
//  Created by 李传铎 on 15/10/27.
//  Copyright (c) 2015年 李传铎. All rights reserved.
//

#import "PayAbnormalViewController.h"
#import "PayViewController.h"
@interface PayAbnormalViewController ()

@end

@implementation PayAbnormalViewController
- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    self.navTitleLabel.text = @"支付信息";
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *beijingImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 280)];
    beijingImage.image = [UIImage imageNamed:@"zhifubeijingtupian.png"];
    [self.view addSubview:beijingImage];
    
    UIImageView *zhifuchenggongImage = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 158.5) / 2, 84, 158.5, 158.5)];
    zhifuchenggongImage.image = [UIImage imageNamed:@"zhifushibai.png"];
    [self.view addSubview:zhifuchenggongImage];
    
    UILabel *chenggongLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 84 + 158.5 + 20, self.view.frame.size.width, 20)];
    chenggongLabel.textAlignment = NSTextAlignmentCenter;
    chenggongLabel.text = @"支付异常";
    chenggongLabel.textColor = [UIColor whiteColor];
    chenggongLabel.font = [UIFont systemFontOfSize:22];
    [self.view addSubview:chenggongLabel];
    
    UILabel *chashouLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 84 + 158.5 + 60, self.view.frame.size.width, 20)];
    chashouLabel.textColor = [UIColor whiteColor];
    chashouLabel.text = @"当前支付异常，请重新支付";
    chashouLabel.textAlignment = NSTextAlignmentCenter;
    chashouLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:chashouLabel];
    
    UIButton *wanchengButton = [UIButton buttonWithType:UIButtonTypeCustom];
    wanchengButton.frame = CGRectMake((self.view.frame.size.width - 210) / 2, 254 + 158.5, 210, 40);
    [wanchengButton setBackgroundImage:[UIImage imageNamed:@"zhongxinzhifu.png"] forState:UIControlStateNormal];
    [wanchengButton addTarget:self action:@selector(chongxinButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wanchengButton];
    
}

- (void)PlayWithPop{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)chongxinButton{
    for (UIViewController *vcHome in self.navigationController.viewControllers) {
        if ([vcHome isKindOfClass:[PayViewController class]]) {
            [self.navigationController popToViewController:vcHome animated:YES];
        }
    }
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
