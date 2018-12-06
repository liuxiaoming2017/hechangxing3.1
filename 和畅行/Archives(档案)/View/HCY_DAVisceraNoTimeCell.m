//
//  HCY_DAVisceraNoTimeCell.m
//  和畅行
//
//  Created by Wei Zhao on 2018/12/6.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "HCY_DAVisceraNoTimeCell.h"


@implementation HCY_DAVisceraNoTimeCell
@synthesize subLayer;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    
    UIImageView *lineImageV = [[UIImageView alloc] initWithFrame:CGRectMake(30, self.timeLabel.bottom+5, 1, 25)];
    lineImageV.backgroundColor = UIColorFromHex(0xe2e2e2);
    [self addSubview:lineImageV];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(self.timeLabel.right - 20, lineImageV.bottom-15, ScreenWidth-self.timeLabel.right + 10, 79)];
    imageV.layer.cornerRadius = 8.0;
    imageV.layer.masksToBounds = YES;
    imageV.backgroundColor = [UIColor whiteColor];
    [self addSubview:imageV];
    [self insertSublayerWithImageView:imageV];
    
    self.createDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,  imageV.top+imageV.height/2.0-20, 60, 20)];
    self.createDateLabel.font=[UIFont systemFontOfSize:13.0];
    self.createDateLabel.textAlignment = NSTextAlignmentCenter;
    self.createDateLabel.textColor=UIColorFromHex(0x8E8E93);
    self.createDateLabel.text = @"08:08";
    [self addSubview:self.createDateLabel];
    
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:@"症状选择:\nICD-10:"];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:8];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [@"症状选择:\nICD-10:" length])];
    
    
    
    self.typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageV.left+15, imageV.top, 80, imageV.height)];
    self.typeLabel.attributedText = attributedString1;
    self.typeLabel.numberOfLines = 2;
    self.typeLabel.textColor = RGB(55, 55, 55);
    self.typeLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.typeLabel];
    
    
    self.topLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.typeLabel.right, imageV.top + 13, ScreenWidth - self.typeLabel.right - 20, imageV.height/2 - 13)];
    self.topLabel.font=[UIFont systemFontOfSize:15];
    self.topLabel.textColor=RGB(221, 156, 92);
    self.topLabel.text = @"新病有汗";
    [self addSubview:self.topLabel];
    
    self.lowLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.typeLabel.right, self.topLabel.bottom  , ScreenWidth - self.typeLabel.right - 20, imageV.height/2-13)];
    self.lowLabel.font=[UIFont systemFontOfSize:15];
    self.lowLabel.textColor=RGB(221, 156, 92);
    self.lowLabel.text = @"无";
    [self addSubview:self.lowLabel];
    
    
    
    
    UIImageView *lineImageV2 = [[UIImageView alloc] initWithFrame:CGRectMake(lineImageV.left, 105-15, 1, 30)];
    lineImageV2.backgroundColor = UIColorFromHex(0xe2e2e2);
    [self addSubview:lineImageV2];
    
}

- (void)configCellWithModel1
{
    self.timeLabel.frame = CGRectMake(10, 0, 80, 20);
    
    
}

- (void)configCellWithModel2
{
    
}


//为cell 赋值
- (void)assignmentVisceraWithModel:(HealthTipsModel *)model{
    
    NSString *timestr = model.createTime;
    timestr = [timestr stringByReplacingOccurrencesOfString:@"-" withString:@"月"];
    timestr = [timestr stringByAppendingString:@"日"];
    NSRange range = NSMakeRange(timestr.length - 6, 1);
    NSString *subString3 = [timestr substringWithRange:range];
    if ([subString3 isEqualToString: @"0"]) {
        self.timeLabel.text = [timestr substringFromIndex:timestr.length - 5];
        
    }else {
        self.timeLabel.text = [timestr substringFromIndex:timestr.length - 6];
        
    }
    self.topLabel.text = model.zz_name_str;
    self.lowLabel.text = model.icd_name_str;
    NSString *littletimestr = [NSString stringWithFormat:@"%@",model.createDate];
    self.createDateLabel.text = [self getDateStringWithTimeStr:littletimestr];
    
}


-(NSString *)getDateStringWithTimeStr:(NSString *)str{
    NSTimeInterval time=[str doubleValue]/1000;//传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; //实例化一个NSDateFormatter对象
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    return currentDateStr;
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
