//
//  SongListCell.m
//  Voicediagno
//
//  Created by 刘晓明 on 2018/4/24.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "SongListCell.h"
#import "ProgressIndicator.h"
@implementation SongListCell

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
    self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7.5, 30, 30)];
    self.iconImage.image = [UIImage imageNamed:@"YY_GongIcon"];
    self.iconImage.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.iconImage];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-160)/2.0, 10, 160, 25)];
    self.titleLabel.textAlignment=NSTextAlignmentLeft;
    self.titleLabel.font=[UIFont systemFontOfSize:16.0];
    self.titleLabel.textColor = UIColorFromHex(0x8e3a3a);
    self.titleLabel.backgroundColor=[UIColor clearColor];
    
    self.downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.downloadBtn.frame = CGRectMake(ScreenWidth-40, 8, 29, 30);
    [self.downloadBtn setImage:[UIImage imageNamed:@"New_yy_zt_xz"] forState:UIControlStateNormal];
    self.downloadBtn.userInteractionEnabled = NO;
    //[self.downloadBtn setImage:[UIImage imageNamed:@"New_yy_zt_bf"] forState:UIControlStateSelected];
    //[self.downloadBtn addTarget:self action:@selector(downloadAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *lineImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 45-1, ScreenWidth, 1)];
    lineImageV.backgroundColor = UIColorFromHex(0xDADADA);
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.downloadBtn];
    [self addSubview:lineImageV];
}

- (void)downloadSuccess
{
    [self.downloadBtn setImage:[UIImage imageNamed:@"New_yy_zt_zt"] forState:UIControlStateNormal];
    
    [self.downloadBtn.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[ProgressIndicator class]]){
            [obj removeFromSuperview];
        }
    }];
    self.PlayOrdownload = YES;
}

- (void)downloadFail
{
    [self.downloadBtn setImage:[UIImage imageNamed:@"New_yy_zt_xz"] forState:UIControlStateNormal];
    self.PlayOrdownload = NO;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
//    if(selected){
//        self.titleLabel.textColor = UIColorFromHex(0X4FAEFE);
//    }else{
//        self.titleLabel.textColor = UIColorFromHex(0xB0B0B0);
//    }
    
}

- (void)setDownLoadButton:(BOOL)isHidden
{
    if(isHidden){
        self.downloadBtn.hidden = YES;
        //self.selectionStyle = UITableViewCellSelectionStyleGray;
    }else{
        self.downloadBtn.hidden = NO;
        //self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
}


- (void)setTitleColor:(UIColor *)color
{
    self.titleLabel.textColor = color;
}

- (void)layoutSubviews
{
    self.downloadBtn.frame = CGRectMake(self.width-40, (self.height-30)/2.0, 30, 30);
}

- (void)setIconImageWith:(NSString *)str
{
    self.iconImage.image = [UIImage imageNamed:str];
}

- (void)downloadAction:(UIButton *)btn
{
    if([self.delegate respondsToSelector:@selector(downLoadButton:withDownload:)]){
        [self.delegate downLoadButton:btn withDownload:self.PlayOrdownload];
    }
}

//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
//{
//    
//    return YES;
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
//    if(self.PlayOrdownload){
//        if(selected){
//            [self.downloadBtn setImage:[UIImage imageNamed:@"New_yy_zt_bf"] forState:UIControlStateNormal];
//        }else{
//             [self.downloadBtn setImage:[UIImage imageNamed:@"New_yy_zt_zt"] forState:UIControlStateNormal];
//        }
//    }
    
}

@end
