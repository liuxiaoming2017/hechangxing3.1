//
//  IjoouCollectionCell.m
//  HarmonyYi
//
//  Created by Wei Zhao on 2019/12/11.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "IjoouCollectionCell.h"

@implementation IjoouCollectionCell
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
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    backImageView.backgroundColor = [UIColor whiteColor];
    backImageView.layer.cornerRadius = Adapter(10);
    //backImageView.layer.masksToBounds = YES;
    backImageView.userInteractionEnabled = YES;
    [self  insertSublayerWithImageView:backImageView];
    
    [self addSubview:backImageView];
    
    self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(self.width/6, self.width/6, self.width/3*2, self.width/3*2)];
    self.imageV.image = [UIImage imageNamed:@"ijoou背景"];
    [self addSubview:self.imageV];
    
    self.titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0,0 ,self.imageV.width, self.imageV.height)];
    self.titleLabel1.font = [UIFont systemFontOfSize:25];
    self.titleLabel1.textAlignment = NSTextAlignmentCenter;
    self.titleLabel1.textColor = RGB_ButtonBlue;
    self.titleLabel1.text = @"A122222";
    self.titleLabel1.numberOfLines = 0;
    [self.imageV addSubview:self.titleLabel1];
    
    CGFloat cellWithW;
    if (ISPaid) {
        cellWithW = Adapter(15);
    }else{
        cellWithW = Adapter(20);
    }
    self.selectedBT = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.selectedBT.frame = CGRectMake(self.width/4*3, self.width/4*3, self.width/4, self.width/4);
    [self.selectedBT setImage:[[UIImage imageNamed:@"ijoou未选中"]transformWidth:cellWithW height:cellWithW] forState:(UIControlStateNormal)];
    [self.selectedBT setImage:[[UIImage imageNamed:@"ijoou未选中"]transformWidth:cellWithW height:cellWithW] forState:(UIControlStateHighlighted)];
    [self.selectedBT addTarget:self action:@selector(selectedAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.selectedBT];
    
    self.voltameterView = [[QQBatteryView alloc]initWithFrame:CGRectMake(self.width/6*5 - Adapter(10), Adapter(10), self.width/6, self.width/12)];
    [self addSubview:self.voltameterView];
    
    NSArray *titleArray = @[@"30min",@"43℃"];
    for (int i = 0; i<2; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(backImageView.width/2*i, self.imageV.bottom, backImageView.width/2, backImageView.width/6)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = titleArray[i];
        label.hidden = YES;
        [self addSubview:label];
        if (i==0) {
            self.timeLabel = label;
        }else{
            self.temperatureLabel = label;
        }
    }
}

-(void)selectedAction:(UIButton *)button {
    if (self.selectedBlock) {
        self.selectedBlock();
    }
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
