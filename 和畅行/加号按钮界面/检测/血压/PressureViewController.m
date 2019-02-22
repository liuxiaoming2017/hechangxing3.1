//
//  PressureViewController.m
//  Voicediagno
//
//  Created by Mymac on 15/9/23.
//  Copyright (c) 2015年 Mymac. All rights reserved.
//

#import "PressureViewController.h"
#import "BloodGuideViewController.h"
#import "BloodPressureNonDeviceViewController.h"
#import "HHBlueToothManager.h"
#import "AdvisoryTableViewCell.h"
#import "LoginViewController.h"
#import "SubMemberView.h"
#import "NSObject+SBJson.h"
#import "ArchivesController.h"
static int const tick = 80;

@interface PressureViewController ()<MBProgressHUDDelegate,ASIHTTPRequestDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UILabel *pulseLabel;
@property (nonatomic,strong)UILabel *shrinkPressureLabel;
@property (nonatomic,strong)UILabel *diastolicPressureLabel;
@property (nonatomic,strong)HHBlueToothManager *manager;
/**imageViewImage*/
@property (nonatomic,strong) UIImageView *imageViewImage;
/**stateLabel*/
@property (nonatomic,strong) UILabel *stateLabel;
/**boodArray*/
@property (nonatomic,strong) NSArray *boodArray;
/**startCheck*/
@property (nonatomic,strong) UIButton *startCheck;
/**commitBtn*/
@property (nonatomic,strong) UIButton *commitBtn;
/**nonDeviceCheck*/
@property (nonatomic,strong) UIButton *nonDeviceCheck;

/**countdownLabel*/
@property (nonatomic,strong) UILabel *countdownLabel;

@property(nonatomic,strong)NSTimer *timer;

/**timeCount*/
@property (nonatomic,assign) int timeCount;

/**subId*/
@property (nonatomic,copy) NSString *subId;

@property (nonatomic,assign) BOOL isHidden;

@end

@implementation PressureViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//- (void)goBack:(UIButton *)btn
//{
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
     [_timer invalidate];
    self.timer = nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navTitleLabel.text =  ModuleZW(@"血压脉搏检测");
    [self initWithController];
    
    //血压检测
    [self bloodTest];
    self.isHidden = NO;
    
    
//    UIButton *lookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [lookBtn setBackgroundImage:[UIImage imageNamed:@"look"] forState:UIControlStateNormal];
//    [lookBtn setTitle:@"查看档案" forState:UIControlStateNormal];
//    lookBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    lookBtn.frame = CGRectMake(100 ,200, 100, 40);
//    [lookBtn addTarget:self action:@selector(lookClickBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:lookBtn];
}

-(void)backClick:(UIButton *)button{
    [self.navigationController popToRootViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];
}

