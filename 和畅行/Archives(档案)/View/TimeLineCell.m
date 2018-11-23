//
//  TimeLineCell.m
//  和畅行
//
//  Created by 刘晓明 on 2018/11/7.
//  Copyright © 2018 刘晓明. All rights reserved.
//

#import "TimeLineCell.h"

@implementation TimeLineCell

@synthesize subLayer;

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
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 50, 20)];
    //self.timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.timeLabel.textAlignment=NSTextAlignmentLeft;
    self.timeLabel.font=[UIFont systemFontOfSize:15.0];
    self.timeLabel.textColor=UIColorFromHex(0x8E8E93);
    self.timeLabel.backgroundColor=[UIColor clearColor];
    self.timeLabel.text = @"11-23";
    [self addSubview:self.timeLabel];
    
    UIImageView *lineImageV = [[UIImageView alloc] initWithFrame:CGRectMake(25, self.timeLabel.bottom+5, 1, 20)];
    //UIImageView *lineImageV = [[UIImageView alloc] initWithFrame:CGRectZero];
    lineImageV.backgroundColor = UIColorFromHex(0xe2e2e2);
    [self addSubview:lineImageV];
    
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(self.timeLabel.right, lineImageV.bottom-5, ScreenWidth-self.timeLabel.right-10, 49)];
    //UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageV.layer.cornerRadius = 8.0;
    imageV.layer.masksToBounds = YES;
    [imageV.layer setBorderWidth:1.0];
    [imageV.layer setBorderColor:UIColorFromHex(0XEEEEEE).CGColor];
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
    
    UIImageView *lineImageV2 = [[UIImageView alloc] initWithFrame:CGRectMake(lineImageV.left, 105-10, 1, 10)];
    lineImageV2.backgroundColor = UIColorFromHex(0xe2e2e2);
    [self addSubview:lineImageV2];
    
}

- (void)configCellWithModel1
{
    self.timeLabel.frame = CGRectMake(10, 0, 80, 20);
    
    
}

- (void)configCellWithModel2
{
    
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
        subLayer.shadowColor = UIColorFromHex(0xDEDEDDE).CGColor;//shadowColor阴影颜色
        subLayer.shadowOffset = CGSizeMake(2,2);//shadowOffset阴影偏移,x向右偏移3，y向下偏移2，默认(0, -3),这个跟shadowRadius配合使用
        subLayer.shadowOpacity = 0.6;//阴影透明度，默认0
        subLayer.shadowRadius = 3;//阴影半径，默认3
        [self.layer insertSublayer:subLayer below:imageV.layer];
    }else{
        subLayer.frame = imageV.frame;
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
