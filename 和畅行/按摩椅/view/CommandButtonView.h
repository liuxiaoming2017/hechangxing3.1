//
//  CommandButtonView.h
//  和畅行
//
//  Created by 刘晓明 on 2019/9/11.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ArmChairModel;


@protocol CommandButtonDelegate <NSObject>

- (void)commandActionWithModel:(ArmChairModel *)model withTag:(NSInteger )tag;

@end

@interface CommandButtonView : UIView

@property (nonatomic,strong) UIButton *commandButton;
@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) ArmChairModel *model;

@property (nonatomic ,weak) id <CommandButtonDelegate> delegate;


- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)title;

- (id)initWithFrame:(CGRect)frame withModel:(ArmChairModel *)model;

- (void)setButtonViewSelect:(BOOL)select;

- (void)setButtonViewSelect:(BOOL)select WithImageStr:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
