//
//  NavBarViewController.h
//  和畅行
//
//  Created by 刘晓明 on 2018/7/11.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubMemberView.h"

@interface NavBarViewController : UIViewController

@property (nonatomic,strong) UIView *topView;

@property (nonatomic,strong) UILabel  *navTitleLabel;

@property (nonatomic,strong) UIButton *preBtn;

@property (nonatomic,strong) UIButton *rightBtn;

@property (nonatomic,strong) UIButton *leftBtn;

- (void)showAlertViewController:(NSString *)message;

- (void)showAlertWarmMessage:(NSString *)message;

- (void)goBack:(UIButton *)btn;

- (void)userBtnAction:(UIButton *)btn;
@end
