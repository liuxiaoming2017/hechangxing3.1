//
//  QuestionTableCell.m
//  和畅行
//
//  Created by 刘晓明 on 2019/4/29.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "QuestionTableCell.h"

@implementation QuestionTableCell
@synthesize rightView,leftView;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self initUI];
    
}

- (void)initUI
{
    leftView.layer.cornerRadius = 5.0;
    leftView.layer.masksToBounds = YES;
    //[leftView.layer addSublayer:[self addGradientLayerWithColor1:UIColorFromHex(0x52c8a1) withColor2:UIColorFromHex(0x0ba151) withFrame:leftView.bounds]];
    
    [leftView.layer insertSublayer:[self addGradientLayerWithColor1:UIColorFromHex(0x52c8a1) withColor2:UIColorFromHex(0x0ba151) withFrame:leftView.bounds] atIndex:0];
    
    rightView.layer.cornerRadius = 8.0;
    rightView.layer.masksToBounds = YES;
    //rightView.backgroundColor = [UIColor orangeColor];
    //[rightView.layer addSublayer:[self addGradientLayerWithColor1:UIColorFromHex(0x81dddd) withColor2:UIColorFromHex(0x5d97f2) withFrame:rightView.bounds]];
    [rightView.layer insertSublayer:[self addGradientLayerWithColor1:UIColorFromHex(0x81dddd) withColor2:UIColorFromHex(0x5d97f2) withFrame:rightView.bounds] atIndex:0];
    rightView.hidden = YES;
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
       // [self setupUI];
    }
    return self;
}

/*
- (void)setupUI
{
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(5, 10, 30, 30)];
    [self addSubview:leftView];
    
    leftView.layer.cornerRadius = 5.0;
    leftView.layer.masksToBounds = YES;
    [leftView.layer addSublayer:[self addGradientLayerWithColor1:UIColorFromHex(0x52c8a1) withColor2:UIColorFromHex(0x0ba151) withFrame:leftView.bounds]];
    
    
    self.indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
    self.indexLabel.font = [UIFont systemFontOfSize:16];
    self.indexLabel.textAlignment = NSTextAlignmentCenter;
    self.indexLabel.textColor = [UIColor whiteColor];
    self.indexLabel.text = @"1";
    [leftView addSubview:self.indexLabel];
    
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(leftView.right, 0, ScreenWidth-leftView.right-69-10+20+10, 80)];
    imageV.image = [UIImage imageNamed:@"content_back"];
    imageV.tag = 2019;
    imageV.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:imageV];
   
    
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageV.left+26, 15, ScreenWidth-leftView.right-69-10-16, 50)];
    self.contentLabel.font = [UIFont systemFontOfSize:16];
    self.contentLabel.textAlignment = NSTextAlignmentLeft;
    self.contentLabel.textColor = UIColorFromHex(0x80808c);
    self.contentLabel.text = @"总是";
    self.contentLabel.numberOfLines = 0;
    [self addSubview:self.contentLabel];
    
    
    rightView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth-59, 5, 49, 49)];
   
    [self addSubview:rightView];
    rightView.layer.cornerRadius = 8.0;
    rightView.layer.masksToBounds = YES;
    
   
    [rightView.layer addSublayer:[self addGradientLayerWithColor1:UIColorFromHex(0x81dddd) withColor2:UIColorFromHex(0x5d97f2) withFrame:rightView.bounds]];
    rightView.hidden = YES;
    
    self.answerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 49, 49)];
    self.answerLabel.font = [UIFont systemFontOfSize:16];
    self.answerLabel.textAlignment = NSTextAlignmentCenter;
    self.answerLabel.textColor = [UIColor whiteColor];
    self.answerLabel.text = @"总是";
    [rightView addSubview:self.answerLabel];

   
}
*/


- (void)setanswerLabelContent:(NSString *)str
{
    rightView.hidden = NO;
    self.answerLabel.text = str;
}

- (CAGradientLayer *)addGradientLayerWithColor1:(UIColor *)color1 withColor2:(UIColor *)color2 withFrame:(CGRect)frame
{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame =frame;
    gradientLayer.colors = [NSArray arrayWithObjects:(id)color1.CGColor,(id)color2.CGColor, nil];
    gradientLayer.startPoint = CGPointMake(0.5, 0);
    gradientLayer.endPoint = CGPointMake(0.5, 1);
    gradientLayer.locations = @[@0.1,@0.5];
    return gradientLayer;
}

//-(void)layoutSubviews
//{
//  //  NSLog(@"height:%f",self.height);
//    UIImageView *imageV = (UIImageView *)[self viewWithTag:2019];
//    imageV.height = self.height;
//    
//    self.contentLabel.height = imageV.height-30;
//
//}

- (CGFloat)setCellHeight:(NSString *)str
{
    CGSize strSize = [self.contentLabel.text boundingRectWithSize:CGSizeMake(self.contentLabel.width, 1200) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
    CGFloat hh = MAX(60+20, strSize.height+18+20);
    
    return hh;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
