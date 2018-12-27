//
//  LoginRequestController.h
//  和畅行
//
//  Created by 刘晓明 on 2018/7/6.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginRequestController : UIViewController
{
    UIView *navView;
    UILabel *titleLabel;
    UITextField *passWordBox;
}

- (void)addBackBtn;
- (void)addRightBtn;
- (void)registAction;

- (void)userLoginWithParams:(NSDictionary *)paramDic withisCheck:(BOOL)isCheck;

- (void)userLoginWithWeiXParams:(NSDictionary *)paramDic withCheck:(NSInteger)check;

- (void)userLoginWithShortMessage:(NSString *)phoneStr;

- (void)showAlertViewController:(NSString *)message;
- (void)showAlertWarmMessage:(NSString *)message;
@end
