//
//  SugerViewController.m
//  Voicediagno
//
//  Created by Mymac on 15/9/23.
//  Copyright (c) 2015年 Mymac. All rights reserved.
//

#import "SugerViewController.h"
//#import "BloodSugerGuideViewController.h"
#import "LoginViewController.h"
#import "AdvisoryTableViewCell.h"
#import "JSONKit.h"
#import "BloodSugerModel.h"
#import "SubMemberView.h"
#import "NSObject+SBJson.h"
#import "SugerStandardController.h"

#define NUMBERS @"0123456789.n"
#define kCELLHEIGHT 20.0f
#define kNomal @"您的血糖正常，控制得不错，建议您继续保持当下的健康生活方式，并定期监测血糖。"
#define kEmptyHigh @"您空腹血糖偏高，为%.2fmmol/L，建议您在医生指导下对血糖进行定期监测、科学控制。"
#define kEmptyLow @"您空腹血糖偏低，为%.2fmmol/L，建议您适量进食予以缓解，并在医生指导下对血糖进行定期监测，及时纠正。"
#define kFullHigh @"您餐后2小时血糖偏高，为%.2fmmol/L，建议您在医生指导下对血糖进行定期监测、科学控制。"

@interface SugerViewController ()<UITextFieldDelegate,MBProgressHUDDelegate,ASIHTTPRequestDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    MBProgressHUD *_progress;
    UITextField *_textFiled;
    NSString *_type;//判断是空腹或者餐后，---- 空腹为empty，餐后为full
    NSString *_result;
    //提示信息
    UIScrollView *_scrollView;
    UITableView *_leftTableView;
    UITableView *_rightTableView;
    NSMutableArray *_leftData;
    NSMutableArray *_rightData;

    NSInteger _totalCount;//测量的总次数
    NSInteger _nomalCount;//正常的次数
    NSInteger _unNomalCount;//异常的次数
    NSInteger _emptyCount;//空腹测量次数
    NSInteger _fullCount;//餐后测量次数
}
@end

@implementation SugerViewController

-(void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navTitleLabel.text = @"血糖检测";
    _type = @"empty";
    [self initWithController];
    [self bounceView];
}

-(void)backClick:(UIButton *)button{
    [self.navigationController popToRootViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];
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
    
    UIButton *beforeMealButton = [Tools creatButtonWithFrame:CGRectMake(30, kNavBarHeight+36, 60, 60) target:self sel:@selector(beforeClick:) tag:21 image:@"血糖7" title:nil];
    [beforeMealButton setEnabled:NO];
    [beforeMealButton setImage:[UIImage imageNamed:@"血糖7"] forState:UIControlStateDisabled];
    [self.view addSubview:beforeMealButton];
    
    UIButton *afterMealButton = [Tools creatButtonWithFrame:CGRectMake(kScreenSize.width-90, beforeMealButton.top, 60, 60) target:self sel:@selector(afterClick:) tag:22 image:@"血糖8" title:nil];
    [self.view addSubview:afterMealButton];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    imageView.tag = 10;
    imageView.userInteractionEnabled = YES;
    imageView.center = self.view.center;
    imageView.image = [UIImage imageNamed:@"血糖9"];
    [self.view addSubview:imageView];
    
    UILabel *reminderLabel = [Tools creatLabelWithFrame:CGRectMake(20, 60, 160, 20) text:@"输入当前血糖值" textSize:12];
    reminderLabel.textAlignment = NSTextAlignmentCenter;
    reminderLabel.textColor = [Tools colorWithHexString:@"#3fcadb"];
    reminderLabel.font = [UIFont systemFontOfSize:12];
    [imageView addSubview:reminderLabel];
    
    _textFiled = [[UITextField alloc] initWithFrame:CGRectMake(60, 90, 80, 40)];
    _textFiled.delegate = self;
    _textFiled.tag = 100;
    _textFiled.borderStyle = UITextBorderStyleRoundedRect;
    _textFiled.placeholder = @"--mmol/L";
    _textFiled.font = [UIFont systemFontOfSize:14];
    _textFiled.textColor = [Tools colorWithHexString:@"#3fcadb"];
    _textFiled.textAlignment = NSTextAlignmentCenter;
    _textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    [imageView addSubview:_textFiled];
    
    
    //提交按钮
    UIButton *commitButton = [Tools creatButtonWithFrame:CGRectMake(kScreenSize.width/2-100, imageView.bottom+30, 200, 40) target:self sel:@selector(commitClick:) tag:101 image:@"0_15" title:nil];
    [self.view addSubview:commitButton];
    
    //使用规范
    UIButton *useNorm = [Tools creatButtonWithFrame:CGRectMake(kScreenSize.width/2-30,commitButton.bottom+30, 60, 25) target:self sel:@selector(useNormClick:) tag:102 image:@"使用规范" title:nil];
    [self.view addSubview:useNorm];
}
//收键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_textFiled resignFirstResponder];
}
//只允许textField输入数字
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
    BOOL canChange = [string isEqualToString:filtered];
    return canChange;
}

