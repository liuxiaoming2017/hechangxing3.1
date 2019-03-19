//
//  TemperNonDeviceViewController.m
//  Voicediagno
//
//  Created by Mymac on 15/9/28.
//  Copyright (c) 2015年 Mymac. All rights reserved.
//

#import "TemperNonDeviceViewController.h"
#import "AdvisoryTableViewCell.h"
#import "LoginViewController.h"
#import "NSObject+SBJson.h"

#define NUMBERS @"0123456789.n"

#define kHigh @"体温值偏高。若排除外界影响因素如情绪激动、精神紧张、进食、运动、怀孕（特指适龄女性）等情况外，伴有头痛、乏力等不适症状发生，请及时到医院就诊。"
#define kLow @"体温值偏低。需要注意保暖，少运动，多饮热水，进食温热食物，必要时请到医院就诊，及时得到专业救诊。"

@interface TemperNonDeviceViewController ()<UITextFieldDelegate,MBProgressHUDDelegate,ASIHTTPRequestDelegate>
{
    
    UITextField *_textField;
}
@end

@implementation TemperNonDeviceViewController
- (void)dealloc
{
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navTitleLabel.text = ModuleZW(@"体温检测");
    [self initWithController];
    [self bounceView];
    
}

#pragma mark ------ 弹出视图
-(void)bounceView{
    //弹出视图
    
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

#pragma mark ------- 初始化界面
-(void)initWithController{
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, kNavBarHeight+26, kScreenSize.width-20, 140)];
    imageView.tag = 41;
    imageView.userInteractionEnabled = YES;
    imageView.image = [UIImage imageNamed:@"血压15"];
    [self.view addSubview:imageView];
    
    UIImageView *inputImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, kScreenSize.width-20-40, 40)];
    inputImageView.userInteractionEnabled = YES;
    inputImageView.image = [UIImage imageNamed:@"血压11"];
    UIImageView *reminderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12.5, 15, 15)];
    reminderImageView.image = [UIImage imageNamed:@"体温_非设备检测03"];
    [inputImageView addSubview:reminderImageView];
    
    
    UILabel *categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 12.5, 60, 15)];
    categoryLabel.text = ModuleZW(@"当前体温");
    categoryLabel.textAlignment = NSTextAlignmentLeft;
    categoryLabel.textColor = [Tools colorWithHexString:@"#878787"];
    categoryLabel.font = [UIFont systemFontOfSize:13];
    //[inputImageView addSubview:categoryLabel];
    
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(30, 0, kScreenSize.width-8-40-30, 40)];
    _textField.font = [UIFont systemFontOfSize:16];
    _textField.keyboardType = UIKeyboardTypeDecimalPad;
    _textField.placeholder = ModuleZW(@"当前体温");
    _textField.delegate = self;
    
    [inputImageView addSubview:_textField];
    
    
    [imageView addSubview:inputImageView];
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((kScreenSize.width-20)/2-80, 90, 160, 30)];
    [button addTarget:self action:@selector(saveClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:ModuleZW(@"血压13")] forState:UIControlStateNormal];
    [imageView addSubview:button];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITextField *tf1 = _textField;
    
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

#pragma mark --------- 提交数据

-(void)saveClick:(UIButton *)button{
    NSLog(@"点击保存");
    //获取子账户
    if (_textField.text.floatValue < 30 || _textField.text == nil) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.removeFromSuperViewOnHide =YES;
        hud.mode = MBProgressHUDModeText;
        hud.label.text = ModuleZW(@"请输入正常的体温值！");
        hud.label.numberOfLines = 0;
        hud.minSize = CGSizeMake(132.f, 108.0f);
        [hud hideAnimated:YES afterDelay:2];
    }else{
        //收键盘
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        [self requestNetworkData:[NSString stringWithFormat:@"%@",[MemberUserShance shareOnce].idNum]];

        
//        if([GlobalCommon isManyMember]){
//            __weak typeof(self) weakSelf = self;
//            SubMemberView *subMember = [[SubMemberView alloc] initWithFrame:CGRectZero];
//            [subMember receiveSubIdWith:^(NSString *subId) {
//                NSLog(@"%@",subId);
//                if ([subId isEqualToString:@"user is out of date"]) {
//                    //登录超时
//
//                }else{
//                    [weakSelf requestNetworkData:subId];
//                }
//                [subMember hideHintView];
//            }];
//        }else{
//            [self requestNetworkData:[NSString stringWithFormat:@"%@",[MemberUserShance shareOnce].idNum]];
//        }
        
       
    }
    
}


