//
//  ZKIndxView.m
//  hechangyi
//
//  Created by Longma on 16/10/19.
//  Copyright © 2016年 Longma. All rights reserved.
//

#import "ZKIndxView.h"
//#import "TipClickController.h"
//#import "UIView+ViewController.h"

#define proportion ScreenWidth/320.0

@interface ZKIndxView ()
@property (nonatomic,strong) UIButton *dismissBtn;

@property (nonatomic,strong) UIButton *pushButton;
@property (nonatomic,strong) UILabel *pushNameLabel;
@property (nonatomic,strong) NSMutableArray *btnArray;

@end

@implementation ZKIndxView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       _btnArray = [[NSMutableArray alloc]init];
       
        NSArray *imagesData = @[@"erxue",@"yundong",@"yinyue",@"xueya",@"liuyan",@"dianhua",@"aijiu"];
        NSArray *imagesNameData = @[@"耳穴",@"运动",@"音乐",@"血压",@"留言",@"电话",@"艾灸"];
        if([UserShareOnce shareOnce].isOnline){
//            imagesData = @[@"yundong",@"xueya",@"dianhua",@"aijiu"];
//            imagesNameData = @[@"运动",@"血压",@"电话",@"艾灸"];
            imagesData = @[@"yundong",@"xueya",@"dianhua"];
            imagesNameData = @[@"运动",@"血压",@"电话"];
        }
        NSInteger lieshu = imagesData.count/3+imagesData.count%3;
        for(int i=0;i<imagesData.count;i++){
            //row排数;col列数
            int row = i/3;
            int col = i%3;
            CGFloat ICON_W = 50*proportion;
            CGFloat MARGIN = 50*proportion;
            
            CGFloat margin = (ScreenWidth-ICON_W*3)/4.0;
            
            CGFloat topY = ScreenHeight  - lieshu * (ICON_W + MARGIN)-60;
            if(iPhoneX){
                topY = ScreenHeight  - lieshu * (ICON_W + MARGIN)-85;
            }
            
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(margin*(col+1) + col * ICON_W, topY + 25 + row * (ICON_W + MARGIN), ICON_W, ICON_W)];
            if((imagesData.count%3 == 1) && (i==imagesData.count-1)){
                button.frame = CGRectMake(margin*(col+2) + (col+1) * ICON_W, topY + 25 + row * (ICON_W + MARGIN), ICON_W, ICON_W);
            }
            [button setImage:[UIImage imageNamed:imagesData[i]] forState:UIControlStateNormal];
            button.tag = 100+i;
            [button addTarget:self action:@selector(pushButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            
            UILabel *name = [[UILabel alloc]init];
            name.text = imagesNameData[i];
            name.frame = CGRectMake(30 + col * (40+MARGIN), CGRectGetMaxY(button.frame )+ 12, 80, 15);
            name.font =[UIFont systemFontOfSize:15];
            name.textColor = [UIColor whiteColor];
            name.centerX = button.centerX;
            name.textAlignment = NSTextAlignmentCenter;
            
            [self addSubview:button];
            [self addSubview:name];
        }
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"tabBar_publish_icon_selected"] forState:(UIControlStateNormal)];
        button.frame = CGRectMake(ScreenWidth/2-25,ScreenHeight - 50, 50, 50);
        if(iPhoneX){
            button.top = ScreenHeight - 50 - 34;
        }
        [button addTarget:self action:@selector(dismissClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
        
        [self addSubview:button];
        //[self showBtn];
    }
    return self;
}

/**
 *  推出界面
 */

- (void)pushButtonClick:(UIButton *)btn{
  
    NSLog(@"a");
    
    if ([self.delegate respondsToSelector:@selector(indexClickWitbNumber:)]) {
        [self.delegate indexClickWitbNumber:btn.tag];
    }
    
}

