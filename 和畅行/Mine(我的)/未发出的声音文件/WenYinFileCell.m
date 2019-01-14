//
//  WenYinFileCell.m
//  和畅行
//
//  Created by 刘晓明 on 2018/12/26.
//  Copyright © 2018 刘晓明. All rights reserved.
//

#import "WenYinFileCell.h"


@implementation WenYinFileCell

@synthesize lbname,lbDate,CellAcessImgView,CellDeleImgView;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    
    CGFloat cellHeight = 47;
   // CGFloat cellWidth = ScreenWidth;
    
    UIImage* CellIcon=nil;
    CellIcon=[UIImage imageNamed:@"YY_GongIcon.png"];
    UIImageView * CellIconView=[[UIImageView alloc] init];
    CellIconView.frame=CGRectMake(20, (cellHeight-CellIcon.size.height/2)/2, CellIcon.size.width/2, CellIcon.size.height/2);
    CellIconView.image=CellIcon;
    [self addSubview:CellIconView];
    
    
    lbname=[[UILabel alloc] init];
    lbname.frame=CGRectMake(CellIconView.frame.origin.x+CellIconView.frame.size.width+8, (self.frame.size.height-23)/2, 54, 23);
    lbname.backgroundColor=[UIColor clearColor];
    lbname.textColor=[UtilityFunc colorWithHexString:@"#666666"];
    lbname.font=[UIFont systemFontOfSize:12];
    lbname.text=@"经络";
    [self addSubview:lbname];
    
    lbDate=[[UILabel alloc] init];
    lbDate.frame=CGRectMake(lbname.frame.origin.x+lbname.frame.size.width+22, (cellHeight-23)/2, 140, 23);
    lbDate.backgroundColor=[UIColor clearColor];
    lbDate.textColor=[UtilityFunc colorWithHexString:@"#666666"];
    lbDate.font=[UIFont systemFontOfSize:10];
    //lbDate.text=[NSString stringWithFormat:@"时间:%@年%@月%@日",string2,string3,string4];
    [self addSubview:lbDate];
    
    
    
    UIImage* CellAccessImg=[UIImage imageNamed:@"My_upIcon.png"];
    CellAcessImgView=[UIButton buttonWithType:UIButtonTypeCustom];
    //CellAcessImgView.tag=indexPath.row+10000;
    CellAcessImgView.frame=CGRectMake(lbDate.frame.origin.x+lbDate.frame.size.width+20.5, (cellHeight-CellAccessImg.size.width/2)/2, CellAccessImg.size.width/2, CellAccessImg.size.height/2);
    [CellAcessImgView addTarget:self action:@selector(AcessActive:) forControlEvents:UIControlEventTouchUpInside];
    [CellAcessImgView setImage:CellAccessImg forState:UIControlStateNormal];
    [self addSubview:CellAcessImgView];
    
    UIImage* CellDeleImg=[UIImage imageNamed:@"My_DeleIcon.png"];
    CellDeleImgView=[UIButton buttonWithType:UIButtonTypeCustom];
    //CellDeleImgView.tag=indexPath.row+10000;
    CellDeleImgView.frame=CGRectMake(CellAcessImgView.frame.origin.x+CellAcessImgView.frame.size.width+15, (cellHeight-CellAccessImg.size.width/2)/2, CellDeleImg.size.width/2, CellDeleImg.size.height/2);
    [CellDeleImgView addTarget:self action:@selector(DeleActive:) forControlEvents:UIControlEventTouchUpInside];
    [CellDeleImgView setImage:CellDeleImg forState:UIControlStateNormal];
    [self addSubview:CellDeleImgView];
     
}

- (void)showCellViewWithString1:(NSString *)string1 withString2:(NSString *)string2 string3:(NSString *)string3
{
    lbDate.text=[NSString stringWithFormat:@"时间:%@年%@月%@日",string1,string2,string3];
}

-(void)AcessActive:(UIButton *)sender
{
    if([self.delegate respondsToSelector:@selector(upLoadButton:)]){
        [self.delegate upLoadButton:sender];
    }
}

-(void)DeleActive:(UIButton *)sender
{
    if([self.delegate respondsToSelector:@selector(deleteButton:)]){
        [self.delegate deleteButton:sender];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
