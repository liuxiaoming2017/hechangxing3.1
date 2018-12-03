//
//  GovSectionView.m
//  FounderReader-2.5
//
//  Created by 黄柳姣 on 2018/1/23.
//

#import "GovSectionView.h"
#import "UIImageView+WebCache.h"

@implementation GovSectionView

+ (GovSectionView *)showWithName:(NSString *)nameStr withSection:(NSInteger)section
{
    GovSectionView  *sectionV = [[GovSectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 90)];
    sectionV.backgroundColor = [UIColor clearColor];
    sectionV.tag = 100+section;
    
    UIImage *HeadImage = [UIImage imageNamed:@"五月健康报告"];
    CGFloat imageWidth = HeadImage.size.width;
    CGFloat imageHeight = HeadImage.size.height;
    
    NSLog(@"WIDTH:%f,height:%f,width:%f",HeadImage.size.width,HeadImage.size.height,ScreenWidth);
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-imageWidth)/2.0, 3.5, imageWidth, imageHeight)];
    imageV.image = [UIImage imageNamed:@"五月健康报告"];
    imageV.contentMode = UIViewContentModeScaleToFill;
    [sectionV addSubview:imageV];
    
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
