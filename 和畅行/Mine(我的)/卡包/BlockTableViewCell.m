//
//  BlockTableViewCell.m
//  Voicediagno
//
//  Created by 李传铎 on 15/9/8.
//  Copyright (c) 2015年 李传铎. All rights reserved.
//

#import "BlockTableViewCell.h"

@implementation BlockTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
      
        [self customView];
       
        
    }
    return self;
}


-(void)customView {
    
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5,ScreenWidth - 40, 130)];
    //添加渐变色
    [imageV.layer addSublayer:[UIColor setGradualChangingColor:imageV fromColor:@"4294E1" toColor:@"D1BDFF"]];
    imageV.layer.cornerRadius = 10;
    imageV.layer.masksToBounds = YES;
    [self addSubview:imageV];
    
    
    _hLabel = [[UILabel alloc] init];
    _hLabel.frame = CGRectMake(10, 10, 150, 30);
    _hLabel.textColor = [UIColor whiteColor];
    _hLabel.text = @"视频问诊半年卡";
    _hLabel.font = [UIFont systemFontOfSize:21];
    [imageV addSubview:_hLabel];
    
    _mLabel = [[UILabel alloc] init];
    _mLabel.frame = CGRectMake(10,_hLabel.bottom , imageV.width - 20, 60 );
    _mLabel.numberOfLines = 2;
    _mLabel.text = @"阿道夫沙发沙发沙发上发送到发的是飞洒发士大夫撒按时发生";
    _mLabel.font = [UIFont systemFontOfSize:14];
    _mLabel.textColor = [UIColor whiteColor];
    [imageV addSubview:_mLabel];
    
    
    _imageV = [[UIImageView alloc]init];
    _imageV.frame  =CGRectMake(imageV.width - 60,  5, 50, 45);
    _imageV.image = [UIImage imageNamed:@"未激活.png"];
    [imageV addSubview:_imageV];
   
    _yLabel = [[UILabel alloc] init];
    _yLabel.frame = CGRectMake(10, _mLabel.bottom , 160, 20);
    _yLabel.text = @"2019-11-11到期";
    _yLabel.font = [UIFont systemFontOfSize:12];
    _yLabel.textColor = [UIColor whiteColor];
    [imageV addSubview:_yLabel];
      
    
}




- (void)layoutSubviews{
    [super layoutSubviews];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
