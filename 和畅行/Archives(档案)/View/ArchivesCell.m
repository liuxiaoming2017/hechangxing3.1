//
//  ArchivesCell1.m
//  和畅行
//
//  Created by 刘晓明 on 2018/7/23.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "ArchivesCell.h"
#import "ArchiveModel.h"
#import "UIImageView+WebCache.h"

@implementation ArchivesCell

@synthesize iconImage,typeLabel,resultLabel,timeLabel,lineImage,doctorHintLabel,checkResultLabel;


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
        iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        iconImage.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:iconImage];
        
        typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconImage.right+20, 5, 60, 40)];
        typeLabel.font = [UIFont systemFontOfSize:14];
        typeLabel.textAlignment = NSTextAlignmentLeft;
        typeLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        [self.contentView addSubview:typeLabel];
        
        resultLabel = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-160)/2.0, 5, 160, 40)];
        resultLabel.font = [UIFont systemFontOfSize:14];
        resultLabel.textAlignment = NSTextAlignmentLeft;
        resultLabel.textColor = [UIColor colorWithRed:254/255.0 green:152/255.0 blue:77/255.0 alpha:1.0];;
        [self.contentView addSubview:resultLabel];
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-140, 5, 130, 40)];
        timeLabel.font = [UIFont systemFontOfSize:14];
        timeLabel.textAlignment = NSTextAlignmentRight;
        timeLabel.textColor = RGB(102, 102, 102);
        [self.contentView addSubview:timeLabel];
        
        checkResultLabel = [[UILabel alloc] initWithFrame:CGRectMake(typeLabel.right+10, 5, 60, 40)];
        checkResultLabel.font = [UIFont systemFontOfSize:14];
        checkResultLabel.textAlignment = NSTextAlignmentLeft;
        checkResultLabel.textColor = RGB(254, 152, 77);
        checkResultLabel.numberOfLines = 0;
        checkResultLabel.hidden = YES;
        [self.contentView addSubview:checkResultLabel];
        
        doctorHintLabel = [[UILabel alloc] initWithFrame:CGRectMake(resultLabel.right+10, 5, 160, 40)];
        doctorHintLabel.font = [UIFont systemFontOfSize:14];
        doctorHintLabel.textAlignment = NSTextAlignmentLeft;
        doctorHintLabel.textColor = RGB(254, 152, 77);
        doctorHintLabel.numberOfLines = 0;
        doctorHintLabel.hidden = YES;
        [self.contentView addSubview:doctorHintLabel];
    
        lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 49, ScreenWidth, 1)];
        lineImage.contentMode = UIViewContentModeScaleToFill;
        lineImage.image = [UIImage imageNamed:@"健康讲座线"];
        [self.contentView addSubview:lineImage];
        
    }
    return self;
}
# pragma mark - 普通cell
-(void)configMiddleCellWithArchive:(ArchiveModel *)archive
{
    checkResultLabel.hidden = YES;
    doctorHintLabel.hidden = YES;
    if(archive.cellType == cellType_new){
        iconImage.frame = CGRectMake(10, 10, 30, 30);
        resultLabel.textColor = [UIColor blackColor];
        resultLabel.text = [NSString stringWithFormat:@"辨识结果:%@",archive.symptom];
        typeLabel.textColor = RGB(102, 102, 102);
        typeLabel.frame = CGRectMake(iconImage.right+20, 5, 60, 40);
        resultLabel.frame = CGRectMake(typeLabel.right+5, 5, ScreenWidth-typeLabel.right-5-135, 40);
        iconImage.image = [UIImage imageNamed:archive.iconImage];
        typeLabel.text = archive.result;
        resultLabel.font = [UIFont systemFontOfSize:14];
        
    }else if (archive.cellType == cellType_jingLuo){
        resultLabel.textColor = RGB(254, 152, 77);
        resultLabel.text = archive.symptom;
        resultLabel.frame = CGRectMake((ScreenWidth-60)/2.0, 5, 60, 40);
        [iconImage sd_setImageWithURL:[NSURL URLWithString:archive.iconImage] placeholderImage:[UIImage imageNamed:@"jinluo_default_icon"]];
        typeLabel.text = @"经络辨识";
        iconImage.frame = CGRectMake(15, 10, 30, 30);
        typeLabel.frame = CGRectMake(iconImage.right+30, 5, 60, 40);
        
        resultLabel.font = [UIFont systemFontOfSize:15];
    }else if (archive.cellType == cellType_tiZhi){
        resultLabel.textColor = RGB(254, 152, 77);
        resultLabel.text = archive.symptom;
        resultLabel.frame = CGRectMake((ScreenWidth-60)/2.0, 5, 60, 40);
        [iconImage sd_setImageWithURL:[NSURL URLWithString:archive.iconImage] placeholderImage:[UIImage imageNamed:@"tizhi_default_icon"]];
        typeLabel.text = @"体质辨识";
        iconImage.frame = CGRectMake(15, 10, 30, 30);
        typeLabel.frame = CGRectMake(iconImage.right+30, 5, 60, 40);
        
        resultLabel.font = [UIFont systemFontOfSize:15];
    }
    timeLabel.frame = CGRectMake(ScreenWidth-135, 5, 120, 40);
    lineImage.frame = CGRectMake(0, 49, ScreenWidth, 1);
    timeLabel.text = [self timestampSwitchTime:archive.time];
}

