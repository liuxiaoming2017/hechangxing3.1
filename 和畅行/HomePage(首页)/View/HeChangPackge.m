//
//  HeChangPackge.m
//  和畅行
//
//  Created by 刘晓明 on 2018/7/9.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "HeChangPackge.h"
#import "HeChangPackgeController.h"
#import "HCY_ActivityController.h"

@interface HeChangPackge()

@property (nonatomic,strong) UILabel *stateLabel;
@property (nonatomic,strong) CAShapeLayer *shapeLayer;


@end

@implementation HeChangPackge
@synthesize shapeLayer,stateLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self createupUI];
    }
    return self;
}

- (void)createupUI
{
    
    self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.width *274/414)];
    
    self.imageV.userInteractionEnabled = YES;
    [self addSubview:self.imageV];
    
    //下方阴影效果
    CALayer *subLayer=[CALayer layer];
    CGRect fixframe = self.imageV.frame;
    subLayer.frame= fixframe;
    subLayer.cornerRadius=11;
    subLayer.backgroundColor=[UIColorFromHex(0xffffff) colorWithAlphaComponent:1.0].CGColor;
    subLayer.masksToBounds=NO;
    subLayer.shadowColor = UIColorFromHex(0x258ce0).CGColor;//shadowColor阴影颜色
    subLayer.shadowOffset = CGSizeMake(2,5);//shadowOffset阴影偏移,x向右偏移3，y向下偏移2，默认(0, -3),这个跟shadowRadius配合使用
    subLayer.shadowOpacity = 0.6;//阴影透明度，默认0
    subLayer.shadowRadius = 11;//阴影半径，默认3
//    [self.layer insertSublayer:subLayer below:self.imageV.layer];
    
    //CGFloat originX = (ScreenWidth - 122*3-18)/2.0;
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(Adapter(20), self.height/2.0-Adapter(50), ScreenWidth - Adapter(40), Adapter(30))];
    self.titleLabel.font = [UIFont systemFontOfSize:21];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.text = ModuleZW(@"和畅包");
    [self addSubview:self.titleLabel];
    
    
    self.remindLabel = [[UILabel alloc] initWithFrame:CGRectMake(Adapter(70), self.titleLabel.bottom, ScreenWidth - Adapter(140) , Adapter(80))];
    self.remindLabel.font = [UIFont systemFontOfSize:16];
    self.remindLabel.numberOfLines = 0;
    self.remindLabel.textAlignment = NSTextAlignmentCenter;
    self.remindLabel.textColor = [UIColor whiteColor];
    NSString *str = ModuleZW(@"您未完成和畅体检,全部完成体检后定制属于您的和畅服务包");
    self.remindLabel.text = str;
    [self addSubview:self.remindLabel];
    //CGSize strSize = [str boundingRectWithSize:CGSizeMake(self.remindLabel.width, 1200) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont fontWithName:[[UIFont systemFontOfSize:1] fontName] size:15]} context:nil].size;
    //self.remindLabel.frame = CGRectMake(self.remindLabel.left, imgV.top+(imgV.height-strSize.height)/2.0, self.remindLabel.width, strSize.height);
    