/*  消失方法
*/
- (void)dismissClick:(UIButton *)btn{
    //[self hiddenBtn];
    NSLog(@"消失");
    
    if ([self.delegate respondsToSelector:@selector(indexDissmiss)]) {
        [self.delegate indexDissmiss];
    }
    
}

- (void)delayMethod{
    if ([self.delegate respondsToSelector:@selector(indexDissmiss)]) {
            [self.delegate indexDissmiss];
        }

}

-(void)showBtn{
    for (int  i = 0; i<_btnArray.count; i++) {
        UIButton *btn=_btnArray[i];
        //        btn.transform=CGAffineTransformIdentity;
        
        CGPoint startPoint = CGPointMake(ScreenWidth/2-20,ScreenHeight - 60);
        //        CGPoint startPoint = CGPointFromString([NSString stringWithFormat:@"%@",[_homeBtn.layer valueForKeyPath:@"position"]]);
        NSInteger buttonSize = floor((ScreenWidth) / [_btnArray count]) -1;

        NSInteger buttonX = (i * buttonSize) +i;
        CGPoint endPoint =CGPointMake(buttonX +10 + 50, CGRectGetMaxY(self.frame)-200);
        //position animation
        CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        positionAnimation.duration=.3;
        positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        positionAnimation.fromValue = [NSValue valueWithCGPoint:startPoint];
        positionAnimation.toValue = [NSValue valueWithCGPoint:endPoint];
        positionAnimation.beginTime = CACurrentMediaTime() + (0.3/(float)_btnArray.count * (float)i);
        positionAnimation.fillMode = kCAFillModeForwards;
        positionAnimation.removedOnCompletion = NO;
        
        [btn.layer addAnimation:positionAnimation forKey:@"positionAnimation"];
        
        btn.layer.position=endPoint;
        
        //scale animation
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.duration=.3;
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        scaleAnimation.fromValue = @(0);
        scaleAnimation.toValue = @(1);
        scaleAnimation.beginTime = CACurrentMediaTime() + (0.3/(float)_btnArray.count * (float)i);
        scaleAnimation.fillMode = kCAFillModeForwards;
        scaleAnimation.removedOnCompletion = NO;
        
        [btn.layer addAnimation:scaleAnimation forKey:@"transformscale"];
        btn.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    }
}

-(void)hiddenBtn{
    int index = 0;
    for (int  i = (int)_btnArray.count-1; i>=0; i--) {
        UIButton *btn=_btnArray[i];
        //        btn.transform=CGAffineTransformIdentity;
        //CGPoint startPoint = CGPointMake(49, 419);
        CGPoint startPoint = CGPointFromString([NSString stringWithFormat:@"%@",[btn.layer valueForKeyPath:@"position"]]);
        CGPoint endPoint =CGPointMake(ScreenWidth/2-20,ScreenHeight - 60);
        //position animation
        CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        positionAnimation.duration=.3;
        positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        positionAnimation.fromValue = [NSValue valueWithCGPoint:startPoint];
        positionAnimation.toValue = [NSValue valueWithCGPoint:endPoint];
        positionAnimation.beginTime = CACurrentMediaTime() + (.3/(float)_btnArray.count * (float)index);
        positionAnimation.fillMode = kCAFillModeForwards;
        positionAnimation.removedOnCompletion = NO;
        
        [btn.layer addAnimation:positionAnimation forKey:@"positionAnimation"];
        //btn.layer.position=startPoint;
        
        //scale animation
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.duration=.3;
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        scaleAnimation.fromValue = @(1);
        scaleAnimation.toValue = @(0);
        scaleAnimation.beginTime = CACurrentMediaTime() + (0.3/(float)_btnArray.count * (float)index);
        scaleAnimation.fillMode = kCAFillModeForwards;
        scaleAnimation.removedOnCompletion = NO;
        
        [btn.layer addAnimation:scaleAnimation forKey:@"transformscale"];
        btn.transform = CGAffineTransformMakeScale(1.f, 1.f);
        index++;
    }
}

@end
