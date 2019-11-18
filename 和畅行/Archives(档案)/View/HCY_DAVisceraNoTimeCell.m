//
//  HCY_DAVisceraNoTimeCell.m
//  和畅行
//
//  Created by Wei Zhao on 2018/12/6.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "HCY_DAVisceraNoTimeCell.h"


@implementation HCY_DAVisceraNoTimeCell

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
    
    UIImageView *lineImageV = [[UIImageView alloc] initWithFrame:CGRectMake(Adapter(30), 0, 1, Adapter(30))];
    lineImageV.backgroundColor = UIColorFromHex(0xe2e2e2);
    [self addSubview:lineImageV];
    
    self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(Adapter(60), lineImageV.bottom-Adapter(15), ScreenWidth-Adapter(70), Adapter(79))];
    self.imageV.layer.cornerRadius = 8.0;
    self.imageV.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.imageV];
    self.imageV.layer.shadowColor = RGB(200, 200, 200).CGColor;
    self.imageV.layer.shadowOffset = CGSizeMake(0,0);
    self.imageV.layer.shadowOpacity = 0.5;
    self.imageV.layer.shadowRadius = 5;
    
    
    self.createDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,  self.imageV.top+self.imageV.height/2.0-Adapter(20), Adapter(60), Adapter(20))];
    self.createDateLabel.font=[UIFont systemFontOfSize:13.0];
    self.createDateLabel.textAlignment = NSTextAlignmentCenter;
    self.createDateLabel.textColor=UIColorFromHex(0x8E8E93);
    self.createDateLabel.text = @"08:08";
    [self addSubview:self.createDateLabel];
    
   
    self.doctorNameLabel = [[UILabel alloc]initWithFrame:CGRectMake( Adapter(15), 0, Adapter(130), self.imageV.height/2)];
    self.doctorNameLabel.textColor = RGB(55, 55, 55);
    self.doctorNameLabel.font = [UIFont systemFontOfSize:15];
    [self.imageV addSubview:self.doctorNameLabel];
    
    self.departmentNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.imageV.width - Adapter(130) , 0,Adapter(120) , self.imageV.height/2)];
    self.departmentNameLabel.textAlignment = NSTextAlignmentRight;
    self.departmentNameLabel.textColor = RGB(55, 55, 55);
    self.departmentNameLabel.font = [UIFont systemFontOfSize:15];
    [self.imageV addSubview:self.departmentNameLabel];
    
    
    self.CCLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.doctorNameLabel.left , self.doctorNameLabel.bottom, self.imageV.width - 10, self.imageV.height/2)];
    self.CCLabel.textColor = RGB(55, 55, 55);
    self.CCLabel.font = [UIFont systemFontOfSize:15];
    [self.imageV addSubview:self.CCLabel];
    
    
    
    
    self.lineImageV2 = [[UIImageView alloc] initWithFrame:CGRectMake(lineImageV.left, self.createDateLabel.bottom + Adapter(10), 1, Adapter(37))];
    self.lineImageV2.backgroundColor = UIColorFromHex(0xe2e2e2);
    [self addSubview:self.lineImageV2];
    
}

- (void)configCellWithModel2
{
    
}


//为cell 赋值
- (void)assignmentNoVisceraWithModel:(HealthTipsModel *)model{
    
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




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
