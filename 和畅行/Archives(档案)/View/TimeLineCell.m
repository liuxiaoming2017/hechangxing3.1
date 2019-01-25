//
//  TimeLineCell.m
//  和畅行
//
//  Created by 刘晓明 on 2018/11/7.
//  Copyright © 2018 刘晓明. All rights reserved.
//

#import "TimeLineCell.h"
@implementation TimeLineCell

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
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 20)];
    self.timeLabel.textAlignment=NSTextAlignmentLeft;
    self.timeLabel.font=[UIFont systemFontOfSize:16.0];
    self.timeLabel.textColor=[UIColor blackColor];
    self.timeLabel.backgroundColor=[UIColor clearColor];
    self.timeLabel.text = @"11-23";
    [self addSubview:self.timeLabel];
    
    UIImageView *lineImageV = [[UIImageView alloc] initWithFrame:CGRectMake(30, self.timeLabel.bottom+5, 1, 20)];
    lineImageV.backgroundColor = UIColorFromHex(0xe2e2e2);
    [self addSubview:lineImageV];
    
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(65 , lineImageV.bottom-5, ScreenWidth-75, 49)];
    imageV.layer.cornerRadius = 8.0;
    imageV.layer.masksToBounds = YES;
    imageV.backgroundColor = [UIColor whiteColor];
    [self addSubview:imageV];
    [self insertSublayerWithImageView:imageV];
    
    self.createDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,  imageV.top+imageV.height/2.0-10, 60, 20)];
    self.createDateLabel.font=[UIFont systemFontOfSize:13.0];
    self.createDateLabel.textAlignment = NSTextAlignmentCenter;
    self.createDateLabel.textColor=UIColorFromHex(0x8E8E93);
    self.createDateLabel.text = @"08:08";
    [self addSubview:self.createDateLabel];
    
    UIImageView *circleImageV = [[UIImageView alloc] initWithFrame:CGRectMake(20, imageV.top+imageV.height/2.0-10, 20, 20)];
    //UIImageView *circleImageV = [[UIImageView alloc] initWithFrame:CGRectZero];
    circleImageV.layer.cornerRadius = circleImageV.width/2.0;
    circleImageV.layer.masksToBounds = YES;
    circleImageV.backgroundColor = UIColorFromHex(0xe2e2e2);
