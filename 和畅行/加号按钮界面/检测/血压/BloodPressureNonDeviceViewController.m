//
//  BloodPressureNonDeviceViewController.m
//  Voicediagno
//
//  Created by Mymac on 15/9/25.
//  Copyright (c) 2015年 Mymac. All rights reserved.
//

#import "BloodPressureNonDeviceViewController.h"
#import "AdvisoryTableViewCell.h"
#import "LoginViewController.h"

#import "SubMemberView.h"
#import "NSObject+SBJson.h"

#import "AppDelegate.h"
#import "ArchivesController.h"

#define NUMBERS @"0123456789n"

#define kLow @"血压值偏低，建议均衡营养，坚持锻炼，改善体质。"
#define kNomal @"血压值正常，建议继续保持当下的健康生活方式，并定期测量血压。"
#define kHigh @"血压值正常稍高，请采取健康的生活方式，戒烟限酒，限制钠盐的摄入，加强锻炼，密切关注血压。"
#define kHigher @"血压值偏高，请戒烟限酒，限制钠盐的摄入，加强锻炼。"
#define kMoreHigher @"血压值过高，请严格调整作息，控制饮食。若身体不适，请注意及时就诊。"
#define kHighest @"血压值严重偏高。请注意及时就诊，配合治疗。"


@interface BloodPressureNonDeviceViewController ()<UITextFieldDelegate,MBProgressHUDDelegate,ASIHTTPRequestDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_TextFieldArr;
    
}

/**subId*/
@property (nonatomic,copy) NSString *subId;


@end

@implementation BloodPressureNonDeviceViewController

- (void)dealloc
{
    [self.showView release];
    [self.tableView release];
    [self.personView release];
    [_TextFieldArr release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _TextFieldArr = [[NSMutableArray alloc] init];
    self.nameLabel.text = @"血压检测";
    [self initWithController];
    [self bounceView];
}

#pragma mark ------ 弹出视图
-(void)bounceView{
    //弹出视图
    self.dataArr = [[NSMutableArray alloc]init];
    self.headArray = [[NSMutableArray alloc]init];
    _memberChildId = [UserShareOnce shareOnce].mengberchildId;
    _personView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _personView.backgroundColor = [UIColor blackColor];
    _personView.alpha = 0.3;
    [self.view addSubview:_personView];
    _showView = [[UIView alloc]initWithFrame:CGRectMake(30, 100, self.view.frame.size.width - 60, self.view.frame.size.height - 190)];
    _showView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_showView];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, _showView.frame.size.width, _showView.frame.size.height - 80) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_showView addSubview:_tableView];
    [_tableView registerClass:[AdvisoryTableViewCell class] forCellReuseIdentifier:@"CELL"];
    _tableView.backgroundColor = [UIColor whiteColor];
    //_tableView.hidden = YES;
    
    _tableView.tableFooterView = [[UIView alloc]init];
    
    _showView.hidden = YES;
    _personView.hidden = YES;
    
    //_showView添加点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScreen:)];
    [_personView addGestureRecognizer:tap];
    [tap release];
    
    
}
-(void)tapScreen:(UITapGestureRecognizer *)tap{
    [_showView setHidden:YES];
    [_personView setHidden:YES];
}


