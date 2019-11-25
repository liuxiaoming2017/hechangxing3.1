//
//  PostButtonView.h
//  和畅行
//
//  Created by 刘晓明 on 2019/11/19.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ArmChairModel;

NS_ASSUME_NONNULL_BEGIN

@interface PostButtonView : UIView

@property (nonatomic,strong) UIButton *commandButton;
@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) ArmChairModel *model;

- (id)initWithFrame:(CGRect)frame withModel:(ArmChairModel *)model;



@end

NS_ASSUME_NONNULL_END
