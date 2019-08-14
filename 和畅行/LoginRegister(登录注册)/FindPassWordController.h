//
//  FindPassWordController.h
//  和畅行
//
//  Created by 刘晓明 on 2018/7/6.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "LoginRequestController.h"
#import "LPPopup.h"

@interface FindPassWordController : LoginRequestController<UITextFieldDelegate>
{
    CGPoint ptCenter;
    NSString* TempSec;
    NSTimer* timer;
    int pageNo;
    int STtimeer;
    UIButton* YZMbtn;
}
@property(nonatomic,strong) UITextField* RepInputphoneTF;
@property(nonatomic,strong) UITextField* TtempInputsecTF;
@property(nonatomic,strong) UITextField * NewInputSecTF;
@property(nonatomic,strong) UITextField* AgainInputSecTF;
@property(nonatomic,strong) UITextField * pYzmTF;
@property(nonatomic,copy) NSString* YZMcode;
@end
