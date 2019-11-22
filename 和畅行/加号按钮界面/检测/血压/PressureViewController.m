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

@interface PressureViewController ()<MBProgressHUDDelegate,UITableViewDataSource,UITableViewDelegate>

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



/**subId*/
@property (nonatomic,copy) NSString *subId;

@property (nonatomic,assign) BOOL isHidden;
@property (nonatomic,assign) BOOL canSubmit;

@end

@implementation PressureViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self bloodTest];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navTitleLabel.text =  ModuleZW(@"血压心率检测");
    self.navTitleLabel.font = [UIFont systemFontOfSize:18/[UserShareOnce shareOnce].multipleFontSize];
    [self initWithController];
    
    self.isHidden = NO;
    self.canSubmit = NO;
}


-(void)initWithController{
    
    //显示用户脉搏、收缩压、舒张压信息
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(Adapter(10), kNavBarHeight + Adapter(30), kScreenSize.width-Adapter(20), Adapter(270))];
    imageView.layer.cornerRadius = Adapter(10);
    imageView.layer.masksToBounds = YES;
    [self insertSublayerWithImageView:imageView with:self.view];
    [self.view addSubview:imageView];
    
    UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - Adapter(25), kNavBarHeight +Adapter(10), Adapter(50), Adapter(50))];
    iconImageView.image = [UIImage imageNamed:@"血压icon"];
    iconImageView.layer.cornerRadius = Adapter(10);
    iconImageView.layer.masksToBounds = YES;
    [self.view addSubview:iconImageView];
    
    
    //收缩压
    UILabel *shrink = [Tools creatLabelWithFrame:CGRectMake(imageView.width/2 - Adapter(100), Adapter(50), Adapter(70), Adapter(30)) text:ModuleZW(@"收缩压") textSize:14];
    shrink.textAlignment = NSTextAlignmentRight;
    shrink.textColor = [UIColor blackColor];
    [imageView addSubview:shrink];
    
    _shrinkPressureLabel = [Tools creatLabelWithFrame:CGRectMake(imageView.width/2 - Adapter(10) , Adapter(50), Adapter(60), Adapter(30)) text:@"__" textSize:19];
    _shrinkPressureLabel.textAlignment = NSTextAlignmentRight;
    _shrinkPressureLabel.textColor = [UIColor blackColor];
    [imageView addSubview:_shrinkPressureLabel];
    
    UILabel *shrinkUnit = [Tools creatLabelWithFrame:CGRectMake(imageView.width/2  + Adapter(50), Adapter(50), Adapter(100), Adapter(30)) text:@"mmHg" textSize:19];
    shrinkUnit.textAlignment = NSTextAlignmentLeft;
    shrinkUnit.textColor = [UIColor blackColor];
    [imageView addSubview:shrinkUnit];
    
    //舒张压
    UILabel *diastolic = [Tools creatLabelWithFrame:CGRectMake(imageView.width/2  - Adapter(100), shrinkUnit.bottom + Adapter(50), Adapter(70), Adapter(30)) text:ModuleZW(@"舒张压") textSize:14];
    diastolic.textAlignment = NSTextAlignmentRight;
    diastolic.textColor = [UIColor blackColor];
    [imageView addSubview:diastolic];
    
    _diastolicPressureLabel = [Tools creatLabelWithFrame:CGRectMake(imageView.width/2 - Adapter(10), shrinkUnit.bottom + Adapter(50), Adapter(60), Adapter(30)) text:@"__" textSize:19];
    _diastolicPressureLabel.textAlignment = NSTextAlignmentRight;
    _diastolicPressureLabel.textColor = [UIColor blackColor];
    [imageView addSubview:_diastolicPressureLabel];
    
    UILabel *diastolicUnit = [Tools creatLabelWithFrame:CGRectMake(imageView.width/2 + Adapter(50), shrinkUnit.bottom + Adapter(50), Adapter(100), Adapter(30)) text:@"mmHg" textSize:19];
    diastolicUnit.textAlignment = NSTextAlignmentLeft;
    diastolicUnit.textColor = [UIColor blackColor];
    [imageView addSubview:diastolicUnit];
    
    //脉搏
    UILabel *pulse = [Tools creatLabelWithFrame:CGRectMake(imageView.width/2  - Adapter(130), diastolicUnit.bottom + Adapter(50), Adapter(100), Adapter(30)) text:ModuleZW(@"心率") textSize:14];
    pulse.textAlignment = NSTextAlignmentRight;
    pulse.textColor = [UIColor blackColor];
    [imageView addSubview:pulse];
    
    _pulseLabel = [Tools creatLabelWithFrame:CGRectMake(imageView.width/2 - Adapter(10), diastolicUnit.bottom + Adapter(50), Adapter(60), Adapter(30)) text:@"__" textSize:19];
    _pulseLabel.textAlignment = NSTextAlignmentRight;
    _pulseLabel.textColor = [UIColor blackColor];
    [imageView addSubview:_pulseLabel];
    
    UILabel *pulseUnit = [Tools creatLabelWithFrame:CGRectMake(imageView.width/2 +Adapter(50), diastolicUnit.bottom + Adapter(50), Adapter(50), Adapter(30)) text:@"BMP" textSize:16];
    pulseUnit.font = [UIFont systemFontOfSize:16];
    pulseUnit.textAlignment = NSTextAlignmentLeft;
    pulseUnit.textColor = [UIColor blackColor];
    [imageView addSubview:pulseUnit];
    
    
    [self createButton];
    
}


