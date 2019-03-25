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
    
    self.typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 100, 30)];
    self.typeLabel.textAlignment=NSTextAlignmentLeft;
    self.typeLabel.font=[UIFont systemFontOfSize:13.0];
    self.typeLabel.textColor=[UIColor whiteColor];
    self.typeLabel.backgroundColor=[UIColor clearColor];
    [self addSubview:self.typeLabel];

    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(cellWidth/2.0-40, 0, 80, 30)];
    self.contentLabel.textAlignment=NSTextAlignmentCenter;
    self.contentLabel.font=[UIFont systemFontOfSize:13.0];
    self.contentLabel.textColor=[UIColor whiteColor];
    self.contentLabel.backgroundColor=[UIColor clearColor];
    [self addSubview:self.contentLabel];
    
    self.tradeBtn = [HCY_UnderlineButton buttonWithType:(UIButtonTypeCustom)];
    self.tradeBtn.frame =CGRectMake(cellWidth-90, 0, 85, 30);
    self.tradeBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    self.tradeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.tradeBtn addTarget:self action:@selector(consultingAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.tradeBtn setColor:[UIColor whiteColor]];
    [self addSubview:self.tradeBtn];
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
