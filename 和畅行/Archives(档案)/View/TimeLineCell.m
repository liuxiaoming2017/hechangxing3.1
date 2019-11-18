//
//  TimeLineCell.m
//  和畅行
//
//  Created by 刘晓明 on 2018/11/7.
//  Copyright © 2018 刘晓明. All rights reserved.
//

#import "TimeLineCell.h"
@implementation TimeLineCell

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
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.textAlignment=NSTextAlignmentLeft;
    self.timeLabel.font=[UIFont systemFontOfSize:16.0];
    self.timeLabel.textColor=[UIColor blackColor];
    self.timeLabel.backgroundColor=[UIColor clearColor];
    self.timeLabel.text = @"11-23";
    [self.contentView addSubview:self.timeLabel];
    
    UIImageView *lineImageV = [[UIImageView alloc] init];
    lineImageV.backgroundColor = UIColorFromHex(0xe2e2e2);
    [self.contentView addSubview:lineImageV];
    
    UIImageView *imageV = [[UIImageView alloc] init];
    imageV.layer.cornerRadius = 8.0;
    imageV.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:imageV];
    self.imageV = imageV;

    imageV.layer.shadowColor = RGB(200, 200, 200).CGColor;
    imageV.layer.shadowOffset = CGSizeMake(0,0);
    imageV.layer.shadowOpacity = 0.5;
    imageV.layer.shadowRadius = 5;
    
    
    self.createDateLabel = [[UILabel alloc]init];
    self.createDateLabel.font=[UIFont systemFontOfSize:13.0];
    self.createDateLabel.textAlignment = NSTextAlignmentCenter;
    self.createDateLabel.textColor=UIColorFromHex(0x8E8E93);
    self.createDateLabel.text = @"08:08";
    [self.contentView addSubview:self.createDateLabel];
    
    
    self.kindImage = [[UIImageView alloc]init];
    self.kindImage.image = [UIImage imageNamed:@"经络Icon"];
    [imageV addSubview:self.kindImage];

    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.font=[UIFont systemFontOfSize:16];
    self.contentLabel.textColor=RGB(128, 128, 128);
    self.contentLabel.text = @"大羽";
    self.contentLabel.numberOfLines = 0;
    [imageV addSubview:self.contentLabel];

    
    self.lineImageV2 = [[UIImageView alloc] init];
    self.lineImageV2.backgroundColor = UIColorFromHex(0xe2e2e2);
    [self.contentView addSubview:self.lineImageV2];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(Adapter(10.0));
        make.size.mas_equalTo(CGSizeMake(Adapter(200), Adapter(20)));
        make.leading.equalTo(self.contentView.mas_leading).offset(Adapter(10.0));
    }];
    [lineImageV  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom).offset(Adapter(5));
        make.size.mas_equalTo(CGSizeMake(1, Adapter(20)));
        make.left.equalTo(self.contentView.mas_left).offset(Adapter(30));
    }];
    [self.createDateLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineImageV.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(Adapter(60), Adapter(20)));
        make.left.equalTo(self.contentView.mas_left);
    }];
    [self.lineImageV2  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.createDateLabel.mas_bottom);
        make.width.mas_equalTo(1);
        make.left.equalTo(self.contentView.mas_left).offset(Adapter(30));
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineImageV.mas_bottom).offset(Adapter(-5));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(Adapter(-5));
        make.leading.equalTo(self.contentView.mas_leading).offset(Adapter(65));
        make.trailing.equalTo(self.contentView.mas_trailing).offset(Adapter(-10));
        
    }];
    
    [self.kindImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageV.mas_top).offset(Adapter(9));
        make.left.equalTo(imageV.mas_left).offset(Adapter(9));
        make.size.mas_equalTo(CGSizeMake(Adapter(31), Adapter(31)));
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageV.mas_top);
        make.bottom.equalTo(self.imageV.mas_bottom);
        make.leading.equalTo(self.imageV.mas_leading).offset(Adapter(60));
        make.trailing.equalTo(self.imageV.mas_trailing);
        make.height.greaterThanOrEqualTo(@(Adapter(49)));
    }];
    
}




