//
//  EnRegistrController.m
//  和畅行
//
//  Created by Wei Zhao on 2019/7/16.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "EnRegistrController.h"
#import "EnPassWordController.h"
@interface EnRegistrController ()<UITextFieldDelegate>
@property (nonatomic,strong)UIView *backView;
@property (nonatomic,assign)BOOL isPhone;
@property (nonatomic,strong)UITextField *phoneTF;
@end

@implementation EnRegistrController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topView.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self layoutRegistView];
    self.isPhone = YES;
    
}
//布局注册页面
-(void)layoutRegistView {
    
    
    UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, ScreenHeight/ 2 - 140, ScreenWidth - 20, 30)];
    topLabel.text = @"What's Your MobMobile Number?";
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.textColor = RGB_ButtonBlue;
    topLabel.font = [UIFont systemFontOfSize:22];
    [self.view addSubview:topLabel];
    
    UILabel *areaNumberLB = [[UILabel alloc]initWithFrame:CGRectMake(20, topLabel.bottom + 20, 50, 30)];
    areaNumberLB.text = @"US  +1";
    areaNumberLB.font = [UIFont systemFontOfSize:15];
    areaNumberLB.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:areaNumberLB];
    
    
    UITextField *phoneTF = [[UITextField alloc]initWithFrame:CGRectMake(80, topLabel.bottom +  20, ScreenWidth - 100, 30)];
    phoneTF.font = [UIFont systemFontOfSize:15];
    phoneTF.delegate = self;
    phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:phoneTF];
    
    self.phoneTF = phoneTF;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(20, phoneTF.bottom, ScreenWidth - 40, 1)];
    lineView.backgroundColor = RGB_ButtonBlue;
    [self.view addSubview:lineView];
    
    UIButton *nextButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    nextButton.frame = CGRectMake(20, lineView.bottom + 15, ScreenWidth - 40, 35);
    nextButton.layer.cornerRadius = nextButton.height/2;
    nextButton.layer.masksToBounds = YES;
    [nextButton setTitle:@"Next" forState:(UIControlStateNormal)];
    [nextButton setBackgroundColor:RGB_ButtonBlue];
     __weak typeof(self) weakself = self;
    [[nextButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        if(self.isPhone == NO){
            
            if(![weakself isValidateEmail:phoneTF.text]){
                 [self showAlertWarmMessage:@"incorrect format of phone number/Email address"];
                return ;
            }
        }else{
            if(phoneTF.text.length != 10 ){
                 [self showAlertWarmMessage:@"incorrect format of phone number/Email address"];
                return ;
            }
            
            if(![weakself deptNumInputShouldNumber:phoneTF.text] ){
                [self showAlertWarmMessage:@"incorrect format of phone number/Email address"];
                return ;
            }
        }
      
        EnPassWordController *passVC = [[EnPassWordController alloc]init];
        passVC.myNumberStr = phoneTF.text;
        [weakself.navigationController pushViewController:passVC animated:YES];
    }];
    [self.view addSubview:nextButton];
    
   
    
    UIButton *changeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    changeButton.frame = CGRectMake(20, nextButton.bottom + 30, ScreenWidth - 40, 35);
    changeButton.layer.cornerRadius = nextButton.height/2;
    changeButton.layer.masksToBounds = YES;
    [changeButton setTitle:@"User your email address" forState:(UIControlStateNormal)];
    [changeButton setTitleColor:RGB_ButtonBlue forState:(UIControlStateNormal)];
    [changeButton setBackgroundColor:RGB(232, 241, 255)];
    [[changeButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [phoneTF resignFirstResponder];
        phoneTF.text = @"";
        if([changeButton.titleLabel.text isEqualToString:@"User your email address"]){
            [changeButton setTitle:@"User your mobile number" forState:(UIControlStateNormal)];
            topLabel.text = @"What's Your Email Address?";
            areaNumberLB.hidden = YES;
            phoneTF.keyboardType = UIKeyboardTypeDefault;
            [phoneTF becomeFirstResponder];
            self.isPhone = NO;
            phoneTF.left = 30;
        }else{
            [changeButton setTitle:@"User your email address" forState:(UIControlStateNormal)];
            topLabel.text = @"What's Your Mobile Number?";
             areaNumberLB.hidden = NO;
            self.isPhone = YES;
            phoneTF.keyboardType = UIKeyboardTypeNumberPad;
            [phoneTF becomeFirstResponder];
            phoneTF.left = 80;
        }
        [UIView animateWithDuration:0.5 animations:^{
            self.backView.alpha = 1;
        }];
        [UIView animateWithDuration:0.5 animations:^{
            self.backView.alpha = 0;
        }];
        
        
    }];
    [self.view addSubview:changeButton];
    
    RAC(nextButton, enabled) = [RACSignal combineLatest:@[phoneTF.rac_textSignal] reduce:^id _Nullable(NSString * username){
        if(username.length> 0 ) {
            nextButton.backgroundColor = UIColorFromHex(0x1e82d2);
        }else{
            nextButton.backgroundColor = RGB(195, 195, 195);
        }
        return @(username.length);
    }];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.alpha = 0;
    [self.view addSubview:backView];
    self.backView = backView;
    
    [self addEnPopButton];
    
}

//判断是否为电话号码

- (BOOL) deptNumInputShouldNumber:(NSString *)str
{
    if (str.length == 0) {
        return NO;
    }
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:str]) {
        return YES;
    }
    return NO;
}

-(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    return [emailTest evaluateWithObject:email];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.phoneTF endEditing:YES];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.phoneTF becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.phoneTF endEditing:YES];
}




@end