# pragma mark - 脏腑图cell
-(void)configZangFuCellWithArchive:(ArchiveModel *)archive
{
    checkResultLabel.hidden = NO;
    doctorHintLabel.hidden = NO;
    iconImage.frame = CGRectMake(15, 15, 54, 49);
    iconImage.image = [UIImage imageNamed:@"pinggu"];
    typeLabel.frame = CGRectMake(iconImage.right+15, 10, 65, 25);
    typeLabel.text = @"症状选择:";
    
    checkResultLabel.frame = CGRectMake(typeLabel.right, typeLabel.top, ScreenWidth-typeLabel.right-15, 25);
    checkResultLabel.text = archive.result;
    
    resultLabel.frame = CGRectMake(typeLabel.left, typeLabel.bottom, 60, 25);
    doctorHintLabel.frame = CGRectMake(checkResultLabel.left, resultLabel.top, ScreenWidth-resultLabel.right-15, 25);
    resultLabel.text = @"ICD-10:";
    resultLabel.textColor = RGB(102, 102, 102);
    doctorHintLabel.text = archive.symptom;
    
    timeLabel.frame = CGRectMake(ScreenWidth-145, 80-25, 130, 25);
    timeLabel.text = [self timestampSwitchTime:archive.time];
    lineImage.frame = CGRectMake(0, 79, ScreenWidth, 1);
}

# pragma mark - 心率图cell
-(void)configXinLvCellWithArchive:(ArchiveModel *)archive
{
    checkResultLabel.hidden = NO;
    doctorHintLabel.hidden = NO;
    iconImage.frame = CGRectMake(15, 20, 50, 41);
    iconImage.image = [UIImage imageNamed:@"archiveElec"];
    
    typeLabel.frame = CGRectMake(iconImage.right+15, 5, 90, 25);
    typeLabel.textColor = [UIColor blackColor];
    typeLabel.text = @"心率监测结果:";
    
    CGFloat checkResultwidth = ScreenWidth - typeLabel.right-5-15;
    
    checkResultLabel.text = archive.result;
    CGSize checkResultSize = [archive.result boundingRectWithSize:CGSizeMake(checkResultwidth, 1200) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont fontWithName:[[UIFont systemFontOfSize:1] fontName] size:14]} context:nil].size;
    double checkResultheight = checkResultSize.height > 25 ? checkResultSize.height : 25;
    checkResultheight = MIN(checkResultheight, 50);
    
    checkResultLabel.frame = CGRectMake(typeLabel.right+5, typeLabel.top, checkResultwidth, checkResultheight);
    
    resultLabel.frame = CGRectMake(typeLabel.left, checkResultLabel.bottom, 115, 25);
    resultLabel.text = @"心电图医生提示:";
    resultLabel.textColor = [UIColor blackColor];
    
    CGFloat doctorHintwidth = ScreenWidth - resultLabel.right-5-15;
    doctorHintLabel.text = archive.symptom;
    CGSize doctorHintSize = [archive.symptom boundingRectWithSize:CGSizeMake(doctorHintwidth, 1200) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont fontWithName:[[UIFont systemFontOfSize:1] fontName] size:14]} context:nil].size;
     CGFloat doctorHintheight = doctorHintSize.height > 25 ? doctorHintSize.height : 25;
    doctorHintLabel.frame = CGRectMake(resultLabel.right+5, resultLabel.top, doctorHintwidth, doctorHintheight);
    checkResultLabel.left = doctorHintLabel.left;
    
    timeLabel.frame = CGRectMake(ScreenWidth-145, 100-25, 130, 25);
    timeLabel.text = [self timestampSwitchTime:archive.time];
    lineImage.frame = CGRectMake(0, 99, ScreenWidth, 1);
}

# pragma mark - 时间戳转换
-(NSString *)timestampSwitchTime:(NSString *)timestamp{
    
    
    timestamp = [NSString stringWithFormat:@"%@",timestamp];
    if(timestamp.length>10){
        timestamp = [timestamp substringToIndex:10];
    }
    
    double stamp = [timestamp doubleValue];
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:stamp];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    
    //将时间转换为字符串
    
    NSString *timeS = [formatter stringFromDate:myDate];
    
    
    
    return timeS;
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