#pragma mark ------- 初始化界面
-(void)initWithController{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 90, kScreenSize.width-20, 200)];
    imageView.tag = 41;
    imageView.userInteractionEnabled = YES;
    imageView.image = [UIImage imageNamed:@"血压15"];
    [self.view addSubview:imageView];
    
    NSArray *imagesArr = [[[NSArray alloc] initWithArray:@[@"血压10",@"血压12",@"血压14"]] autorelease];
    NSArray *titleArr = [[[NSArray alloc] initWithArray:@[@"收缩压",@"舒张压",@"脉搏次数"]] autorelease];
    for (int i=0; i<3; i++) {
        UIImageView *inputImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20+40*i, kScreenSize.width-20-40, 40)];
        inputImageView.tag = 31+i;
        inputImageView.userInteractionEnabled = YES;
        inputImageView.image = [UIImage imageNamed:@"血压11"];
        UIImageView *reminderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12.5, 15, 15)];
        reminderImageView.image = [UIImage imageNamed:imagesArr[i]];
        [inputImageView addSubview:reminderImageView];
        [reminderImageView release];
        
        UILabel *categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 12.5, 60, 15)];
        categoryLabel.text = titleArr[i];
        categoryLabel.textAlignment = NSTextAlignmentLeft;
        categoryLabel.textColor = [Tools colorWithHexString:@"#878787"];
        categoryLabel.font = [UIFont systemFontOfSize:13];
        [inputImageView addSubview:categoryLabel];
        [categoryLabel release];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(90, 0, kScreenSize.width-8-40-90, 40)];
        textField.delegate = self;
        textField.tag = 21+i;
        [_TextFieldArr addObject:textField];
        [inputImageView addSubview:textField];
        [textField release];
        //____________________
        
        
        //————————————————————
        
        [imageView addSubview:inputImageView];
        [inputImageView release];
    }
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((kScreenSize.width-20)/2-80, 150, 160, 30)];
    [button addTarget:self action:@selector(saveClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"血压13"] forState:UIControlStateNormal];
    [imageView addSubview:button];
    [button release];
    [imageView release];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITextField *tf1 = _TextFieldArr[0];
    UITextField *tf2 = _TextFieldArr[1];
    UITextField *tf3 = _TextFieldArr[2];
    
    [tf1 resignFirstResponder];
    [tf2 resignFirstResponder];
    [tf3 resignFirstResponder];
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
#pragma mark ------- 提交数据
-(void)saveClick:(UIButton *)button{
    NSLog(@"点击保存");
    UITextField *tf1 = _TextFieldArr[0];
    UITextField *tf2 = _TextFieldArr[1];
    UITextField *tf3 = _TextFieldArr[2];
    BOOL ret1 = [self isBlankString:tf1.text];
    BOOL ret2 = [self isBlankString:tf2.text];
    BOOL ret3 = [self isBlankString:tf3.text];
    if (ret1) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.removeFromSuperViewOnHide =YES;
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"收缩压不能为空";
        hud.minSize = CGSizeMake(132.f, 108.0f);
        [hud hideAnimated:YES afterDelay:2];
    }else if (ret2){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.removeFromSuperViewOnHide =YES;
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"舒张压不能为空";
        hud.minSize = CGSizeMake(132.f, 108.0f);
        [hud hideAnimated:YES afterDelay:2];
    }else if (ret3){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.removeFromSuperViewOnHide =YES;
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"脉搏次数不能为空";
        hud.minSize = CGSizeMake(132.f, 108.0f);
        [hud hideAnimated:YES afterDelay:2];
    }else{
        //收键盘
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        
//        _personView.hidden = NO;
//        _showView.hidden = NO;
//        [self.view bringSubviewToFront:_personView];
//        [self.view bringSubviewToFront:_showView];
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
    //得到子账户的id
    self.subId = subId;
    
    //提交数据
    UITextField *tf1 = _TextFieldArr[0];
    UITextField *tf2 = _TextFieldArr[1];
    UITextField *tf3 = _TextFieldArr[2];
    NSInteger highCount = [tf1.text integerValue];
    NSInteger lowCount = [tf2.text integerValue];
    NSInteger pulseCount = [tf3.text integerValue];
    
    //提交数据
    NSString *aUrl = [NSString stringWithFormat:@"%@/member/uploadData.jhtml",URL_PRE];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:aUrl]];
    [request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]];
    [request setPostValue:[UserShareOnce shareOnce].uid forKey:@"memberId"];
    [request addPostValue:subId forKey:@"memberChildId"];
    [request addPostValue:@(30) forKey:@"datatype"];
    [request addPostValue:@(highCount) forKey:@"highPressure"];
    [request addPostValue:@(lowCount) forKey:@"lowPressure"];
    [request addPostValue:@(pulseCount) forKey:@"pulse"];
    [request addPostValue:[UserShareOnce shareOnce].token forKey:@"token"];
    [request setTimeOutSeconds:20];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestError:)];
    [request setDidFinishSelector:@selector(requestCompleted:)];
    [request startAsynchronous];
}

