//
//  QuestionTableCell.h
//  和畅行
//
//  Created by 刘晓明 on 2019/4/29.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QuestionTableCell : UITableViewCell

//@property (nonatomic ,strong) UILabel *indexLabel;
//@property (nonatomic ,strong) UILabel *contentLabel;
//@property (nonatomic ,strong) UILabel *answerLabel;
//@property (nonatomic, strong) UIView *rightView;

@property (weak, nonatomic) IBOutlet UILabel *indexLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *rightView;

@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

- (CGFloat)setCellHeight:(NSString *)str;
- (void)setanswerLabelContent:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