//    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake((ScreenWidth-272)/2.0, self.imageV.bottom-20, 272, 40)];
//    bottomView.backgroundColor = [UIColor whiteColor];
//    bottomView.layer.cornerRadius = bottomView.height/2.0;
//    bottomView.clipsToBounds = YES;
//    [self addSubview:bottomView];
    
    
    self.toViewButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.toViewButton addTarget:self action:@selector(pushAction) forControlEvents:(UIControlEventTouchUpInside)];
    self.toViewButton.frame = CGRectMake(ScreenWidth/2.0 - Adapter(136), self.imageV.bottom - Adapter(25), Adapter(272), Adapter(60));
   // [self addSubview:self.toViewButton];

    
    UIButton *tapButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    tapButton.frame = CGRectMake(Adapter(10),self.titleLabel.top, self.width-Adapter(20), Adapter(110));
    [tapButton addTarget:self action:@selector(tapAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:tapButton];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
//    [bottomView addGestureRecognizer:tap];
    
    /*
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    imageV.layer.cornerRadius = 8.0;
    imageV.layer.masksToBounds = YES;
    imageV.backgroundColor = [UIColor whiteColor];
    [self addSubview:imageV];
    [GlobalCommon insertSublayerWithView:self withImageView:imageV];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 15, 120, 30)];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = @"和畅包";
    [self addSubview:titleLabel];
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 50+5, 80, 80)];
    imgV.tag = 101;
    imgV.image = [UIImage imageNamed:@"packge"];
    [self addSubview:imgV];
    
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-200)/2.0, 5, 200, 40)];
    self.contentLabel.font = [UIFont systemFontOfSize:18];
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    self.contentLabel.textColor = UIColorFromHex(0X1E82D2);
    self.contentLabel.text = @"和畅服务";
    
    self.remindLabel = [[UILabel alloc] initWithFrame:CGRectMake(imgV.right+15, imgV.top+10, self.width-imgV.right-30, 60)];
    self.remindLabel.font = [UIFont systemFontOfSize:15];
    self.remindLabel.numberOfLines = 0;
    self.remindLabel.textAlignment = NSTextAlignmentLeft;
    self.remindLabel.textColor = UIColorFromHex(0X8E8E93);
    NSString *str = @"您未完成和畅体检,全部完成体检后定制属于您的和畅服务包";
    self.remindLabel.text = str;
    [self addSubview:self.remindLabel];
    CGSize strSize = [str boundingRectWithSize:CGSizeMake(self.remindLabel.width, 1200) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont fontWithName:[[UIFont systemFontOfSize:1] fontName] size:15]} context:nil].size;
    self.remindLabel.frame = CGRectMake(self.remindLabel.left, imgV.top+(imgV.height-strSize.height)/2.0, self.remindLabel.width, strSize.height);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
     */
}


-(void)changeBackImageWithStr:(NSString *)str {
    
    if (str==nil || [str isKindOfClass:[NSNull class]]||str.length == 0) {
        //添加渐变色
//        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//        gradientLayer.frame = self.imageV.bounds;
//        gradientLayer.colors = [NSArray arrayWithObjects:(id)UIColorFromHex(0x1E82D2).CGColor,(id)UIColorFromHex(0x2B95EB).CGColor,(id)UIColorFromHex(0x05A1EE).CGColor, nil];
//        gradientLayer.startPoint = CGPointMake(0.5, 0);
//        gradientLayer.endPoint = CGPointMake(0.5, 1);
//        gradientLayer.locations = @[@0,@0.5,@1.0];
//        [self.imageV.layer addSublayer:gradientLayer];
        
        [self.imageV setImage:[UIImage imageNamed:@"bg_blue"]];
        
    }else {
        
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@",URL_PRE,str];
        NSURL *url = [NSURL URLWithString:imageUrl];
        [self.imageV sd_setImageWithURL:url];
    }
    
}

- (void)changePackgeTypeWithStatus:(NSInteger)status withXingStr:(NSString *)xingStr
{
    if(status >=0 && status <= 11){
        
    }else{
        [MemberUserShance shareOnce].isOpenPackge = NO;
//        [self updateImageView];
        return;
    }
    NSString *bingTaiStr = @"";
    [MemberUserShance shareOnce].isOpenPackge = YES;
    switch (status) {
        case 0:
            bingTaiStr = ModuleZW(@"未病态");
            break;
        case 1:
            bingTaiStr = ModuleZW(@"欲病态");
            break;
        case 2:
            bingTaiStr = ModuleZW(@"欲病态");
            break;
        case 3:
           bingTaiStr = ModuleZW(@"中重度已病态");
            break;
        case 4:
            bingTaiStr = ModuleZW(@"重度已病态");
            break;
        case 5:
            bingTaiStr = ModuleZW(@"轻度已病态");
            break;
        case 6:
            bingTaiStr = ModuleZW(@"中度已病态");
            break;
        case 7:
            bingTaiStr = ModuleZW(@"中重度已病态");
            break;
        case 8:
            bingTaiStr = ModuleZW(@"重度已病态");
            break;
        case 9:
            bingTaiStr = ModuleZW(@"中度已病态");
            break;
        case 10:
            bingTaiStr = ModuleZW(@"中重度已病态");
            break;
        case 11:
            bingTaiStr = ModuleZW(@"重度已病态");
            break;
        default:
            break;
    }
     [self showYiBingTianWithStr:bingTaiStr withStr:xingStr];
}

