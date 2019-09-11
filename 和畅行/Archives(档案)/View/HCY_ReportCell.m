//
//  HCY_ReportCell.m
//  和畅行
//
//  Created by 出神入化 on 2018/12/14.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "HCY_ReportCell.h"

@implementation HCY_ReportCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
        [self setUI];
    }
    return self;
}


-(void)setUI {
    
//    backImageView;
//    quarterLabel;
//    timeLabel;
    
    self.backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth - 20, 100)];
    [self.backImageView.layer addSublayer:[UIColor setGradualChangingColor:self.backImageView fromColor:@"4294E1" toColor:@"D1BDFF"]];
    self.backImageView.layer.cornerRadius = 10;
    self.backImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.backImageView];
    
    self.quarterLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.backImageView.width, 80)];
    self.quarterLabel.backgroundColor = [UIColor clearColor];
    self.quarterLabel.textColor = [UIColor whiteColor];
    self.quarterLabel.text = @"第一季度阶段报告";
    self.quarterLabel.textAlignment = NSTextAlignmentCenter;
    self.quarterLabel.font = [UIFont systemFontOfSize:24];
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, self.backImageView.width, 30)];
    self.timeLabel.backgroundColor = [UIColor clearColor];
    self.timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel.text = @"2018.01.30-2018.03.31";
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.font = [UIFont systemFontOfSize:14];
    
}

-(void)setReportModel:(HealthTipsModel *)model withIndex:(NSIndexPath *)indexpath {
    
    NSString *quarterStr = [NSString string];
    if (![GlobalCommon stringEqualNull:model.quarter]) {
       quarterStr  = [NSString stringWithFormat:@"%@",model.quarter];
    }else{
        quarterStr = model.name;
    }
    NSString *yearStr = [NSString stringWithFormat:@"%@",model.year];
    
    NSString *topColor = [NSString string];
    NSString *bottomColor = [NSString string];
    NSString *quartertitleStr= [NSString string];
    NSString *timeStr= [NSString string];

    if ([quarterStr isEqualToString:@"1"]) {
        topColor = @"2BAD75";
        bottomColor = @"DBCC61";
        quartertitleStr = ModuleZW(@"第一季度阶段报告");
        timeStr =  [NSString stringWithFormat:@"%@.01.01-%@.3.31",yearStr,yearStr];
    }else if ([quarterStr isEqualToString:@"2"]) {
        topColor = @"4294E1";
        bottomColor = @"D1BDFF";
        quartertitleStr = ModuleZW(@"第二季度阶段报告");
        timeStr =  [NSString stringWithFormat:@"%@.04.01-%@.06.30",yearStr,yearStr];
        timeStr = @"2018.04.01-2018.06.30";
    }else if ([quarterStr isEqualToString:@"3"]) {
        topColor = @"E2862C";
        bottomColor = @"F3D285";
        quartertitleStr = ModuleZW(@"第三季度阶段报告");
        timeStr =  [NSString stringWithFormat:@"%@.07.01-%@.09.30",yearStr,yearStr];
        timeStr = @"2018.07.01-2018.09.30";
    }else{
        topColor = @"6673EE";
        bottomColor = @"FCA6D1";
        quartertitleStr = ModuleZW(@"第四季度阶段报告");
        timeStr =  [NSString stringWithFormat:@"%@.10.01-%@.12.31",yearStr,yearStr];
        timeStr = @"2018.10.01-2018.12.31";
    }
    
    [self.backImageView.layer addSublayer:[UIColor setGradualChangingColor:self.backImageView fromColor:topColor toColor:bottomColor]];

    self.quarterLabel.text = quartertitleStr;
    self.timeLabel.text    = timeStr;
    [self.backImageView addSubview:self.quarterLabel];
    [self.backImageView addSubview:self.timeLabel];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