-(void)createButton{
    UIButton *startCheckBt = [UIButton  buttonWithType:(UIButtonTypeCustom)];
    startCheckBt.frame = CGRectMake(ScreenWidth/2 - Adapter(70),Adapter(330)+kNavBarHeight , Adapter(140), Adapter(30));
    startCheckBt.backgroundColor = RGB_ButtonBlue;
    startCheckBt.layer.cornerRadius = Adapter(15);
    [startCheckBt setTitle:ModuleZW(@"开始检测") forState:(UIControlStateNormal)];
    startCheckBt.layer.masksToBounds = YES;
    [startCheckBt.titleLabel setFont:[UIFont systemFontOfSize:14]];
    startCheckBt.enabled = NO;
    startCheckBt.alpha = 0.5;
    self.startCheck = startCheckBt;
    [[startCheckBt rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
     
        self.isHidden = NO;
        [startCheckBt setTitle:ModuleZW(@"重新检测") forState:(UIControlStateNormal)];
        
//        if ([self.manager.connectState isEqualToString:kCONNECTED_POWERD_ON]) {
//            NSLog(@"蓝牙已经打开，等待搜寻设备的services和characteristics");
//        }
//        [self.manager cancelPeripheralConnection];
//
//        [self bloodTest];
        //开始检测通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kPERIPHERAL_BEGIN object:nil userInfo:nil];
        
        //开始倒计时
//        [self startCountDown];

    }];
    [self.view addSubview:startCheckBt];
    
    
    UIButton *nonDeviceCheckBt = [UIButton  buttonWithType:(UIButtonTypeCustom)];
    nonDeviceCheckBt.frame = CGRectMake(ScreenWidth/2 - Adapter(70),_startCheck.bottom+Adapter(30), Adapter(140), Adapter(30));
    nonDeviceCheckBt.backgroundColor = RGB_ButtonBlue;
    nonDeviceCheckBt.layer.cornerRadius = Adapter(15);
    [nonDeviceCheckBt setTitle:ModuleZW(@"手动录入") forState:(UIControlStateNormal)];
    nonDeviceCheckBt.layer.masksToBounds = YES;
    [nonDeviceCheckBt.titleLabel setFont:[UIFont systemFontOfSize:14]];
    self.nonDeviceCheck = nonDeviceCheckBt;
    [[nonDeviceCheckBt rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        BloodPressureNonDeviceViewController *nonDeviceCheck = [[BloodPressureNonDeviceViewController alloc] init];
        [self.navigationController pushViewController:nonDeviceCheck animated:YES];
    }];
    [self.view addSubview:nonDeviceCheckBt];

    
    //使用规范
//    UIButton *useNorm = [Tools creatButtonWithFrame:CGRectMake(kScreenSize.width/2-30,nonDeviceCheck.bottom+15, 60, 25) target:self sel:@selector(useNormClick:) tag:101 image:ModuleZW(@"使用规范") title:nil];
//    [self.view addSubview:useNorm];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.manager cancelPeripheralConnection];
}

