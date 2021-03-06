//
//  AlterViewController.m
//  Voicediagno
//
//  Created by ZhangYunguang on 16/1/11.
//  Copyright © 2016年 ZhangYunguang. All rights reserved.
//

#import "AlterViewController.h"
#import "SonAccount.h"
#import "Global.h"

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import <sys/utsname.h>
#import "ZHPickView.h"
#import "LoginViewController.h"

#define currentMonth [currentMonthString integerValue]
SonAccount *sonAccount;
@interface AlterViewController ()<ZHPickViewDelegate,ASIHTTPRequestDelegate,ASIProgressDelegate,UITextFieldDelegate>
@property(nonatomic,retain)ZHPickView *pickview;
@property(nonatomic,retain)NSIndexPath *indexPath;
@property (nonatomic ,retain) NSMutableArray *imagesArray;//图片数组
@property (nonatomic ,retain) UISegmentedControl* SegSex;
@property (nonatomic ,retain) UISegmentedControl* YiHunSex;
@property (nonatomic, assign) BOOL isChooseSex;
@property (nonatomic, assign) BOOL isChooseMedicare;
@end

@implementation AlterViewController

@synthesize mobilestr;
//@synthesize BirthDay_btn;
@synthesize usernametr;
@synthesize Birthdaystr;
@synthesize genderstr;
@synthesize emailstr;
@synthesize idstr;
@synthesize regcodestr;
@synthesize datePicker;
@synthesize pRegistrationTF,pRegistrationnewTF,pyouxiangTF,pshenfenZTF;
@synthesize PersonInfoTableView=_PersonInfoTableView;
@synthesize customPicker=_customPicker;
@synthesize toolbarCancelDone=_toolbarCancelDone;
@synthesize pngFilePath;
@synthesize currentMonthString=_currentMonthString;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)dealloc
{
    self.dataArray = nil;
    self.datePicker = nil;
    self.model = nil;
    self.customPicker = nil;
}

-(void) showHUD
{
    progress_ = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progress_];
    [self.view bringSubviewToFront:progress_];
    progress_.delegate = self;
    progress_.label.text = ModuleZW(@"加载中...");
    [progress_ showAnimated:YES];
}

- (void)hudWasHidden
{
    
    // Remove HUD from screen when the HUD was hidded
    [progress_ removeFromSuperview];
    
    progress_ = nil;
    
}


