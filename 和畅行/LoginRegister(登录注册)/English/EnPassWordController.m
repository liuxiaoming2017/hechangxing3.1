//
//  EnPassWordController.m
//  和畅行
//
//  Created by Wei Zhao on 2019/7/16.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "EnPassWordController.h"
#import "EnCodeController.h"
@interface EnPassWordController ()
@property (nonatomic,strong)UITextField *phoneTF;
@end

@implementation EnPassWordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topView.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self layoutEnPassWordView];
}
-(void) layoutEnPassWordView{
    UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, ScreenHeight/ 2 - 140, ScreenWidth - 20, 30)];
    topLabel.text = @"Create a PassWPassword";
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.textColor = RGB_ButtonBlue;
    topLabel.font = [UIFont systemFontOfSize:22];
    [self.view addSubview:topLabel];
    
    
    UITextField *phoneTF = [[UITextField alloc]initWithFrame:CGRectMake(25, topLabel.bottom +  20, ScreenWidth - 50, 30)];
    phoneTF.font = [UIFont systemFontOfSize:15];
    phoneTF.placeholder = @"Password";
    phoneTF.secureTextEntry = YES;
    [self.view addSubview:phoneTF];
    self.phoneTF = phoneTF;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(20, phoneTF.bottom, ScreenWidth - 40, 1)];
    lineView.backgroundColor = RGB_ButtonBlue;
    [self.view addSubview:lineView];
    
    
    UILabel *bottowLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, lineView.bottom + 10, ScreenWidth - 40, 50)];
    bottowLabel.text = @"Enter 6-20 characters, which can be letters, numbers or symbols combination";
    bottowLabel.numberOfLines = 2;
    bottowLabel.textAlignment = NSTextAlignmentCenter;
    bottowLabel.textColor = RGB_TextGray;
    bottowLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:bottowLabel];
    
    
    UIButton *nextButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    nextButton.frame = CGRectMake(20, bottowLabel.bottom + 30, ScreenWidth - 40, 35);
    nextButton.layer.cornerRadius = nextButton.height/2;
    nextButton.layer.masksToBounds = YES;
    [nextButton setTitle:@"Send Code" forState:(UIControlStateNormal)];
    [nextButton setBackgroundColor:RGB_ButtonBlue];
    [[nextButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        if (phoneTF.text.length<6||phoneTF.text.length>20) {
            [self showAlertWarmMessage: @"Enter 6-20 characters, which can be letters, numbers or symbols combination"];
            return;
        }
        
//        EnCodeController *passVC = [[EnCodeController alloc]init];
//        passVC.numberStr = self.myNumberStr;
//        passVC.passWordStr = phoneTF.text;
//        [self.navigationController pushViewController:passVC animated:YES];
//        return ;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = ModuleZW(@"加载中...");
        NSString *iPoneNumber = [NSString stringWithFormat:@"%@ky3h.com",self.myNumberStr];
        NSString *tokenStr = [GlobalCommon md5:iPoneNumber].uppercaseString;
        NSString *urlStr = [NSString string];
        NSDictionary *dic = [NSDictionary dictionary];
        if([self.myNumberStr containsString:@"@"]){
            urlStr  = @"/login/send/email.jhtml";
            dic = @{@"email":self.myNumberStr,
                    @"token":tokenStr};
        }else{
            urlStr  = @"/login/send/phone.jhtml";
            dic = @{@"phone":self.myNumberStr,
                    @"token":tokenStr};
        }
        
        [[NetworkManager sharedNetworkManager] requestWithType:BAHttpRequestTypePost urlString:urlStr parameters:dic successBlock:^(id response) {
            NSLog(@"%@",response);
            [hud hideAnimated:YES];
            if ([response[@"status"] integerValue] == 100){
                EnCodeController *passVC = [[EnCodeController alloc]init];
                passVC.numberStr = self.myNumberStr;
                passVC.passWordStr = phoneTF.text;
                [self.navigationController pushViewController:passVC animated:YES];
            }else{
                if ([GlobalCommon stringEqualNull:response[@"message"]]) {
                    [self showAlertWarmMessage:response[@"data"]];
                }else{
                    [self showAlertWarmMessage:response[@"message"]];
                }
                
            }
        
        } failureBlock:^(NSError *error) {
            [hud hideAnimated:YES];
            [self showAlertWarmMessage:requestErrorMessage];
        }];
        
      
    }];
    [self.view addSubview:nextButton];
    
    RAC(nextButton, enabled) = [RACSignal combineLatest:@[phoneTF.rac_textSignal] reduce:^id _Nullable(NSString * username){
        if(username.length> 0 ) {
            nextButton.backgroundColor = UIColorFromHex(0x1e82d2);
        }else{
            nextButton.backgroundColor = RGB(195, 195, 195);
        }
        return @(username.length);
    }];
    
    
    [self addEnPopButton];
    
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