-(void)initWithController{
    
    //背景图片
//    UIImageView *bgView = [[UIImageView alloc] init];
//    bgView.frame = CGRectMake(0, 64, kScreenSize.width,kScreenSize.height);
//    bgView.image = [UIImage imageNamed:@"healthBg"];
//    [self.view addSubview:bgView];
    
    
    //倒计时
    UIImageView *countdownView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 90, 50, 40)];
    countdownView.image = [UIImage imageNamed:@"0_06"];
    [self.view addSubview:countdownView];
    
    UILabel *countdownLabel = [Tools creatLabelWithFrame:CGRectMake(0, 13, countdownView.frame.size.width, 15) text:ModuleZW(@"80 秒") textSize:16];
    countdownLabel.textAlignment = NSTextAlignmentCenter;
    countdownLabel.textColor = [UIColor whiteColor];
    self.countdownLabel = countdownLabel;
    [countdownView addSubview:countdownLabel];
    
    //连接状态
    UIImageView *stateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenSize.width-60, 90, 50, 40)];
    stateImageView.image = [UIImage imageNamed:@"0_06"];
    
    UIImageView *imageViewImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 2, 30, 25)];
    imageViewImage.image = [UIImage imageNamed:@"unconnectedImage"];
    [stateImageView addSubview:imageViewImage];
    self.imageViewImage = imageViewImage;
    
    UILabel *stateLabel = [Tools creatLabelWithFrame:CGRectMake(0, 25, stateImageView.frame.size.width, 15) text:ModuleZW(@"未连接") textSize:14];
    stateLabel.textAlignment = NSTextAlignmentCenter;
    stateLabel.font = [UIFont boldSystemFontOfSize:10];
    stateLabel.textColor = [UIColor whiteColor];
    //stateLabel.adjustsFontSizeToFitWidth = YES;
    self.stateLabel = stateLabel;
    [stateImageView addSubview:stateLabel];
    
    
    [self.view addSubview:stateImageView];
   
    
    //显示用户脉搏、收缩压、舒张压信息
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, kScreenSize.height==480? 120: 140, kScreenSize.width-20, 220)];
    imageView.image = [UIImage imageNamed:@"血压02"];
    [self.view addSubview:imageView];
    //脉搏
    UILabel *pulse = [Tools creatLabelWithFrame:CGRectMake(15, 30, 80, 46.7) text:ModuleZW(@"脉搏") textSize:19];
    pulse.font = [UIFont systemFontOfSize:19];
    pulse.textAlignment = NSTextAlignmentRight;
    pulse.textColor = [UIColor whiteColor];
    [imageView addSubview:pulse];
    //pulse.backgroundColor = [UIColor redColor];
    
    _pulseLabel = [Tools creatLabelWithFrame:CGRectMake(100, 30, 80, 46.7) text:@"- -/" textSize:29];
    _pulseLabel.font = [UIFont systemFontOfSize:29];
    _pulseLabel.textAlignment = NSTextAlignmentRight;
    _pulseLabel.textColor = [UIColor whiteColor];
    [imageView addSubview:_pulseLabel];
    //_pulseLabel.backgroundColor = [UIColor redColor];
    
    UILabel *pulseUnit = [Tools creatLabelWithFrame:CGRectMake(180, 35, 30, 46.7) text:ModuleZW(@"分") textSize:16];
    pulseUnit.font = [UIFont systemFontOfSize:16];
    pulseUnit.textAlignment = NSTextAlignmentLeft;
    pulseUnit.textColor = [UIColor whiteColor];
    [imageView addSubview:pulseUnit];
    //pulseUnit.backgroundColor = [UIColor redColor];
    
    //收缩压
    UILabel *shrink = [Tools creatLabelWithFrame:CGRectMake(15, 81.7, 80, 46.7) text:ModuleZW(@"收缩压") textSize:19];
    shrink.font = [UIFont systemFontOfSize:19];
    shrink.textAlignment = NSTextAlignmentRight;
    shrink.textColor = [UIColor whiteColor];
    [imageView addSubview:shrink];
    
    _shrinkPressureLabel = [Tools creatLabelWithFrame:CGRectMake(100, 81.7, 80, 46.7) text:@"- -/" textSize:29];
    _shrinkPressureLabel.font = [UIFont systemFontOfSize:29];
    _shrinkPressureLabel.textAlignment = NSTextAlignmentRight;
    _shrinkPressureLabel.textColor = [UIColor whiteColor];
    [imageView addSubview:_shrinkPressureLabel];
    
    UILabel *shrinkUnit = [Tools creatLabelWithFrame:CGRectMake(180, 86.7, 50, 46.7) text:@"mmHg" textSize:16];
    shrinkUnit.font = [UIFont systemFontOfSize:16];
    shrinkUnit.textAlignment = NSTextAlignmentLeft;
    shrinkUnit.textColor = [UIColor whiteColor];
    [imageView addSubview:shrinkUnit];
    
    //舒张压
    UILabel *diastolic = [Tools creatLabelWithFrame:CGRectMake(15, 133.4, 80, 46.7) text:ModuleZW(@"舒张压") textSize:19];
    diastolic.font = [UIFont systemFontOfSize:19];
    diastolic.textAlignment = NSTextAlignmentRight;
    diastolic.textColor = [UIColor whiteColor];
    [imageView addSubview:diastolic];
    
    _diastolicPressureLabel = [Tools creatLabelWithFrame:CGRectMake(100, 133.4, 80, 46.7) text:@"- -/" textSize:29];
    _diastolicPressureLabel.font = [UIFont systemFontOfSize:29];
    _diastolicPressureLabel.textAlignment = NSTextAlignmentRight;
    _diastolicPressureLabel.textColor = [UIColor whiteColor];
    [imageView addSubview:_diastolicPressureLabel];
    
    UILabel *diastolicUnit = [Tools creatLabelWithFrame:CGRectMake(180, 138.4, 50, 46.7) text:@"mmHg" textSize:16];
    diastolicUnit.font = [UIFont systemFontOfSize:16];
    diastolicUnit.textAlignment = NSTextAlignmentLeft;
    diastolicUnit.textColor = [UIColor whiteColor];
    [imageView addSubview:diastolicUnit];
    
    
    [self createButton];
    
}


