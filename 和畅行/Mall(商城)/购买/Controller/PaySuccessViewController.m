//
//  PaySuccessViewController.m
//  Voicediagno
//
//  Created by 李传铎 on 15/10/26.
//  Copyright (c) 2015年 李传铎. All rights reserved.
//

#import "PaySuccessViewController.h"

#import "EDWKWebViewController.h"
//#import "PersonContentssViewController.h"

@interface PaySuccessViewController ()

@end

@implementation PaySuccessViewController
- (void)dealloc{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    
    self.navTitleLabel.text = @"支付信息";
    
    UIImageView *beijingImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 280)];
    beijingImage.image = [UIImage imageNamed:@"zhifubeijingtupian.png"];
    [self.view addSubview:beijingImage];
   
    UIImageView *zhifuchenggongImage = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 158.5) / 2, 84, 158.5, 158.5)];
    zhifuchenggongImage.image = [UIImage imageNamed:@"zhifuchenggong.png"];
    [self.view addSubview:zhifuchenggongImage];
   
    UILabel *chenggongLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 84 + 158.5 + 20, self.view.frame.size.width, 20)];
    chenggongLabel.textAlignment = NSTextAlignmentCenter;
    chenggongLabel.text = @"支付成功";
    chenggongLabel.textColor = [UIColor whiteColor];
    chenggongLabel.font = [UIFont systemFontOfSize:22];
    [self.view addSubview:chenggongLabel];
   
    UILabel *chashouLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 84 + 158.5 + 60, self.view.frame.size.width, 20)];
    chashouLabel.textColor = [UIColor whiteColor];
    chashouLabel.text = @"您已成功购买商品，请注意查收";
    chashouLabel.textAlignment = NSTextAlignmentCenter;
    chashouLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:chashouLabel];

    UIButton *wanchengButton = [UIButton buttonWithType:UIButtonTypeCustom];
    wanchengButton.frame = CGRectMake((self.view.frame.size.width - 210) / 2, 254 + 158.5, 210, 40);
    [wanchengButton setBackgroundImage:[UIImage imageNamed:@"zhifuwancheng.png"] forState:UIControlStateNormal];
    [wanchengButton addTarget:self action:@selector(wanchengButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wanchengButton];
                            
}
- (void)PlayWithPop{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)wanchengButton{
    
    for (UIViewController *vcHome in self.navigationController.viewControllers) {
        /**
         *  通过点击乐药界面push出的购物车界面
         */
//        if ([vcHome isKindOfClass:[LeyaoZKViewController class]]) {
//            /**
//             *  乐药购买成功后将购物车清空
//             */
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"PayStatues" object:nil];
//            [self.navigationController popToViewController:vcHome animated:YES];
//
//
//        }
        /**
         *  通过点击健康商城界面push出的购物车界面
         */
        if ([vcHome isKindOfClass:[EDWKWebViewController class]]){
            NSArray *array = self.navigationController.viewControllers;
            NSLog(@"%@",array);
            [self.navigationController popToViewController:array[0] animated:YES];
            
        }
        /**
         *  通过点击订单列表push出的购物车界面
         */
//        if ([vcHome isKindOfClass:[MenuWebViewController class]]) {
//            NSArray *array = self.navigationController.viewControllers;
//            NSLog(@"%@",array);
//            [self.navigationController popToViewController:array[3] animated:YES];
//
//        }
        
        
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
