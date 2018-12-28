//
//  GovSectionView.m
//  FounderReader-2.5
//
//  Created by 黄柳姣 on 2018/1/23.
//

#import "GovSectionView.h"
#import "UIImageView+WebCache.h"
#import "ResultSpeakController.h"

@implementation GovSectionView

+ (GovSectionView *)showWithModel:(HealthTipsModel *)model {
    GovSectionView  *sectionV = [[GovSectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 90)];
    sectionV.backgroundColor = [UIColor clearColor];
    
    NSString *topColor = [NSString string];
    NSString *bottomColor = [NSString string];
    NSString *quarterStr= [NSString string];
    NSString *timeStr= [NSString string];
    
    NSString *str = [NSString stringWithFormat:@"%@",model.quarter];
    
    int quarter = [str intValue];
    
    if (quarter==1){
        topColor = @"2BAD75";
        bottomColor = @"DBCC61";
        quarterStr = @"第一季度阶段报告";
        timeStr = [NSString stringWithFormat:@"%@.01.01-%@.03.31",model.year,model.year];
    }else if (quarter==2){
        topColor = @"4294E1";
        bottomColor = @"D1BDFF";
        quarterStr = @"第二季度阶段报告";
        timeStr = [NSString stringWithFormat:@"%@.04.01-%@.06.30",model.year,model.year];
    }else if (quarter==3){
        topColor = @"E2862C";
        bottomColor = @"F3D285";
        quarterStr = @"第三季度阶段报告";
        timeStr = [NSString stringWithFormat:@"%@.07.01-%@.09.30",model.year,model.year];
    }else if (quarter==4){
        topColor = @"6673EE";
        bottomColor = @"FCA6D1";
        quarterStr = @"第四季度阶段报告";
        timeStr = [NSString stringWithFormat:@"%@.10.01-%@.12.31",model.year,model.year];
    }
    
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth - 20, 80)];
    [backImageView.layer addSublayer:[UIColor setGradualChangingColor:backImageView fromColor:topColor toColor:bottomColor]];
    backImageView.userInteractionEnabled = YES;
    backImageView.layer.cornerRadius = 10;
    backImageView.layer.masksToBounds = YES;
    [sectionV addSubview:backImageView];
    
    UILabel *quarterLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, backImageView.width, 70)];
    quarterLabel.backgroundColor = [UIColor clearColor];
    quarterLabel.textColor = [UIColor whiteColor];
    quarterLabel.text = quarterStr;
    quarterLabel.textAlignment = NSTextAlignmentCenter;
    quarterLabel.font = [UIFont systemFontOfSize:24];
    [backImageView addSubview:quarterLabel];
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, backImageView.width, 30)];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.text = timeStr;
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.font = [UIFont systemFontOfSize:14];
    [backImageView addSubview:timeLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:sectionV action:@selector(sectionTapAction:)];
    [sectionV addGestureRecognizer:tap];
    
    return sectionV;
}


- (void)sectionTapAction:(UITapGestureRecognizer *)gest
{
    if([self.delegate respondsToSelector:@selector(sectionGestTap:withTapGesture:)]){
        [self.delegate sectionGestTap:self.sect withTapGesture:gest];
    }
}

+ (CGFloat)getSectionHeight
{
    return 90;
}

- (void)setFrame:(CGRect)frame{
    
    CGRect sectionRect = [self.tableView rectForSection:self.section];
    CGRect newFrame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(sectionRect), CGRectGetWidth(frame), CGRectGetHeight(frame)); [super setFrame:newFrame];
}


@end
