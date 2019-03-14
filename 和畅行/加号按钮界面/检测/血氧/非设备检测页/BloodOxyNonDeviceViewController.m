//
//  BloodOxyNonDeviceViewController.m
//  Voicediagno
//
//  Created by Mymac on 15/9/28.
//  Copyright (c) 2015年 Mymac. All rights reserved.
//

#import "BloodOxyNonDeviceViewController.h"
#import "AdvisoryTableViewCell.h"
#import "LoginViewController.h"
#import "SubMemberView.h"

#define NUMBERS @"0123456789.n"
#define kNomal  ModuleZW(@"血氧饱和度正常。")
#define kLow ModuleZW(@"血氧饱和度偏低。建议监测，若持续偏低，请及时到医院就诊。")

@interface BloodOxyNonDeviceViewController ()<UITextFieldDelegate,MBProgressHUDDelegate,ASIHTTPRequestDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_TextFieldArr;
}
/**textField*/
@property (nonatomic,strong) UITextField *textField;
/**subId*/
@property (nonatomic,copy) NSString *subId;
@end

@implementation BloodOxyNonDeviceViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _TextFieldArr = [[NSMutableArray alloc] init];
     self.navTitleLabel.text  =ModuleZW(@"血氧检测");
    [self initWithController];
    [self bounceView];
}
#pragma mark ------ 弹出视图
-(void)bounceView{
    //弹出视图
    self.dataArr = [[NSMutableArray alloc]init];
    self.headArray = [[NSMutableArray alloc]init];
    _personView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _personView.backgroundColor = [UIColor blackColor];
    _personView.alpha = 0.3;
    [self.view addSubview:_personView];
    _showView = [[UIView alloc]initWithFrame:CGRectMake(30, 100, self.view.frame.size.width - 60, self.view.frame.size.height - 190)];
    _showView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_showView];
  
    
    _showView.hidden = YES;
    _personView.hidden = YES;
    
    //_showView添加点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScreen:)];
    [_personView addGestureRecognizer:tap];
    
    
}
-(void)tapScreen:(UITapGestureRecognizer *)tap{
    [_showView setHidden:YES];
    [_personView setHidden:YES];
}
#pragma mark ------ 初始化界面
-(void)initWithController{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 90, kScreenSize.width-20, 140)];
    imageView.tag = 41;
    imageView.userInteractionEnabled = YES;
    imageView.image = [UIImage imageNamed:@"血压15"];
    [self.view addSubview:imageView];
   
    UIImageView *inputImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, kScreenSize.width-20-40, 40)];
    inputImageView.userInteractionEnabled = YES;
    inputImageView.image = [UIImage imageNamed:@"血压11"];
    UIImageView *reminderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12.5, 15, 15)];
    reminderImageView.image = [UIImage imageNamed:@"血氧10"];
    [inputImageView addSubview:reminderImageView];
    
    UILabel *categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 12.5, 60, 15)];
    categoryLabel.text = ModuleZW(@"当前血氧");
    categoryLabel.textAlignment = NSTextAlignmentLeft;
    categoryLabel.textColor = [Tools colorWithHexString:@"#878787"];
    categoryLabel.font = [UIFont systemFontOfSize:13];
    [inputImageView addSubview:categoryLabel];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(90, 0, kScreenSize.width-8-40-90, 40)];
    textField.delegate = self;
    textField.placeholder = ModuleZW(@"请输入0~100整数值");
    textField.keyboardType = UIKeyboardTypeNumberPad;
    [_TextFieldArr addObject:textField];
    [inputImageView addSubview:textField];
    self.textField  = textField;
    
        
    [imageView addSubview:inputImageView];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((kScreenSize.width-20)/2-80, 90, 160, 30)];
    [button addTarget:self action:@selector(saveClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:ModuleZW(@"血压13")] forState:UIControlStateNormal];
    [imageView addSubview:button];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITextField *tf1 = _TextFieldArr[0];
    
    [tf1 resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
//只允许textField输入数字
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
    BOOL canChange = [string isEqualToString:filtered];
    return canChange;
}
#pragma mark -------- 提交数据
-(void)saveClick:(UIButton *)button{
    NSLog(@"点击保存");
    UITextField *tf = _TextFieldArr[0];
    //获取子账户
    if (tf.text.floatValue > 100 || tf.text == nil ||tf.text.floatValue <0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.removeFromSuperViewOnHide =YES;
        hud.mode = MBProgressHUDModeText;
        hud.labelText = ModuleZW(@"请输入正常的血氧值！");
        hud.minSize = CGSizeMake(132.f, 108.0f);
        [hud hide:YES afterDelay:2];
    }else{
        //收键盘
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        [self requestNetworkData:[NSString stringWithFormat:@"%@",[MemberUserShance shareOnce].idNum]];

//        [self GetWithModifi ];
        
    }
}

-(void)GetWithModifi
{
    
    if([GlobalCommon isManyMember]){
        __weak typeof(self) weakSelf = self;
        SubMemberView *subMember = [[SubMemberView alloc] initWithFrame:CGRectZero];
        [subMember receiveSubIdWith:^(NSString *subId) {
            NSLog(@"%@",subId);
            if ([subId isEqualToString:@"user is out of date"]) {
                //登录超时
                
            }else{
                [weakSelf requestNetworkData:subId];
            }
            [subMember hideHintView];
        }];
    }else{
        [self requestNetworkData:[NSString stringWithFormat:@"%@",[MemberUserShance shareOnce].idNum]];
    }
}