- (void)requestNetworkData:(NSString *)subId
{
    [self showPreogressView];
    float tempNums = [self->_textField.text floatValue];
    //提交数据
    NSString *aUrl = [NSString stringWithFormat:@"%@/member/uploadData.jhtml",URL_PRE];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:aUrl]];
    [request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]];
    if([UserShareOnce shareOnce].languageType){
        [request addRequestHeader:@"language" value:[UserShareOnce shareOnce].languageType];
    }
    [request setPostValue:[UserShareOnce shareOnce].uid forKey:@"memberId"];
    [request addPostValue:subId forKey:@"memberChildId"];
    [request addPostValue:@(40) forKey:@"datatype"];
    [request addPostValue:@(tempNums) forKey:@"temperature"];
    [request addPostValue:[UserShareOnce shareOnce].token forKey:@"token"];
    [request setTimeOutSeconds:20];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestError:)];
    [request setDidFinishSelector:@selector(requestCompleted:)];
    [request startAsynchronous];
}



-(void)requestCompleted:(ASIHTTPRequest *)request{
    [self hidePreogressView];
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    
    NSNumber *state = dic[@"status"];
    if (state.integerValue == 100) {
        NSLog(@"数据提交成功");
        //弹出视图，展现结果
        float tempNum = [_textField.text floatValue];//呼吸次数
        NSString *resultStr = [[NSString alloc] init];
        //成人，正常值16~20次/分
        if(tempNum >=36 && tempNum <37.3){
            resultStr = ModuleZW(@"正常");
        }else if (tempNum <38){
            resultStr = ModuleZW(@"低热");
        }else if (tempNum <39){
            resultStr = ModuleZW(@"中度发热");
        }else if (tempNum <41){
            resultStr = ModuleZW(@"高热");
        }else{
            resultStr = ModuleZW(@"超高热");
        }

        UIView *view = [[UIView alloc] initWithFrame:self.view.frame];
        view.tag = 31;
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.3;
        UIView *view2 = [[UIView alloc] initWithFrame:self.view.frame];
        view2.tag = 32;
        self.view.userInteractionEnabled = YES;
        view.userInteractionEnabled = YES;
        view2.userInteractionEnabled = YES;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 303*1.1, 195*1.1)];
        imageView.center = self.view.center;
        imageView.userInteractionEnabled = YES;
        imageView.image = [UIImage imageNamed:@"bounceView"];
        
        UIButton *confirmBtn = [Tools creatButtonWithFrame:CGRectMake(imageView.left, imageView.bottom, imageView.width, 40*1.1) target:self sel:@selector(confirmBtnClick2:) tag:21 image:ModuleZW(@"sureButton") title:nil];
        
        UILabel *countLabel = [Tools labelWith:[NSString stringWithFormat:ModuleZW(@"您当前体温%.1f℃"),tempNum] frame:CGRectMake(0, 60, imageView.bounds.size.width, 20) textSize:14 textColor:[Tools colorWithHexString:@"#e79947"] lines:1 aligment:NSTextAlignmentCenter];
    
        if ([resultStr isEqualToString:ModuleZW(@"正常")]) {
            UILabel *resultLabel1 = [Tools labelWith:ModuleZW(@"当前体温值") frame:CGRectMake(imageView.bounds.size.width/2-90, 110, 110, 20) textSize:12 textColor:[Tools colorWithHexString:@"#666666"] lines:1 aligment:NSTextAlignmentRight];
            UILabel *resultLabel2 = [Tools labelWith:resultStr frame:CGRectMake(imageView.bounds.size.width/2+20, 110, 50, 20) textSize:12 textColor:[Tools colorWithHexString:@"#68c900"] lines:1 aligment:NSTextAlignmentLeft];
            [imageView addSubview:resultLabel1];
            [imageView addSubview:resultLabel2];
        }else{
            UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, imageView.bounds.size.width-40, 80)];
            hintLabel.numberOfLines = 0;
            hintLabel.font = [UIFont systemFontOfSize:12];
            NSMutableAttributedString *hintString = nil;
            NSRange range;
            if (tempNum >=37.3) {
                hintString = [[NSMutableAttributedString alloc] initWithString:ModuleZW(kHigh)];
                range = [[hintString string] rangeOfString:ModuleZW(@"偏高")];
            }else{
                hintString = [[NSMutableAttributedString alloc] initWithString:ModuleZW(kLow)];
                range = [[hintString string] rangeOfString:ModuleZW(@"偏低")];
            }
            [hintString addAttribute:NSForegroundColorAttributeName value:[Tools colorWithHexString:@"f60a0c"] range:range];
            hintLabel.attributedText = hintString;
            [imageView addSubview:hintLabel];
            
        }
        
        [imageView addSubview:countLabel];
        [view2 addSubview:imageView];
        [self.view addSubview:view];
        [self.view addSubview:view2];
        [view2 addSubview:confirmBtn];
        
       
    
    }else{
        
        [self showAlertWarmMessage:ModuleZW(@"提交数据失败")];
        
    }
    
    
    //[self customeView];
}

-(void)requestError:(ASIHTTPRequest *)request{
    [self hidePreogressView];
    [self showAlertWarmMessage:ModuleZW(@"提交数据失败")];
}


//点击确定
-(void)confirmBtnClick2:(UIButton *)button{
    UIView *v1 = [self.view viewWithTag:31];
    UIView *v2 = [self.view viewWithTag:32];
    [v1 removeFromSuperview];
    [v2 removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