- (void)updateImageView
{
    
//    NSString *str = ModuleZW(@"您未完成和畅体检,全部完成体检后定制属于您的和畅服务包");
//    self.remindLabel.text = str;
//    [self.toViewButton setBackgroundImage:[UIImage imageNamed:ModuleZW(@"和畅包未检测")] forState:(UIControlStateNormal)];
    
    self.hidden = YES;

}


- (void)createShapeLayerWithColor:(UIColor *)shapeColor
{
   
    
    if(!shapeLayer){
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(56, 86+10) radius:40 startAngle:M_PI-M_PI_4 endAngle:M_PI*2+M_PI/4 clockwise:YES];
        shapeLayer = [[CAShapeLayer alloc]init];
        shapeLayer.path = path.CGPath;
        shapeLayer.lineWidth = 6.0;
        shapeLayer.lineCap = @"round";
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        //shapeLayer.strokeColor = UIColorAlpha(0x61D179, 1.0).CGColor;
        shapeLayer.strokeColor = shapeColor.CGColor;
        
        shapeLayer.strokeStart = 0;
        shapeLayer.strokeEnd = 1.0;
        
        [self.layer addSublayer:shapeLayer];
    }else{
        shapeLayer.strokeColor = shapeColor.CGColor;
    }
}

- (void)joinStringWithstr1:(NSString *)colorStr1 WithStr2:(NSString *)colorStr2 withColor:(UIColor *)titleColor
{
    NSString *str = [NSString stringWithFormat:@"您当前处在%@的%@状态",colorStr1,colorStr2];
//    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
//    [attributeStr addAttribute:NSForegroundColorAttributeName value:titleColor range:NSMakeRange(5, 2)];
//    [attributeStr addAttribute:NSForegroundColorAttributeName value:titleColor range:NSMakeRange(8, 2)];
//    self.remindLabel.attributedText = attributeStr;
    
    self.remindLabel.text = str;
    
//    UIImageView *imgV = [self viewWithTag:101];
//    imgV.hidden = YES;
    
//    if(!stateLabel){
//        stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(56-20, 96-20, 40, 40)];
//        stateLabel.font = [UIFont systemFontOfSize:18];
//        stateLabel.textAlignment = NSTextAlignmentCenter;
//        stateLabel.textColor = titleColor;
//        stateLabel.text = colorStr1;
//        [self addSubview:stateLabel];
//    }else{
//        stateLabel.hidden = NO;
//        stateLabel.textColor = titleColor;
//        stateLabel.text = colorStr1;
//    }
    
    
}

- (void)showWeiBingTianWithStr:(NSString *)str2
{
    NSString *str = [NSString stringWithFormat:@"您当前处在%@",str2];
    self.remindLabel.text = str;
}

- (void)showYiBingTianWithStr:(NSString *)str1 withStr:(NSString *)str2
{
    NSString *stateStr = [NSString stringWithFormat:@"您当前属于%@",str1];
    NSString *str = [NSString stringWithFormat:@"%@%@，%@",ModuleZW(stateStr),str2,ModuleZW(@"点击查看我们为您定制的和畅服务包")];
    self.remindLabel.text = str;
    [self.toViewButton setBackgroundImage:[UIImage imageNamed:ModuleZW(@"和畅包p")] forState:(UIControlStateNormal)];

}

- (void)tapAction
{
    if(![MemberUserShance shareOnce].isOpenPackge){
        return;
    }
    HeChangPackgeController *vc = [[HeChangPackgeController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:vc animated:YES];
    vc.titleStr = ModuleZW(@"和畅包");
    //[MemberUserShance shareOnce].idNum
    NSString *urlStr = [NSString stringWithFormat:@"%@member/service/home/1/%@.jhtml?isnew=1",URL_PRE,[MemberUserShance shareOnce].idNum];
    vc.progressType = progress2;
    vc.urlStr = urlStr;
    
}

-(void)pushAction {
    
    NSLog(@"pushModel.link:%@",_pushModel.link);
    if(_pushModel.link==nil||[_pushModel.link isKindOfClass:[NSNull class]]||_pushModel.link.length == 0){
        
        [self tapAction];
        
        
    }else {
        HCY_ActivityController *vc = [[HCY_ActivityController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.viewController.navigationController pushViewController:vc animated:YES];
        vc.titleStr = _pushModel.title;
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",URL_PRE,_pushModel.link];
        vc.progressType = progress2;
        vc.urlStr = urlStr;
    }
    
   
}

@end
