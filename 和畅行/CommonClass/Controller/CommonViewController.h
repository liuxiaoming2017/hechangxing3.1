//
//  CommonViewController.h
//  和畅行
//
//  Created by 刘晓明 on 2018/7/2.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonViewController : UIViewController

@property (nonatomic,strong) UILabel  *navTitleLabel;

- (void)showAlertViewController:(NSString *)message;

- (void)showAlertWarmMessage:(NSString *)message;
@end
