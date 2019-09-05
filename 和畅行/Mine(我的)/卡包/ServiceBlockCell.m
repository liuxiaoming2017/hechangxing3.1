//
//  ServiceBlockCell.m
//  和畅行
//
//  Created by 刘晓明 on 2018/12/20.
//  Copyright © 2018 刘晓明. All rights reserved.
//

#import "ServiceBlockCell.h"

@implementation ServiceBlockCell

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
    NSLog(@"width:%f",self.width);
    
    CGFloat cellWidth = ScreenWidth - 20 -20*2-10;
    
    self.typeLabel = [[UILabel alloc] init];
    self.typeLabel.textAlignment=NSTextAlignmentLeft;
    self.typeLabel.numberOfLines = 0;
    self.typeLabel.font=[UIFont systemFontOfSize:13.0];
    self.typeLabel.textColor=[UIColor whiteColor];
    self.typeLabel.backgroundColor=[UIColor clearColor];
    [self.contentView addSubview:self.typeLabel];

    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.textAlignment=NSTextAlignmentCenter;
    self.contentLabel.font=[UIFont systemFontOfSize:13.0];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.textColor=[UIColor whiteColor];
    self.contentLabel.backgroundColor=[UIColor clearColor];
    [self.contentView addSubview:self.contentLabel];
    
    self.tradeBtn = [HCY_UnderlineButton buttonWithType:(UIButtonTypeCustom)];
    self.tradeBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.tradeBtn.titleLabel setNumberOfLines:0];
    self.tradeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.tradeBtn addTarget:self action:@selector(consultingAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.tradeBtn setColor:[UIColor whiteColor]];
    [self.contentView addSubview:self.tradeBtn];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(2);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-2);
        make.leading.equalTo(self.contentView.mas_leading).offset(5);
        make.width.mas_equalTo((self.contentView.width- 60)/2);
        make.height.greaterThanOrEqualTo(@(30));
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(2);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-2);
        make.left.equalTo(self.typeLabel.mas_right);
        make.width.mas_equalTo(60);
        make.height.greaterThanOrEqualTo(@(30));
    }];
    
    [self.tradeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(2);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-2);
        make.trailing.equalTo(self.contentView.mas_trailing).offset(-5);
        make.width.mas_equalTo((self.contentView.width- 60)/2);
        make.height.greaterThanOrEqualTo(@(30));
    }];
}

- (void)consultingAction:(UIButton *)btn
{
    if([self.delegate respondsToSelector:@selector(selectTradeButton:)]){
        [self.delegate selectTradeButton:btn.titleLabel.text];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