-(void)commitBtnClick:(UIButton *)button{
  
    //得到子账户的id
    self.subId = [NSString stringWithFormat:@"%@",[MemberUserShance shareOnce].idNum];
    
    
//    [self showPreogressView];
//    NSInteger highCount = [self.boodArray[3] integerValue];
//    NSInteger lowCount = [self.boodArray[4] integerValue];
//    NSInteger pulseCount = [self.boodArray[5] integerValue];
//
//    //提交数据
//    NSString *aUrl = [NSString stringWithFormat:@"%@/member/uploadData.jhtml",URL_PRE];
//    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:aUrl]];
//    [request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]];
//    if([UserShareOnce shareOnce].languageType){
//        [request addRequestHeader:@"language" value:[UserShareOnce shareOnce].languageType];
//    }
//
//
//
//    [request setPostValue:[UserShareOnce shareOnce].uid forKey:@"memberId"];
//    [request addPostValue:self.subId forKey:@"memberChildId"];
//    [request addPostValue:@(30) forKey:@"datatype"];
//    [request addPostValue:@(highCount) forKey:@"highPressure"];
//    [request addPostValue:@(lowCount) forKey:@"lowPressure"];
//    [request addPostValue:@(pulseCount) forKey:@"pulse"];
//    [request addPostValue:[UserShareOnce shareOnce].token forKey:@"token"];
//    [request setTimeOutSeconds:20];
//    [request setRequestMethod:@"POST"];
//    [request setDelegate:self];
//    [request setDidFailSelector:@selector(requestError:)];
//    [request setDidFinishSelector:@selector(requestCompleted:)];
//    [request startAsynchronous];
    
    [self showPreogressView];
    NSInteger highCount = [self.boodArray[3] integerValue];
    NSInteger lowCount = [self.boodArray[4] integerValue];
    NSInteger pulseCount = [self.boodArray[5] integerValue];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setObject:[UserShareOnce shareOnce].uid forKey:@"memberId"];
    [dic setObject:self.subId forKey:@"memberChildId"];
    [dic setObject:@(30) forKey:@"datatype"];
    [dic setObject:@(highCount) forKey:@"highPressure"];
    [dic setObject:@(lowCount) forKey:@"lowPressure"];
    [dic setObject:@(pulseCount) forKey:@"pulse"];
    [dic setObject:[UserShareOnce shareOnce].token forKey:@"token"];
    
    __weak typeof(self) weakSelf = self;
    [[NetworkManager sharedNetworkManager] requestWithCookieType:1 urlString:@"member/uploadData.jhtml" headParameters:nil parameters:dic successBlock:^(id response) {
        [weakSelf requestCompleted:response];
    } failureBlock:^(NSError *error) {
        [weakSelf hidePreogressView];
        [weakSelf showAlertWarmMessage:ModuleZW(@"提交数据失败")];
    }];
    
}

-(void)reChekBtnClick:(UIButton *)button{
    //开始检测通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kPERIPHERAL_BEGIN object:nil userInfo:nil];
}


//
//-(void)useNormClick:(UIButton *)button{
//    NSLog(@"点击使用规范");
//    [[NSUserDefaults standardUserDefaults] setObject:@"11" forKey:@"clickUseNorm_blood"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    BloodGuideViewController *bloodGuide = [[BloodGuideViewController alloc] init];
//    [self.navigationController pushViewController:bloodGuide animated:YES];
//
//}

//血压检测
- (void)bloodTest{
    
    if(kPlayer.playerState == 2){
        [kPlayer stop];
    }
    
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
        weakSelf.startCheck.alpha = 1.0;
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kPERIPHERAL_CONNECT_FAILED object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        NSLog(@"外设连接失败");
        //        [SVProgressHUD showInfoWithStatus:@"设备连接失败"];
        
        weakSelf.stateLabel.text = ModuleZW(@"未连接");
        weakSelf.imageViewImage.image = [UIImage imageNamed:@"unconnectedImage"];
        weakSelf.startCheck.enabled = NO;
        weakSelf.startCheck.alpha = 0.6;
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:kPERIPHERAL_DISCONNECTED object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        NSLog(@"外设断开连接");
        weakSelf.startCheck.alpha = 0.6;
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
                    weakSelf.nonDeviceCheck.alpha = 1;
                    weakSelf.nonDeviceCheck.enabled =YES;
                    [weakSelf.startCheck setTitle:ModuleZW(@"重新检测") forState:(UIControlStateNormal)];
                    weakSelf.startCheck.enabled = YES;
                    weakSelf.startCheck.alpha = 1;
                }
            }
        }
        
    }];
    
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
    _showView = [[UIView alloc]initWithFrame:CGRectMake(Adapter(30), Adapter(100), self.view.frame.size.width - Adapter(60), self.view.frame.size.height - Adapter(190))];
    _showView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_showView];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, _showView.frame.size.width, _showView.frame.size.height - Adapter(80)) style:UITableViewStylePlain];
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