-(void)createButton{
    UIButton *startCheck = [Tools creatButtonWithFrame:CGRectMake(50, kScreenSize.height==480 ? 350: 390, kScreenSize.width-100, (kScreenSize.width-100)/6.0) target:self sel:@selector(startCheckClick:) tag:11 image:@"血压03" title:nil];
    startCheck.enabled = NO;
    self.startCheck = startCheck;
    [self.view addSubview:startCheck];
    
    UIButton *nonDeviceCheck = [Tools creatButtonWithFrame:CGRectMake(50,startCheck.bottom+20, kScreenSize.width-100, (kScreenSize.width-100)/6.0) target:self sel:@selector(nonDeviceChekClick:) tag:12 image:@"血压05" title:nil];
    nonDeviceCheck.enabled = YES;
    self.nonDeviceCheck = nonDeviceCheck;
    [self.view addSubview:nonDeviceCheck];
    
    //使用规范
    UIButton *useNorm = [Tools creatButtonWithFrame:CGRectMake(kScreenSize.width/2-30,nonDeviceCheck.bottom+15, 60, 25) target:self sel:@selector(useNormClick:) tag:101 image:@"使用规范" title:nil];
    [self.view addSubview:useNorm];
}

-(void)startCheckClick:(UIButton *)button{
    NSLog(@"点击开始检测按钮");
//    [button removeFromSuperview];
//    UIButton *commitBtn = [Tools creatButtonWithFrame:CGRectMake(50, kScreenSize.height==480 ? 350: 390, kScreenSize.width-100, 40) target:self sel:@selector(reChekBtnClick:) tag:13 image:@"血压04" title:nil];
//    commitBtn.enabled = YES;
//    self.commitBtn = commitBtn;
//    [self.view addSubview:commitBtn];
    
    [self.startCheck setImage:[UIImage imageNamed:@"血压04"] forState:UIControlStateNormal];
    self.isHidden = NO;
    self.nonDeviceCheck.enabled = NO;
    
//    UIButton *reCheckBtn = [Tools creatButtonWithFrame:CGRectMake(50, kScreenSize.height==480 ? 400:450, kScreenSize.width-100, 40) target:self sel:@selector(reChekBtnClick:) tag:14 image:@"血压04" title:nil];
//    [self.view addSubview:reCheckBtn];
    
    
    //开始检测通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kPERIPHERAL_BEGIN object:nil userInfo:nil];
    
    //开始倒计时
    [self startCountDown];
    
    
//    static BOOL isPressed = NO;
//    
//    UIButton *repeatCheck = (UIButton *)[self.view viewWithTag:12];
//    if (isPressed) {
//        isPressed = NO;
//        [repeatCheck setImage:[UIImage imageNamed:@"血压05"] forState:UIControlStateNormal];
//        [button setImage:[UIImage imageNamed:@"血压03"] forState:UIControlStateNormal];
//    }else{
//        isPressed = YES;
//        [repeatCheck setImage:[UIImage imageNamed:@"血压04"] forState:UIControlStateNormal];
//        [button setImage:[UIImage imageNamed:@"血压06"] forState:UIControlStateNormal];
//    }
}

