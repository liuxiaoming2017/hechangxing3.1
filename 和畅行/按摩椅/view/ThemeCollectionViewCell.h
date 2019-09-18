//
//  ThemeCollectionViewCell.h
//  和畅行
//
//  Created by 刘晓明 on 2019/9/10.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ThemeCollectionViewCell;
@class ArmChairModel;

@protocol ThemeCollectionCellDelegate<NSObject>

- (void)selectTackWithModel:(ArmChairModel *)model;

@end

@interface ThemeCollectionViewCell : UICollectionViewCell
@property (nonatomic,weak) id<ThemeCollectionCellDelegate>delegate;
- (void)reloadDataWithArray:(NSArray *)array;
@end

NS_ASSUME_NONNULL_END