- (void)requestResourceslistail:(ASIHTTPRequest *)request
{
    
//    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取子账户信息失败!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
//    av.tag = 100008;
//    [av show];
//    [av release];
}

- (void)requestResourceslistFinish:(ASIHTTPRequest *)request
{
    // [self hudWasHidden:nil];
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    id status=[dic objectForKey:@"status"];
    if ([status intValue]==100)
    {
        _personView.hidden = NO;
        _showView.hidden = NO;
        [self.view bringSubviewToFront:_personView];
        [self.view bringSubviewToFront:_showView];
        
        self.dataArr=[dic objectForKey:@"data"];
        [self.tableView reloadData];
    }
    else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.removeFromSuperViewOnHide =YES;
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"当前账户已过期，请重新登录";  //提示的内容
        hud.minSize = CGSizeMake(132.f, 108.0f);
        [hud hideAnimated:YES afterDelay:2];
        
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        [login release];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AdvisoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        UIImageView *aimage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 13.5, 53 / 2, 53 / 2)];
        aimage.image = [UIImage imageNamed:@"4111_11.png"];
        [cell addSubview:aimage];
    }else{
        UIImageView *aimage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 13.5, 53 / 2, 53 / 2)];
        aimage.image = [UIImage imageNamed:@"4123_15.png"];
        [cell addSubview:aimage];
    }
    if ([[self.dataArr[indexPath.row] objectForKey:@"name"]isEqualToString:[UserShareOnce shareOnce].username]) {
        cell.nameLabel.text = [UserShareOnce shareOnce].name;
    }else{
        cell.nameLabel.text = [self.dataArr[indexPath.row] objectForKey:@"name"];
    }
    
    int sesss ;
    int age ;
    
    if ([[self.dataArr[indexPath.row] objectForKey:@"birthday"]isEqual:[NSNull null]] ) {
        NSString *sex = @"";
        if ([[UserShareOnce shareOnce].gender isEqual:[NSNull null]]||[[UserShareOnce shareOnce].gender isEqualToString:@"male"]) {
            sex =@"男" ;
        }else{
            sex = @"女";
        }
        
        cell.sexLabel.text = [NSString stringWithFormat:@"%@",sex];
        cell.phoneLabel.text = [NSString stringWithFormat:@"%@岁",@"0"];
        
    }else{
        NSString *sex = @"";
        if ([[self.dataArr[indexPath.row] objectForKey:@"gender"]isEqual:[NSNull null]]||[[self.dataArr[indexPath.row] objectForKey:@"gender"] isEqualToString:@"male"]) {
            sex =@"男" ;
        }else{
            sex = @"女";
        }
        
        NSString *str = [[self.dataArr[indexPath.row] objectForKey:@"birthday"] substringToIndex:4];
        sesss = [str intValue];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDate *now;
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
        NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        now=[NSDate date];
        comps = [calendar components:unitFlags fromDate:now];
        age = (int)[comps year] - sesss;
        // NSString *sexStr = [NSString stringWithFormat:@"(%@%d岁)",sex,age];
        cell.sexLabel.text = [NSString stringWithFormat:@"%@",sex];
        cell.phoneLabel.text = [NSString stringWithFormat:@"%d岁",age];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _personView.hidden = YES;
    _showView.hidden = YES;
    self.headArray = self.dataArr[indexPath.row];
    int age = 0;
    
    if ([[self.dataArr[indexPath.row] objectForKey:@"name"]isEqualToString:[UserShareOnce shareOnce].username]) {
        _nameLabel.text = [UserShareOnce shareOnce].name;
        
    }else{
        _nameLabel.text = [self.dataArr[indexPath.row] objectForKey:@"name"];
    }
    NSString *sex = @"";
    if ([[self.dataArr[indexPath.row] objectForKey:@"gender"]isEqual:[NSNull null]]||[[self.dataArr[indexPath.row] objectForKey:@"gender"] isEqualToString:@"male"]) {
        sex =@"男" ;
    }else{
        sex = @"女";
    }
    _memberChildId = [self.dataArr[indexPath.row] objectForKey:@"id"];
    NSString *str = @"";
    if ([[self.dataArr[indexPath.row] objectForKey:@"birthday"] isEqual:[NSNull null]]) {
        // str = [[UserShareOnce shareOnce].birthday substringToIndex:4];
        age = 0;
    }else{
        str = [[self.dataArr[indexPath.row] objectForKey:@"birthday"] substringToIndex:4];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDate *now;
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
        NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        now=[NSDate date];
        comps = [calendar components:unitFlags fromDate:now];
        age = (int)[comps year] - [str intValue];
    }
    
    NSDictionary *memberDic = [[NSDictionary alloc] initWithDictionary:self.dataArr[indexPath.row]];
    NSNumber *memberId = @(0);
    memberId = memberDic[@"id"];
    
    UITextField *tf1 = _TextFieldArr[0];
    UITextField *tf2 = _TextFieldArr[1];
    UITextField *tf3 = _TextFieldArr[2];
    NSInteger highCount = [tf1.text integerValue];
    NSInteger lowCount = [tf2.text integerValue];
    NSInteger pulseCount = [tf3.text integerValue];
    
    //提交数据
    NSString *aUrl = [NSString stringWithFormat:@"%@/member/uploadData.jhtml",URL_PRE];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:aUrl]];
    [request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]];
    [request setPostValue:[UserShareOnce shareOnce].uid forKey:@"memberId"];
    [request addPostValue:memberId forKey:@"memberChildId"];
    [request addPostValue:@(30) forKey:@"datatype"];
    [request addPostValue:@(highCount) forKey:@"highPressure"];
    [request addPostValue:@(lowCount) forKey:@"lowPressure"];
    [request addPostValue:@(pulseCount) forKey:@"pulse"];
    [request addPostValue:[UserShareOnce shareOnce].token forKey:@"token"];
    [request setTimeOutSeconds:20];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestError:)];
    [request setDidFinishSelector:@selector(requestCompleted:)];
    [request startAsynchronous];
    [memberDic release];
}
-(void)requestCompleted:(ASIHTTPRequest *)request{
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    //NSDictionary *dataDic = dic[@"data"];
    NSNumber *state = dic[@"status"];
    if (state.integerValue == 100) {
        NSLog(@"数据提交成功");
        //弹出视图，展现结果
        UITextField *tf1 = _TextFieldArr[0];
        UITextField *tf2 = _TextFieldArr[1];
        UITextField *tf3 = _TextFieldArr[2];
        NSInteger highCount = [tf1.text integerValue];
        NSInteger lowCount = [tf2.text integerValue];
        NSInteger pulseCount = [tf3.text integerValue];
        
        //NSString *resultStr = [[NSString alloc] init];
        
        
        UIView *view = [[UIView alloc] initWithFrame:self.view.frame];
        view.tag = 331;
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.3;
        UIView *view2 = [[UIView alloc] initWithFrame:self.view.frame];
        view2.backgroundColor = [UIColor clearColor];
        view2.tag = 332;
        self.view.userInteractionEnabled = YES;
        view.userInteractionEnabled = YES;
        view2.userInteractionEnabled = YES;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width-40, 180)];
        imageView.center = self.view.center;
        imageView.userInteractionEnabled = YES;
        imageView.image = [UIImage imageNamed:@"bounceView"];