-(void)requestCompleted:(NSDictionary *)dic{
    [self hidePreogressView];
//    NSString* reqstr=[request responseString];
//    NSDictionary * dic=[reqstr JSONValue];
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
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width-Adapter(40), Adapter(180))];
        imageView.center = self.view.center;
        imageView.userInteractionEnabled = YES;
        imageView.image = [UIImage imageNamed:@"bounceView"];
        

        
        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sureBtn setBackgroundImage:[UIImage imageNamed:@"sure"] forState:UIControlStateNormal];
        [sureBtn setTitle:ModuleZW(@"返回检测") forState:UIControlStateNormal];
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        sureBtn.frame = CGRectMake(Adapter(20), kScreenSize.height/2+Adapter(90), imageView.frame.size.width * 0.5, Adapter(40));
        [sureBtn addTarget:self action:@selector(confirmBtnClick2:) forControlEvents:UIControlEventTouchUpInside];
        [view2 addSubview:sureBtn];
        
        UIButton *lookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [lookBtn setBackgroundImage:[UIImage imageNamed:@"look"] forState:UIControlStateNormal];
        [lookBtn setTitle:ModuleZW(@"查看档案") forState:UIControlStateNormal];
        lookBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        lookBtn.frame = CGRectMake(CGRectGetMaxX(sureBtn.frame), sureBtn.frame.origin.y, imageView.frame.size.width * 0.5, Adapter(40));
        [lookBtn addTarget:self action:@selector(lookClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [view2 addSubview:lookBtn];
        
        UILabel *countLabel = [Tools labelWith:[NSString stringWithFormat:ModuleZW(@"您当前脉搏%ld次/分  收缩压%ldmmHg  舒张压 %ldmmhg"),(long)pulseCount,(long)highCount,(long)lowCount] frame:CGRectMake(0, Adapter(50), imageView.bounds.size.width, Adapter(60)) textSize:14 textColor:[Tools colorWithHexString:@"#e79947"] lines:0 aligment:NSTextAlignmentCenter];
        
        
        UILabel *label0 = [[UILabel alloc] init];
        label0.text = ModuleZW(@"血压、脉搏正常范围参考值：");
        label0.textAlignment = NSTextAlignmentCenter;
        label0.font = [UIFont systemFontOfSize:13];
        label0.frame = CGRectMake(Adapter(20), Adapter(110), imageView.bounds.size.width-Adapter(40), Adapter(20));
        [imageView addSubview:label0];
        
        UILabel *label1 = [[UILabel alloc] init];
        label1.text = ModuleZW(@"脉搏：60－100次/分");
        label1.textAlignment = NSTextAlignmentCenter;
        label1.font = [UIFont systemFontOfSize:12];
        label1.frame = CGRectMake(Adapter(20), CGRectGetMaxY(label0.frame), imageView.bounds.size.width-Adapter(40), Adapter(16));
        [imageView addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] init];
        label2.text =ModuleZW( @"90 < 高压 / 收缩压（mmHg）< 140");
        label2.textAlignment = NSTextAlignmentCenter;
        label2.font = [UIFont systemFontOfSize:12];
        label2.frame = CGRectMake(Adapter(20), CGRectGetMaxY(label1.frame), imageView.bounds.size.width-Adapter(40), Adapter(16));
        [imageView addSubview:label2];
        
        UILabel *label3 = [[UILabel alloc] init];
        label3.text = ModuleZW(@"60 < 低压 / 舒张压（mmHg）< 90");
        label3.textAlignment = NSTextAlignmentCenter;
        label3.font = [UIFont systemFontOfSize:12];
        label3.frame = CGRectMake(Adapter(20), CGRectGetMaxY(label2.frame), imageView.bounds.size.width-Adapter(40), Adapter(16));
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