-(void)nonDeviceChekClick:(UIButton *)button{
    NSLog(@"点击非设备检测");
    BloodPressureNonDeviceViewController *nonDeviceCheck = [[BloodPressureNonDeviceViewController alloc] init];
    [self.navigationController pushViewController:nonDeviceCheck animated:YES];
    
}

-(void)commitBtnClick:(UIButton *)button{
  
    
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
    
    
    [self showPreogressView];
    NSInteger highCount = [self.boodArray[5] integerValue];
    NSInteger lowCount = [self.boodArray[3] integerValue];
    NSInteger pulseCount = [self.boodArray[4] integerValue];
    
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

-(void)reChekBtnClick:(UIButton *)button{
    //开始检测通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kPERIPHERAL_BEGIN object:nil userInfo:nil];
}



-(void)useNormClick:(UIButton *)button{
    NSLog(@"点击使用规范");
    [[NSUserDefaults standardUserDefaults] setObject:@"11" forKey:@"clickUseNorm_blood"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    BloodGuideViewController *bloodGuide = [[BloodGuideViewController alloc] init];
    [self.navigationController pushViewController:bloodGuide animated:YES];
    
}

//血压检测
- (void)bloodTest{
    
    self.manager = [[HHBlueToothManager alloc] init];
    
    
    __weak typeof(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:kCONNECTED_STATE_CHANGED object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        NSLog(@"蓝牙连接状态：%@",weakSelf.manager.connectState);
        if ([weakSelf.manager.connectState isEqualToString:kCONNECTED_POWERD_ON]) {
            NSLog(@"蓝牙已经打开，等待搜寻设备的services和characteristics");
        }
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:kPERIPHERAL_CONNECTED object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        NSLog(@"外设已连接，可以开始测量");
        
        weakSelf.stateLabel.text = ModuleZW(@"已连接");
        weakSelf.imageViewImage.image = [UIImage imageNamed:@"connectedImage"];
        weakSelf.startCheck.enabled = YES;
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kPERIPHERAL_CONNECT_FAILED object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        NSLog(@"外设连接失败");
        //        [SVProgressHUD showInfoWithStatus:@"设备连接失败"];
        
        weakSelf.stateLabel.text = ModuleZW(@"未连接");
        weakSelf.imageViewImage.image = [UIImage imageNamed:@"unconnectedImage"];
        weakSelf.startCheck.enabled = NO;
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:kPERIPHERAL_DISCONNECTED object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        NSLog(@"外设断开连接");
        
        weakSelf.stateLabel.text = ModuleZW(@"未连接");
        weakSelf.imageViewImage.image = [UIImage imageNamed:@"unconnectedImage"];
        weakSelf.startCheck.enabled = NO;
        
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kPERIPHERAL_DATA object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        NSLog(@"接收血压检测数据：%@",note.userInfo);
        
        NSArray *dataArray = note.userInfo[@"dataArray"];
        
        if (dataArray.count > 0) {
            
            weakSelf.commitBtn.enabled = YES;
            NSString *pulseLabelStr = @"";
            NSString *shrinkPressureLabelStr = @"";
            NSString *diastolicPressureLabelStr = @"";
            if(dataArray.count>5){
                pulseLabelStr = [dataArray[5] stringValue];
               //self->_pulseLabel.text = [NSString stringWithFormat:@"%@ /",dataArray[5]];
            }
            if(dataArray.count>3){
                shrinkPressureLabelStr = [dataArray[3] stringValue];
                //self->_shrinkPressureLabel.text = [NSString stringWithFormat:@"%@ /",dataArray[3]];
            }
            if(dataArray.count>4){
                diastolicPressureLabelStr = [dataArray[4] stringValue];
                //self->_diastolicPressureLabel.text = [NSString stringWithFormat:@"%@ /",dataArray[4]];
            }
            if([pulseLabelStr isEqualToString:@"255"] && [shrinkPressureLabelStr isEqualToString:@"255"] && [diastolicPressureLabelStr isEqualToString:@"255"]){
                
            }else{
                weakSelf.boodArray = dataArray;
                weakSelf.pulseLabel.text = [NSString stringWithFormat:@"%@ /",pulseLabelStr];
                weakSelf.shrinkPressureLabel.text = [NSString stringWithFormat:@"%@ /",shrinkPressureLabelStr];
                weakSelf.diastolicPressureLabel.text = [NSString stringWithFormat:@"%@ /",diastolicPressureLabelStr];
                if(weakSelf.isHidden == NO){
                    weakSelf.isHidden = YES;
                    [weakSelf commitBtnClick:nil];
                    [weakSelf stopTimer];
                }
            }
        }
        
    }];
    
    //开启一个线程接收数据
//    dispatch_queue_t queue = dispatch_queue_create("com.huaxinlongma.handleDataQueue", NULL);
//    dispatch_async(queue, ^{
//        
//        
//    }) ;
    
}


//点击确定
-(void)confirmBtnClick2:(UIButton *)button{
    UIView *v1 = [self.view viewWithTag:331];
    UIView *v2 = [self.view viewWithTag:332];
    [v1 removeFromSuperview];
    [v2 removeFromSuperview];
    
    self.nonDeviceCheck.enabled = YES;
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
   
    
    
}

-(void)tapScreen:(UITapGestureRecognizer *)tap{
    [_showView setHidden:YES];
    [_personView setHidden:YES];
}


#pragma mark -------- 选择子账户
-(void)GetWithModifi
{
    // [self showHUD];
    NSString *UrlPre=URL_PRE;
    NSString *aUrlle= [NSString stringWithFormat:@"%@/member/memberModifi/list.jhtml?memberId=%@",UrlPre,[UserShareOnce shareOnce].uid];
    aUrlle = [aUrlle stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:aUrlle];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]];
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:20];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestResourceslistail:)];
    [request setDidFinishSelector:@selector(requestResourceslistFinish:)];
    [request startAsynchronous];
}

