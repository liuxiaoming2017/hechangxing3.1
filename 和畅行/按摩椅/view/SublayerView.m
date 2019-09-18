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
    
    self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(25, 19, self.frame.size.width-48, self.frame.size.height-19-47)];
    self.imageV.layer.cornerRadius = 8;
    self.imageV.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.imageV];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.imageV.frame)+10, self.frame.size.width-15*2, 20)];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = UIColorFromHex(0x7D7D7D);
    self.titleLabel.highlightedTextColor = [UIColor redColor];
    self.titleLabel.text = @"发卡拉";
    self.titleLabel.numberOfLines = 0;
    [self addSubview:self.titleLabel];
    
    
}

- (void)setImageVandTitleLabelwithModel:(ArmChairModel *)model
{
    self.model = model;
    self.imageV.image = [UIImage imageNamed:model.name];
     NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:model.name attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size:14],NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]}];
    self.titleLabel.attributedText = string;
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
