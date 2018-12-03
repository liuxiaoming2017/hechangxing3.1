//
//  GovSectionView.h
//  FounderReader-2.5
//
//  Created by 黄柳姣 on 2018/1/23.
//

#import <UIKit/UIKit.h>
@class GovSectionView;

@protocol govSectionViewDelegate<NSObject>
- (void)sectionGestTap:(NSInteger)section withTapGesture:(UITapGestureRecognizer *)gest;
@end

@interface GovSectionView : UIView

@property NSUInteger section;
@property (nonatomic,assign) NSInteger sect;
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, weak) id<govSectionViewDelegate>delegate;

+ (GovSectionView *)showWithName:(NSString *)nameStr withSection:(NSInteger)section;
+ (CGFloat)getSectionHeight;
@end