-(void)backClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];
}
-(void)RightsAction
{
    if ([BirthDay_btn.titleLabel.text isEqualToString:@""]||[BirthDay_btn.titleLabel.text isEqualToString:ModuleZW(@"请输入出生日期")]   ) {
        [self showAlertWarmMessage:ModuleZW(@"请输入出生日期")];
        return;
    }
    if ([self isBlankString:Yh_TF.text]) {
         [self showAlertWarmMessage:ModuleZW(@"请输入称呼")];
        
        return;
    }
    NSLog(@"--- >> %@",Certificates_Number_Tf.text);
    if ([self isBlankString:Certificates_Number_Tf.text] || [Certificates_Number_Tf.text isEqualToString:ModuleZW(@"请输入证件号码")] || [Certificates_Number_Tf.text isEqualToString:ModuleZW(@"请输入身份证号")]) {
        [self showAlertWarmMessage:ModuleZW(@"请输入证件号码")];
        return;
    }
    
    
    if (![NSString stringWithIDCardValidate:Certificates_Number_Tf.text]) {
        [self showAlertWarmMessage:ModuleZW(@"请输入正确证件号码")];
        return;
    }
    
    if ([self isBlankString:TelephoneLb_Tf.text] || [TelephoneLb_Tf.text isEqualToString:ModuleZW(@"请输入手机号")]) {
        [self showAlertWarmMessage:ModuleZW(@"请输入手机号")];
        return;
    }
    [self showHUD];
    [self restoreView];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    NSString *UrlPre=URL_PRE;
    NSString *aUrl = nil;
    
    if ([self.category isEqualToString:@"addMember"]) {
        aUrl = [NSString stringWithFormat:@"%@/member/memberModifi/save.jhtml",UrlPre];
    }else{
        aUrl = [NSString stringWithFormat:@"%@/member/memberModifi/update.jhtml",UrlPre];
    }

    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:aUrl]];
    [request addRequestHeader:@"token" value:[UserShareOnce shareOnce].token];
    [request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]];
    if([UserShareOnce shareOnce].languageType){
        [request addRequestHeader:@"language" value:[UserShareOnce shareOnce].languageType];
    }
    NSLog(@"---- >  %@",Certificates_Number_Tf.text);
    [request setPostValue:self.model.familyID forKey:@"Id"];
    [request setPostValue:Yh_TF.text forKey:@"name"];
    [request setPostValue:Certificates_Number_Tf.text forKey:@"IDCard"];
    [request setPostValue:IsYiBao forKey:@"isMedicare"];
    [request setPostValue:SexStr forKey:@"gender"];
    [request setPostValue:BirthDay_btn.titleLabel.text forKey:@"birthday"];
    [request setPostValue:TelephoneLb_Tf.text forKey:@"mobile"];
    [request setPostValue:[UserShareOnce shareOnce].uid forKey:@"memberId"];
    
    //
    [request addPostValue:[UserShareOnce shareOnce].token forKey:@"token"];
    [request setTimeOutSeconds:20];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestuserinfossErrorsss:)];
    [request setDidFinishSelector:@selector(requestuserinfossCompleteds:)];
    [request startAsynchronous];
    
}
- (void)requestuserinfossErrorsss:(ASIHTTPRequest *)request
{
    [self hudWasHidden];
    
    [self showAlertWarmMessage:ModuleZW(@"抱歉，请检查您的网络是否畅通")];
}
- (void)requestuserinfossCompleteds:(ASIHTTPRequest *)request
{
    [self hudWasHidden];
    NSString* reqstr=[request responseString];
    NSLog(@"dic==%@",reqstr);
    NSDictionary * dic=[reqstr JSONValue];
    NSLog(@"dic==%@",dic);
    id status=[dic objectForKey:@"status"];
    NSLog(@"%@",[dic objectForKey:@"status"]);
    if ([status intValue]==100) {
        [self changeMemberChildWithData:[dic objectForKey:@"data"]];
        [self showAlertWarmMessage:ModuleZW(@"信息更新成功")];
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:ModuleZW(@"提示") message:ModuleZW(@"信息更新成功") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAct1 = [UIAlertAction actionWithTitle:ModuleZW(@"确定") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertVC addAction:alertAct1];
        [self presentViewController:alertVC animated:YES completion:NULL];
        
    }
    else if ([status intValue]==44)
    {
        
        [self showAlertWarmMessage:ModuleZW(@"登录超时，请重新登录")];
    }else{
        NSString *str = [dic objectForKey:@"data"];
        [self showAlertWarmMessage:str];
    }
    
}

