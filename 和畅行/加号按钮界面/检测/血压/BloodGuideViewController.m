//
//  BloodGuideViewController.m
//  和畅行
//
//  Created by 刘晓明 on 2018/8/15.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "BloodGuideViewController.h"
#import "PressureViewController.h"

@interface BloodGuideViewController ()

@end

@implementation BloodGuideViewController

- (void)dealloc
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, ScreenWidth, ScreenHeight-kNavBarHeight)];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.tag = 1024;
    [self.view addSubview:scrollView];
    
    NSArray *arr = @[@"bloodguide1",@"bloodguide2",@"bloodguide3",@"bloodguide4"];
    for(NSInteger i=0;i<arr.count;i++){
        UIImageView *imageV = [[UIImageView alloc] init];
        if(i==0){
           imageV.frame = CGRectMake(0, 0, ScreenWidth, 0.57*ScreenWidth);
        }else if (i==1){
            imageV.frame = CGRectMake(0, 0.57*ScreenWidth, ScreenWidth, 0.73*ScreenWidth);
        }else if (i==2){
            imageV.frame = CGRectMake(0, (0.57+0.73)*ScreenWidth, ScreenWidth, 0.75*ScreenWidth);
        }else{
            imageV.frame = CGRectMake(0, (0.57+0.73+0.75)*ScreenWidth, ScreenWidth, 0.23*ScreenWidth);
        }
        
        imageV.contentMode = UIViewContentModeScaleToFill;
        imageV.image = [UIImage imageNamed:[arr objectAtIndex:i]];
        [scrollView addSubview:imageV];
        
    }
    scrollView.contentSize = CGSizeMake(1, (0.57+0.73+0.75+0.23)*ScreenWidth);
    scrollView.bounces = NO;
    
    
}

- (void)setIsBottom:(BOOL)isBottom
{
    _isBottom = isBottom;
    if(isBottom){
        UIScrollView *scv = (UIScrollView *)[self.view viewWithTag:1024];
        scv.contentSize = CGSizeMake(1, (0.57+0.73+0.75+0.23)*ScreenWidth+110);
        [self createBottomView];
    }
}

- (void)createBottomView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenSize.height-110, kScreenSize.width, 110)];
    imageView.userInteractionEnabled = YES;
    imageView.image = [UIImage imageNamed:@"流程介绍页_02"];
    [self.view addSubview:imageView];
    
    UIButton *checkInstance = [Tools creatButtonWithFrame:CGRectMake(kScreenSize.width/2-60, 18, 120, 30) target:self sel:@selector(chekInstaceClick:) tag:11 image:@"立即检测" title:nil];
    [imageView addSubview:checkInstance];
    
    UIButton *neverCaution = [Tools creatButtonWithFrame:CGRectMake(kScreenSize.width/2-60, 63, 120, 30) target:self sel:@selector(neverCautionClick:) tag:12 image:@"不再提醒" title:nil];
    [imageView addSubview:neverCaution];
}

-(void)chekInstaceClick:(UIButton *)button{
    NSLog(@"点击立即检测");
    PressureViewController *pressure = [[PressureViewController alloc] init];
    [self.navigationController pushViewController:pressure animated:YES];
}

-(void)neverCautionClick:(UIButton *)button{
    NSLog(@"点击不再提醒");
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"bloodNeverCaution"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    PressureViewController *pressure = [[PressureViewController alloc] init];
    [self.navigationController pushViewController:pressure animated:YES];
    
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
