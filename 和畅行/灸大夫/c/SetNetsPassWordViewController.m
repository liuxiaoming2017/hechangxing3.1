//
//  SetNetsPassWordViewController.m
//  MoxaYS
//
//  Created by xuzengjun on 16/11/29.
//  Copyright © 2016年 jiudaifu. All rights reserved.
//

#import "SetNetsPassWordViewController.h"
#import "ImgTextView.h"
#import "KeyBoardManager.h"
#import "UIView+FirstResponder.h"
#import "i9_MoxaMainViewController.h"
#import "OMGToast.h"
#import "PubFunc.h"
#import <moxibustion/moxibustion.h>

@interface SetNetsPassWordViewController ()
@property (weak, nonatomic) IBOutlet ImgTextView *mNewPwd;
@property (weak, nonatomic) IBOutlet ImgTextView *mOldPwd;
@property (weak, nonatomic) IBOutlet UIButton *mSureBtn;
@property (weak, nonatomic) IBOutlet UIButton *mCancleBtn;
@property (strong, nonatomic) IBOutlet UIControl *mCntrolview;

@end

@implementation SetNetsPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.topView.backgroundColor = UIColorFromHex(0x1e82d2);
    self.leftBtn.hidden = YES;
    self.rightBtn.hidden = YES;
    self.preBtn.hidden = NO;
    self.navTitleLabel.text = @"设置灸头网络密码";
    self.navTitleLabel.textColor = [UIColor whiteColor];
    
    [self initData];
    [self initView];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationItem.title = @"设置灸头网络密码";
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(void)initView{
    //_mNewPwd.frame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    [_mNewPwd setPlaceHolder:@"请输入新密码"];
    [_mOldPwd setPlaceHolder:@"再次输入新密码"];
//    [_mNewPwd setLImage:[UIImage imageNamed:@"login_ic_password.png"]];
//    [_mOldPwd setLImage:[UIImage imageNamed:@"login_ic_password.png"]];
    [_mNewPwd setSecure:YES];
    [_mOldPwd setSecure:YES];
    [_mNewPwd setKeyBoardType:UIKeyboardTypePhonePad maxInputLen:3];
    [_mOldPwd setKeyBoardType:UIKeyboardTypePhonePad maxInputLen:3];
    [[KeyBoardManager sharedInstance] configViewControl:self responderView:_mNewPwd, _mOldPwd, nil];
    [_mCntrolview addTarget:self action:@selector(onClickControl:) forControlEvents:UIControlEventTouchUpInside];
    _mSureBtn.layer.masksToBounds = YES;
    _mSureBtn.layer.cornerRadius = 5;
    
    _mCancleBtn.layer.masksToBounds = YES;
    _mCancleBtn.layer.cornerRadius = 5;
}

- (IBAction)onClickControl:(id)sender {
    [[self.view findFirstResponder] resignFirstResponder];
}

-(void)initData{

}

-(BOOL)JugdePwd{
    if([PubFunc isEmpty:[_mNewPwd getInputText]] && [PubFunc isEmpty:[_mOldPwd getInputText]]){
        [OMGToast showWithText:@"请输入您要设置的密码" duration:1.5f];
        return NO;
    }
    if(![[_mNewPwd getInputText] isEqualToString:[_mOldPwd getInputText]]){
        [OMGToast showWithText:@"两次密码不符,请重新输入" duration:1.5f];
        [_mNewPwd setInputText:@""];
        [_mOldPwd setInputText:@""];
        return NO;
    }
    return YES;
}

- (IBAction)SureBtnOnclinck:(id)sender {
    if([self JugdePwd]){
        if([_fatherVC isKindOfClass:[i9_MoxaMainViewController class]]){
            i9_MoxaMainViewController *vc = (i9_MoxaMainViewController*)_fatherVC;
            [vc SetPassWord:[_mNewPwd getInputText] ISsetpwd_:YES];
            [self.navigationController popToViewController:_fatherVC animated:YES];
        }
    }
}

- (IBAction)mCancleBtnOnclink:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
