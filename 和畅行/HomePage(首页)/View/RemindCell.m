//
//  RemindCell.m
//  和畅行
//
//  Created by 刘晓明 on 2018/7/10.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "RemindCell.h"


@implementation RemindCell

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
    self.backgroundColor = [UIColor clearColor];
    UIImageView *imageV = [[UIImageView alloc] init];
    imageV.layer.cornerRadius = 8.0;
    imageV.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:imageV];
    imageV.layer.shadowColor = RGB(200, 200, 200).CGColor;
    imageV.layer.shadowOffset = CGSizeMake(0,0);
    imageV.layer.shadowOpacity = 0.5;
    imageV.layer.shadowRadius = 5;
    
    self.lineImageV = [[UIImageView alloc] init];
    [imageV  addSubview:self.lineImageV];
    
    
    self.typeLabel = [[UILabel alloc] init];
    self.typeLabel.textAlignment=NSTextAlignmentLeft;
    self.typeLabel.font=[UIFont systemFontOfSize:13.0];
    self.typeLabel.numberOfLines = 0;
    self.typeLabel.textColor=UIColorFromHex(0x8E8E93);
    self.typeLabel.backgroundColor=[UIColor clearColor];
    [imageV  addSubview:self.typeLabel];

    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.textAlignment=NSTextAlignmentLeft;
    self.contentLabel.font=[UIFont systemFontOfSize:13.0];
    self.contentLabel.textColor=UIColorFromHex(0x8E8E93);
    self.contentLabel.backgroundColor=[UIColor clearColor];
    self.contentLabel.numberOfLines = 0;
    [imageV  addSubview:self.contentLabel];
    
    self.circleImageV = [[UIImageView alloc] init];
    self.circleImageV.backgroundColor = [UIColor redColor];
    self.circleImageV.layer.cornerRadius = Adapter(3.0);
    self.circleImageV.layer.masksToBounds = YES;
    [imageV  addSubview:self.circleImageV];
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(Adapter(5));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(Adapter(-5));
        make.leading.equalTo(self.contentView.mas_leading).offset(Adapter(10));
        make.trailing.equalTo(self.contentView.mas_trailing).offset(Adapter(-10));
    }];
    
    [self.lineImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageV.mas_top).offset(Adapter(10));
        make.bottom.equalTo(imageV.mas_bottom).offset(Adapter(-10));
        make.leading.equalTo(imageV.mas_leading);
        make.width.mas_equalTo(Adapter(2));
    }];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageV.mas_top);
        make.bottom.equalTo(imageV.mas_bottom);
        make.leading.equalTo(imageV.mas_leading).offset(Adapter(15));
        make.width.mas_equalTo(Adapter(70));
        make.height.greaterThanOrEqualTo(@(Adapter(49)));
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageV.mas_top);
        make.bottom.equalTo(imageV.mas_bottom);
        make.leading.equalTo(imageV.mas_leading).offset(Adapter(85));
        make.trailing.equalTo(imageV.mas_trailing).offset(Adapter(-30));
        make.height.greaterThanOrEqualTo(@(Adapter(49)));
    }];
    
    [self.circleImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(imageV.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(Adapter(6), Adapter(6)));
        make.trailing.equalTo(imageV.mas_trailing).offset(Adapter(-15));
        
    }];
}


@end
