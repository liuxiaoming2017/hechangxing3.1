//
//  NoTimeLineCell.m
//  和畅行
//
//  Created by 刘晓明 on 2018/11/23.
//  Copyright © 2018 刘晓明. All rights reserved.
//

#import "NoTimeLineCell.h"

#define imagevRight 60

@implementation NoTimeLineCell

@synthesize subLayer;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

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
    
   
    UIImageView *lineImageV = [[UIImageView alloc] initWithFrame:CGRectMake(30, 0, 1, 10)];
    //UIImageView *lineImageV = [[UIImageView alloc] initWithFrame:CGRectZero];
    lineImageV.backgroundColor = UIColorFromHex(0xe2e2e2);
    
    [self addSubview:lineImageV];
    
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(65, lineImageV.bottom-5, ScreenWidth-75, 49)];
    //UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageV.layer.cornerRadius = 8.0;
    imageV.layer.masksToBounds = YES;
//    [imageV.layer setBorderWidth:1.0];
//    [imageV.layer setBorderColor:UIColorFromHex(0XEEEEEE).CGColor];
    imageV.backgroundColor = [UIColor whiteColor];
    [self addSubview:imageV];
    [self insertSublayerWithImageView:imageV];
    
    UIImageView *circleImageV = [[UIImageView alloc] initWithFrame:CGRectMake(20, imageV.top+imageV.height/2.0-10, 20, 20)];
    //UIImageView *circleImageV = [[UIImageView alloc] initWithFrame:CGRectZero];
    circleImageV.layer.cornerRadius = circleImageV.width/2.0;
    circleImageV.layer.masksToBounds = YES;
    circleImageV.backgroundColor = UIColorFromHex(0xe2e2e2);
//    [self addSubview:circleImageV];
    
    self.typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 35,49)];
    self.typeLabel.text =ModuleZW(@"经络");
    self.typeLabel.textColor = [UIColor blackColor];
    self.typeLabel.font = [UIFont systemFontOfSize:16];
    [imageV addSubview:self.typeLabel];
    
    self.kindLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.typeLabel.right, self.typeLabel.bottom - 30, 55, 15)];
    self.kindLabel.text = @"(mmHg)";
    self.kindLabel.textColor = RGB(128, 128, 128);;
    self.kindLabel.font = [UIFont systemFontOfSize:12];
    [imageV addSubview:self.kindLabel];
    
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.kindLabel.right+ 5, 0, imageV.width - self.kindLabel.right - 7, imageV.height)];
    self.contentLabel.font=[UIFont systemFontOfSize:16];
    self.contentLabel.textColor=RGB(128, 128, 128);
    self.contentLabel.text = ModuleZW(@"大羽");
    [imageV addSubview:self.contentLabel];

    
    self.createDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,  imageV.top+imageV.height/2.0-10, 60, 20)];
    self.createDateLabel.font=[UIFont systemFontOfSize:12.0];
    self.createDateLabel.textAlignment = NSTextAlignmentCenter;
    self.createDateLabel.textColor=UIColorFromHex(0x8E8E93);
    self.createDateLabel.text = @"08:08";
    [self addSubview:self.createDateLabel];

    
    self.lineImageV2 = [[UIImageView alloc] initWithFrame:CGRectMake(lineImageV.left, imageV.bottom-5+5, 1, 12)];
     self.lineImageV2.backgroundColor = UIColorFromHex(0xe2e2e2);
    [self addSubview: self.lineImageV2];
    
}