- (void)changeMemberChildWithData:(NSArray *)arrMem
{
    NSMutableArray *memberArr = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dic in  arrMem) {
        ChildMemberModel *model = [ChildMemberModel mj_objectWithKeyValues:dic];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
        [memberArr addObject:data];
    }
    
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberChirldArr"];
    if (arr.count) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"memberChirldArr"];
    }
    NSArray *modelArr = [[NSArray alloc] initWithArray:memberArr];
    
    [[NSUserDefaults standardUserDefaults] setObject:modelArr forKey:@"memberChirldArr"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    // alert.tag=10002;
//    if (alertView.tag==10007)
//    {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//    if (alertView.tag==100008)
//    {
//        LoginViewController *loginVC = [[LoginViewController alloc]init];
//        [self.navigationController pushViewController:loginVC animated:YES];
//    }
//}

- (void)viewDidLoad
{
    self.navigationController.navigationBarHidden = YES;
    _dataArray = [[NSMutableArray alloc]init];
    [super viewDidLoad];
    CGRect tempRect= self.view.frame;
    tempRect.size.height-=45;
    self.view.frame=tempRect;
    NSString *str = nil;
    if ([self.category isEqualToString:@"addMember"]) {
        str = ModuleZW(@"家庭成员");
    }else{
        str = ModuleZW(@"修改信息");
    }
    self.navTitleLabel.text = str;
    self.view.backgroundColor=[UtilityFunc colorWithHexString:@"##f2f1ef"];
    
    UILabel* lb1=[[UILabel alloc] init];
    lb1.frame=CGRectMake(0, kNavBarHeight, ScreenWidth, 1);
    lb1.backgroundColor=[UIColor clearColor];
    [self.view addSubview:lb1];
    
    
    
    _imagesArray = [[NSMutableArray alloc]initWithObjects:@"专家咨询1_03.png",@"专家咨询_06.png",@"专家咨询1_03(111).png",@"专家咨询_08.png",@"专家咨询_13.png",@"专家咨询_16.png", nil];
    
    
    UITableView *tableview=[[UITableView alloc]init];
    tableview.frame=CGRectMake(0,kNavBarHeight, ScreenWidth, ScreenHeight-kNavBarHeight-51-47);
    tableview.delegate=self;
    tableview.dataSource=self;
    tableview.bounces = NO;
    tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableview.backgroundColor=[UIColor clearColor];
    _PersonInfoTableView=tableview;
    [self.view addSubview:tableview];
    
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTouchInSide)];
    tableViewGesture.numberOfTapsRequired = 1;//几个手指点击
    tableViewGesture.cancelsTouchesInView = NO;//是否取消点击处的其他action
    [_PersonInfoTableView addGestureRecognizer:tableViewGesture];
    
    [self.view addSubview:self.topView];

    PersionInfoArray=[NSMutableArray new];
    [PersionInfoArray addObject:ModuleZW(@"称呼：")];
    //    [PersionInfoArray addObject:@"用户名"];
    [PersionInfoArray addObject:ModuleZW(@"性别：")];
    [PersionInfoArray addObject:ModuleZW(@"出生日期：")];
    [PersionInfoArray addObject:ModuleZW(@"是否有医疗保险：")];
    [PersionInfoArray addObject:ModuleZW(@"证件号码：")];
    [PersionInfoArray addObject:ModuleZW(@"手机号码：")];
    ptCenterper=self.view.center;
    
    
    
    
    UIButton *commitBtn = [Tools creatButtonWithFrame:CGRectMake(kScreenSize.width/2-147.5, 380, 295, 45) target:self sel:@selector(RightsAction) tag:444 image:@"家庭成员_提交" title:nil];
    [self.view addSubview:commitBtn];
    [self.view bringSubviewToFront:commitBtn];
    
}

