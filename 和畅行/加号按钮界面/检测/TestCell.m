//
//  TestCell.m
//  和畅行
//
//  Created by 刘晓明 on 2018/8/16.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "TestCell.h"

@implementation TestCell

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
    self.iconImage.image = [UIImage imageNamed:@"YY_GongIcon"];
    self.iconImage.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.iconImage];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconImage.right+22, 5, 160, 20)];
    self.titleLabel.textAlignment=NSTextAlignmentLeft;
    self.titleLabel.font=[UIFont systemFontOfSize:13.0];
    self.titleLabel.textColor = UIColorFromHex(0x333333);
    self.titleLabel.backgroundColor=[UIColor clearColor];
    
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.left, self.titleLabel.bottom+3, 160, 20)];
    self.dateLabel.textAlignment=NSTextAlignmentLeft;
    self.dateLabel.font=[UIFont systemFontOfSize:13.0];
    self.dateLabel.textColor = UIColorFromHex(0X8E8E93);
    self.dateLabel.backgroundColor=[UIColor clearColor];
    
    self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2.0-20, 10, 200, 30)];
    self.descriptionLabel.textAlignment=NSTextAlignmentLeft;
    self.descriptionLabel.font=[UIFont systemFontOfSize:15.0];
    self.descriptionLabel.textColor = UIColorFromHex(0x333333);
    self.descriptionLabel.backgroundColor=[UIColor clearColor];
    
    self.testBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.testBtn.frame = CGRectMake(ScreenWidth-85, 12, 70, 26);
    self.testBtn.backgroundColor = UIColorFromHex(0x1e82d2);
    [self.testBtn setTitle:@"检测" forState:UIControlStateNormal];
    [self.testBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.testBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.testBtn.layer.cornerRadius = 10;
    self.testBtn.clipsToBounds = YES;
    self.testBtn.userInteractionEnabled = NO;
    
    UIImageView *lineImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 49-1, ScreenWidth, 1)];
    lineImageV.backgroundColor = UIColorFromHex(0xDADADA);
    
    
    [self addSubview:self.iconImage];
    [self addSubview:self.titleLabel];
    [self addSubview:self.dateLabel];
    [self addSubview:self.descriptionLabel];
    [self addSubview:self.testBtn];
    [self addSubview:lineImageV];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