-(void)insertSublayerWithImageView:(UIImageView *)imageV
{
    if(!subLayer){
        subLayer=[CALayer layer];
        CGRect fixframe = imageV.frame;
        subLayer.frame= fixframe;
        subLayer.cornerRadius=8;
        subLayer.backgroundColor=[UIColorFromHex(0xffffff) colorWithAlphaComponent:1.0].CGColor;
        //UIColorFromHex(0xDEDEDDE) [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0] 0XEEEEEE
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

//为cell 赋值
- (void)assignmentNoCellWithModel:(HealthTipsModel *)model withType:(NSInteger )typeInteger {
    
    NSString *typeStr  = [NSString string];
    
    if (typeInteger == 0) {
        NSString *nameStr= [NSString string];
        if ([model.typeName isEqualToString:ModuleZW(@"血压")]) {
            NSArray * array= [model.name componentsSeparatedByString:@"-"];
            if (array.count > 1) {
                nameStr = [NSString stringWithFormat:@"%@%@  %@%@",ModuleZW(@"收缩压"),array[1],ModuleZW(@"舒张压"),array[0]];
            }else{
                nameStr = model.name;
            }
        }else {
            nameStr = model.name;
        }
        typeStr = model.typeName;
        self.contentLabel.text = nameStr;
        self.timeLabel.text = model.date;
        self.createDateLabel.text = model.time;
        
    }else if (typeInteger == 1){
        //档案最新
        if ([model.typeStr isEqualToString:@"oxygen"]){
            typeStr = ModuleZW(@"血氧");
            self.contentLabel.text = model.density;
        }else if ([model.typeStr isEqualToString:@"bloodPressure"]){
            typeStr = ModuleZW(@"血压");
            self.contentLabel.text = [NSString stringWithFormat:@"%@ %@  %@ %@",ModuleZW(@"收缩压"),model.highPressure,ModuleZW(@"舒张压"),model.lowPressure];
        }else if ([model.typeStr isEqualToString:@"ecg"]){
            typeStr = ModuleZW(@"心电");
            self.contentLabel.text = [model.subject valueForKey:@"name"];
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
        self.createDateLabel.text =   [self getDateStringWithTimeStr:[NSString stringWithFormat:@"%@",model.createDate]];
        
    }else if (typeInteger == 5){
        typeStr = ModuleZW(@"脏腑");
        if([GlobalCommon stringEqualNull:model.name]){
            self.contentLabel.text = ModuleZW(@"无症状");
        }else{
            self.contentLabel.text = model.name;
        }
        self.createDateLabel.text = model.time;
    }else  if (typeInteger == 10){
        typeStr = ModuleZW(@"心率");
        self.contentLabel.text = [model.subject valueForKey:@"name"];
        NSString *str = [NSString stringWithFormat:@"%@",model.createDate];
        self.createDateLabel.text = [self getDateStringWithTimeStr:str];
    }else {
        if ([model.subjectCategorySn isEqualToString:@"TZBS"]){
            typeStr = ModuleZW(@"体质");
        }else{
            typeStr = ModuleZW(@"经络");
        }
        self.contentLabel.text = [model.subject valueForKey:@"name"];
        NSString *str = [NSString stringWithFormat:@"%@",model.createDate];
        self.createDateLabel.text = [self getDateStringWithTimeStr:str];
    }
    
    NSString *kindStr= [NSString string];
    if ([self.typeLabel.text isEqualToString:ModuleZW(@"血压")]) {
        kindStr = @"(mmHg)";
    }else  if ([self.typeLabel.text isEqualToString:ModuleZW(@"心率")]||[self.typeLabel.text isEqualToString:ModuleZW(@"呼吸")]) {
        kindStr = ModuleZW(@"(次/分)");
    }else if ([self.typeLabel.text isEqualToString:ModuleZW(@"血糖")]) {
        kindStr = @"(mmol/L)";
    }else if ([self.typeLabel.text isEqualToString:ModuleZW(@"体温")]) {
        kindStr = @"(℃)";
    }else{
        kindStr = nil;
    }
    
    self.kindLabel.text = kindStr;
    self.typeLabel.text = typeStr;
    
    if ([UserShareOnce shareOnce].languageType){
        
        NSString *salaryStr1 = [NSString string];
        if (kindStr){
            salaryStr1 =  [NSString stringWithFormat:@"%@\n%@",typeStr,kindStr];
        }else{
            salaryStr1 = typeStr;
        }
        NSLog(@"%@  ",salaryStr1);
        self.typeLabel.numberOfLines = 2;
        NSMutableAttributedString *salaryStr = [[NSMutableAttributedString alloc]initWithString:salaryStr1];
        [salaryStr beginEditing];
        [salaryStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(salaryStr1.length - kindStr.length ,kindStr.length)];
        [salaryStr addAttribute:NSForegroundColorAttributeName value:RGB(128, 128, 128) range:NSMakeRange(salaryStr1.length - kindStr.length ,kindStr.length)];

        [salaryStr endEditing];
        self.typeLabel.attributedText = salaryStr;
        CGRect textRect = [typeStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 59)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}
                                             context:nil];
        [self.typeLabel setFrame:CGRectMake(10, 0, textRect.size.width, 49)];
        self.kindLabel.text = @"";
        self.contentLabel.numberOfLines = 2;
        self.contentLabel.textAlignment = NSTextAlignmentCenter;
        self.contentLabel.frame = CGRectMake(self.typeLabel.right+ 5, 0, ScreenWidth-85 - self.typeLabel.right, 49);
        
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

@end
