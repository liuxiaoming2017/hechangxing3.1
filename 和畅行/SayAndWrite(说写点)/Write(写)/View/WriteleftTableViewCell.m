//
//  WriteleftTableViewCell.m
//  和畅行
//
//  Created by 出神入化 on 2019/4/26.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "WriteleftTableViewCell.h"

@implementation WriteleftTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        _typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5,70, self.height - 10)];
        _typeLabel.textColor = RGB_TextGray;
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        _typeLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _typeLabel.numberOfLines = 0;
        _typeLabel.font = [UIFont systemFontOfSize:14];
        _numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 5, 14, 14)];
        _numberLabel.backgroundColor = RGB_TextAppOrange;
        _numberLabel.layer.cornerRadius = 7;
        _numberLabel.layer.masksToBounds = YES;
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.hidden = YES;
        _numberLabel.font =  [UIFont systemFontOfSize:13];
        _numberLabel.textColor = [UIColor whiteColor];
        _numberLabel.text = @"5";
        [self addSubview:_numberLabel];
        [self addSubview:_typeLabel];
        self.backgroundColor = [UIColor clearColor];
        
    
    }
    return self;
}


-(void)customViewrRowAtIndexPath:(NSIndexPath *)indexPath withArray:(NSArray *)dataArray {
    
    if(indexPath.row == 0){
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_backView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5,5)];
        //创建 layer
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _backView.bounds;
        //赋值
        maskLayer.path = maskPath.CGPath;
        _backView.layer.mask = maskLayer;
    }else if(indexPath.row == dataArray.count - 1){
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_backView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5,5)];
        //创建 layer
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _backView.bounds;
        //赋值
        maskLayer.path = maskPath.CGPath;
        _backView.layer.mask = maskLayer;
    }else{
    }
    
//     [self insertSublayerWithView:_backView AtIndexPath:indexPath];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)insertSublayerWithView:(UIView *)view AtIndexPath:(NSIndexPath *)indexPath
{
    if(!_subLayer){
        _subLayer=[CALayer layer];
        CGRect fixframe = view.frame;
        _subLayer.frame= fixframe;
        _subLayer.backgroundColor=[UIColorFromHex(0xffffff) colorWithAlphaComponent:1.0].CGColor;
        _subLayer.shadowOffset = CGSizeMake(0.0f,0.0f);
        _subLayer.shadowOpacity = 0.7f;
        _subLayer.masksToBounds=NO;
        _subLayer.shadowColor = [UIColor lightGrayColor].CGColor;//shadowColor阴影颜色
        CGRect shadowRect = CGRectInset(view.bounds, 0, 4);  // inset top/bottom
        _subLayer.shadowPath = [[UIBezierPath bezierPathWithRect:shadowRect] CGPath];
        [self.layer insertSublayer:_subLayer below:view.layer];
    }else{
        _subLayer.frame = view.frame;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

  _typeLabel.textColor  = selected ? RGB_TextOrange : RGB_TextGray;
}

@end
