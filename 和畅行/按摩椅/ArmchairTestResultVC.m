//
//  ArmchairTestResultVC.m
//  和畅行
//
//  Created by 刘晓明 on 2019/9/17.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "ArmchairTestResultVC.h"

@interface ArmchairTestResultVC ()

@end

@implementation ArmchairTestResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    
}

- (void)initUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake((ScreenWidth-86)/2.0,kNavBarHeight+35,86,28);
    label.numberOfLines = 0;
    [self.view addSubview:label];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"评估完成！"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 17],NSForegroundColorAttributeName: [UIColor colorWithRed:30/255.0 green:130/255.0 blue:210/255.0 alpha:1.0]}];
    
    label.attributedText = string;
    label.textAlignment = NSTextAlignmentCenter;
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-180)/2.0, label.bottom+66, 180, 251)];
    imageV.image = [UIImage imageNamed:@"酸疼检测结果"];
    [self.view addSubview:imageV];
    
    
    NSArray *colorArr = @[[UIColor colorWithRed:252/255.0 green:198/255.0 blue:184/255.0 alpha:1.0],[UIColor colorWithRed:254/255.0 green:231/255.0 blue:185/255.0 alpha:1.0],[UIColor colorWithRed:211/255.0 green:241/255.0 blue:187/255.0 alpha:1.0],];
    NSArray *colorArr1 = @[[UIColor colorWithRed:252/255.0 green:198/255.0 blue:184/255.0 alpha:1.0],[UIColor colorWithRed:254/255.0 green:231/255.0 blue:185/255.0 alpha:1.0]];
    NSArray *titleArr = @[@"重度",@"中度",@"轻度"];
    for(NSInteger i=0;i<3;i++){
        UIView *view1 = [[UIView alloc] init];
        view1.frame = CGRectMake(imageV.right+12,imageV.bottom-20-50*i,20,20);
        UIColor *color = [colorArr objectAtIndex:i];
        view1.layer.backgroundColor = color.CGColor;
        view1.layer.cornerRadius = 10;
        [self.view addSubview:view1];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(view1.right+15, view1.top+2, 27.5, 16)];
        label1.text = [titleArr objectAtIndex:i];
        label1.font = [UIFont fontWithName:@"PingFang SC" size:12];
        label1.textAlignment = NSTextAlignmentLeft;
        label1.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
        [self.view addSubview:label1];
    }
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(28, imageV.bottom+56, 53, 16)];
    label1.text = @"疲劳指数";
    label1.font = [UIFont fontWithName:@"PingFang SC" size:12];
    label1.textAlignment = NSTextAlignmentLeft;
    label1.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
    [self.view addSubview:label1];
    
    self.pilaoLabel = [[UILabel alloc] initWithFrame:CGRectMake(label1.right+11, label1.top, 26, 16)];
    self.pilaoLabel.font = [UIFont fontWithName:@"PingFang SC" size:12];
    self.pilaoLabel.text = @"中度";
    self.pilaoLabel.textAlignment = NSTextAlignmentLeft;
    self.pilaoLabel.textColor = [UIColor colorWithRed:254/255.0 green:231/255.0 blue:185/255.0 alpha:1.0];
    [self.view addSubview:self.pilaoLabel];
    
    UIView *pilaoView = [[UIView alloc] initWithFrame:CGRectMake(28, label1.bottom+8, ScreenWidth-56, 20)];
    pilaoView.layer.backgroundColor = [UIColor colorWithRed:246/255.0 green:247/255.0 blue:249/255.0 alpha:1.0].CGColor;
    pilaoView.layer.cornerRadius = 10.0;
    pilaoView.clipsToBounds = YES;
    [self.view addSubview:pilaoView];
    
    for(NSInteger i = 0;i<2;i++){
        UIImageView *lineV = [[UIImageView alloc] initWithFrame:CGRectMake(pilaoView.left+pilaoView.width/3.0*(i+1), pilaoView.top, 2, pilaoView.height)];
        lineV.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:lineV];
    }
    
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(28, pilaoView.bottom+11, 53, 16)];
    label2.text = @"酸痛指数";
    label2.font = [UIFont fontWithName:@"PingFang SC" size:12];
    label2.textAlignment = NSTextAlignmentLeft;
    label2.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
    [self.view addSubview:label2];
    
    self.suantengLabel = [[UILabel alloc] initWithFrame:CGRectMake(label2.right+11, label2.top, 26, 16)];
    self.suantengLabel.font = [UIFont fontWithName:@"PingFang SC" size:12];
    self.suantengLabel.text = @"轻度";
    self.suantengLabel.textAlignment = NSTextAlignmentLeft;
    self.suantengLabel.textColor = [UIColor colorWithRed:254/255.0 green:231/255.0 blue:185/255.0 alpha:1.0];
    [self.view addSubview:self.suantengLabel];
    
    UIView *suantengView = [[UIView alloc] initWithFrame:CGRectMake(28, label2.bottom+8, ScreenWidth-56, 20)];
    suantengView.layer.backgroundColor = [UIColor colorWithRed:246/255.0 green:247/255.0 blue:249/255.0 alpha:1.0].CGColor;
    suantengView.layer.cornerRadius = 10.0;
    [self.view addSubview:suantengView];
    
    for(NSInteger i = 0;i<2;i++){
        UIImageView *lineV = [[UIImageView alloc] initWithFrame:CGRectMake(suantengView.left+suantengView.width/3.0*(i+1), suantengView.top, 2, suantengView.height)];
        lineV.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:lineV];
    }
    
    [self setupLineView:pilaoView colors:colorArr1];
    [self setupLineView:suantengView colors:colorArr];
}



-(void)setupLineView:(UIView *)lineView colors:(NSArray *)colorArr
{
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:CGPointMake(0, lineView.bounds.size.height/2)];
    [linePath addLineToPoint:CGPointMake(lineView.bounds.size.width*2/3, lineView.bounds.size.height/2)];
    
    __block float a = 0;
    
    for(UIColor *color in colorArr){
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        //每次动画的持续时间
        animation.duration = 1;
        //动画起始位置
        animation.fromValue = @(0);
        //动画结束位置
        animation.toValue = @(1);
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = linePath.CGPath;
        shapeLayer.lineWidth = lineView.bounds.size.height;
        shapeLayer.fillColor = nil;
        shapeLayer.strokeColor = color.CGColor;
        //strokeStart defaults to zero and strokeEnd to one.
        shapeLayer.strokeStart = a;
        //分成了多少段，每次加多少分之一
        shapeLayer.strokeEnd = a + 1.0/colorArr.count;
        //添加动画
        [shapeLayer addAnimation:animation forKey:@"strokeEndAnimation"];
        [lineView.layer addSublayer:shapeLayer];
        
        a = shapeLayer.strokeEnd;
    }
    
    
}

@end