//    [self addSubview:circleImageV];
    
    self.typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 0,0)];
    self.typeLabel.text = @"经络";
    [self.typeLabel sizeToFit];
    self.typeLabel.textColor = [UIColor blackColor];
    self.typeLabel.font = [UIFont systemFontOfSize:16];
    [imageV addSubview:self.typeLabel];
    
    self.kindLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.typeLabel.right, self.typeLabel.bottom - 15, 55, 15)];
    self.kindLabel.text = @"(mmHg)";
    self.kindLabel.textColor = RGB(128, 128, 128);;
    self.kindLabel.font = [UIFont systemFontOfSize:12];
    [imageV addSubview:self.kindLabel];
    
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.kindLabel.right+ 5, 0, imageV.width - self.kindLabel.right - 7, imageV.height)];
    self.contentLabel.font=[UIFont systemFontOfSize:16];
    self.contentLabel.textColor=RGB(128, 128, 128);
    self.contentLabel.text = @"大羽";
    [imageV addSubview:self.contentLabel];
    

    
    
    self.lineImageV2 = [[UIImageView alloc] initWithFrame:CGRectMake(lineImageV.left, 105-20, 1, 20)];
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
- (void)assignmentCellWithModel:(HealthTipsModel *)model withType:(NSInteger )typeInteger{

    if (typeInteger == 0) {
        NSString *nameStr= [NSString string];
        if ([model.typeName isEqualToString:@"血压"]) {
            NSArray * array= [model.name componentsSeparatedByString:@"-"];
            if (array.count > 1) {
                nameStr = [NSString stringWithFormat:@"收缩压%@  舒张压%@",array[1],array[0]];
            }else{
                nameStr = model.name;
            }
        }else {
            nameStr = model.name;
        }
        self.typeLabel.text = model.typeName;
        self.contentLabel.text = nameStr;
        self.timeLabel.text = model.date;
        self.createDateLabel.text = model.time;
        
    }else if (typeInteger == 1){
        //档案最新
        if ([model.typeStr isEqualToString:@"oxygen"]){
            self.typeLabel.text = @"血氧";
            self.contentLabel.text = model.density;
        }else if ([model.typeStr isEqualToString:@"bloodPressure"]){
            self.typeLabel.text = @"血压";
            self.contentLabel.text = [NSString stringWithFormat:@"收缩压%@  舒张压%@",model.highPressure,model.lowPressure];
        }else if ([model.typeStr isEqualToString:@"ecg"]){
            self.typeLabel.text = @"心电";
            self.contentLabel.text = [model.subject valueForKey:@"name"];
        }else if ([model.typeStr isEqualToString:@"JLBS"]){
            self.typeLabel.text = @"经络";
            self.contentLabel.text = [model.subject valueForKey:@"name"];
        }else if ([model.typeStr isEqualToString:@"TZBS"]){
            self.typeLabel.text = @"体质";
            self.contentLabel.text = [model.subject valueForKey:@"name"];
        }else if ([model.typeStr isEqualToString:@"ZFBS"]){
            self.typeLabel.text = @"脏腑";
            self.contentLabel.text = model.zz_name_str;
        }else if ([model.typeStr isEqualToString:@"bodyTemperature"]){
            self.typeLabel.text = @"体温";
            self.contentLabel.text = model.temperature;
        }
    } else if (typeInteger == 5){
        self.typeLabel.text = @"脏腑";
        if([GlobalCommon stringEqualNull:model.name]){
            self.contentLabel.text = @"无症状";
        }else{
            self.contentLabel.text = model.name;
        }
        self.timeLabel.text = model.date;
        self.createDateLabel.text = model.time;
    }else  if (typeInteger == 10){
        self.typeLabel.text = @"心率";
        self.contentLabel.text = [model.subject valueForKey:@"name"];
        NSString *timerStr = [NSString stringWithFormat:@"%@",model.createDate];
        
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
        timerStr = [self getDateStringWithOtherTimeStr:timerStr];
        self.contentLabel.text = [model.subject valueForKey:@"name"];;
        NSString *str = [NSString stringWithFormat:@"%@",model.createDate];
        self.createDateLabel.text = [self getDateStringWithTimeStr:str];
    }else{
        if ([model.subjectCategorySn isEqualToString:@"TZBS"]){
            self.typeLabel.text = @"体质";
        }else{
            self.typeLabel.text = @"经络";
        }
        self.contentLabel.text = [model.subject valueForKey:@"name"];
        NSString *timerStr = [NSString stringWithFormat:@"%@",model.createDate];
        timerStr = [self getDateStringWithOtherTimeStr:timerStr];
        self.timeLabel.text = timerStr;
        NSString *str = [NSString stringWithFormat:@"%@",model.createDate];
        self.createDateLabel.text = [self getDateStringWithTimeStr:str];
    }
    
    NSString *kindStr= [NSString string];
    if ([self.typeLabel.text isEqualToString:@"血压"]) {
        kindStr = @"(mmHg)";
    }else  if ([self.typeLabel.text isEqualToString:@"心率"]||[self.typeLabel.text isEqualToString:@"呼吸"]) {
        kindStr = @"(次/分)";
    }else if ([self.typeLabel.text isEqualToString:@"血糖"]) {
        kindStr = @"(mmol/L)";
    }else if ([self.typeLabel.text isEqualToString:@"体温"]) {
        kindStr = @"(℃)";
    }else{
        kindStr = @"";
    }
    self.kindLabel.text = kindStr;
    
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
    [dateFormatter setDateFormat:@"MM月dd日"];
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
