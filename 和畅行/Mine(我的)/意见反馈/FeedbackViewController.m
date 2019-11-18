//
//  MoreProductinfoViewController.m
//  Voicediagno
//
//  Created by wangfeng on 14-9-10.
//  Copyright (c) 2014年 wangfeng. All rights reserved.
//

#import "FeedbackViewController.h"
//#import "LBReadingTimeScrollPanel.h"
#import "Global.h"

#import "LoginViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
@interface FeedbackViewController ()<UITextViewDelegate>
@property(nonatomic,retain) UITextView* acceptTV;
@property (nonatomic ,retain) UILabel *textLabel;
@property (nonatomic,strong)UIButton *submitBT;

@end

@implementation FeedbackViewController
@synthesize acceptTV=_acceptTV;
- (void)dealloc{
   
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)goBack:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.view.backgroundColor=[UtilityFunc colorWithHexString:@"#ffffff"];
    
    self.navTitleLabel.text = ModuleZW(@"意见反馈");
    
    UIImage* userImg=[UIImage imageNamed:@"Feedback_UserImg.png"];
    UIImageView* UserImgView=[[UIImageView alloc] init];
    UserImgView.frame=CGRectMake(16.5, kNavBarHeight+10.5, userImg.size.width/2, userImg.size.height/2);
    UserImgView.image=userImg;
    [self.view addSubview:UserImgView];
   
    UILabel* UserNameLb=[[UILabel alloc ] init];
    UserNameLb.frame=CGRectMake(UserImgView.right+8.5, kNavBarHeight+10.5, ScreenWidth -UserImgView.right -12 , userImg.size.height/2);
    UserNameLb.text=ModuleZW(@"感谢您提出的宝贵意见");
    UserNameLb.textColor=[UtilityFunc colorWithHexString:@"#333333"];
    UserNameLb.font=[UIFont systemFontOfSize:12];
    [self.view addSubview:UserNameLb];
   

    
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(CancelButtonAction)];
    
    //  NSLog(@"dddd=%f",lb3.frame.origin.y);
    [self.view addGestureRecognizer:tap];
   
    UILabel* Linelb1=[[UILabel alloc] init];
    Linelb1.frame=CGRectMake(0, kNavBarHeight+ScreenWidth*0.093, ScreenWidth, 1);
    Linelb1.backgroundColor=[UtilityFunc colorWithHexString:@"#e7e7e5"];
    [self.view addSubview:Linelb1];
    
    _textLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth*0.027, kNavBarHeight+ScreenWidth*0.12, ScreenWidth-ScreenWidth*0.054, ScreenWidth*0.053)];
    _textLabel.text = ModuleZW(@" 请提出您的宝贵意见");
    _textLabel.font = [UIFont systemFontOfSize:13];
    _textLabel.textColor = [UtilityFunc colorWithHexString:@"#666666"];
    [self.view addSubview:_textLabel];
    _acceptTV=[[UITextView alloc] init];
    _acceptTV.delegate=self;
    //_acceptTV.placeholder=@"";
    _acceptTV.textColor = [UtilityFunc colorWithHexString:@"#666666"];
    _acceptTV.font = [UIFont systemFontOfSize:13];
    _acceptTV.backgroundColor=[UIColor clearColor];
    _acceptTV.keyboardAppearance = UIKeyboardTypePhonePad;
//    _acceptTV.textColor=[UtilityFunc colorWithHexString:@"#676767"];
    UIView *grayView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, ScreenWidth*0.1067)];
    grayView.backgroundColor=[UtilityFunc colorWithHexString:@"#f1f3f6"];
   // _acceptTV.inputAccessoryView=grayView;
    _acceptTV.tag = 125;
    [_acceptTV setReturnKeyType:UIReturnKeyDone];
    //_textLabel.hidden = [_acceptTV hasText];
    UIButton *doneButton=[UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame=CGRectMake(self.view.frame.size.width - ScreenWidth*0.21, 0, ScreenWidth*0.42, ScreenWidth*0.1067);
    //设置按钮的标题UIControlStateNormal是按钮正常显示的状态
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    //改变字体颜色
    [doneButton setTitleColor:[UIColor blackColor] forState : UIControlStateNormal];
    //给按钮响应方法
    [doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChanges:) name:UITextViewTextDidChangeNotification object:self.acceptTV];
    [grayView addSubview:doneButton];
    
