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
        [self layOutCellView];
    }
    return self;
}
-(void)layOutCellView{
    
    _typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(Adapter(10), Adapter(5),Adapter(70), self.height - Adapter(10))];
    _typeLabel.textColor = RGB_TextGray;
    _typeLabel.textAlignment = NSTextAlignmentCenter;
    _typeLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _typeLabel.numberOfLines = 0;
    _typeLabel.font = [UIFont systemFontOfSize:14];
    _numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(Adapter(75), 0, Adapter(14), Adapter(14))];
    _numberLabel.backgroundColor = RGB_TextAppOrange;
    _numberLabel.layer.cornerRadius = _numberLabel.height/2;
    _numberLabel.layer.masksToBounds = YES;
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    _numberLabel.hidden = YES;
    _numberLabel.font =  [UIFont systemFontOfSize:13];
    _numberLabel.textColor = [UIColor whiteColor];
    _numberLabel.text = @"5";
    [self.contentView  addSubview:_numberLabel];
    [self.contentView  addSubview:_typeLabel];
    self.backgroundColor = [UIColor clearColor];
    
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(Adapter(5));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(Adapter(-5));
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.height.greaterThanOrEqualTo(@(Adapter(40)));
    }];
    
    
    
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
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

  _typeLabel.textColor  = selected ? RGB_TextOrange : RGB_TextGray;
}

@end
