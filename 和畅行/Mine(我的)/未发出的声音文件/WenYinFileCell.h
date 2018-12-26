//
//  WenYinFileCell.h
//  和畅行
//
//  Created by 刘晓明 on 2018/12/26.
//  Copyright © 2018 刘晓明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class WenYinFileCell;
@protocol WenYinFileCellDelegate<NSObject>
@optional
@optional

- (void)upLoadButton:(UIButton *)btn;
- (void)deleteButton:(UIButton *)btn;

@end

@interface WenYinFileCell : UITableViewCell
@property (nonatomic ,retain) UILabel *lbname;
@property (nonatomic ,retain) UILabel *lbDate;
@property (nonatomic ,retain) UIButton *CellAcessImgView;
@property (nonatomic ,retain) UIButton *CellDeleImgView;
@property (nonatomic,weak) id<WenYinFileCellDelegate>delegate;

- (void)showCellViewWithString1:(NSString *)string1 withString2:(NSString *)string2 string3:(NSString *)string3;

@end

NS_ASSUME_NONNULL_END