//    [_acceptTV.layer setMasksToBounds:YES];
    _acceptTV.frame=CGRectMake(ScreenWidth*0.027, _textLabel.top, ScreenWidth-ScreenWidth*0.054, (ScreenHeight-kNavBarHeight-ScreenWidth*0.096)/2);
    [self.view addSubview:_acceptTV];
    
    UILabel* Linelb2=[[UILabel alloc] init];
    Linelb2.frame=CGRectMake(0, _acceptTV.frame.origin.y+_acceptTV.frame.size.height+1, ScreenWidth, 1);
    Linelb2.backgroundColor=[UtilityFunc colorWithHexString:@"#e7e7e5"];
    [self.view addSubview:Linelb2];
   
    
    UIButton *findpsButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [findpsButton setTitle:ModuleZW(@"提交") forState:(UIControlStateNormal)];
    [findpsButton setBackgroundColor:RGB_ButtonBlue];
    findpsButton.frame=CGRectMake((ScreenWidth-ScreenWidth*0.266)/2,_acceptTV.bottom + ScreenWidth*0.133, ScreenWidth*0.266,ScreenWidth*0.08);
    findpsButton.layer.cornerRadius = findpsButton.height/2;
    findpsButton.layer.masksToBounds = YES;
    [findpsButton addTarget:self action:@selector(userFeedbackButton) forControlEvents:UIControlEventTouchUpInside];
    findpsButton.userInteractionEnabled = NO;
    findpsButton.alpha = 0.4;
    _submitBT = findpsButton;
    [self.view addSubview:findpsButton];
       // Do any additional setup after loading the view.
}
- (void)textDidChanges:(NSNotificationCenter*)notifi{
    _textLabel.hidden = [_acceptTV hasText];
    if([_acceptTV hasText]){
        _submitBT.userInteractionEnabled = YES;
        _submitBT.alpha = 1;
    }else{
        _submitBT.userInteractionEnabled = NO;
        _submitBT.alpha = 0.4;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
       // [self.view endEditing:YES];
        return NO;//这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}



- (void)doneButtonAction:(UIButton *)sender{
    NSLog(@"%s",__FUNCTION__);
    //点击此按钮，就撤出按钮，键盘收回
    //    第一步，找到键盘响应者
    UITextView *_textField=(UITextView *)[self.view viewWithTag:125];
    //找到之后，释放第一响应者
    [_textField resignFirstResponder];
    
    //移除一个响应事件
    //    [sender removeTarget:self action:@selector(doneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    if(![text isEqualToString:@""])
//    {
//        [_textLabel setHidden:YES];
//    }
//    if([text isEqualToString:@""]&&range.length==1&&range.location==0){
//        [_textLabel setHidden:NO];
//    }
//    if ([text isEqualToString:@"\n"]) {
//        [textView resignFirstResponder];
//        
//        return NO;
//    }
//    return YES;
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)userFeedbackButton
{
    if (_acceptTV.text.length==0) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:ModuleZW(@"提示") message:ModuleZW(@"请填写反馈意见") delegate:nil cancelButtonTitle:ModuleZW(@"确定") otherButtonTitles:nil,nil];
        [av show];
        
        return;

    }
    NSString *UrlPre=URL_PRE;
    NSString *aUrlle= [NSString stringWithFormat:@"%@member_suggest/commit.jhtml?memberId=%@&content=%@",UrlPre,[UserShareOnce shareOnce].uid,_acceptTV.text];
    aUrlle = [aUrlle stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url1 = [NSURL URLWithString:aUrlle];
    ASIFormDataRequest *request=[[ASIFormDataRequest alloc]initWithURL:url1];
    if([UserShareOnce shareOnce].languageType){
        [request addRequestHeader:@"language" value:[UserShareOnce shareOnce].languageType];
    }
    // [request addRequestHeader:@"token" value:g_userInfo.token];
    //后面加的10.11
    [request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request setDidFailSelector:@selector(requestFeedbackError:)];//requestLoginError
    [request setDidFinishSelector:@selector(requestFeedbackCompleted:)];
    [request startAsynchronous];
    
}
- (void)requestFeedbackError:(ASIHTTPRequest *)request
{
    //[self hudWasHidden:nil];
    //[SSWaitViewEx removeWaitViewFrom:self.view];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:ModuleZW(@"提示") message:ModuleZW(@"抱歉，请检查您的网络是否畅通") delegate:self cancelButtonTitle:ModuleZW(@"确定") otherButtonTitles:nil,nil];
    [av show];
    
}
- (void)requestFeedbackCompleted:(ASIHTTPRequest *)request
{
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    id status=[dic objectForKey:@"status"];
    if ([status intValue]==100)
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:ModuleZW(@"提示") message:ModuleZW(@"意见反馈成功") delegate:self cancelButtonTitle:ModuleZW(@"确定") otherButtonTitles:nil,nil];
        av.tag = 1000;
        [av show];
        
    }
    else
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:ModuleZW(@"提示") message:ModuleZW(@"登录超时，请重新登录") delegate:self cancelButtonTitle:ModuleZW(@"确定") otherButtonTitles:nil,nil];
        av.tag =  100008;
        [av show];
        
    }
}
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // alert.tag=10002;
    if (alertView.tag==100008)
    {
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    if (alertView.tag==1000) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)CancelButtonAction
{
    
}
//- (void)textViewDidEndEditing:(UITextView *)textView {
//    
//    [textView resignFirstResponder];
//    [self restoreView ];
//    
//}
//-(void)textViewDidBeginEditing:(UITextView *)textView {
//    
//    [self performSelector:@selector(resizeViewForInput:) withObject:textView];
//    
//}
-(void)resizeViewForInput:(id)sender
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //上移30个单位，按实际情况设置
    CGRect rect=CGRectMake(0.0f,-60,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
}
-(void)restoreView
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //如果当前View是父视图，则Y为20个像素高度，如果当前View为其他View的子视图，则动态调节Y的高度
    CGRect rect=CGRectMake(0.0f,0,width,height);
    self.view.frame=rect;
    //  NSLog(@"%f %f %f %f",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_acceptTV resignFirstResponder];
}
#pragma mark - UITextView Delegate Methods
//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    if ([text isEqualToString:@"\n"]) {
//        [textView resignFirstResponder];
//        return NO;
//    }
//    return YES;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
