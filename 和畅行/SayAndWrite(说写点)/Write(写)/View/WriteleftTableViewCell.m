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
        _backView = [[UIView alloc]initWithFrame:CGRectMake(15, 5, self.width -20, self.height -10)];
        [self insertSublayerWithView:_backView];
        [self addSubview:_backView];
        _typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, _backView.width - 20, _backView.height - 20)];
        _typeLabel.textColor = RGB_TextGray;
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        _typeLabel.layer.cornerRadius = _typeLabel.height/2;
        _typeLabel.numberOfLines = 2;
        _typeLabel.layer.masksToBounds = YES;
        _typeLabel.font = [UIFont systemFontOfSize:14];

    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)insertSublayerWithView:(UIView *)view
{
    if(!_subLayer){
        _subLayer=[CALayer layer];
        CGRect fixframe = view.frame;
        _subLayer.frame= fixframe;
        _subLayer.cornerRadius=8;
        _subLayer.backgroundColor=[UIColorFromHex(0xffffff) colorWithAlphaComponent:1.0].CGColor;
        
        _subLayer.masksToBounds=NO;
        _subLayer.shadowColor = [UIColor lightGrayColor].CGColor;//shadowColor阴影颜色
        _subLayer.shadowOffset = CGSizeMake(0,1);//shadowOffset阴影偏移,x向右偏移3，y向下偏移2，默认(0, -3),这个跟shadowRadius配合使用
        _subLayer.shadowOpacity = 0.4;//阴影透明度，默认0
        _subLayer.shadowRadius = 4;//阴影半径，默认3
        [self.layer insertSublayer:_subLayer below:view.layer];
    }else{
        _subLayer.frame = view.frame;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
