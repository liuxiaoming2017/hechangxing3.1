//
//  HCY_DAVisceraCell.m
//  和畅行
//
//  Created by Wei Zhao on 2018/12/6.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "HCY_DAVisceraCell.h"

@implementation HCY_DAVisceraCell

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
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 72, 20)];
    self.timeLabel.textAlignment=NSTextAlignmentLeft;
    self.timeLabel.font=[UIFont systemFontOfSize:16.0];
    self.timeLabel.textColor=[UIColor blackColor];
    self.timeLabel.backgroundColor=[UIColor clearColor];
    self.timeLabel.text = @"11-23";
    [self addSubview:self.timeLabel];
    
    UIImageView *lineImageV = [[UIImageView alloc] initWithFrame:CGRectMake(30, self.timeLabel.bottom+5, 1, 25)];
    lineImageV.backgroundColor = UIColorFromHex(0xe2e2e2);
    [self addSubview:lineImageV];
    
    self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(self.timeLabel.right - 20, lineImageV.bottom-15, ScreenWidth-self.timeLabel.right + 10, 79)];
    self.imageV.layer.cornerRadius = 8.0;
    self.imageV.layer.masksToBounds = YES;
    self.imageV.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.imageV];
    [self insertSublayerWithImageView:self.imageV];
    
    self.createDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,  self.imageV.top+self.imageV.height/2.0-20, 60, 20)];
    self.createDateLabel.font=[UIFont systemFontOfSize:13.0];
    self.createDateLabel.textAlignment = NSTextAlignmentCenter;
    self.createDateLabel.textColor=UIColorFromHex(0x8E8E93);
    self.createDateLabel.text = @"08:08";
    [self addSubview:self.createDateLabel];
    
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:@"症状选择:\nICD-10:"];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:8];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [attributedString1 length])];
  

    
    self.typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.imageV.left+15, self.imageV.top, 80, self.imageV.height)];
    self.typeLabel.attributedText = attributedString1;
    self.typeLabel.numberOfLines = 2;
    self.typeLabel.textColor = RGB(55, 55, 55);
    self.typeLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.typeLabel];
    
    
    self.topLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.typeLabel.right, self.imageV.top + 13, ScreenWidth - self.typeLabel.right - 20, self.imageV.height/2 - 13)];
    self.topLabel.font=[UIFont systemFontOfSize:15];
    self.topLabel.textColor=RGB(221, 156, 92);
    self.topLabel.text = @"新病有汗";
    [self addSubview:self.topLabel];
    
    self.lowLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.typeLabel.right, self.topLabel.bottom  , ScreenWidth - self.typeLabel.right - 20, self.imageV.height/2-13)];
    self.lowLabel.font=[UIFont systemFontOfSize:15];
    self.lowLabel.textColor=RGB(221, 156, 92);
    self.lowLabel.text = @"无";
    [self addSubview:self.lowLabel];
    
    
    //病历
    
    
    self.doctorNameLabel = [[UILabel alloc]initWithFrame:CGRectMake( 15, 5, 130, self.imageV.height/2)];
    self.doctorNameLabel.textColor = RGB(55, 55, 55);
    self.doctorNameLabel.font = [UIFont systemFontOfSize:15];
    self.doctorNameLabel.hidden = YES;
    [self.imageV addSubview:self.doctorNameLabel];
    
    self.departmentNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.imageV.width - 130 , 0,120 , self.imageV.height/2)];
    self.departmentNameLabel.textAlignment = NSTextAlignmentRight;
    self.departmentNameLabel.textColor = RGB(55, 55, 55);
    self.departmentNameLabel.font = [UIFont systemFontOfSize:15];
    self.departmentNameLabel.hidden = YES;
    [self.imageV addSubview:self.departmentNameLabel];
    
    
    self.CCLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.doctorNameLabel.left , self.doctorNameLabel.bottom - 10, self.imageV.width - 10, self.imageV.height/2)];
    self.CCLabel.textColor = RGB(55, 55, 55);
    self.CCLabel.hidden = YES;
    self.CCLabel.font = [UIFont systemFontOfSize:15];
    [self.imageV addSubview:self.CCLabel];
    
        
    self.lineImageV2 = [[UIImageView alloc] initWithFrame:CGRectMake(lineImageV.left, self.createDateLabel.bottom + 10, 1, 37)];
    self.lineImageV2.backgroundColor = UIColorFromHex(0xe2e2e2);
    [self addSubview:self.lineImageV2];
    
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
    