-(void)beforeClick:(UIButton *)button{
    NSLog(@"点击空腹按钮");
    _type = @"empty";
    _textFiled.text = nil;
    UIButton *afterMealButton = (UIButton *)[self.view viewWithTag:22];
    [button setEnabled:NO];
    [button setImage:[UIImage imageNamed:@"血糖7"] forState:UIControlStateDisabled];
    [afterMealButton setEnabled:YES];
    [afterMealButton setImage:[UIImage imageNamed:@"血糖8"] forState:UIControlStateNormal];
}

-(void)afterClick:(UIButton *)button{
    NSLog(@"点击餐后按钮");
    _type = @"full";
    _textFiled.text = nil;
    UIButton *beforeMealButton = (UIButton *)[self.view viewWithTag:21];
    [button setEnabled:NO];
    [button setImage:[UIImage imageNamed:@"血糖4"] forState:UIControlStateDisabled];
    [beforeMealButton setEnabled:YES];
    [beforeMealButton setImage:[UIImage imageNamed:@"血糖2"] forState:UIControlStateNormal];
}
#pragma mark ------ 提交数据
-(void)commitClick:(UIButton *)button{
    NSLog(@"点击提交按钮");
    if ([self isBlankString:_textFiled.text] || [_textFiled.text integerValue] == 0) {
        NSString *str = @"血糖值不能为空";
        if([self isBlankString:_textFiled.text]){
            str = @"血糖值不能为空";
        }else if ([_textFiled.text integerValue] == 0){
            str = @"您的输入有误,请重新输入";
        }
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.removeFromSuperViewOnHide =YES;
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"血糖值不能为空";
        hud.minSize = CGSizeMake(132.f, 108.0f);
        [hud hideAnimated:YES afterDelay:2];
    }else{
        //收键盘
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        
        //选择子账户
        [self GetWithModifi];
    }
}

//用来判断字符串是否为空，如果返回YES就是空，返回NO，字符串不为空
-(BOOL)isBlankString:(NSString *)string
{
    if (string == nil || string == NULL)
    {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)
    {
        return YES;
    }
    return NO;
}

