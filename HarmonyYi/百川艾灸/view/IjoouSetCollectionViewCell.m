//
//  IjoouSetCollectionViewCell.m
//  HarmonyYi
//
//  Created by Wei Zhao on 2019/12/13.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "IjoouSetCollectionViewCell.h"

@implementation IjoouSetCollectionViewCell
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
    self.isChooes = NO;
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    backImageView.backgroundColor = [UIColor whiteColor];
    backImageView.layer.cornerRadius = Adapter(10);
    backImageView.userInteractionEnabled = YES;
    [self  insertSublayerWithImageView:backImageView];
    
    [self addSubview:backImageView];
    
    self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(self.width/6,Adapter(10) , self.width/3*2, self.width/3*2)];
    self.imageV.image = [UIImage imageNamed:@"ijoou未选中背景"];
    [self addSubview:self.imageV];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0 ,self.imageV.width, self.imageV.height)];
    self.titleLabel.font = [UIFont systemFontOfSize:25/[UserShareOnce shareOnce].multipleFontSize];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = RGB_ButtonBlue;
    self.titleLabel.text = @"A1";
    self.titleLabel.numberOfLines = 0;
    [self.imageV addSubview:self.titleLabel];
    CGFloat cellWithW;
    if (ISPaid) {
        cellWithW = Adapter(15);
    }else{
        cellWithW = Adapter(20);
    }
    
    self.selectImageView = [[UIImageView alloc]initWithFrame:CGRectMake(backImageView.width/4*3,backImageView.width/4 - cellWithW, cellWithW, cellWithW)];
    self.selectImageView.image = [UIImage imageNamed:@"ijoou设置选中"];
    self.selectImageView.hidden = YES;
    [backImageView addSubview:self.selectImageView];
    
  
    NSArray *titleArray = @[@"30min",@"43℃"];
    for (int i = 0; i<2; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((backImageView.width/2+ Adapter(5))*i, self.imageV.bottom, backImageView.width/2- Adapter(5), backImageView.width/3-Adapter(10))];
        label.font = [UIFont systemFontOfSize:13/[UserShareOnce shareOnce].multipleFontSize];
        label.text = titleArray[i];
        [self addSubview:label];
        if (i==0) {
            self.timeLabel = label;
            label.textAlignment = NSTextAlignmentRight;
        }else{
            self.temperatureLabel = label;
        }
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
