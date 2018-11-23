//
//  ReadOrWriteView.m
//  和畅行
//
//  Created by 刘晓明 on 2018/7/3.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "ReadOrWriteView.h"
#import "UIView+ViewController.h"
#import "TipWriteController.h"
#import "TipClickController.h"
#import "TipSpeakController.h"

@implementation ReadOrWriteView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self initWithUI];
       // [self createUI];
    }
    return self;
}

- (void)initWithUI
{
    //97.6 76.8
    CGFloat imageWidth = 122;
    CGFloat imageHeight = 96;
    
    imageWidth = (ScreenWidth - 10*4)/3.0;
    imageHeight = imageWidth*76.8/97.7;
//
//    NSLog(@"sc:%f",ScreenWidth);
//
 //   CGFloat originX = (ScreenWidth - imageWidth*3-19)/2.0;
    
    NSArray *imageArr = @[@"readImage",@"writeImage",@"hitImage"];
    
    for(NSInteger i = 0;i<3;i++){
        
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(10+(imageWidth+10)*i, 10, imageWidth, imageHeight);
        [rightBtn setImage:[UIImage imageNamed:[imageArr objectAtIndex:i]] forState:UIControlStateNormal];
        //[rightBtn setBackgroundImage:[UIImage imageNamed:[imageArr objectAtIndex:i]] forState:UIControlStateNormal];
        rightBtn.tag=100+i;
        [rightBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightBtn];
    }
}

- (void)createUI
{
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    imageV.layer.cornerRadius = 8.0;
    imageV.layer.masksToBounds = YES;
    //添加渐变色
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = imageV.bounds;
    gradientLayer.colors = [NSArray arrayWithObjects:(id)UIColorFromHex(0x1E82D2).CGColor,(id)UIColorFromHex(0x2B95EB).CGColor,(id)UIColorFromHex(0x05A1EE).CGColor, nil];
    gradientLayer.startPoint = CGPointMake(0.5, 0);
    gradientLayer.endPoint = CGPointMake(0.5, 1);
    gradientLayer.locations = @[@0,@0.5,@1.0];
    [imageV.layer addSublayer:gradientLayer];
    [self addSubview:imageV];
    
    UIButton *readBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    readBtn.frame = CGRectMake((self.width-100)/2.0, 24, 100, 100);
    [readBtn setImage:[UIImage imageNamed:@"readImage"] forState:UIControlStateNormal];
    [readBtn addTarget:self action:@selector(readBtnBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:readBtn];
    
    UIButton *writeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    writeBtn.frame = CGRectMake(readBtn.left-70, readBtn.bottom+12, 100, 100);
    [writeBtn setImage:[UIImage imageNamed:@"writeImage"] forState:UIControlStateNormal];
    [writeBtn addTarget:self action:@selector(writeBtnBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:writeBtn];
    
    UIButton *hitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    hitBtn.frame = CGRectMake(writeBtn.right+40, writeBtn.top, 100, 100);
    [hitBtn setImage:[UIImage imageNamed:@"hitImage"] forState:UIControlStateNormal];
    [hitBtn addTarget:self action:@selector(hitBtnBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:hitBtn];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width/2.0+5, self.height/2.0+12) radius:56 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc]init];
    shapeLayer.path = path.CGPath;
    shapeLayer.lineWidth = 2.0;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = UIColorAlpha(0x9bccf4, 0.47).CGColor;
    
    shapeLayer.strokeStart = 0.19;
    shapeLayer.strokeEnd = 0.34;
    
    [self.layer addSublayer:shapeLayer];
    
    UIBezierPath *path2 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width/2.0+5, self.height/2.0+12) radius:56 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    CAShapeLayer *shapeLayer2 = [[CAShapeLayer alloc]init];
    shapeLayer2.path = path2.CGPath;
    shapeLayer2.lineWidth = 2.0;
    shapeLayer2.fillColor = [UIColor clearColor].CGColor;
    shapeLayer2.strokeColor = UIColorAlpha(0x91dcfc, 0.47).CGColor;
    
    shapeLayer2.strokeStart = 0.85;
    shapeLayer2.strokeEnd = 1.0;
    
    [self.layer addSublayer:shapeLayer2];
    
    UIBezierPath *path3 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width/2.0+5, self.height/2.0+12) radius:56 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    CAShapeLayer *shapeLayer3 = [[CAShapeLayer alloc]init];
    shapeLayer3.path = path3.CGPath;
    shapeLayer3.lineWidth = 2.0;
    shapeLayer3.fillColor = [UIColor clearColor].CGColor;
    shapeLayer3.strokeColor = UIColorAlpha(0x9bccf4, 0.47).CGColor;
    
    shapeLayer3.strokeStart = 0.49;
    shapeLayer3.strokeEnd = 0.624;
    
    [self.layer addSublayer:shapeLayer3];
    
    CALayer *subLayer=[CALayer layer];
    CGRect fixframe = imageV.frame;
    subLayer.frame= fixframe;
    subLayer.cornerRadius=8;
    subLayer.backgroundColor=[UIColorFromHex(0xc5c5c5) colorWithAlphaComponent:1.0].CGColor;
    subLayer.masksToBounds=NO;
    subLayer.shadowColor = UIColorFromHex(0xc5c5c5).CGColor;//shadowColor阴影颜色
    subLayer.shadowOffset = CGSizeMake(2,5);//shadowOffset阴影偏移,x向右偏移3，y向下偏移2，默认(0, -3),这个跟shadowRadius配合使用
    subLayer.shadowOpacity = 0.6;//阴影透明度，默认0
    subLayer.shadowRadius = 8;//阴影半径，默认3
    [self.layer insertSublayer:subLayer below:imageV.layer];
    //[GlobalCommon insertSublayerWithView:self withImageView:imageV];
    
}

- (void)buttonAction:(UIButton *)btn
{
    switch (btn.tag) {
        case 100:
        {
            TipSpeakController *vc = [[TipSpeakController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.viewController.navigationController pushViewController:vc animated:YES];
        }
            break;
           case 101:
        {
            TipWriteController *vc = [[TipWriteController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.viewController.navigationController pushViewController:vc animated:YES];
        }
            break;
            case 102:
        {
            TipClickController *vc = [[TipClickController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.viewController.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

# pragma mark - 写按钮点击
- (void)writeBtnBtnAction:(UIButton *)btn
{
    TipWriteController *vc = [[TipWriteController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}
# pragma mark - 说按钮点击
- (void)readBtnBtnAction:(UIButton *)btn
{
    TipSpeakController *vc = [[TipSpeakController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}
# pragma mark - 点按钮点击
- (void)hitBtnBtnAction:(UIButton *)btn
{
    TipClickController *vc = [[TipClickController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

@end
