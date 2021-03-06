//
//  RemindCell.m
//  和畅行
//
//  Created by 刘晓明 on 2018/7/10.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "RemindCell.h"


@implementation RemindCell

@synthesize subLayer;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, ScreenWidth-20, 35+14)];
    imageV.layer.cornerRadius = 8.0;
    imageV.layer.masksToBounds = YES;
    imageV.backgroundColor = [UIColor whiteColor];
    [self addSubview:imageV];
     [self insertSublayerWithImageView:imageV];
    
    self.lineImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, imageV.top+10, 2, 15+14)];
    [self addSubview:self.lineImageV];
    
    self.backgroundColor = [UIColor clearColor];
    
    self.typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 8+14, 80, 16)];
    self.typeLabel.textAlignment=NSTextAlignmentLeft;
    self.typeLabel.font=[UIFont systemFontOfSize:13.0];
    self.typeLabel.textColor=UIColorFromHex(0x8E8E93);
    self.typeLabel.backgroundColor=[UIColor clearColor];
    [self addSubview:self.typeLabel];
    
//    UIImageView *lineImageV = [[UIImageView alloc] initWithFrame:CGRectMake(self.typeLabel.right+10, 44, ScreenWidth-14*2-self.typeLabel.right-10-5, 1)];
//    lineImageV.backgroundColor = UIColorFromHex(0xDADADA);
    
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.typeLabel.right+15, 8+7, 200, 30)];
    self.contentLabel.textAlignment=NSTextAlignmentLeft;
    self.contentLabel.font=[UIFont systemFontOfSize:13.0];
    self.contentLabel.textColor=UIColorFromHex(0x8E8E93);
    self.contentLabel.backgroundColor=[UIColor clearColor];
    [self addSubview:self.contentLabel];
    
    self.circleImageV = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentLabel.right+5, 24+3, 6, 6)];
    self.circleImageV.backgroundColor = [UIColor redColor];
    self.circleImageV.layer.cornerRadius = 3.0;
    self.circleImageV.layer.masksToBounds = YES;
    
    [self addSubview:self.circleImageV];
}

-(void)insertSublayerWithImageView:(UIImageView *)imageV
{
    if(!subLayer){
        subLayer=[CALayer layer];
        CGRect fixframe = imageV.frame;
        subLayer.frame= fixframe;
        subLayer.cornerRadius=8;
        subLayer.backgroundColor=[UIColorFromHex(0xffffff) colorWithAlphaComponent:1.0].CGColor;
        //UIColorFromHex(0xDEDEDDE) [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0] 0XEEEEEE
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
