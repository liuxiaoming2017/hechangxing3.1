//
//  MyAdvisoryTableViewCell.m
//  Voicediagno
//
//  Created by 李传铎 on 15/9/21.
//  Copyright (c) 2015年 李传铎. All rights reserved.
//

#import "MyAdvisoryTableViewCell.h"

@implementation MyAdvisoryTableViewCell
- (void)dealloc{
    
   
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, ScreenWidth - 30, 130)];
        backView.layer.cornerRadius = 10;
        backView.layer.masksToBounds = YES;
        backView.userInteractionEnabled = YES;
        backView.backgroundColor = [UIColor whiteColor];
        [self insertSublayerWithImageView:backView];
        [self addSubview:backView];
        
        
        _answerLabel = [[UILabel alloc]init];
        _answerLabel.font = [UIFont systemFontOfSize:16];
        _answerLabel.textAlignment = NSTextAlignmentRight;
        _answerLabel.textColor = RGB_TextAppOrange;
        [backView addSubview:_answerLabel];
        
        _contentlabel = [[UILabel alloc]init];
        _contentlabel.textColor = [UIColor blackColor];
        _contentlabel.font = [UIFont systemFontOfSize:16];
        _contentlabel.numberOfLines = 0;
        [backView addSubview:_contentlabel];
       
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = RGB_TextGray;
        _timeLabel.font = [UIFont systemFontOfSize:16];
        [backView addSubview:_timeLabel];
        
        
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    _contentlabel.frame = CGRectMake(10, 10, ScreenWidth - 60, 90);
    _answerLabel.frame = CGRectMake(ScreenWidth - 150, 100, 100, 30);
    _timeLabel.frame = CGRectMake(20, 100, 200, 30);
    
}
-(void)insertSublayerWithImageView:(UIImageView *)imageV
{
    if(!_subLayer){
        _subLayer=[CALayer layer];
        CGRect fixframe = imageV.frame;
        _subLayer.frame= fixframe;
        _subLayer.cornerRadius=8;
        _subLayer.backgroundColor=[UIColorFromHex(0xffffff) colorWithAlphaComponent:1.0].CGColor;
        
        _subLayer.masksToBounds=NO;
        _subLayer.shadowColor = [UIColor lightGrayColor].CGColor;//shadowColor阴影颜色
        _subLayer.shadowOffset = CGSizeMake(0,1);//shadowOffset阴影偏移,x向右偏移3，y向下偏移2，默认(0, -3),这个跟shadowRadius配合使用
        _subLayer.shadowOpacity = 0.4;//阴影透明度，默认0
        _subLayer.shadowRadius = 4;//阴影半径，默认3
        [self.layer insertSublayer:_subLayer below:imageV.layer];
    }else{
        _subLayer.frame = imageV.frame;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
