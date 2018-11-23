//
//  BaseControlViewController.m
//  MoxaAdvisor
//
//  Created by qiuweixuan on 15/5/5.
//  Copyright (c) 2015年 jiudaifu. All rights reserved.
//

#import "BaseControlViewController.h"
//#import "BaiduMobStat.h"

@interface BaseControlViewController ()

@end

@implementation BaseControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}


-(UIViewController *)getViewControlByclass:(Class)classname{
    NSArray *viewArray = [self.navigationController viewControllers];
    UIViewController *ysvc = nil;
    for (UIView *v in viewArray)
    {
        if([v isKindOfClass:classname])
        {
            ysvc = (UIViewController *)v;
            break;
        }
    }
    return ysvc;
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
