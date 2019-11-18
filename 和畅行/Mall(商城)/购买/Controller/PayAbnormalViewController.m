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
    self.navTitleLabel.text = ModuleZW(@"支付信息");
    self.preBtn.hidden = NO;
    self.leftBtn.hidden = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *beijingImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, self.view.frame.size.width, Adapter(300))];
    beijingImage.image = [UIImage imageNamed:@"zhifubeijingtupian"];
    [self.view addSubview:beijingImage];
    
    UIImageView *zhifuchenggongImage = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - Adapter(158.5)) / 2, kNavBarHeight + Adapter(20), Adapter(158.5), Adapter(158.5))];
    zhifuchenggongImage.image = [UIImage imageNamed:@"zhifushibai.png"];
    [self.view addSubview:zhifuchenggongImage];
    
    UILabel *chenggongLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, zhifuchenggongImage.bottom + Adapter(20), self.view.frame.size.width, Adapter(20))];
    chenggongLabel.textAlignment = NSTextAlignmentCenter;
    chenggongLabel.text = ModuleZW(@"支付异常");
    chenggongLabel.textColor = [UIColor whiteColor];
    chenggongLabel.font = [UIFont systemFontOfSize:22];
    [self.view addSubview:chenggongLabel];
    
    UILabel *chashouLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, chenggongLabel.bottom + Adapter(10), self.view.frame.size.width, Adapter(20))];
    chashouLabel.textColor = [UIColor whiteColor];
    chashouLabel.text = ModuleZW(@"当前支付异常，请重新支付");
    chashouLabel.textAlignment = NSTextAlignmentCenter;
    chashouLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:chashouLabel];
    
    UIButton *wanchengButton = [UIButton buttonWithType:UIButtonTypeCustom];
    wanchengButton.frame = CGRectMake((self.view.frame.size.width - Adapter(210)) / 2, Adapter(412.55), Adapter(210), Adapter(40));
    [wanchengButton setBackgroundImage:[UIImage imageNamed:@"zhongxinzhifu"] forState:UIControlStateNormal];
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
