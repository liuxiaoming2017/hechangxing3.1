//
//  MineCell.m
//  和畅行
//
//  Created by 刘晓明 on 2018/8/2.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "MineCell.h"

@implementation MineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
    self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 7.5, 35, 35)];
    //self.iconImage.image = [UIImage imageNamed:@"YY_GongIcon"];
    self.iconImage.contentMode = UIViewContentModeScaleAspectFit;
//    [self addSubview:self.iconImage];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, 10, 250, 30)];
    self.titleLabel.textAlignment=NSTextAlignmentLeft;
    self.titleLabel.font=[UIFont systemFontOfSize:14.0];
    self.titleLabel.textColor = UIColorFromHex(0x8e8e93);
    self.titleLabel.backgroundColor=[UIColor clearColor];
    
//    self.arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-30, 22-5, 10, 16)];
//    self.arrowImage.image = [UIImage imageNamed:@"1我的_09"];
    
//    self.lineImageV = [[UIImageView alloc] initWithFrame:CGRectMake(self.titleLabel.left, 49-1, self.arrowImage.right-self.titleLabel.left, 1)];
//    self.lineImageV.backgroundColor = UIColorFromHex(0xDADADA);
    
    [self addSubview:self.titleLabel];
//    [self addSubview:self.arrowImage];
//    [self addSubview:self.lineImageV];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
