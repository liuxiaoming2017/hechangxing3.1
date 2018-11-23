//
//  LoginViewController.h
//  和畅行
//
//  Created by 刘晓明 on 2018/7/4.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "LoginRequestController.h"

@interface LoginViewController :LoginRequestController<UITextFieldDelegate>
{
    UITextField *userNameBox;
    //UITextField *passWordBox;
    BOOL isCheck;
    BOOL isPush;
    NSTimer* timer;
    int pageNo;
}

@property (nonatomic,assign) BOOL isChangeUser;

@end
