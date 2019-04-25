//
//  TestCell.h
//  和畅行
//
//  Created by 刘晓明 on 2018/8/16.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  void (^LeftOneBlock) (void);
typedef  void (^LeftTwoBlock) (void);
typedef  void (^RighOneBlock) (void);
typedef  void (^RighTwoBlock) (void);
@interface TestCell : UITableViewCell
@property (nonatomic, copy) LeftOneBlock  leftOneBlock;
@property (nonatomic, copy) LeftTwoBlock  leftTwoBlock;
@property (nonatomic, copy) RighOneBlock  righOneBlock;
@property (nonatomic, copy) RighTwoBlock  righTwoBlock;
@property (nonatomic,strong) UIImageView *iconImage;
@property (nonatomic,strong) UIImageView *arrowImageView;
@property (nonatomic,strong) UILabel *leftLabel;
@property (nonatomic,strong) UILabel *middLabel;
@property (nonatomic,strong) UILabel *rightLabel;
@property (nonatomic,strong) UILabel *left1Label;
@property (nonatomic,strong) UILabel *midd1Label;
@property (nonatomic,strong) UILabel *right1Label;
@property (nonatomic,strong) UILabel *dateLabel;

@property (nonatomic,strong) UIButton *lefttBtn;
@property (nonatomic,strong) UIButton *rightBtn;


@property (nonatomic,strong) CALayer *subLayer;

@property (nonatomic,assign)int typeInt;

@end