#pragma mark -------- 选择子账户
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
    float sugerValue = [self->_textFiled.text floatValue];
    BOOL isAbnormity = NO;
    if ([self->_type isEqualToString:@"empty"]) {
        //空腹
        if (sugerValue <3.9) {
            self->_result = [[NSString alloc] initWithFormat:kEmptyLow,sugerValue];
            isAbnormity = YES;
        }else if (sugerValue <=6.1){
            self->_result = [[NSString alloc] initWithFormat:kNomal];
            isAbnormity = NO;
        }else{
            self->_result = [[NSString alloc] initWithFormat:kEmptyHigh,sugerValue];
            isAbnormity = YES;
        }
    }else{
        //餐后
        if (sugerValue <=7.8) {
            self->_result = [[NSString alloc] initWithFormat:kNomal];
            isAbnormity = NO;
        }else{
            self->_result = [[NSString alloc] initWithFormat:kFullHigh,sugerValue];
            isAbnormity = YES;
        }
        
    }
    
    [self showPreogressView];
    NSString *aUrl = [NSString stringWithFormat:@"%@/member/uploadData.jhtml",URL_PRE] ;
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:aUrl]];
    [request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]];
    [request setPostValue:[UserShareOnce shareOnce].uid forKey:@"memberId"];
    [request addPostValue:subId forKey:@"memberChildId"];
    [request addPostValue:@(60) forKey:@"datatype"];
    [request addPostValue:@(sugerValue) forKey:@"levels"];
    [request addPostValue:self->_type forKey:@"type"];
    [request addPostValue:@(isAbnormity) forKey:@"isAbnormity"];
    [request addPostValue:[UserShareOnce shareOnce].token forKey:@"token"];
    [request setTimeOutSeconds:20];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestError:)];
    [request setDidFinishSelector:@selector(requestCompleted:)];
    [request startAsynchronous];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _leftTableView){
        return _leftData.count+1;
    }else if (tableView == _rightTableView){
        return _rightData.count+1;
    }
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _leftTableView) {
        //空腹的tableView
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"leftCell"];
        }
        if (indexPath.row==0) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width/2, 20)];
            label.text = @"空腹";
            label.font = [UIFont systemFontOfSize:13];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [Tools colorWithHexString:@"#e79947"];
            [cell addSubview:label];
           
        }else{
            BloodSugerModel *model = _leftData[indexPath.row-1];
            UILabel *timeLabel = [Tools labelWith:[self timeStringFrom:model.modifyDate.doubleValue] frame:CGRectMake(5, 0, 30, 20) textSize:10 textColor:nil lines:1 aligment:NSTextAlignmentLeft];
            UILabel *levelLabel = [Tools labelWith:[NSString stringWithFormat:@"%ldmmol/L",model.levels] frame:CGRectMake(_scrollView.frame.size.width/4-5, 0, _scrollView.frame.size.width/4, 20) textSize:10 textColor:nil lines:1 aligment:NSTextAlignmentRight];
            [cell addSubview:timeLabel];
            [cell addSubview:levelLabel];
            
        }
        return cell;
    }else if (tableView == _rightTableView){
        //餐后的tableView
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rightCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"rightCell"];
        }
        if (indexPath.row==0) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width/2, 20)];
            label.text = @"餐后";
            label.font = [UIFont systemFontOfSize:13];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [Tools colorWithHexString:@"#e79947"];
            [cell addSubview:label];
            
        }else{
            BloodSugerModel *model = _rightData[indexPath.row-1];
            UILabel *timeLabel = [Tools labelWith:[self timeStringFrom:model.modifyDate.doubleValue] frame:CGRectMake(5, 0, 30, 20) textSize:10 textColor:nil lines:1 aligment:NSTextAlignmentLeft];
            UILabel *levelLabel = [Tools labelWith:[NSString stringWithFormat:@"%ldmmol/L",model.levels] frame:CGRectMake(_scrollView.frame.size.width/4-5, 0, _scrollView.frame.size.width/4, 20) textSize:10 textColor:nil lines:1 aligment:NSTextAlignmentRight];
            [cell addSubview:timeLabel];
            [cell addSubview:levelLabel];
            
        }
        return cell;
        
    }
    return nil;
}
//得到时间字符串  --------->>>  注意：传入的时间为mm
-(NSString *)timeStringFrom:(double )time{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    //dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:time/1000.0f];
    return  [dateFormatter stringFromDate:timeDate];
}