//为cell 赋值
- (void)assignmentCellWithModel:(HealthTipsModel *)model withType:(NSInteger )typeInteger{

    
    NSString *typeStr = [NSString string];
    if (typeInteger == 0) {
        NSString *nameStr= [NSString string];
        if ([model.type isEqualToString:@"BLOOD"]) {
            NSArray * array= [model.name componentsSeparatedByString:@"-"];
            if (array.count > 1) {
                if([UserShareOnce shareOnce].languageType){
                    nameStr =  [NSString stringWithFormat:@"%@ %@",array[0],array[1]];
                }else{
                    nameStr =  [NSString stringWithFormat:@"%@%@ %@%@",ModuleZW(@"收缩压"),array[0],ModuleZW(@"舒张压"),array[1]];
                }
            }else{
                nameStr = model.name;
            }
        }else if ([model.type isEqualToString:@"memberHealthr"]) {
            nameStr = model.name;
            if ([nameStr isEqualToString:@""]) {
                nameStr = ModuleZW(@"我的上传报告");
            }
        } else {
            nameStr = model.name;
        }
       
        typeStr = model.typeName;
        self.contentLabel.text = nameStr;
       
        self.timeLabel.text =   [self getDateStringWithOtherTimeStr:[NSString stringWithFormat:@"%@",model.createTime]];
        self.createDateLabel.text = [self getDateStringWithTimeStr:[NSString stringWithFormat:@"%@",model.createTime]];
        
    }else if (typeInteger == 1){
        //档案最新
        if ([model.typeStr isEqualToString:@"oxygen"]){
            typeStr =ModuleZW(@"血氧");
            CGFloat density =  [model.density  floatValue];
            self.contentLabel.text =[NSString stringWithFormat:@"%.0f%%",density*100];
        }else if ([model.typeStr isEqualToString:@"bloodPressure"]){
            typeStr = ModuleZW(@"血压");
            self.contentLabel.text = [NSString stringWithFormat:@"%@%@ %@%@",ModuleZW(@"收缩压"),model.highPressure,ModuleZW(@"舒张压"),model.lowPressure];
//            self.contentLabel.text = [NSString stringWithFormat:@"%@ -  %@",model.highPressure,model.highPressure];
        }else if ([model.typeStr isEqualToString:@"ecg"]){
            typeStr = ModuleZW(@"心率");
            self.contentLabel.text = model.heartRate;
        }else if ([model.typeStr isEqualToString:@"JLBS"]){
            typeStr = ModuleZW(@"经络");
            self.contentLabel.text = [model.subject valueForKey:@"name"];
        }else if ([model.typeStr isEqualToString:@"TZBS"]){
            typeStr = ModuleZW(@"体质");
            self.contentLabel.text = [model.subject valueForKey:@"name"];
        }else if ([model.typeStr isEqualToString:@"ZFBS"]){
            typeStr = ModuleZW(@"脏腑");
            self.contentLabel.text = model.cert_name;
        }else if ([model.typeStr isEqualToString:@"bodyTemperature"]){
            typeStr = ModuleZW(@"体温");
            self.contentLabel.text = model.temperature;
        }
        self.timeLabel.text =   [self getDateStringWithOtherTimeStr:[NSString stringWithFormat:@"%@",model.createDate]];
        self.createDateLabel.text =  [self getDateStringWithTimeStr:[NSString stringWithFormat:@"%@",model.createDate]];
       
    } else if (typeInteger == 5){
        typeStr = ModuleZW(@"脏腑");
        if([GlobalCommon stringEqualNull:model.name]){
            self.contentLabel.text = ModuleZW(@"无症状");
        }else{
            self.contentLabel.text = model.name;
        }
        NSString *timeStr = [self getDateStringWithOtherTimeStr:[NSString stringWithFormat:@"%@",model.createTime]];
        self.timeLabel.text = timeStr;
        self.createDateLabel.text = model.time;
    }else  if (typeInteger == 10||typeInteger == 9){
        typeStr = ModuleZW(@"心率");
        self.contentLabel.text = model.heartRate;
        NSString *timerStr = [NSString stringWithFormat:@"%@",model.createDate];
        NSString *timestr = model.createTime;
        self.timeLabel.text = [model.createTime substringFromIndex:timestr.length - 5];
        timerStr = [self getDateStringWithOtherTimeStr:timerStr];
        NSString *str = [NSString stringWithFormat:@"%@",model.createDate];
        self.createDateLabel.text = [self getDateStringWithTimeStr:str];
    }else  if (typeInteger == 14){
        if(![GlobalCommon stringEqualNull:model.content]){
            self.contentLabel.text = model.content;
        }else{
            self.contentLabel.text = ModuleZW(@"我的上传报告");
        }
        NSString *timerStr = [NSString stringWithFormat:@"%@",model.createDate];
        self.timeLabel.text = [self getDateStringWithOtherTimeStr:timerStr];
        self.createDateLabel.text = [self getDateStringWithTimeStr:timerStr];
    }else{
        if ([model.subjectCategorySn isEqualToString:@"TZBS"]){
            typeStr = ModuleZW(@"体质");
        }else{
            typeStr = ModuleZW(@"经络");
        }
        self.contentLabel.text = [model.subject valueForKey:@"name"];
        NSString *timerStr = [NSString stringWithFormat:@"%@",model.createDate];
        timerStr = [self getDateStringWithOtherTimeStr:timerStr];
        self.timeLabel.text = timerStr;
        NSString *str = [NSString stringWithFormat:@"%@",model.createDate];
        self.createDateLabel.text = [self getDateStringWithTimeStr:str];
    }
    
    
    NSString *kindStr= [NSString string];
    NSString *kindIcon= [NSString string];
    if ([typeStr isEqualToString:ModuleZW(@"血压")]) {
        kindStr = @"(mmHg)";
        kindIcon = @"血压Icon";
    }else  if ([typeStr isEqualToString:ModuleZW(@"心率")]){
        kindStr = ModuleZW(@"(次/分)");
        kindIcon = @"心率Icon";
    }else if ([typeStr isEqualToString:ModuleZW(@"呼吸")]) {
        kindStr = ModuleZW(@"(次/分)");
        kindIcon = @"呼吸Icon";
    }else if ([typeStr isEqualToString:ModuleZW(@"血糖")]) {
        kindStr = @"(mmol/L)";
        kindIcon = @"血糖Icon";
    }else if ([typeStr isEqualToString:ModuleZW(@"体温")]) {
        kindStr = @"(℃)";
        kindIcon = @"体温Icon";
    }else if ([typeStr isEqualToString:ModuleZW(@"经络")]) {
        kindStr = @"";
        kindIcon = @"经络Icon";
    }else if ([typeStr isEqualToString:ModuleZW(@"血氧")]) {
        kindStr = @"";
        kindIcon = @"血氧Icon";
    }else if ([typeStr isEqualToString:ModuleZW(@"体质")]) {
        kindStr = @"";
        kindIcon = @"体质Icon";
    }else if ([typeStr isEqualToString:ModuleZW(@"脏腑")]) {
        kindStr = @"";
        kindIcon = @"脏腑Icon";
    }else  if ([typeStr isEqualToString:ModuleZW(@"我的上传报告")]){
        kindStr = @"";
        kindIcon = @"报告";
    }
    if (model.pictures) {
        kindStr = @"";
         kindIcon = @"报告";
    }
    
    NSString *salaryStr1 = [NSString string];
    if (kindStr.length > 1){
        salaryStr1 =  [NSString stringWithFormat:@"%@%@",self.contentLabel.text,kindStr];
    }else{
        salaryStr1 = self.contentLabel.text;
    }
    NSMutableAttributedString *salaryStr = [[NSMutableAttributedString alloc]initWithString:salaryStr1];
    [salaryStr beginEditing];
    [salaryStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(salaryStr1.length - kindStr.length ,kindStr.length)];
    [salaryStr addAttribute:NSForegroundColorAttributeName value:RGB(128, 128, 128) range:NSMakeRange(salaryStr1.length - kindStr.length ,kindStr.length)];
    
    [salaryStr endEditing];
    self.contentLabel.attributedText = salaryStr;
    self.kindImage.image = [UIImage imageNamed:kindIcon];
    
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
    
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy"];
    NSString *thisYearString=[dateformatter stringFromDate:senddate];
    
    NSTimeInterval time=[str doubleValue]/1000;//传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; //实例化一个NSDateFormatter对象
    //设定时间格式,这里可以设置成自己需要的格式
    NSString *dateStr = [NSString stringWithFormat:@"yyyy-MM-dd"];
    [dateFormatter setDateFormat:dateStr];
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    if ([currentDateStr containsString:thisYearString]) {
        currentDateStr = [currentDateStr substringFromIndex:5];
    }
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
