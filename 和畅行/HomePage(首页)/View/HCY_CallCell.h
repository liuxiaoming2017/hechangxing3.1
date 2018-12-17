//
//  HCY_CallCell.h
//  和畅行
//
//  Created by 出神入化 on 2018/12/12.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCY_CallCell : UITableViewCell

typedef void (^ComeToNextBlack) (HCY_CallCell *);

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeLabel;
@property (weak, nonatomic) IBOutlet UIButton *comeButton;

@property (nonatomic,copy) ComeToNextBlack comeToNextBlock;
-(void)cellsetAttributewithIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