//        imageView.layer.cornerRadius = 15.0;
//        imageView.clipsToBounds = YES;
        

        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sureBtn setBackgroundImage:[UIImage imageNamed:@"sure"] forState:UIControlStateNormal];
        [sureBtn setTitle:@"返回检测" forState:UIControlStateNormal];
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        sureBtn.frame = CGRectMake(20, kScreenSize.height/2+90, imageView.frame.size.width * 0.5, 40);
        [sureBtn addTarget:self action:@selector(confirmBtnClick2:) forControlEvents:UIControlEventTouchUpInside];
        [view2 addSubview:sureBtn];
        
        UIButton *lookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [lookBtn setBackgroundImage:[UIImage imageNamed:@"look"] forState:UIControlStateNormal];
        [lookBtn setTitle:@"查看档案" forState:UIControlStateNormal];
        lookBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        lookBtn.frame = CGRectMake(CGRectGetMaxX(sureBtn.frame), sureBtn.frame.origin.y, imageView.frame.size.width * 0.5, 40);
        [lookBtn addTarget:self action:@selector(lookClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [view2 addSubview:lookBtn];
        
        UILabel *countLabel = [Tools labelWith:[NSString stringWithFormat:@"您当前脉搏%ld次/分\n收缩压  %ldmmHg\n舒张压  %ldmmhg",(long)pulseCount,(long)highCount,(long)lowCount] frame:CGRectMake(0, 50, imageView.bounds.size.width, 60) textSize:14 textColor:[Tools colorWithHexString:@"#e79947"] lines:0 aligment:NSTextAlignmentCenter];
        
        
        UILabel *label0 = [[UILabel alloc] init];
        label0.text = @"血压、脉搏正常范围参考值：";
        label0.textAlignment = NSTextAlignmentCenter;
        label0.font = [UIFont systemFontOfSize:13];
        label0.frame = CGRectMake(20, 110, imageView.bounds.size.width-40, 20);
        [imageView addSubview:label0];
        
        UILabel *label1 = [[UILabel alloc] init];
        label1.text = @"脉搏：60－100次/分";
        label1.textAlignment = NSTextAlignmentCenter;
        label1.font = [UIFont systemFontOfSize:12];
        label1.frame = CGRectMake(20, CGRectGetMaxY(label0.frame), imageView.bounds.size.width-40, 16);
        [imageView addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] init];
        label2.text = @"90 < 高压 / 收缩压（mmHg）< 140";
        label2.textAlignment = NSTextAlignmentCenter;
        label2.font = [UIFont systemFontOfSize:12];
        label2.frame = CGRectMake(20, CGRectGetMaxY(label1.frame), imageView.bounds.size.width-40, 16);
        [imageView addSubview:label2];
        
        UILabel *label3 = [[UILabel alloc] init];
        label3.text = @"60 < 低压 / 舒张压（mmHg）< 90";
        label3.textAlignment = NSTextAlignmentCenter;
        label3.font = [UIFont systemFontOfSize:12];
        label3.frame = CGRectMake(20, CGRectGetMaxY(label2.frame), imageView.bounds.size.width-40, 16);
        [imageView addSubview:label3];
        
        [imageView addSubview:countLabel];
        [view2 addSubview:imageView];
        [self.view addSubview:view];
        [self.view addSubview:view2];
        //        [view2 addSubview:confirmBtn];
        [imageView release];
        [view release];
        [view2 release];

        
    }else{
        [self showAlertWarmMessage:@"提交数据失败"];
    }
    
    
    //[self customeView];
}

-(void)requestError:(ASIHTTPRequest *)request{
    [self showAlertWarmMessage:@"提交数据失败"];
}


//点击确定
-(void)confirmBtnClick2:(UIButton *)button{
    UIView *v1 = [self.view viewWithTag:331];
    UIView *v2 = [self.view viewWithTag:332];
    [v1 removeFromSuperview];
    [v2 removeFromSuperview];
}

//查看档案
- (void)lookClickBtn:(UIButton *)btn{
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *controller = app.window.rootViewController;
    UITabBarController  *rvc = (UITabBarController  *)controller;
    [rvc setSelectedIndex:1];
    [UserShareOnce shareOnce].wherePop = @"血压";
    [UserShareOnce shareOnce].bloodMemberID = [NSString stringWithFormat:@"%@",[MemberUserShance shareOnce].idNum];;
    [self.navigationController popToRootViewControllerAnimated:YES];
    
//    UITabBarController *main = [(AppDelegate*)[UIApplication sharedApplication].delegate tabBar];
//    main.selectedIndex = 1;
//    UINavigationController *nav = main.selectedViewController;
//    ArchivesController *vc = (ArchivesController *)nav.topViewController;
//    vc.currentIndex = 5;
//
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    window.rootViewController = main;
    
}
@end