-(void)hudWasHidden{
    [_progress removeFromSuperview];
    
    _progress = nil;
}
-(void)requestCompleted:(ASIHTTPRequest *)request{
    
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    //NSDictionary *dataDic = dic[@"data"];
    NSNumber *state = dic[@"status"];
    if (state.integerValue == 100) {
        NSLog(@"数据提交成功");
        //请求数据,得到空腹、餐前的数据
        [self getData];
        
    }else{
        [self showAlertWarmMessage:@"提交数据失败"];
       
    }
    
}

-(void)requestError:(ASIHTTPRequest *)request{
    //[self hudWasHidden];
    [self hidePreogressView];
    [self showAlertWarmMessage:@"提交数据失败"];
    
}
#pragma MARK ---------  获取当天体检血糖的数据
-(void)getData{
    
    NSString *aUrlle= [NSString stringWithFormat:@"%@/subject_report /findDate.jhtml?mcId=%@",URL_PRE,[MemberUserShance shareOnce].idNum];
    aUrlle = [aUrlle stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:aUrlle];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:20];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(getDataError:)];
    [request setDidFinishSelector:@selector(getDataFinish:)];
    [request startAsynchronous];
}

-(void)getDataFinish:(ASIHTTPRequest *)request{
    [self hidePreogressView];
    NSString *jsonString = [request responseString];
    NSDictionary *dic = [jsonString JSONValue];
    if ([dic[@"status"] integerValue] == 100) {
        NSLog(@"请求成功");
        _leftData = [[NSMutableArray alloc] init];
        _rightData = [[NSMutableArray alloc] init];
        //数据清零
        _totalCount = 0;
        _emptyCount = 0;
        _fullCount = 0;
        _nomalCount = 0;
        _unNomalCount = 0;
        NSDictionary *data = dic[@"data"];
        NSLog(@"%@",data);
        NSArray *emptyArr = data[@"type=empty"];
        for (NSDictionary *emptyDic in emptyArr) {
            BloodSugerModel *model = [[BloodSugerModel alloc] init];
            model = [BloodSugerModel mj_objectWithKeyValues:emptyDic];
            
            [_leftData addObject:model];
            
            _totalCount++;
            _emptyCount++;
            if ([emptyDic[@"isAbnormity"] integerValue] == 1) {
                _unNomalCount++;
            }else{
                _nomalCount++;
            }
        }
        NSArray *fullArr = data[@"type=full"];
        for (NSDictionary *fullDic in fullArr) {
            _totalCount++;
            _fullCount++;
            BloodSugerModel *model = [[BloodSugerModel alloc] init];
            model = [BloodSugerModel mj_objectWithKeyValues:fullDic];
            [_rightData addObject:model];
            
            if ([fullDic[@"isAbnormity"] integerValue] == 1) {
                _unNomalCount++;
            }else{
                _nomalCount++;
            }
        }
        //弹出提示信息
        [self showHintInfo];
    }else{
        MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mbHud.removeFromSuperViewOnHide = YES;
        mbHud.mode = MBProgressHUDModeText;
        mbHud.label.text = @"获取血糖数据失败";
        mbHud.minSize = CGSizeMake(132.f, 108.f);
        [mbHud hideAnimated:YES afterDelay:2];
    }
}
#pragma mark -------- 展示提示信息
-(void)showHintInfo{
    //弹出视图，展现结果

    UIView *view = [[UIView alloc] initWithFrame:self.view.frame];
    view.tag = 331;
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.3;
    UIView *view2 = [[UIView alloc] initWithFrame:self.view.frame];
    view2.tag = 332;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 303*1.1, 195*1.1)];
    imageView.center = self.view.center;
    imageView.userInteractionEnabled = YES;
    imageView.image = [UIImage imageNamed:@"bounceView"];

    UIButton *confirmBtn = [Tools creatButtonWithFrame:CGRectMake(imageView.left, imageView.bottom, imageView.width, 40*1.1) target:self sel:@selector(confirmBtnClick2:) tag:21 image:@"确定" title:nil];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, imageView.bounds.size.width, imageView.bounds.size.height-60)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(imageView.frame.size.width, ((_emptyCount>_fullCount? _emptyCount: _fullCount)+1)*kCELLHEIGHT+110);
    
    [imageView addSubview:_scrollView];
    NSString *checkType = nil;
    if ([_type isEqualToString:@"empty"]) {
        checkType = @"空腹";
    }else{
        checkType = @"餐后";
    }
    UILabel *countLabel = [Tools labelWith:[NSString stringWithFormat:@"您今天测量血糖%ld次，正常%ld次，异常%ld次\n您当前检测%@血糖值为%.1fmmol/L",(long)_totalCount,(long)_nomalCount,(long)_unNomalCount,checkType,_textFiled.text.floatValue] frame:CGRectMake(0, 0, imageView.bounds.size.width, 30) textSize:12 textColor:[Tools colorWithHexString:@"#e79947"] lines:0 aligment:NSTextAlignmentCenter];
    [_scrollView addSubview:countLabel];
    UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 35, imageView.bounds.size.width-40, 60)];
    
    hintLabel.numberOfLines = 0;
    hintLabel.font = [UIFont systemFontOfSize:12];
    NSMutableAttributedString *hintString = [[NSMutableAttributedString alloc] initWithString:_result];
    NSRange range;
    if ([_result isEqualToString:kNomal]) {
        range = NSMakeRange(4, 2);
    }else if ([_result isEqualToString:[NSString stringWithFormat:kFullHigh,_textFiled.text.floatValue]]){
        range = NSMakeRange(8, 2);
    }else{
        range = NSMakeRange(5, 2);
    }

    [hintString addAttribute:NSForegroundColorAttributeName value:[Tools colorWithHexString:@"f60a0c"] range:range];
    hintLabel.attributedText = hintString;
    [_scrollView addSubview:hintLabel];
    //创建两个tableView
    [self createDoubleTableView];
    
    [view2 addSubview:imageView];
    [self.view addSubview:view];
    [self.view addSubview:view2];
    [view2 addSubview:confirmBtn];
    
}

