//
//  RemindRegAlertView.m
//  
//
//  Created by wangdong on 16/3/3.
//
//

#import "RemindRegAlertView.h"
#import "ImgTextView.h"
#import "UIButton+Bootstrap.h"
#import "UIViewController+CWPopup.h"
#import <moxibustion/BlueToothCommon.h>
#import "OMGToast.h"
#import "MBProgressHUD.h"
//#import "MachineInfo.h"
#import "UIView+FirstResponder.h"
#import "PubFunc.h"

@interface RemindRegAlertView ()<MBProgressHUDDelegate>
@property (weak, nonatomic) IBOutlet ImgTextView *mobileNumberView;
@property (weak, nonatomic) IBOutlet ImgTextView *passwordView;
@property (weak, nonatomic) IBOutlet UIView *btn3View;
@property (weak, nonatomic) IBOutlet UIView *btn2View;
@property (weak, nonatomic) IBOutlet UIButton *remindNext3Btn;
@property (weak, nonatomic) IBOutlet UIButton *login3Btn;
@property (weak, nonatomic) IBOutlet UIButton *register3Btn;

@property (weak, nonatomic) IBOutlet UIButton *login2Btn;
@property (weak, nonatomic) IBOutlet UIButton *register2Btn;

@property (weak, nonatomic) UIViewController *vc;
@property (strong, nonatomic) MBProgressHUD *progressView;
@property (strong, nonatomic) NSString *userName;
@property (assign, nonatomic) int webResult;

@end

@implementation RemindRegAlertView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initViewAndDatas];
}

- (void)initViewAndDatas {
    [_mobileNumberView setLImage:[UIImage imageNamed:@"login_ic_user.png"]];
    [_passwordView setLImage:[UIImage imageNamed:@"login_ic_password.png"]];
    [_mobileNumberView setPlaceHolder:@"请输入手机号/用户名"];
    _mobileNumberView.filterStr = @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.@-";
    [_passwordView getInputView].text = _password;
    [_passwordView getInputView].enabled = NO;
    [_mobileNumberView setKeyBoardType:UIKeyboardTypeDefault maxInputLen:30];
    [_passwordView setKeyBoardType:UIKeyboardTypeDefault maxInputLen:16];
    
    if (_type == 3) {
        _btn2View.hidden = YES;
        [_remindNext3Btn withBorder:1 normalColor:[UIColor whiteColor] pressedColor:PRESSED_BTN_COLOR];
        [_login3Btn withBorder:1 normalColor:[UIColor whiteColor] pressedColor:PRESSED_BTN_COLOR];
        [_register3Btn normalColor:NORMAL_BTN_COLOR pressedColor:PRESSED_BTN_COLOR];
    }else {
        _btn3View.hidden = YES;
        [_login2Btn withBorder:1 normalColor:[UIColor whiteColor] pressedColor:PRESSED_BTN_COLOR];
        [_register2Btn normalColor:NORMAL_BTN_COLOR pressedColor:PRESSED_BTN_COLOR];
    }
}

- (void)setBlurView:(UIViewController*)blueView {
    _vc = blueView;
}

- (IBAction)onClickControl:(id)sender {
    [[_mobileNumberView getInputView] resignFirstResponder];
}

- (IBAction)onClickRemindNextBtn:(id)sender {
    [_vc dismissPopupViewControllerAnimated:YES completion:nil];
    if (_clickDelegate && [_clickDelegate respondsToSelector:@selector(RemindRegOnClickBtn:)]) {
        [_clickDelegate RemindRegOnClickBtn:@"remindNext"];
    }
}

- (IBAction)onClickLoginBtn:(id)sender {
    [[self.view findFirstResponder] resignFirstResponder];
//    NSString *number = [_mobileNumberView getInputText];
//    if ([PubFunc isEmpty:number]) {
//        [OMGToast shakeMessage:@"请输入您的手机号" duration:1.5f attchView:_mobileNumberView];
//        return;
//    }
//    
//    if (![PubFunc isMobileNo:[_mobileNumberView getInputText]]) {
//        [OMGToast shakeMessage:@"这不是个手机号码" duration:1.5f attchView:_mobileNumberView];
//        return;
//    }
    
//    [_vc dismissPopupViewControllerAnimated:YES completion:nil];
    if (_clickDelegate && [_clickDelegate respondsToSelector:@selector(RemindRegOnClickBtn:)]) {
        [_clickDelegate RemindRegOnClickBtn:[NSString stringWithFormat:@"login%@", @""]];
    }
}

- (IBAction)onClickRegisterBtn:(id)sender {
    [[self.view findFirstResponder] resignFirstResponder];
    NSString *number = [_mobileNumberView getInputText];
    if ([PubFunc isEmpty:number]) {
        [OMGToast shakeMessage:@"请输入手机号/用户名" duration:1.5f attchView:_mobileNumberView];
        return;
    }
    
//    if (![PubFunc isMobileNo:[_mobileNumberView getInputText]]) {
//        [OMGToast shakeMessage:@"这不是个手机号码" duration:1.5f attchView:_mobileNumberView];
//        return;
//    }
    
    
    if (_clickDelegate && [_clickDelegate respondsToSelector:@selector(RemindRegOnClickBtn:)]) {
        [_clickDelegate RemindRegOnClickBtn:[NSString stringWithFormat:@"register%@", number]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
