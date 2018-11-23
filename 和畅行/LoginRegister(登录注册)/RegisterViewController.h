//
//  RegisterViewController.h
//  和畅行
//
//  Created by 刘晓明 on 2018/7/4.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "LoginRequestController.h"

@interface RegisterViewController : LoginRequestController<UITextViewDelegate,UITextFieldDelegate>
{
    CGPoint ptCenter;
    NSTimer* timer;
    int pageNo;
    int STtimeer;
    UIButton* YZMbtn;
    NSString* YZMcode;
    BOOL isagreen;
    UIButton* btnagreen;
}

@property(nonatomic,retain) UITextField* pregistrationTF;
@property (nonatomic,retain) UITextField* pRegist_Sec_TF;
@property(nonatomic,retain) UITextField*  pSecTF;
@property( nonatomic,retain) UITextField* pSureTF;
@property(nonatomic,retain) UITextField * pYzmTF;

@end
