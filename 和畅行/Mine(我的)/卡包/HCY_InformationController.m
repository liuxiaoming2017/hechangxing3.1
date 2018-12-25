//
//  HCY_InformationController.m
//  和畅行
//
//  Created by Wei Zhao on 2018/12/10.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "HCY_InformationController.h"
#import "BlockViewController.h"
@interface HCY_InformationController ()

@property (nonatomic,strong)UILabel *hLabel;
@property (nonatomic,strong)UILabel *mLabel;
@property (nonatomic,strong)UILabel *yLabel;

@end

@implementation HCY_InformationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutView];
    
    
}

-(void)layoutView {
    
    self.navigationItem.title = @"添加新卡";
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, kNavBarHeight + 40,ScreenWidth - 20, 130)];
    //添加渐变色
    [imageV.layer addSublayer:[UIColor setGradualChangingColor:imageV fromColor:@"4294E1" toColor:@"D1BDFF"]];
    
    imageV.layer.cornerRadius = 10;
    imageV.layer.masksToBounds = YES;
    [self.view addSubview:imageV];
    
    
    _hLabel = [[UILabel alloc] init];
    _hLabel.frame = CGRectMake(imageV.left + 10, imageV.top + 10, 150, 30);
    _hLabel.textColor = [UIColor whiteColor];
    _hLabel.text = @"视频问诊半年卡";
    _hLabel.font = [UIFont systemFontOfSize:21];
    [self.view addSubview:_hLabel];
    
    _mLabel = [[UILabel alloc] init];
    _mLabel.frame = CGRectMake(_hLabel.left,_hLabel.bottom , self.view.width -  30, 60 );
    _mLabel.numberOfLines = 2;
    _mLabel.text = @"阿道夫沙发沙发沙发上发送到发的是飞洒发士大夫撒按时发生";
    _mLabel.font = [UIFont systemFontOfSize:14];
    _mLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_mLabel];
    

    _yLabel = [[UILabel alloc] init];
    _yLabel.frame = CGRectMake(_hLabel.left , _mLabel.bottom , 160, 20);
    _yLabel.text = @"2019-11-11到期";
    _yLabel.font = [UIFont systemFontOfSize:12];
    _yLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_yLabel];
    
    UIButton *addButton = [Tools creatButtonWithFrame:CGRectMake(ScreenWidth/2-70, imageV.bottom + 70, 140, 50) target:self sel:@selector(addCarAction) tag:3333 image:nil title:@"添加"];
    [addButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [addButton setBackgroundColor:RGB_ButtonBlue];
    addButton.layer.cornerRadius = 25;
    addButton.layer.masksToBounds = YES;
    [self.view addSubview:addButton];
    
}


-(void)addCarAction {
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[BlockViewController class]]) {
            BlockViewController *A =(BlockViewController *)controller;
            [self.navigationController popToViewController:A animated:YES];
        }
    }

}


@end
