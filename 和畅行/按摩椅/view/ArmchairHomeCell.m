//
//  ArmchairHomeCell.m
//  和畅行
//
//  Created by 刘晓明 on 2019/9/2.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "ArmchairHomeCell.h"


#define armchairCellW ((ScreenWidth-107*3)/4.0)

@implementation ArmchairHomeCell

@synthesize subLayer;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(armchairCellW/2.0, armchairCellW/2.0, 107, 111)];
    backImageView.backgroundColor = [UIColor whiteColor];
    backImageView.layer.cornerRadius = 10;
    backImageView.layer.masksToBounds = YES;
    backImageView.userInteractionEnabled = YES;
    [self  insertSublayerWithImageView:backImageView];
   
    [self addSubview:backImageView];
    
    //NSLog(@"#####:%@",NSStringFromCGRect(self.frame));
    
    //self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(25, 19, self.frame.size.width-48, self.frame.size.height-19-47)];
    self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-60)/2.0, (self.frame.size.height-49-10-20)/2.0, 60, 49)];
    self.imageV.layer.cornerRadius = 8;
    self.imageV.contentMode = UIViewContentModeScaleAspectFit;
    self.imageV.image = [UIImage imageNamed:@"sports01"];
    [self addSubview:self.imageV];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.imageV.frame)+10, self.frame.size.width-15*2, 20)];
    self.titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:14*[UserShareOnce shareOnce].fontSize];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
    //self.titleLabel.highlightedTextColor = UIColorFromHex(0X1E82D2);
    self.titleLabel.text = @"发卡拉";
    self.titleLabel.numberOfLines = 0;
    [self addSubview:self.titleLabel];
    
   
    
}

-(void)insertSublayerWithImageView:(UIImageView *)imageV
{
    if(!subLayer){
        subLayer=[CALayer layer];
        CGRect fixframe = imageV.frame;
        subLayer.frame= fixframe;
        subLayer.cornerRadius=8;
        subLayer.backgroundColor=[UIColorFromHex(0xffffff) colorWithAlphaComponent:1.0].CGColor;
        
        subLayer.masksToBounds=NO;
        subLayer.shadowColor = [UIColor lightGrayColor].CGColor;//shadowColor阴影颜色
        subLayer.shadowOffset = CGSizeMake(0,1);//shadowOffset阴影偏移,x向右偏移3，y向下偏移2，默认(0, -3),这个跟shadowRadius配合使用
        subLayer.shadowOpacity = 0.4;//阴影透明度，默认0
        subLayer.shadowRadius = 4;//阴影半径，默认3
        [self.layer insertSublayer:subLayer below:imageV.layer];
    }else{
        subLayer.frame = imageV.frame;
    }
    
}

@end
