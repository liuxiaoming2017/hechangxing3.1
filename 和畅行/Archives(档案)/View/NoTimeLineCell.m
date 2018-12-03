//
//  NoTimeLineCell.m
//  和畅行
//
//  Created by 刘晓明 on 2018/11/23.
//  Copyright © 2018 刘晓明. All rights reserved.
//

#import "NoTimeLineCell.h"

#define imagevRight 60

@implementation NoTimeLineCell

@synthesize subLayer;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    
   
    UIImageView *lineImageV = [[UIImageView alloc] initWithFrame:CGRectMake(25, 0, 1, 10)];
    //UIImageView *lineImageV = [[UIImageView alloc] initWithFrame:CGRectZero];
    lineImageV.backgroundColor = UIColorFromHex(0xe2e2e2);
    
    [self addSubview:lineImageV];
    
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(imagevRight, lineImageV.bottom-5, ScreenWidth-imagevRight-10, 49)];
    //UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageV.layer.cornerRadius = 8.0;
    imageV.layer.masksToBounds = YES;
//    [imageV.layer setBorderWidth:1.0];
//    [imageV.layer setBorderColor:UIColorFromHex(0XEEEEEE).CGColor];
    imageV.backgroundColor = [UIColor whiteColor];
    [self addSubview:imageV];
    [self insertSublayerWithImageView:imageV];
    
    UIImageView *circleImageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, imageV.top+imageV.height/2.0-10, 20, 20)];
    //UIImageView *circleImageV = [[UIImageView alloc] initWithFrame:CGRectZero];
    circleImageV.layer.cornerRadius = circleImageV.width/2.0;
    circleImageV.layer.masksToBounds = YES;
    circleImageV.backgroundColor = UIColorFromHex(0xe2e2e2);
    [self addSubview:circleImageV];
    
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageV.left+15, imageV.top, 200, imageV.height)];
    //self.contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.contentLabel.textAlignment=NSTextAlignmentLeft;
    self.contentLabel.font=[UIFont systemFontOfSize:13.0];
    self.contentLabel.textColor=UIColorFromHex(0x8E8E93);
    self.contentLabel.backgroundColor=[UIColor clearColor];
    self.contentLabel.text = @"您的经络状态已有七天未测评";
    [self addSubview:self.contentLabel];
    
    UIImageView *lineImageV2 = [[UIImageView alloc] initWithFrame:CGRectMake(lineImageV.left, imageV.bottom-5+5, 1, 10)];
    lineImageV2.backgroundColor = UIColorFromHex(0xe2e2e2);
    [self addSubview:lineImageV2];
    
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
