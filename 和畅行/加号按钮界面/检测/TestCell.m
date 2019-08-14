//
//  TestCell.m
//  和畅行
//
//  Created by 刘晓明 on 2018/8/16.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "TestCell.h"
#import "PressureViewController.h"
#import "BloodGuideViewController.h"
#import "SugerViewController.h"
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
    
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 24, ScreenWidth - 20, 196)];
    backImageView.backgroundColor = [UIColor whiteColor];
    backImageView.layer.cornerRadius = 10;
    backImageView.layer.masksToBounds = YES;
    backImageView.userInteractionEnabled = YES;
    [self insertSublayerWithImageView:backImageView];
    [self addSubview:backImageView];

    self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2 - 20, 11, 40, 40)];
    self.iconImage.image = [UIImage imageNamed:@"血压icon"];
    [self addSubview:self.iconImage];
    
    NSArray *typeStrArray = @[ModuleZW(@"偏低"),ModuleZW(@"正常"),ModuleZW(@"偏高")];
    for (int i = 0; i < 3; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0 + backImageView.width*i/3 , 30 , backImageView.width/3, 30)];
        label.text = @"110mmHg\n";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:19];
        [backImageView addSubview:label];
        
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0 + backImageView.width*i/3 , 60 , backImageView.width/3, 20)];
        label1.text = @"收缩压";
        label1.textAlignment = NSTextAlignmentCenter;
        label1.font = [UIFont systemFontOfSize:14];
        [backImageView addSubview:label1];
        
        
        UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20 +(backImageView.width-40)*i/3,label1.bottom +5, (backImageView.width-40)/3, 20)];
        typeLabel.textAlignment = NSTextAlignmentCenter;
        typeLabel.text = typeStrArray[i];
        typeLabel.font = [UIFont systemFontOfSize:14];
        typeLabel.textColor = UIColorFromHex(0X8e8e93);
        [backImageView addSubview:typeLabel];
        
        if(i == 0){
            
            UIImageView *jiantouImageView = [[UIImageView alloc]initWithFrame:CGRectMake(backImageView.width/2 -10,typeLabel.bottom , 20, 15)];
            jiantouImageView.image = [UIImage imageNamed:@"黄色向下箭头"];
            [backImageView addSubview:jiantouImageView];
            self.arrowImageView = jiantouImageView;
            
            UIImageView *caiImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20,jiantouImageView.bottom , backImageView.width - 40, 5)];
            caiImageView.layer.cornerRadius = 2.5;
            caiImageView.layer.masksToBounds = YES;
            [caiImageView.layer addSublayer:[UIColor setGradualChangingColorHeng:caiImageView fromColor:@"72dbe4" modColor:@"fa9200" toColor:@"D0000B"]];
            [backImageView addSubview:caiImageView];
            
            self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 ,caiImageView.bottom+8, backImageView.width, 20)];
            self.dateLabel.textAlignment=NSTextAlignmentCenter;
            self.dateLabel.font=[UIFont systemFontOfSize:14];
            self.dateLabel.text = @"------";
            self.dateLabel.textColor = UIColorFromHex(0X8E8E93);
            self.dateLabel.backgroundColor=[UIColor clearColor];
            [backImageView addSubview:self.dateLabel];
            
            self.leftLabel = label;
            self.left1Label = label1;
        }else if (i == 1){
            self.middLabel = label;
            self.midd1Label = label1;
        }else{
            self.rightLabel = label;
            self.right1Label = label1;
        }
        if(i< 2){
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            button.frame = CGRectMake((backImageView.width-40)*(2*i+1)/4 - 25 ,backImageView.height - 40, 100, 26);
            button.backgroundColor = RGB_ButtonBlue;
            button.layer.cornerRadius = 13;
            button.layer.masksToBounds = YES;
            [button setTitle:@"血压检测" forState:(UIControlStateNormal)];
            [button.titleLabel setFont:[UIFont systemFontOfSize:14]];

            [[button rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
                
                    if(self.typeInt == 0){
                        if(i == 0) {
                            if (self.leftOneBlock) {
                                self.leftOneBlock();
                            }
                        }else{
                            if(self.righOneBlock){
                                self.righOneBlock();
                            }
                        }
                    }else{
                        if(i == 0) {
                            if (self.leftTwoBlock){
                                self.leftTwoBlock();
                            }
                        }else{
                            if(self.righTwoBlock){
                                self.righTwoBlock();
                            }
                        }
                    }                
             
            }];
            [backImageView addSubview:button];
            
            if(i == 0){
                self.lefttBtn = button;
            }else if(i == 1){
                self.rightBtn = button;
            }
        }
    }
}

-(void)insertSublayerWithImageView:(UIImageView *)imageV
{
    if(!self.subLayer){
        self.subLayer=[CALayer layer];
        CGRect fixframe = imageV.frame;
        self.subLayer.frame= fixframe;
        self.subLayer.cornerRadius=8;
        self.subLayer.backgroundColor=[UIColorFromHex(0xffffff) colorWithAlphaComponent:1.0].CGColor;
        
        self.subLayer.masksToBounds=NO;
        self.subLayer.shadowColor = [UIColor lightGrayColor].CGColor;//shadowColor阴影颜色
        self.subLayer.shadowOffset = CGSizeMake(0,1);//shadowOffset阴影偏移,x向右偏移3，y向下偏移2，默认(0, -3),这个跟shadowRadius配合使用
        self.subLayer.shadowOpacity = 0.4;//阴影透明度，默认0
        self.subLayer.shadowRadius = 4;//阴影半径，默认3
        [self.layer insertSublayer:self.subLayer below:imageV.layer];
    }else{
        self.subLayer.frame = imageV.frame;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
