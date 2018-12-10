//
//  BoundBlockViewController.m
//  Voicediagno
//
//  Created by ZhangYunguang on 16/1/11.
//  Copyright © 2016年 ZhangYunguang. All rights reserved.
//

#import "BoundBlockViewController.h"
#import "LoginViewController.h"
#import "MBProgressHUD.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "SGScanningQRCodeVC.h"
#import "SGAlertView.h"
#import "HCY_InformationController.h"
@interface BoundBlockViewController ()<UITextFieldDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD* progress_;
}
@property (nonatomic ,retain) UITextField *textField;
@end

@implementation BoundBlockViewController



-(void)backClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleLabel.text = @"我的卡包";
    self.view.backgroundColor = [UIColor whiteColor];
  
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, kNavBarHeight + 70, ScreenWidth, 30)];
    titleLabel.text = @"请在输入框输入服务卡号";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:titleLabel];
    
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(15, titleLabel.bottom + 30, ScreenWidth - 30, 55)];
    _textField.delegate = self;
    _textField.layer.cornerRadius = 10;
    _textField.layer.masksToBounds = YES;
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.layer.borderWidth =1.0f;
    _textField.layer.borderColor = RGB_TextAppBlue.CGColor;;
    _textField.placeholder = @"请输入卡号";
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    _textField.returnKeyType=UIReturnKeyDone;
    [self.view addSubview:_textField];
    
    
    UIButton *bangButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bangButton.frame = CGRectMake(ScreenWidth/2 - 75, _textField.bottom+50, 150, 50);
    [bangButton setTitle:@"添加至卡包" forState:(UIControlStateNormal)];
    [bangButton setBackgroundImage:[UIImage imageNamed:@"HCY_ButtonBack"] forState:UIControlStateNormal];
    [bangButton addTarget:self action:@selector(bangButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bangButton];
    
    
    UIButton *flickingBtn = [Tools creatButtonWithFrame:CGRectMake(ScreenWidth/2 - 13 ,ScreenHeight - 200, 50, 50) target:self sel:@selector(flickingClick) tag:31 image:nil title:@"二维码"];
    [flickingBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [flickingBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [flickingBtn setImage:[UIImage imageNamed:@"二维码"] forState:(UIControlStateNormal)];
    [self.view addSubview:flickingBtn];
   
    
     [flickingBtn setTitleEdgeInsets:UIEdgeInsetsMake(flickingBtn.imageView.frame.size.height +30 ,-flickingBtn.imageView.frame.size.width -18, 0.0,0.0)];
    
    
    
}
- (void)bangButton{
    
    HCY_InformationController *informaTionVC = [[HCY_InformationController alloc]init];
    [self.navigationController pushViewController:informaTionVC animated:YES];
    
    if ([_textField.text isEqualToString:@""]) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"卡号不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [av show];
        
        [av release];
        return;
    }
    [self showHUD];
    NSString *UrlPre=URL_PRE;
    NSString *aUrl = [NSString stringWithFormat:@"%@/member/cashcard/bind.jhtml",UrlPre];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:aUrl]];
    [request addRequestHeader:@"token" value:[UserShareOnce shareOnce].token];
    [request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]];
    
    
    //[request setPostValue:self.UrlHttpImg forKey:@"memberImage"];
    
    [request setPostValue:[UserShareOnce shareOnce].uid forKey:@"memberId"];
    //[request setPostValue:[UserShareOnce shareOnce].uid forKey:@"id"];
    [request setPostValue:_textField.text forKey:@"code"];
    
    //    //[request setPostValue:TelephoneLb_Tf.text forKey:@"phone"];
    // [request setPostValue:@"2" forKey:@"weight"];
    //[request setPostValue:[UserShareOnce shareOnce].uid forKey:@"memberId"];
    
    //
    [request addPostValue:[UserShareOnce shareOnce].token forKey:@"token"];
    // [request setPostValue:AddressLb_Tf.text forKey:@"address"];
    
    // [request setPostValue:Certificates_Number_Tf.text forKey:@"idNumber"];
    
    
    [request setTimeOutSeconds:20];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requesstuserinfoError:)];
    [request setDidFinishSelector:@selector(requesstuserinfoCompleted:)];
    [request startAsynchronous];
    
    
}