- (void)requestNetworkData:(NSString *)subId
{
    //得到子账户的id
    self.subId = subId;
    float density = [self.textField.text floatValue]/100.0f;
    
    //提交数据
    NSString *aUrl = [NSString stringWithFormat:@"%@/member/uploadData.jhtml",URL_PRE];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:aUrl]];
    [request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]];
    if([UserShareOnce shareOnce].languageType){
        [request addRequestHeader:@"language" value:[UserShareOnce shareOnce].languageType];
    }
    [request setPostValue:[UserShareOnce shareOnce].uid forKey:@"memberId"];
    [request addPostValue:subId forKey:@"memberChildId"];
    [request addPostValue:@(20) forKey:@"datatype"];
    [request addPostValue:@(density) forKey:@"density"];
    [request addPostValue:[UserShareOnce shareOnce].token forKey:@"token"];
    [request setTimeOutSeconds:20];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestError:)];
    [request setDidFinishSelector:@selector(requestCompleted:)];
    [request startAsynchronous];
}



-(void)requestCompleted:(ASIHTTPRequest *)request{
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    NSDictionary *dataDic = dic[@"data"];
    NSNumber *state = dic[@"status"];
    UITextField *tf = _TextFieldArr[0];
    if (state.integerValue == 100) {
        NSLog(@"数据提交成功");
        //弹出视图，展现结果
        float sugerValue = [tf.text floatValue]/100.0f;//血氧值
        NSString *resultStr = [[NSString alloc] init];
        //正常值0.95~1.0
        if (sugerValue <0.95){
            resultStr = kLow;
        }else{
            resultStr = kNomal;
        }
        
        UIView *view = [[UIView alloc] initWithFrame:self.view.frame];
        view.tag = 31;
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.3;
        UIView *view2 = [[UIView alloc] initWithFrame:self.view.frame];
        view2.tag = 32;
    
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width-40, 180)];
        imageView.center = self.view.center;
        imageView.userInteractionEnabled = YES;
        imageView.image = [UIImage imageNamed:@"bounceView"];
        
        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sureBtn setBackgroundImage:[UIImage imageNamed:@"sure"] forState:UIControlStateNormal];
        [sureBtn setTitle:ModuleZW(@"返回检测") forState:UIControlStateNormal];
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        sureBtn.frame = CGRectMake(20, kScreenSize.height/2+90, imageView.frame.size.width * 0.5, 40);
        [sureBtn addTarget:self action:@selector(confirmBtnClick2:) forControlEvents:UIControlEventTouchUpInside];
        [view2 addSubview:sureBtn];
        
        UIButton *lookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [lookBtn setBackgroundImage:[UIImage imageNamed:@"look"] forState:UIControlStateNormal];
        [lookBtn setTitle:ModuleZW(@"查看档案") forState:UIControlStateNormal];
        lookBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        lookBtn.frame = CGRectMake(CGRectGetMaxX(sureBtn.frame), sureBtn.frame.origin.y, imageView.frame.size.width * 0.5, 40);
        [lookBtn addTarget:self action:@selector(lookClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [view2 addSubview:lookBtn];
        
        UILabel *countLabel = [Tools labelWith:[NSString stringWithFormat:ModuleZW(@"您当前血氧值：%@ %%"),self.textField.text] frame:CGRectMake(0, 60, imageView.bounds.size.width, 60) textSize:14 textColor:[Tools colorWithHexString:@"#e79947"] lines:0 aligment:NSTextAlignmentCenter];
        
        UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, imageView.bounds.size.width-40, 80)];
        hintLabel.numberOfLines = 0;
        hintLabel.font = [UIFont systemFontOfSize:12];
        hintLabel.textAlignment = NSTextAlignmentCenter;
        
        //血氧正常范围参考值：95%-100%
        hintLabel.text =ModuleZW(@"血氧正常范围参考值：\n95%-100%") ;
        [imageView addSubview:hintLabel];
        [imageView addSubview:countLabel];
        [view2 addSubview:imageView];
        [self.view addSubview:view];
        [self.view addSubview:view2];
        
        
    }else{
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:ModuleZW(@"提示") message:ModuleZW(@"提交数据失败") delegate:self cancelButtonTitle:ModuleZW(@"确定") otherButtonTitles:nil,nil];
        [av show];
    }
}

-(void)requestError:(ASIHTTPRequest *)request{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:ModuleZW(@"提示") message:ModuleZW(@"提交数据失败") delegate:self cancelButtonTitle:ModuleZW(@"确定") otherButtonTitles:nil,nil];
    [av show];
}


//点击返回检测
-(void)confirmBtnClick2:(UIButton *)button{
    UIView *v1 = [self.view viewWithTag:31];
    UIView *v2 = [self.view viewWithTag:32];
    [v1 removeFromSuperview];
    [v2 removeFromSuperview];
//    if (self.abock){
//        self.abock();
//    }
//    [self.navigationController popViewControllerAnimated:YES];
}

//查看档案
- (void)lookClickBtn:(UIButton *)btn{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *controller = app.window.rootViewController;
    UITabBarController  *rvc = (UITabBarController  *)controller;
    [rvc setSelectedIndex:1];
    [UserShareOnce shareOnce].wherePop = ModuleZW(@"血氧");
    [UserShareOnce shareOnce].bloodMemberID = [NSString stringWithFormat:@"%@",self.subId];
    [self.navigationController popToRootViewControllerAnimated:YES];
   
}

@end