- (void)requestResourceslistail:(ASIHTTPRequest *)request
{
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:ModuleZW(@"提示") message:ModuleZW(@"获取子账户信息失败!") delegate:self cancelButtonTitle:ModuleZW(@"确定") otherButtonTitles:nil,nil];
    av.tag = 100008;
    [av show];
    
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
        hud.label.text = ModuleZW(@"当前账户已过期，请重新登录");  //提示的内容
        hud.minSize = CGSizeMake(132.f, 108.0f);
        [hud hideAnimated:YES afterDelay:2];
        
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        
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
            sex =ModuleZW(@"男");
        }else{
            sex = ModuleZW(@"女");
        }
        
        cell.sexLabel.text = [NSString stringWithFormat:@"%@",sex];
        cell.phoneLabel.text = [NSString stringWithFormat:@"%@岁",@"0"];
        
    }else{
        NSString *sex = @"";
        if ([[self.dataArr[indexPath.row] objectForKey:@"gender"]isEqual:[NSNull null]]||[[self.dataArr[indexPath.row] objectForKey:@"gender"] isEqualToString:@"male"]) {
            sex =ModuleZW(@"男");
        }else{
            sex = ModuleZW(@"女");
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
        sex =ModuleZW(@"男") ;
    }else{
        sex = ModuleZW(@"女");
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
    
    NSInteger highCount = [self.boodArray[5] integerValue];
    NSInteger lowCount = [self.boodArray[3] integerValue];
    NSInteger pulseCount = [self.boodArray[4] integerValue];
    
    [self showPreogressView];
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
    
}

-(void)requestCompleted:(ASIHTTPRequest *)request{
    [self hidePreogressView];
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    //NSDictionary *dataDic = dic[@"data"];
    NSNumber *state = dic[@"status"];
    if (state.integerValue == 100) {
        NSLog(@"数据提交成功");
        //弹出视图，展现结果
        NSInteger highCount = [self.boodArray[3] integerValue];
        NSInteger lowCount = [self.boodArray[4] integerValue];
        NSInteger pulseCount = [self.boodArray[5] integerValue];
        //NSString *resultStr = [[NSString alloc] init];
        
        
        UIView *view = [[UIView alloc] initWithFrame:self.view.frame];
        view.tag = 331;
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.3;
        UIView *view2 = [[UIView alloc] initWithFrame:self.view.frame];
        view2.tag = 332;
        self.view.userInteractionEnabled = YES;
        view.userInteractionEnabled = YES;
        view2.userInteractionEnabled = YES;
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
        
        UILabel *countLabel = [Tools labelWith:[NSString stringWithFormat:@"%@%ld%@\n  %@%ldmmHg\n%@ %ldmmhg",ModuleZW(@"您当前脉搏"),(long)pulseCount,ModuleZW(@"次/分"),ModuleZW(@"收缩压"),(long)highCount,ModuleZW(@"舒张压 "),(long)lowCount] frame:CGRectMake(0, 50, imageView.bounds.size.width, 60) textSize:14 textColor:[Tools colorWithHexString:@"#e79947"] lines:0 aligment:NSTextAlignmentCenter];

        
        UILabel *label0 = [[UILabel alloc] init];
        label0.text = ModuleZW(@"血压、脉搏正常范围参考值：");
        label0.textAlignment = NSTextAlignmentCenter;
        label0.font = [UIFont systemFontOfSize:13];
        label0.frame = CGRectMake(20, 110, imageView.bounds.size.width-40, 20);
        [imageView addSubview:label0];
        
        UILabel *label1 = [[UILabel alloc] init];
        label1.text = ModuleZW(@"脉搏：60－100次/分");
        label1.textAlignment = NSTextAlignmentCenter;
        label1.font = [UIFont systemFontOfSize:12];
        label1.frame = CGRectMake(20, CGRectGetMaxY(label0.frame), imageView.bounds.size.width-40, 16);
        [imageView addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] init];
        label2.text =ModuleZW( @"90 < 高压 / 收缩压（mmHg）< 140");
        label2.textAlignment = NSTextAlignmentCenter;
        label2.font = [UIFont systemFontOfSize:12];
        label2.frame = CGRectMake(20, CGRectGetMaxY(label1.frame), imageView.bounds.size.width-40, 16);
        [imageView addSubview:label2];
        
        UILabel *label3 = [[UILabel alloc] init];
        label3.text = ModuleZW(@"60 < 低压 / 舒张压（mmHg）< 90");
        label3.textAlignment = NSTextAlignmentCenter;
        label3.font = [UIFont systemFontOfSize:12];
        label3.frame = CGRectMake(20, CGRectGetMaxY(label2.frame), imageView.bounds.size.width-40, 16);
        [imageView addSubview:label3];
        
        [imageView addSubview:countLabel];
        [view2 addSubview:imageView];
        [self.view addSubview:view];
        [self.view addSubview:view2];
//        [view2 addSubview:confirmBtn];
       
        
    }else{
        [self showAlertWarmMessage:ModuleZW(@"提交数据失败")];
        
    }
    
    
    //[self customeView];
}

