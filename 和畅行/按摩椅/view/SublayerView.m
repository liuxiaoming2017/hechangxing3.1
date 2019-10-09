//
//  SublayerView.m
//  和畅行
//
//  Created by 刘晓明 on 2019/9/9.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "SublayerView.h"

@interface SublayerView ()

@property (nonatomic,strong) CALayer *subLayer;

@property (nonatomic,strong) UIImageView *imageV;
@property (nonatomic,strong) UILabel *titleLabel;


@end

@implementation SublayerView
@synthesize subLayer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    self.userInteractionEnabled = YES;
    
    //self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(25, 19, self.frame.size.width-48, self.frame.size.height-19-47)];
    
    self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-60)/2.0, (self.frame.size.height-49-10-20)/2.0, 60, 49)];
    //NSLog(@"frame:%@",NSStringFromCGRect(self.imageV.frame));
    
    self.imageV.layer.cornerRadius = 8;
    self.imageV.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.imageV];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, CGRectGetMaxY(self.imageV.frame)+10, self.frame.size.width-2*2, 20)];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    //self.titleLabel.highlightedTextColor = [UIColor redColor];
    self.titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:14*[UserShareOnce shareOnce].fontSize > 16.0 ? 16.0 : 14*[UserShareOnce shareOnce].fontSize];
    self.titleLabel.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
    self.titleLabel.text = @"发卡拉";
    self.titleLabel.numberOfLines = 0;
    [self addSubview:self.titleLabel];
    
    
}

- (void)setImageVandTitleLabelwithModel:(ArmChairModel *)model
{
    self.model = model;
    self.imageV.image = [UIImage imageNamed:model.name];
    if([model.name isEqualToString:@"肩颈4D"]){
        self.imageV.image = [UIImage imageNamed:@"肩颈"];
    }
    self.titleLabel.text = model.name;
}

- (void)setImageAndTitleWithModel:(ArmChairModel *)model withName:(NSString *)name
{
    self.model = model;
    NSString *jlbsName = [[NSUserDefaults standardUserDefaults] objectForKey:@"Physical"];
    if([jlbsName isEqualToString:@""] || jlbsName==nil){
        self.titleLabel.text = @"";
        self.imageV.image = [UIImage imageNamed:@"推荐_默认"];
        self.imageV.frame = CGRectMake((self.frame.size.width-70)/2.0, (self.frame.size.height-70)/2.0, 70, 70);
        self.titleLabel.frame = CGRectMake(2, CGRectGetMaxY(self.imageV.frame)+10, self.frame.size.width-2*2, 20);
    }else{
        self.titleLabel.text = [NSString stringWithFormat:@"%@推拿手法",jlbsName];
        jlbsName = [jlbsName substringFromIndex:[jlbsName length]-1];
        self.imageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@icon",jlbsName]];
        self.imageV.frame = CGRectMake((self.frame.size.width-55)/2.0, (self.frame.size.height-55-10-20)/2.0, 55, 55);
        self.titleLabel.frame = CGRectMake(2, CGRectGetMaxY(self.imageV.frame)+10, self.frame.size.width-2*2, 20);
    }
    
}


-(void)insertSublayerFromeView:(UIView *)view
{
    if(!subLayer){
        subLayer=[CALayer layer];
        CGRect fixframe = self.frame;
        subLayer.frame= fixframe;
        subLayer.cornerRadius=8;
        subLayer.backgroundColor=[UIColorFromHex(0xffffff) colorWithAlphaComponent:1.0].CGColor;
        
        subLayer.masksToBounds=NO;
        subLayer.shadowColor = [UIColor lightGrayColor].CGColor;//shadowColor阴影颜色
        subLayer.shadowOffset = CGSizeMake(0,1);//shadowOffset阴影偏移,x向右偏移3，y向下偏移2，默认(0, -3),这个跟shadowRadius配合使用
        subLayer.shadowOpacity = 0.4;//阴影透明度，默认0
        subLayer.shadowRadius = 4;//阴影半径，默认3
        [view.layer insertSublayer:subLayer below:self.layer];
    }else{
        subLayer.frame = self.frame;
    }
    
}



@end