// ------tableView 上添加的自定义手势
- (void)tableViewTouchInSide{
    [self.view endEditing:YES];
    [self restoreView];
    [_pickview remove];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    float height=47;
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return PersionInfoArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 0.000001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LeMedicineCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LeMedicineCell"];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier];
        cell.backgroundColor=[UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    
    cell.imageView.image = [UIImage imageNamed:_imagesArray[indexPath.row]];
    if(indexPath.row==0){
        
        
        UILabel* YhLb=[[UILabel alloc] init];
        YhLb.frame=CGRectMake(45, (cell.frame.size.height-21)/2, 120, 21);
        YhLb.text=[PersionInfoArray objectAtIndex:indexPath.row];
        YhLb.font=[UIFont systemFontOfSize:14];
        YhLb.textColor=[UtilityFunc colorWithHexString:@"#333333"];
        [cell addSubview:YhLb];
        YhLb.backgroundColor=[UIColor whiteColor];
        
        
        Yh_TF=[[UITextField alloc] init];
        Yh_TF.frame=CGRectMake(YhLb.frame.origin.x+YhLb.frame.size.width+5,  (cell.frame.size.height-21)/2, ScreenWidth-YhLb.frame.origin.x-YhLb.frame.size.width-5-20.5, 21);
        
        if ([self.model.name isEqualToString:[UserShareOnce shareOnce].username]) {
            Yh_TF.text= [[UserShareOnce shareOnce].name isKindOfClass:[NSNull class]]? [UserShareOnce shareOnce].username:[UserShareOnce shareOnce].name;
        }else if (self.model.name.length> 26){
            Yh_TF.text = [UserShareOnce shareOnce].wxName;
        }else{
            Yh_TF.text = self.model.name;
        }
        Yh_TF.textAlignment = NSTextAlignmentRight;
        [Yh_TF setValue:[UtilityFunc colorWithHexString:@"#333333"] forKeyPath:@"_placeholderLabel.textColor"];
        [Yh_TF setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
        Yh_TF.returnKeyType=UIReturnKeyDone;
        Yh_TF.delegate=self;
        [Yh_TF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

        [cell addSubview:Yh_TF];
        Yh_TF.font=[UIFont systemFontOfSize:14];
    }
    else if (indexPath.row==1)
    {
        UILabel* SexLb=[[UILabel alloc] init];
        SexLb.frame=CGRectMake(45, (cell.frame.size.height-21)/2, 80, 21);
        SexLb.text=[PersionInfoArray objectAtIndex:indexPath.row];
        SexLb.font=[UIFont systemFontOfSize:14];
        SexLb.textColor=[UtilityFunc colorWithHexString:@"#333333"];
        [cell addSubview:SexLb];
        SexLb.backgroundColor=[UIColor whiteColor];
        
        NSArray *segmentedArray = [[NSArray alloc] initWithObjects:ModuleZW(@"男"),ModuleZW(@"女"),nil];
        _SegSex=[[UISegmentedControl alloc] initWithItems:segmentedArray];
        if (![GlobalCommon stringEqualNull:self.model.gender]) {
            if ( [self.model.gender isEqualToString:@"male"]) {
                _SegSex.selectedSegmentIndex = 0;
                SexStr = @"male";
            }else{
                _SegSex.selectedSegmentIndex = 1;
                SexStr = @"female";
            }
        }
        
        _SegSex.frame=CGRectMake(ScreenWidth-80-40.5, (cell.frame.size.height-26)/2, 100, 26);
        
        _SegSex.segmentedControlStyle = UISegmentedControlStyleBordered;//设置样
        _SegSex.tintColor = [UtilityFunc colorWithHexString:@"#5eb4fd"];
        [cell addSubview:_SegSex];
        [_SegSex addTarget:self action:@selector(SegSexAction1:) forControlEvents:UIControlEventValueChanged];
        
    }
    else if(indexPath.row == 2){
        UILabel* BirthDayLb=[[UILabel alloc] init];
        BirthDayLb.frame=CGRectMake(45, (cell.frame.size.height-21)/2, 120, 21);
        BirthDayLb.text=[PersionInfoArray objectAtIndex:indexPath.row];
        BirthDayLb.font=[UIFont systemFontOfSize:14];
        BirthDayLb.textColor=[UtilityFunc colorWithHexString:@"#333333"];
        [cell addSubview:BirthDayLb];
        BirthDayLb.backgroundColor=[UIColor whiteColor];
        
        BirthDay_btn=[UIButton buttonWithType:UIButtonTypeCustom];
        BirthDay_btn.frame=CGRectMake(BirthDayLb.frame.origin.x+BirthDayLb.frame.size.width+5,  (cell.frame.size.height-21)/2, ScreenWidth-BirthDayLb.frame.origin.x-BirthDayLb.frame.size.width-5-20.5, 21);
        BirthDay_btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        if ([GlobalCommon stringEqualNull:self.model.birthday]) {
            [BirthDay_btn setTitle:ModuleZW(@"请输入出生日期") forState:UIControlStateNormal];
        }else{
            [BirthDay_btn setTitle:self.model.birthday forState:UIControlStateNormal];
        }
        
        [BirthDay_btn addTarget:self action:@selector(BirthDayActive:) forControlEvents:UIControlEventTouchUpInside];
        [BirthDay_btn setTitleColor:[UtilityFunc colorWithHexString:@"#333333"] forState:UIControlStateNormal];
         BirthDay_btn.titleLabel.font=[UIFont systemFontOfSize:14];
        // BirthDay_btn.titleLabel.text = @"请输入生日日期";
        [cell addSubview:BirthDay_btn];
    }
    else if (indexPath.row == 3)
    {
        UILabel* SexLb=[[UILabel alloc] init];
        SexLb.frame=CGRectMake(45, (cell.frame.size.height-21)/2, 120, 21);
        SexLb.text=[PersionInfoArray objectAtIndex:indexPath.row];
        SexLb.font=[UIFont systemFontOfSize:14];
        SexLb.textColor=[UtilityFunc colorWithHexString:@"#333333"];
        [cell addSubview:SexLb];
        SexLb.backgroundColor=[UIColor whiteColor];
        
        NSArray *segmentedArray = [[NSArray alloc] initWithObjects:ModuleZW(@"有"),ModuleZW(@"无"),nil];
        _YiHunSex=[[UISegmentedControl alloc] initWithItems:segmentedArray];
        [_YiHunSex addTarget:self action:@selector(YiHunSexAction1:) forControlEvents:UIControlEventValueChanged];
        _YiHunSex.frame=CGRectMake(ScreenWidth-80-20.5, (cell.frame.size.height-26)/2, 80, 26);
        _YiHunSex.segmentedControlStyle = UISegmentedControlStyleBordered;//设置样
        _YiHunSex.tintColor = [UtilityFunc colorWithHexString:@"#5eb4fd"];
        if ([GlobalCommon stringEqualNull:self.model.isMedicare]||[self.model.isMedicare isEqualToString:@"no"]) {
            _YiHunSex.selectedSegmentIndex = 1;
            IsYiBao = @"no";
        }else{
            _YiHunSex.selectedSegmentIndex = 0;
            IsYiBao =@"yes";
        }
        
        [cell addSubview:_YiHunSex];
        
    }
    else if (indexPath.row == 4)
    {
        UILabel* Certificates_NumberLb=[[UILabel alloc] init];
        Certificates_NumberLb.frame=CGRectMake(45, (cell.frame.size.height-21)/2, 120, 21);
        Certificates_NumberLb.text=[PersionInfoArray objectAtIndex:indexPath.row];
        Certificates_NumberLb.font=[UIFont systemFontOfSize:14];
        Certificates_NumberLb.textColor=[UtilityFunc colorWithHexString:@"#333333"];
        [cell addSubview:Certificates_NumberLb];
        Certificates_NumberLb.backgroundColor=[UIColor whiteColor];
       
        
        Certificates_Number_Tf=[[UITextField alloc] init];
        Certificates_Number_Tf.frame=CGRectMake(Certificates_NumberLb.frame.origin.x+Certificates_NumberLb.frame.size.width+5,  (cell.frame.size.height-21)/2, ScreenWidth-Certificates_NumberLb.frame.origin.x-Certificates_NumberLb.frame.size.width-5-20.5, 21);
        Certificates_Number_Tf.delegate=self;
        Certificates_Number_Tf.textAlignment = NSTextAlignmentRight;
        Certificates_Number_Tf.returnKeyType=UIReturnKeyDone;
        if ([GlobalCommon stringEqualNull:self.model.idcard]) {
            Certificates_Number_Tf.text =ModuleZW( @"请输入身份证号");
        }else{
            Certificates_Number_Tf.text=self.model.idcard;
        }
        [Certificates_Number_Tf setValue:[UtilityFunc colorWithHexString:@"#333333"] forKeyPath:@"_placeholderLabel.textColor"];
        [Certificates_Number_Tf setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
        [cell addSubview:Certificates_Number_Tf];
        Certificates_Number_Tf.keyboardType=UIKeyboardTypeASCIICapable;
        Certificates_Number_Tf.textColor=[UtilityFunc colorWithHexString:@"#333333"];
        Certificates_Number_Tf.font=[UIFont systemFontOfSize:14];
       
        
    }
    else if (indexPath.row == 5)
    {
        UILabel* TelephoneLb=[[UILabel alloc] init];
        TelephoneLb.frame=CGRectMake(45, (cell.frame.size.height-21)/2, 120, 21);
        TelephoneLb.text=[PersionInfoArray objectAtIndex:indexPath.row];
        TelephoneLb.font=[UIFont systemFontOfSize:14];
        TelephoneLb.textColor=[UtilityFunc colorWithHexString:@"#333333"];
        [cell addSubview:TelephoneLb];
        TelephoneLb.backgroundColor=[UIColor whiteColor];
      
        
        TelephoneLb_Tf=[[UITextField alloc] init];
        TelephoneLb_Tf.frame=CGRectMake(TelephoneLb.frame.origin.x+TelephoneLb.frame.size.width+5,  (cell.frame.size.height-21)/2, ScreenWidth-TelephoneLb.frame.origin.x-TelephoneLb.frame.size.width-5-20.5, 21);
        TelephoneLb_Tf.returnKeyType=UIReturnKeyDone;
        TelephoneLb_Tf.delegate=self;
        TelephoneLb_Tf.textAlignment = NSTextAlignmentRight;
        if ([GlobalCommon stringEqualNull:self.model.mobile]) {
            TelephoneLb_Tf.text = ModuleZW(@"请输入手机号");
        }else{
            TelephoneLb_Tf.text=self.model.mobile;
        }
        TelephoneLb_Tf.keyboardType=UIKeyboardTypeNumberPad;
        [TelephoneLb_Tf setValue:[UtilityFunc colorWithHexString:@"#333333"] forKeyPath:@"_placeholderLabel.textColor"];
        [TelephoneLb_Tf setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
        TelephoneLb_Tf.font=[UIFont systemFontOfSize:14];
        [cell addSubview:TelephoneLb_Tf];
        
        
    }
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, cell.bottom-1, ScreenWidth - 20, 1)];
    lineView.backgroundColor =RGB(230, 230, 230);
    [cell addSubview:lineView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor whiteColor];
    return cell;
}
-(void)YiHunSexAction1:(UISegmentedControl *)Seg{
    self.isChooseMedicare = YES;
    NSInteger Index = Seg.selectedSegmentIndex;
    switch (Index) {
        case 0:
        {
            IsYiBao=@"yes";
            break;
        }
        case 1:
        {
            IsYiBao=@"no";
            break;
        }
        default:
            break;
    }
    
    //NSLog(@"Seg.selectedSegmentIndex:%ld",Index);
}
-(void)SegSexAction1:(UISegmentedControl *)Seg{
    self.isChooseSex = YES;
    NSInteger Index = Seg.selectedSegmentIndex;
    switch (Index) {
        case 0:
        {
            SexStr=@"male";
            break;
        }
        case 1:
        {
            SexStr=@"female";
            break;
        }
        default:
            break;
    }
    
}

-(void)CertificatesAactive:(id)sender
{
    if (SelectTF!=nil) {
        [SelectTF resignFirstResponder];
        [self restoreView];
    }
    
    UIAlertController *alectSheet = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:ModuleZW(@"身份证") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:ModuleZW(@"军官证") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:ModuleZW(@"护照") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:ModuleZW(@"其他") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alectSheet addAction:action1];
    [alectSheet addAction:action2];
    [alectSheet addAction:action3];
    [alectSheet addAction:action4];
    [self presentViewController:alectSheet animated:YES completion:NULL];
    
    
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
//                                                             delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil
//                                                    otherButtonTitles:@"身份证", @"军官证",@"护照",@"其它" ,nil];
//    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
//    actionSheet.tag=10006;
//
//    actionSheet.title=@"证件类型";
//    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
   
    
}
-(void) BirthDayActive:(id)sender
{
    if (SelectTF!=nil) {
        [SelectTF resignFirstResponder];
        [self restoreView];
    }
    NSDate *date=[NSDate dateWithTimeIntervalSinceNow:9000000];
    _pickview=[[ZHPickView alloc] initDatePickWithDate:date datePickerMode:UIDatePickerModeDate isHaveNavControler:NO];
    _pickview.maxDate = [NSDate date];
    _pickview.delegate=self;
    [_pickview show];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == Certificates_Number_Tf || textField == TelephoneLb_Tf) {
        if ([textField.text isEqualToString:ModuleZW(@"请输入证件号码")] || [textField.text isEqualToString:ModuleZW(@"请输入身份证号")] || [textField.text isEqualToString:ModuleZW(@"请输入手机号")]) {
            textField.text = nil;
        }
    }
    SelectTF = textField;
    if (textField == Yh_TF) {
        return;
    }
   // [ self resizeViewForInput:nil ];
    
}
-(void)resizeViewForInput:(id)sender
{
    [UIView beginAnimations:@"resize for input" context:nil];
    [UIView setAnimationDuration:0.3f];
    self.view.center = CGPointMake(ptCenterper.x, ptCenterper.y-150);
    [UIView commitAnimations];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self restoreView];
    return YES;
}
-(void)restoreView
{
    [UIView beginAnimations:@"resize for input" context:nil];
    [UIView setAnimationDuration:0.3f];
    self.view.center = CGPointMake(ptCenterper.x, ptCenterper.y+20);
    [UIView commitAnimations];
}
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString {
    NSLog(@"ddfdfd=%@",resultString);
    [BirthDay_btn setTitle:resultString forState:UIControlStateNormal];
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


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
    [_pickview remove];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == TelephoneLb_Tf) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        //so easy
        else if (TelephoneLb_Tf.text.length >= 11) {
            TelephoneLb_Tf.text = [textField.text substringToIndex:11];
            return NO;
        }
    }
    
    if (textField == Yh_TF) {
        
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        //so easy
        else if (Yh_TF.text.length >= 11) {
            Yh_TF.text = [textField.text substringToIndex:11];
            return NO;
        }
        
        
        if (textField.text.length >= 10)
        {
            [self.view endEditing:YES];
            return NO;
        }
    }
    return YES;
}



-(void)textFieldDidChange:(UITextField * )textField
{
    if (textField == Yh_TF) {
        if (textField.text.length > 8) {
            textField.text = [textField.text substringToIndex:8];
        }
    }
}


-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_pickview remove];
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
