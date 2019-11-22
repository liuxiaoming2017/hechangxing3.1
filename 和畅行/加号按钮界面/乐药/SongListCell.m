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
@synthesize subLayer;
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
    
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(Adapter(10), Adapter(5), ScreenWidth - Adapter(20), Adapter(80))];
    backImageView.backgroundColor = [UIColor whiteColor];
    backImageView.layer.cornerRadius = Adapter(10);
    backImageView.layer.masksToBounds = YES;
    backImageView.userInteractionEnabled = YES;
    [self  insertSublayerWithImageView:backImageView];
    [self addSubview:backImageView];
    
    self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(Adapter(10), Adapter(15), Adapter(50), Adapter(50))];
    self.iconImage.image = [UIImage imageNamed:@"宫icon"];
    [backImageView addSubview:self.iconImage];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(Adapter(80) ,Adapter(15), backImageView.width  - Adapter(150) , Adapter(50))];
    self.titleLabel.textAlignment=NSTextAlignmentLeft;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font=[UIFont systemFontOfSize:16.0];
    self.titleLabel.textColor = RGB_TextAppGray;
    self.titleLabel.backgroundColor=[UIColor clearColor];
    
    self.downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.downloadBtn.frame = CGRectMake(backImageView.width - Adapter(60), Adapter(25), Adapter(30), Adapter(30));
    [self.downloadBtn  setBackgroundImage:[UIImage imageNamed:@"乐药下载icon"] forState:UIControlStateNormal];
    self.downloadBtn.userInteractionEnabled = NO;
    
    
    [backImageView addSubview:self.titleLabel];
    [backImageView addSubview:self.downloadBtn];
}

- (void)downloadSuccess
{
    self.downloadBtn.frame = CGRectMake(ScreenWidth - Adapter(80), Adapter(25), Adapter(30), Adapter(30));
    self.downloadBtn.backgroundColor = [UIColor clearColor];
    [self.downloadBtn setTitle:@"" forState:(UIControlStateNormal)];
    [self.downloadBtn setBackgroundImage:[UIImage imageNamed:@"乐药播放icon"] forState:UIControlStateNormal];
    
    [self.downloadBtn.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[ProgressIndicator class]]){
            [obj removeFromSuperview];
        }
    }];
    self.PlayOrdownload = YES;
}

- (void)downloadFailWithImageStr:(NSString *)nameStr
{

    if([nameStr isEqualToString:@"乐药未购买icon"] || [nameStr isEqualToString:@"已加入购物车"]){
        self.downloadBtn.frame = CGRectMake(ScreenWidth - Adapter(110) , Adapter(30), Adapter(80), Adapter(20));
        self.downloadBtn.backgroundColor = RGB(253, 134, 40);
        
        if([nameStr isEqualToString:@"已加入购物车"]){
            self.downloadBtn.backgroundColor = RGB_TextAppGray;
            
        }
        self.downloadBtn.layer.cornerRadius = 10;
        self.downloadBtn.layer.masksToBounds = YES;
        [self.downloadBtn setTitle:ModuleZW(@"加入购物车") forState:(UIControlStateNormal)];
        [self.downloadBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        self.PlayOrdownload = NO;
    }else{
        self.downloadBtn.frame = CGRectMake(ScreenWidth - Adapter(80), Adapter(25), Adapter(30), Adapter(30));
         self.downloadBtn.backgroundColor = [UIColor clearColor];
        
         [self.downloadBtn setTitle:@"" forState:(UIControlStateNormal)];
        self.PlayOrdownload = YES;
        
    }
    [self.downloadBtn setBackgroundImage:[UIImage imageNamed:nameStr] forState:UIControlStateNormal];
//    [self.downloadBtn setImage:[UIImage imageNamed:nameStr] forState:UIControlStateNormal];
    
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];

    
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

-(void)insertSublayerWithImageView:(UIImageView *)imageV
{
    if(!subLayer){
        subLayer=[CALayer layer];
        CGRect fixframe = imageV.frame;
        subLayer.frame= fixframe;
        subLayer.cornerRadius=8;
        subLayer.backgroundColor=[UIColorFromHex(0xffffff) colorWithAlphaComponent:1.0].CGColor;
        
        subLayer.masksToBounds=NO;
        subLayer.shadowColor = [UIColor lightGrayColor].CGColor;//shadowColor阴影颜色
        subLayer.shadowOffset = CGSizeMake(0,1);//shadowOffset阴影偏移,x向右偏移3，y向下偏移2，默认(0, -3),这个跟shadowRadius配合使用
        subLayer.shadowOpacity = 0.4;//阴影透明度，默认0
        subLayer.shadowRadius = 4;//阴影半径，默认3
        [self.layer insertSublayer:subLayer below:imageV.layer];
    }else{
        subLayer.frame = imageV.frame;
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];    
}

@end
