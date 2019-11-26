//
//  InsidelayerView.m
//  和畅行
//
//  Created by 刘晓明 on 2019/9/11.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "InsidelayerView.h"

@interface InsidelayerView ()

@property (nonatomic,strong) CALayer *subLayer;


@end


@implementation InsidelayerView
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
    
}

-(void)insertSublayerFromeView:(UIView *)view
{
    if(!subLayer){
        subLayer=[CALayer layer];
        CGRect fixframe = self.frame;
        subLayer.frame= fixframe;
        subLayer.cornerRadius=Adapter(8);
        subLayer.backgroundColor=[UIColorFromHex(0xffffff) colorWithAlphaComponent:1.0].CGColor;
        
        subLayer.masksToBounds=NO;
        subLayer.shadowColor = [UIColor lightGrayColor].CGColor;//shadowColor阴影颜色
        subLayer.shadowOffset = CGSizeMake(0,Adapter(1));//shadowOffset阴影偏移,x向右偏移3，y向下偏移2，默认(0, -3),这个跟shadowRadius配合使用
        subLayer.shadowOpacity = 0.4;//阴影透明度，默认0
        subLayer.shadowRadius = Adapter(4);//阴影半径，默认3
        [view.layer insertSublayer:subLayer below:self.layer];
    }else{
        subLayer.frame = self.frame;
    }
    
}

@end
