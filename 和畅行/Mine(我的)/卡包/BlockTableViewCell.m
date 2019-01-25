//
//  BlockTableViewCell.m
//  Voicediagno
//
//  Created by 李传铎 on 15/9/8.
//  Copyright (c) 2015年 李传铎. All rights reserved.
//

#import "BlockTableViewCell.h"

@implementation BlockTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
      
        [self customView];
       
        
    }
    return self;
}


-(void)customView {
    
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5,ScreenWidth - 40, 130)];
    //添加渐变色
    [imageV.layer addSublayer:[UIColor setGradualChangingColor:imageV fromColor:@"4294E1" toColor:@"D1BDFF"]];
    imageV.layer.cornerRadius = 10;
    imageV.layer.masksToBounds = YES;
    [self addSubview:imageV];
    
    
    _hLabel = [[UILabel alloc] init];
    _hLabel.frame = CGRectMake(10, 10, 200, 30);
    _hLabel.textColor = [UIColor whiteColor];
    _hLabel.text = @"视频问诊半年卡";
    _hLabel.font = [UIFont systemFontOfSize:21];
    [imageV addSubview:_hLabel];
    
    _mLabel = [[UILabel alloc] init];
    _mLabel.frame = CGRectMake(10,_hLabel.bottom , imageV.width - 20, 60 );
    _mLabel.numberOfLines = 2;
    _mLabel.text = @"阿道夫沙发沙发沙发上发送到发的是飞洒发士大夫撒按时发生";
    _mLabel.font = [UIFont systemFontOfSize:14];
    _mLabel.textColor = [UIColor whiteColor];
    [imageV addSubview:_mLabel];
    
    
    _imageV = [[UIImageView alloc]init];
    _imageV.frame  =CGRectMake(imageV.width - 60,  5, 50, 45);
    _imageV.image = [UIImage imageNamed:@"未激活.png"];
    _imageV.hidden  = YES;
    [imageV addSubview:_imageV];
   
    _yLabel = [[UILabel alloc] init];
    _yLabel.frame = CGRectMake(10, _mLabel.bottom , 160, 20);
    _yLabel.text = @"2019-11-11到期";
    _yLabel.font = [UIFont systemFontOfSize:12];
    _yLabel.textColor = [UIColor whiteColor];
    [imageV addSubview:_yLabel];
    
    
}


-(void)setCarListDataWithModel:(HYC_CardsModel *)model {
    NSString *timeStr = [NSString string];
    if ([model.kindStr isEqualToString:@"现金卡"]){
        NSString *str = [model.cashcard valueForKey:@"name"];
          _hLabel.text = str;
        _mLabel.text = [NSString stringWithFormat:@"余额 : %@元",model.balance];
        timeStr = [NSString stringWithFormat:@"%@",[model.cashcard valueForKey:@"endDate"]];
        _yLabel.text  = [self getDateStringWithTimeStr:timeStr];
    }else{
        _hLabel.text = model.card_name;
        if (model.cardDescription==nil || [model.cardDescription isKindOfClass:[NSNull class]]||model.cardDescription.length == 0) {
            _mLabel.text = @"暂无";
        }else{
            _mLabel.text = model.cardDescription;
        }
        
        if ([model.status  isEqualToString:@"1"]&&![model.kindStr isEqualToString:@"现金卡"]) {
            _imageV.hidden = NO;
        }else {
            _imageV.hidden = YES;
        }
        timeStr = model.exprise_time;
        if(![GlobalCommon stringEqualNull:timeStr]){
            NSString *endTimeStr =  [NSString stringWithFormat:@"%@到期",timeStr];
            _yLabel.text = endTimeStr;
        }
    }
   

}


-(NSString *)getDateStringWithTimeStr:(NSString *)str{
    NSTimeInterval time=[str doubleValue]/1000;//传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; //实例化一个NSDateFormatter对象
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    return currentDateStr;
}


- (void)layoutSubviews{
    [super layoutSubviews];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
