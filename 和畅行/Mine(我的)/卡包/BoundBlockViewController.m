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
@interface BoundBlockViewController ()<UITextFieldDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD* progress_;
}
@property (nonatomic ,retain) UITextField *textField;
@end

@implementation BoundBlockViewController

- (void)dealloc
{
    [super dealloc];
}

-(void)backClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navTitleLabel.text = @"我的卡包";
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *diImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, kNavBarHeight+5, self.view.frame.size.width - 20, 55)];
    
    diImageView.image = [UIImage imageNamed:@"xinkadi.png"];
    [self.view addSubview:diImageView];
    
    UIImageView *kaImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10,20,20,15)];
    
    kaImageView.image = [UIImage imageNamed:@"xinkabao.png"];
    
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(50, 80, self.view.frame.size.width - 70, 55)];
    _textField.delegate = self;
    _textField.placeholder = @"请输入卡号";
    _textField.returnKeyType=UIReturnKeyDone;
    //UIView *redView=[[UIView alloc]initWithFrame:CGRectMake(10, 20, 20, 15)];
    // redView.backgroundColor=[UIColor redColor];
    [diImageView addSubview:kaImageView];
    //    _textField.leftView = redView;
    //    _textField.leftViewMode=UI_textFieldViewModeAlways;
    //    [redView release];
    [self.view addSubview:_textField];
    UIButton *bangButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bangButton.frame = CGRectMake(10, diImageView.bottom+20, self.view.frame.size.width - 20, 45);
    [bangButton setBackgroundImage:[UIImage imageNamed:@"xinkabang.png"] forState:UIControlStateNormal];
    [bangButton addTarget:self action:@selector(bangButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bangButton];
    
    
}
- (void)bangButton{
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