////扫一扫
-(void)flickingClick {
    
    // 1、 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        SGScanningQRCodeVC *scanningQRCodeVC = [[SGScanningQRCodeVC alloc] init];
                        [self presentViewController:scanningQRCodeVC animated:YES completion:nil];
                    });
                }else {
                }
            }];
        } else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相机
            SGScanningQRCodeVC *scanningQRCodeVC = [[SGScanningQRCodeVC alloc] init];
            [self presentViewController:scanningQRCodeVC animated:YES completion:nil];
        } else if (status == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相机
            SGAlertView *alertView = [SGAlertView alertViewWithTitle:@"⚠️ 警告" delegate:nil contentTitle:@"请去-> [设置 - 隐私 - 相机 - 特卫工分] 打开访问开关" alertViewBottomViewType:(SGAlertViewBottomViewTypeOne)];
            [alertView show];
        } else if (status == AVAuthorizationStatusRestricted) {
        }
    } else {
        SGAlertView *alertView = [SGAlertView alertViewWithTitle:@"⚠️ 警告" delegate:nil contentTitle:@"未检测到您的摄像头, 请在真机上测试" alertViewBottomViewType:(SGAlertViewBottomViewTypeOne)];
        [alertView show];
    }
    
    
    
}
    
    
- (void)requesstuserinfoError:(ASIHTTPRequest *)request
{
    [self hudWasHidden:nil];
    //[SSWaitViewEx removeWaitViewFrom:self.view];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"抱歉，请检查您的网络是否畅通" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
    [av show];
    [av release];
}
- (void)requesstuserinfoCompleted:(ASIHTTPRequest *)request
{
    [self hudWasHidden:nil];
    NSString* reqstr=[request responseString];
    //NSLog(@"dic==%@",reqstr);
    NSDictionary * dic=[reqstr JSONValue];
    //NSLog(@"dic==%@",dic);
    id status=[dic objectForKey:@"status"];
    //NSLog(@"234214324%@",status);
    if ([status intValue]== 100) {
        
        //        sonAccount.name = Yh_TF.text;
        //        sonAccount.gender = SexStr;
        //        sonAccount.birthday = BirthDay_btn.titleLabel.text;
        //
        //        sonAccount.mobile = TelephoneLb_Tf.text;
        //        sonAccount.idCard = CertificatesType;
        //        //[UserShareOnce shareOnce].idNumber=Certificates_Number_Tf.text;
        //        sonAccount.medicare = IsYiBao;
        // [UserShareOnce shareOnce].memberImage=self.UrlHttpImg;
        //NSLog(@"111111%@",[dic objectForKey:@"data"]);
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"信息更新成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [av show];
        av.tag=10007;
        [av release];
        _textField.text = @"";
        
    }
    else if ([status intValue]== 44)
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录超时，请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        av.tag  = 100008;
        [av show];
        [av release];
    }
    else  {
        NSString *str = [dic objectForKey:@"data"];
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        
        [av show];
        [av release];
    }
}
-(void) showHUD
{
    progress_ = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progress_];
    [self.view bringSubviewToFront:progress_];
    progress_.delegate = self;
    progress_.label.text = @"加载中...";
    [progress_ showAnimated:YES];
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    NSLog(@"Hud: %@", hud);
    // Remove HUD from screen when the HUD was hidded
    [progress_ removeFromSuperview];
    [progress_ release];
    progress_ = nil;
    
}
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // alert.tag=10002;
    //    if (alertView.tag==10007)
    //    {
    //        [self.navigationController popViewControllerAnimated:YES];
    //    }else
    if (alertView.tag==100008)
    {
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    
}

#pragma mark -- UITextFieldDelegate --代理方法的实现
//这个方法会询问代理对象是否允许输入框进入编辑状态
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"%s",__FUNCTION__);
    return YES;
}
//已经进入编辑状态
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"%s",__FUNCTION__);
}
//询问代理对象是否结束编辑
- (BOOL)textFieldShouldEnditing:(UITextField *)textField{
    NSLog(@"%s",__FUNCTION__);
    return YES;
}

//完成编辑时的代理方法
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"%s",__FUNCTION__);
}
//替换已有的字符
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"range=%@",NSStringFromRange(range));
    NSLog(@"string=%@",string);
    return YES;
}
//询问代理对象是否返回
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"%s",__FUNCTION__);
    //释放第一响应者
    [textField resignFirstResponder];
    return YES;
}
//询问代理对象是否允许清空已有的文本内容
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    NSLog(@"%s",__FUNCTION__);
    return YES;
}


- (void)dealloc
{
    [super dealloc];
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