//档案  病历
    if (![GlobalCommon stringEqualNull:model.medicRecordId]){
        
        NSString *departmentName = [NSString stringWithFormat:ModuleZW(@"科室: %@"),model.doctorDept];
        NSMutableAttributedString *departmentNameStr = [[NSMutableAttributedString alloc]initWithString:departmentName];
        [departmentNameStr beginEditing];
        [departmentNameStr addAttribute:NSForegroundColorAttributeName value:RGB(221, 156, 92) range:NSMakeRange(departmentName.length - model.doctorDept.length ,model.doctorDept.length)];
        [departmentNameStr endEditing];
        
        NSString *doctorName = [NSString stringWithFormat:ModuleZW(@"医生: %@"),model.doctorName];
        NSMutableAttributedString *doctorNameStr = [[NSMutableAttributedString alloc]initWithString:doctorName];
        [doctorNameStr beginEditing];
        [doctorNameStr addAttribute:NSForegroundColorAttributeName value:RGB(221, 156, 92) range:NSMakeRange(doctorNameStr.length - model.doctorName.length ,model.doctorName.length)];
        [doctorNameStr endEditing];        
        
        NSString *mainSuit =  [NSString stringWithFormat:ModuleZW(@"主诉: %@"),model.mainSuit];
        NSMutableAttributedString *mainSuitStr = [[NSMutableAttributedString alloc]initWithString:mainSuit];
        [mainSuitStr beginEditing];
        [mainSuitStr addAttribute:NSForegroundColorAttributeName value:RGB(221, 156, 92) range:NSMakeRange(mainSuitStr.length - model.mainSuit.length ,model.mainSuit.length)];
        [mainSuitStr endEditing];
        
        self.doctorNameLabel.attributedText = departmentNameStr;
        self.departmentNameLabel.attributedText = doctorNameStr;
        self.CCLabel.attributedText = mainSuitStr;
        
        NSString *littletimestr = [NSString stringWithFormat:@"%@",model.createTime];
        self.createDateLabel.text = [self getDateStringWithTimeStr:littletimestr];
        self.timeLabel.text          =  [self getDateStringWithOtherTimeStr:littletimestr];
        
        self.doctorNameLabel.hidden = NO;
        self.departmentNameLabel.hidden = NO;
        self.CCLabel.hidden = NO;
        self.typeLabel.hidden = YES;
        self.topLabel.hidden = YES;
        self.lowLabel.hidden = YES;
        
    }else {
        
        self.doctorNameLabel.hidden = YES;
        self.departmentNameLabel.hidden = YES;
        self.CCLabel.hidden = YES;
        self.typeLabel.hidden = NO;
        self.topLabel.hidden = NO;
        self.lowLabel.hidden = NO;
        
        NSString *timestr = model.createTime;
        timestr = [timestr stringByReplacingOccurrencesOfString:@"-" withString:ModuleZW(@"月")];
        timestr = [timestr stringByAppendingString:ModuleZW(@"日")];
        NSRange range = NSMakeRange(timestr.length - 6, 1);
        NSString *subString3 = [timestr substringWithRange:range];
        if ([subString3 isEqualToString: @"0"]) {
            self.timeLabel.text = [timestr substringFromIndex:timestr.length - 5];
        }else {
            self.timeLabel.text = [timestr substringFromIndex:timestr.length - 6];
        }
        
        NSString *littletimestr = [NSString stringWithFormat:@"%@",model.createDate];
        self.createDateLabel.text = [self getDateStringWithTimeStr:littletimestr];
        
        
    }
    
    if (![model.physique_id isKindOfClass:[NSNull class]]&&model.physique_id!=nil&&model.physique_id.length!=0) {
        
        self.typeLabel.frame = CGRectMake(self.imageV.left+15, self.imageV.top, 80, self.imageV.height);
        self.topLabel.frame = CGRectMake(self.typeLabel.right, self.imageV.top + 13, ScreenWidth - self.typeLabel.right - 20, self.imageV.height/2 - 13);
        self.lowLabel.frame = CGRectMake(self.typeLabel.right, self.topLabel.bottom  , ScreenWidth - self.typeLabel.right - 20, self.imageV.height/2-13);

        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:@"症状选择:\nICD-10:"];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:8];
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [attributedString1 length])];
        
        self.typeLabel.attributedText = attributedString1;
        
        self.topLabel.text = model.zz_name_str;
        self.lowLabel.text = model.icd_name_str;

    }
    
    
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


-(NSString *)getDateStringWithOtherTimeStr:(NSString *)str{
    NSTimeInterval time=[str doubleValue]/1000;//传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; //实例化一个NSDateFormatter对象
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"MM-dd"];
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