-(void)getDataError:(ASIHTTPRequest *)request{
    [self hidePreogressView];
    [self showAlertWarmMessage:@"获取血糖数据失败"];
}

//点击确定
-(void)confirmBtnClick2:(UIButton *)button{
    UIView *v1 = [self.view viewWithTag:331];
    UIView *v2 = [self.view viewWithTag:332];
    [v1 removeFromSuperview];
    [v2 removeFromSuperview];
}
#pragma mark --------  创建提示信息的两个tableView
-(void)createDoubleTableView{
    _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 85, _scrollView.frame.size.width/2, (_emptyCount+1)*kCELLHEIGHT) style:UITableViewStylePlain];
    _leftTableView.dataSource =self;
    _leftTableView.delegate = self;
    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _leftTableView.scrollEnabled = NO;
    _leftTableView.rowHeight = kCELLHEIGHT;
    _leftTableView.userInteractionEnabled = NO;
    [_scrollView addSubview:_leftTableView];
    
    
    _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(_scrollView.frame.size.width/2, 85, _scrollView.frame.size.width/2, (_fullCount+1)*kCELLHEIGHT) style:UITableViewStylePlain];
    _rightTableView.dataSource = self;
    _rightTableView.delegate = self;
    _rightTableView.scrollEnabled = NO;
    _rightTableView.rowHeight = kCELLHEIGHT;
    _rightTableView.userInteractionEnabled = NO;
    _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_scrollView addSubview:_rightTableView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(_scrollView.frame.size.width/2-0.5, 85, 1, ((_emptyCount>_fullCount? _emptyCount: _fullCount)+1)*kCELLHEIGHT)];
    lineView.backgroundColor = [UIColor grayColor];
    [_scrollView addSubview:lineView];
    
}

-(void)useNormClick:(UIButton *) button{
    NSLog(@"点击使用规范");
    SugerStandardController *vc = [[SugerStandardController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
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
