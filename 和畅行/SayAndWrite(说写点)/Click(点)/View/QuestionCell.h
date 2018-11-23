//
//  QuestionCell.h
//  和畅行
//
//  Created by 刘晓明 on 2018/7/16.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QuestionCell;

@protocol QuestionCellDelegate<NSObject>

- (void)selectAnswerWithNumber:(NSInteger )num;

@end

@interface QuestionCell : UICollectionViewCell

@property (nonatomic,strong) UILabel *title1;
@property (nonatomic,strong) UILabel *title2;
@property (nonatomic,weak) id<QuestionCellDelegate>delegate;

- (void)hideBottomQuestion;
- (void)updateButtonStateWithGrade1:(NSInteger )grade withTag:(NSInteger)tag;
@end