-(void)requestError:(ASIHTTPRequest *)request{
    [self hidePreogressView];
    [self showAlertWarmMessage:ModuleZW(@"提交数据失败")];
    
}

/**
 *  开始倒计时
 */
-(void)startCountDown {
    
    [self stopTimer];
    
    self.timeCount = tick;
    self.countdownLabel.text = [NSString stringWithFormat:@"%d %@",self.timeCount,ModuleZW(@"秒")];
    
    _timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

/**
 *  停止倒计时

 */
- (void)stopTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)countDown:(NSTimer *)timer{
    self.timeCount -= 1;
    self.countdownLabel.text = [NSString stringWithFormat:@"%d %@",self.timeCount,ModuleZW(@"秒")];
    
    if (self.timeCount == 1) {
        [self stopTimer];
       
    }
}

//查看档案
- (void)lookClickBtn:(UIButton *)btn{
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *controller = app.window.rootViewController;
    UITabBarController  *rvc = (UITabBarController  *)controller;
    [rvc setSelectedIndex:1];
    [UserShareOnce shareOnce].wherePop = ModuleZW(@"血压");
    [UserShareOnce shareOnce].bloodMemberID = [NSString stringWithFormat:@"%@",self.subId];
    [self.navigationController popToRootViewControllerAnimated:YES];
    

}
@end
