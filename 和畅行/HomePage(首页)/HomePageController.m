//
//  HomePageController.m
//  和畅行
//
//  Created by 刘晓明 on 2018/7/2.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "HomePageController.h"
#import "ReadOrWriteView.h"
#import "HeChangPackge.h"
#import "ChildMemberModel.h"
#import "HeChangRemind.h"
#import "RemindModel.h"
#import "RecommendReadView.h"
#import "HCY_HomeImageModel.h"

#import "AFNetworking.h"

#import "SugerViewController.h"
#import "HCY_ActivityController.h"
#import "TestViewController.h"

#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "Reachability.h"
#import "LoginViewController.h"
#import "NetworkManager.h"
#import <sys/utsname.h>


@interface HomePageController ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *bgScrollView;
@property (nonatomic,strong) HeChangPackge *packgeView;
@property (nonatomic,strong) HeChangRemind *remindView;
@property (nonatomic,strong)  ReadOrWriteView *readWriteView;
@property (nonatomic, strong) RecommendReadView *recommendView;
@property (nonatomic, strong) NSMutableArray    *homeImageArray;
@property (nonatomic, strong) HCY_HomeImageModel *backImageModel;
@property (nonatomic, strong) HCY_HomeImageModel *pushModel;
@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic,strong) UIImageView *activityImage;
@property (nonatomic, strong)UIActivityIndicatorView *testActivityIndicator;
@property (nonatomic) BOOL isRefresh;

@property (nonatomic,strong) NSDictionary *packageDic;

@end

@implementation HomePageController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden = NO;
    self.leftBtn.hidden = NO;
    if ([UserShareOnce shareOnce].isRefresh){
        [self requestPackgeNetWork];
        // [self requestUI];
        [UserShareOnce shareOnce].isRefresh = NO;
    }
    
    
}

-(void)changeSize:(NSNotification *)notifi {
    _packgeView.titleLabel.font = [UIFont systemFontOfSize:21];
    _packgeView.remindLabel.font = [UIFont systemFontOfSize:16];
    _remindView.titleLabel.font = [UIFont systemFontOfSize:18];
    _remindView.timeLabel.font = [UIFont systemFontOfSize:13];
    _recommendView.titleLabel.font = [UIFont systemFontOfSize:17];
    [_remindView.tableView reloadData];
    [_recommendView.collectionV reloadData];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromHex(0xffffff);
    self.topView.backgroundColor = [UIColor clearColor];
    self.isRefresh = YES;
    self.homeImageArray = [NSMutableArray array];
  //  [self createTopView];
   self.startTimeStr = [GlobalCommon getCurrentTimes];
    [self requestUI];
   // [self handleNetworkGroup];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exchangeMemberChild:) name:exchangeMemberChildNotify object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSize:) name:@"CHANGESIZE" object:nil];
//    [UIApplication sharedApplication].windows
    
    [UserShareOnce shareOnce].startTime = [GlobalCommon getCurrentTimes];
    //埋点数据上传
    [self buriedDataPoints];
}



- (void)exchangeMemberChild:(NSNotification *)notify
{
    if([[notify object] isKindOfClass:[self class]]){
        return;
    }
   
   [self requestPackgeNetWork];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (void)addGradientLayer
{
    [self.packgeView changeBackImageWithStr:self.backImageModel.picurl];
    
    if ([self.backImageModel.link isEqualToString:@"0"]) {
        self.packgeView.titleLabel.textColor = [UIColor blackColor];
        self.packgeView.remindLabel.textColor = [UIColor blackColor];
        [self.rightBtn setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
    }else {
        self.packgeView.titleLabel.textColor = [UIColor whiteColor];
        self.packgeView.remindLabel.textColor = [UIColor whiteColor];
        [self.rightBtn setImage:[UIImage imageNamed:@"message_01"] forState:UIControlStateNormal];
    }
    
    if(_havePackage){
        if (_backImageModel.picurl==nil || [_backImageModel.picurl isKindOfClass:[NSNull class]]||_backImageModel.picurl.length == 0) {
            
            [self.imageV setImage:[UIImage imageNamed:@"bg_blue"]];
            
            //        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
            //        gradientLayer.frame = self.imageV.bounds;
            //        gradientLayer.colors = [NSArray arrayWithObjects:(id)UIColorFromHex(0x1E82D2).CGColor,(id)UIColorFromHex(0x2B95EB).CGColor,(id)UIColorFromHex(0x05A1EE).CGColor, nil];
            //        gradientLayer.startPoint = CGPointMake(0.5, 0);
            //        gradientLayer.endPoint = CGPointMake(0.5, 1);
            //        gradientLayer.locations = @[@0,@0.5,@1.0];
            //        [self.imageV.layer addSublayer:gradientLayer];
            
        }else {
            
            NSString *imageUrl = [NSString stringWithFormat:@"%@%@",URL_PRE,_backImageModel.picurl];
            NSURL *url = [NSURL URLWithString:imageUrl];
            [self.imageV sd_setImageWithURL:url];
            
            [self.packgeView.imageV sd_setImageWithURL:url];
        }
    }else{
        [self.packgeView.imageV setImage:NULL];
        [self.imageV setImage:NULL];
    }
    
    
    
    [self.view addSubview:self.topView];
    
    if (self.pushModel.picurl!=nil && ![self.pushModel.picurl isKindOfClass:[NSNull class]]&&self.pushModel.picurl.length != 0) {
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@",URL_PRE,self.pushModel.picurl];
        NSURL *url = [NSURL URLWithString:imageUrl];
        [self.activityImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"activityImage"]];
    }
    
    
}

- (void)createTopViewWithStatus:(BOOL)haveTest
{
    CGFloat imageWidth = (ScreenWidth - 10*4)/3.0;
    CGFloat imageHeight = imageWidth*76.8/97.7;
    
    if(!self.packgeView){
        self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth/1.5)];
            //414.000000    274.005362
        self.imageV.userInteractionEnabled = YES;
        [self.view addSubview:self.imageV];
            
        self.packgeView = [[HeChangPackge alloc] initWithFrame:CGRectMake(0, -kNavBarHeight, ScreenWidth, ScreenWidth/1.5+Adapter(20))];
        
        NSString *str = [[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"%@",[MemberUserShance shareOnce].idNum]];
        if(str){
            NSString *str1 = [[str componentsSeparatedByString:@"&&"] objectAtIndex:0];
            NSString *str2 = [[str componentsSeparatedByString:@"&&"] objectAtIndex:1];
            if(_havePackage){
                [self.packgeView changePackgeTypeWithStatus:[str1 integerValue] withXingStr:str2];
            }
        }
    }
    
    if (!self.bgScrollView){
        self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, ScreenWidth, ScreenHeight-kNavBarHeight-kTabBarHeight)];
        self.bgScrollView.showsVerticalScrollIndicator = NO;
        
        self.bgScrollView.backgroundColor = [UIColor whiteColor];
        self.bgScrollView.bounces = YES;
        self.bgScrollView.contentSize = CGSizeMake(1, ScreenHeight-kNavBarHeight-kTabBarHeight);
        self.bgScrollView.delegate = self;
        if(self.packgeView){
            [self.bgScrollView addSubview:self.packgeView];
        }
        
        [self.view addSubview:self.bgScrollView];
    }
    
    if (!self.readWriteView){
        
        self.readWriteView = [[ReadOrWriteView alloc] initWithFrame:CGRectMake(0, _havePackage?self.packgeView.bottom+Adapter(5):Adapter(5), ScreenWidth, imageHeight+Adapter(10))];
    
        [self.bgScrollView addSubview:self.readWriteView];
    }
    
    //判断有没有活动页面
    if(_isActivity){
        if(!self.activityImage){
            
            CGFloat imageW = ScreenWidth-Adapter(30);
            
            self.activityImage = [[UIImageView alloc] initWithFrame:CGRectMake(Adapter(15), self.readWriteView.bottom+Adapter(10), imageW, imageW/5.15)];
            HCY_HomeImageModel *model = self.pushModel?self.pushModel:self.backImageModel;
            [self.activityImage sd_setImageWithURL:[NSURL URLWithString:model.picurl] placeholderImage:[UIImage imageNamed:@"activityImage"]];
            self.activityImage.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(joinActivity)];
            [self.activityImage addGestureRecognizer:tap];
            
            [self.bgScrollView addSubview:self.activityImage];
        }
    }
    
    
    
    self.readWriteView.frame = CGRectMake(self.readWriteView.left, _havePackage?self.packgeView.bottom-Adapter(65):Adapter(5), self.readWriteView.width, self.readWriteView.height);

    if(_isActivity){
        self.activityImage.frame = CGRectMake(self.activityImage.left, self.readWriteView.bottom+Adapter(10), self.activityImage.width, self.activityImage.height);
    }
    
    if(!self.testActivityIndicator){
        self.testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.testActivityIndicator.center = CGPointMake(self.view.width/2 , _isActivity?self.activityImage.bottom +Adapter(100):self.readWriteView.bottom +Adapter(100));//只能设置中心，不能设置大小
        [self.bgScrollView addSubview:self.testActivityIndicator];
        self.testActivityIndicator.color = RGB_TextAppBlue;
       
    }
    
    if(!self.remindView){
        
        NSMutableArray *mutableArr = [[CacheManager sharedCacheManager] getRemindModelsWith:[MemberUserShance shareOnce].idNum];
        if(mutableArr.count==0){
            NSArray *nameArr = @[ModuleZW(@"一说"),ModuleZW(@"一写"),ModuleZW(@"一点")];
            NSArray *adviceArr = @[jlbsAdvice,zfbsAdvice,tzbsAdvice];
            for(NSInteger i=0;i<nameArr.count;i++){
                RemindModel *model = [[RemindModel alloc] init];
                model.type =[nameArr objectAtIndex:i];
                model.advice = [adviceArr objectAtIndex:i];
                model.isDone = NO;
                [mutableArr addObject:model];
            }
        }
        self.remindView = [[HeChangRemind alloc] initWithFrame:CGRectMake(self.packgeView.left,   self.activityImage?self.activityImage.bottom+Adapter(10):self.readWriteView.bottom+Adapter(10), self.readWriteView.width, Adapter(58)+mutableArr.count*(Adapter(59))) withDataArr:mutableArr];
        [self.bgScrollView addSubview:self.remindView];

    }
    if(!self.recommendView){
        CGFloat width = (ScreenWidth - Adapter(33))/2.5;
        self.recommendView = [[RecommendReadView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.remindView.frame)+Adapter(10), ScreenWidth, width*0.75+Adapter(102))];
        [self.bgScrollView addSubview:self.recommendView];
        self.bgScrollView.contentSize = CGSizeMake(1, self.recommendView.bottom+Adapter(20));
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTableSize:) name:@"CHANGETABLESIZE" object:nil];
        
    }
    
    [self.bgScrollView setContentSize:CGSizeMake(1, self.recommendView.bottom+Adapter(20))];
    
}

- (void)updateViewFrame
{
    self.readWriteView.frame = CGRectMake(self.readWriteView.left, _havePackage?self.packgeView.bottom-Adapter(65):Adapter(5), self.readWriteView.width, self.readWriteView.height);
    self.remindView.frame = CGRectMake(self.remindView.left, self.activityImage?self.activityImage.bottom+Adapter(10):self.readWriteView.bottom+Adapter(10), self.remindView.width, self.remindView.height);
    self.recommendView.frame = CGRectMake(self.recommendView.left,CGRectGetMaxY(self.remindView.frame)+Adapter(10) , self.recommendView.width, self.recommendView.height);
    [self.bgScrollView setContentSize:CGSizeMake(1, self.recommendView.bottom+Adapter(20))];
    
}

-(void)changeTableSize:(NSNotification *)notifi {
    
    self.remindView.tableView.height = self.remindView.tableView.contentSize.height;
    self.remindView.height = Adapter(58) +  self.remindView.tableView.height;
    NSLog(@"%f",self.remindView.tableView.height);
    self.recommendView.top = self.remindView.bottom+Adapter(10);
    NSLog(@"%f",self.remindView.bottom);
}

# pragma mark - 活动页跳转
- (void)joinActivity
{
    HCY_HomeImageModel *model = self.pushModel?self.pushModel:self.backImageModel;
    if(model.link==nil||[model.link isKindOfClass:[NSNull class]]||model.link.length == 0){
        
        return;
    
    }else {
        HCY_ActivityController *vc = [[HCY_ActivityController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        vc.titleStr = model.title;
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",URL_PRE,model.link];
        vc.progressType = progress2;
        vc.urlStr = urlStr;
    }
}


- (void)showHomePackageView
{
    [self createTopViewWithStatus:YES];
    [self addGradientLayer];
    if(self->_isActivity){
        if (self.isRefresh == YES){
            [self.readWriteView setButtonImageWithArray:self.homeImageArray];
            self.isRefresh = NO;
        }
    }else{
        [self.readWriteView initWithUI];
    }
}

# pragma mark - 活动数据的请求
-(void)requestUI {
    
    NSString *urlStr = @"mobile/index/indexpic.jhtml";
    __weak typeof(self) weakSelf = self;
    [[NetworkManager sharedNetworkManager] requestWithType:0 urlString:urlStr parameters:nil successBlock:^(id response) {
        
        [weakSelf requestPackgeNetWork];
        
        if([[response objectForKey:@"status"] integerValue] == 100){

            
            for (NSDictionary *dic in [response valueForKey:@"data"]) {
                HCY_HomeImageModel *model = [[HCY_HomeImageModel alloc]init];
                [model yy_modelSetWithJSON:dic];
                
                if([model.type isEqualToString:@"1"]){
                    self.backImageModel = model;
                }
                if ([model.type isEqualToString:@"2"]){
                    self.pushModel = model;
                    //图片与连接都为空认为没有活动
                    if([GlobalCommon stringEqualNull:model.picurl] && [GlobalCommon stringEqualNull:model.link]){
                        self->_isActivity = NO;
                    }else{
                        self->_isActivity = YES;
                    }
                }
                [self.homeImageArray addObject:model];
                
            }
            
        }else{
            self->_isActivity = NO;
            
        }
        
        //先判断本地有没有和畅包缓存,有则直接展示页面没有则等和畅包接口请求完后再展示
        if([self getLocalPackageContent]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf showHomePackageView];
            });
        }
        
        
    } failureBlock:^(NSError *error) {
        
        self->_isActivity = NO;
        
        [weakSelf requestPackgeNetWork];
        
        if([self getLocalPackageContent]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf showHomePackageView];
            });
        }
    }];
}

# pragma mark - 和畅包网络请求
- (void)requestPackgeNetWork
{
    NSLog(@"------%@",[UserShareOnce shareOnce].uid);
    NSString *urlStr = @"member/new_ins/current.jhtml";
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    NSLog(@"%@",[MemberUserShance shareOnce].idNum);
    if ([MemberUserShance shareOnce].idNum){
        [paramDic setObject:[MemberUserShance shareOnce].idNum forKey:@"memberChildId"];
        [paramDic setObject:@"1" forKey:@"isnew"];
    }else {
        return;
    }
    __weak typeof(self) weakSelf = self;
    
    [[NetworkManager sharedNetworkManager] requestWithType:0 urlString:urlStr parameters:paramDic successBlock:^(id response) {
        
        if([[response objectForKey:@"status"] integerValue] == 100){
            NSInteger status = [[[response objectForKey:@"data"] objectForKey:@"num"] integerValue];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(status >=0 && status <= 11){
                    if(!self->_havePackage){
                        self->_havePackage = YES;
                        if(weakSelf.packgeView){ //之前没有和畅包,得展示和畅包,有则不变
                            [weakSelf updateViewFrame];
                            [weakSelf addGradientLayer];
                        }
                    }
                }else{ //未做检测，不显示和畅包
                    self->_havePackage = NO;
                }
                //本地没有缓存,则在这里展示页面,有缓存在上个接口展示页面
                if(![weakSelf getLocalPackageContent22]){
                    [weakSelf showHomePackageView];
                    //和畅提醒加载需要一个加载框
                    [weakSelf.testActivityIndicator startAnimating];
                }
                if(self->_havePackage){
                    [weakSelf.packgeView changePackgeTypeWithStatus:status withXingStr:[[response objectForKey:@"data"] objectForKey:@"name"]];
                }
                
                //保存和畅包状态,以便下次打开应用直接读取缓存
                NSString *packageStr = [NSString stringWithFormat:@"%ld&&%@",status,[[response objectForKey:@"data"] objectForKey:@"name"]];
                [[NSUserDefaults standardUserDefaults]setValue: packageStr forKey:[NSString stringWithFormat:@"%@",[MemberUserShance shareOnce].idNum]];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            });
            
        }else{
            [weakSelf showAlertWarmMessage:[response objectForKey:@"data"]];
        }
        
        [weakSelf requestRemindNetWork];
        
    } failureBlock:^(NSError *error) {
        [weakSelf requestRemindNetWork];
        
        self->_havePackage = NO;
        if(![self getLocalPackageContent]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf showHomePackageView];
            });
        }
    }];
}

# pragma mark - 和畅提醒网络请求
- (void)requestRemindNetWork
{
    
    NSString *urlStr = @"member/new_ins/newTips.jhtml";
    //NSString *urlStr = @"/member/new_ins/newTips.jhtml";
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [paramDic setObject:[MemberUserShance shareOnce].idNum forKey:@"memberChildId"];
    
    __weak typeof(self) weakSelf = self;
    
    [[NetworkManager sharedNetworkManager] requestWithType:0 urlString:urlStr parameters:paramDic successBlock:^(id response) {
        
        if([[response objectForKey:@"status"] integerValue] == 100){
            
            id jlbsData = [[response objectForKey:@"data"] objectForKey:@"jlbs"];
            if(jlbsData != nil && ![jlbsData isKindOfClass:[NSNull class]]){
                NSDictionary *jlbsDic = [jlbsData objectForKey:@"subject"];
                NSString *jlbsName = [jlbsDic objectForKey:@"name"];
               
                //jlbsName = @"";
                
                [[NSUserDefaults standardUserDefaults]setValue: jlbsName forKey:@"Physical"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }else{
                [[NSUserDefaults standardUserDefaults]setValue: @"" forKey:@"Physical"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            id listData = [[response objectForKey:@"data"] objectForKey:@"todolist"];
            NSMutableArray *mutableArr = [NSMutableArray arrayWithCapacity:0];
            if(listData != nil && ![listData isKindOfClass:[NSNull class]] && [listData count]>0){
                NSArray *listArr = (NSArray *)listData;
                NSLog(@"todolist");
                for(NSDictionary *dic in listArr){
                    RemindModel *model = [RemindModel mj_objectWithKeyValues:dic];
                    model.type = [GlobalCommon getRemindTRypeWithStr:model.type];
                    [mutableArr addObject:model];
                }
                
            }else{
                NSArray *nameArr = @[ModuleZW(@"一说"),ModuleZW(@"一写"),ModuleZW(@"一点")];
                NSArray *adviceArr = @[jlbsAdvice,zfbsAdvice,tzbsAdvice];
                for(NSInteger i=0;i<nameArr.count;i++){
                    RemindModel *model = [[RemindModel alloc] init];
                     model.type =[nameArr objectAtIndex:i];
                    model.advice = [adviceArr objectAtIndex:i];
                    model.isDone = NO;
                    [mutableArr addObject:model];
                }
            }
            
            CacheManager *manager = [CacheManager sharedCacheManager];
            [manager updateOrinsertRemindModels:mutableArr withCustId:[MemberUserShance shareOnce].idNum];
            
            weakSelf.remindView.dataArr = mutableArr;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.remindView updateViewWithData:mutableArr withHeight:Adapter(58)+mutableArr.count*(Adapter(59))];
                weakSelf.recommendView.frame = CGRectMake(0, weakSelf.remindView.bottom+Adapter(10), weakSelf.recommendView.width, weakSelf.recommendView.height);
                
                [weakSelf.bgScrollView setContentSize:CGSizeMake(1, weakSelf.recommendView.bottom+Adapter(20))];
                
            });
            
        }else{
            [weakSelf showAlertWarmMessage:[response objectForKey:@"data"]];
        }
            [self.testActivityIndicator stopAnimating];
            [self.testActivityIndicator setHidesWhenStopped:YES];
    } failureBlock:^(NSError *error) {
        [self.testActivityIndicator stopAnimating];
        [self.testActivityIndicator setHidesWhenStopped:YES];
        
    }];
    
}

- (BOOL)getLocalPackageContent
{
    NSString *str = [[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"%@",[MemberUserShance shareOnce].idNum]];
    if(str){
        NSString *str1 = [[str componentsSeparatedByString:@"&&"] objectAtIndex:0];
        if([str1 integerValue]>=0 && [str1 integerValue]<=11){
            _havePackage = YES;
        }else{
            _havePackage = NO;
        }
        return YES;
    }
    return NO;
}

- (BOOL)getLocalPackageContent22
{
    NSString *str = [[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"%@",[MemberUserShance shareOnce].idNum]];
    if(str){
        return YES;
    }
    return NO;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.bgScrollView)
    {
        //禁止下拉
        CGPoint offset = self.bgScrollView.contentOffset;
        if (offset.y <= 0) {
            offset.y = 0;
        }
        self.bgScrollView.contentOffset = offset;
    }
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

//数据上传处理

-(void)buriedDataPoints {
    
    
    //==============================此接口为用户新增用户信息使用   怎么判断新增客户? 后台判断=========================
    NSString *userSign = [UserShareOnce shareOnce].uid;
    NSString *sexStr  = [NSString string];
    if (![GlobalCommon stringEqualNull:[UserShareOnce shareOnce].gender]) {
        if([[UserShareOnce shareOnce].gender isEqualToString:@"male"]){
            sexStr = @"1";
        }else if ([[UserShareOnce shareOnce].gender isEqualToString:@"female"]){
            sexStr = @"2";
        }else{
            sexStr = @"0";
        }
    }else{
        sexStr = @"0";
    }
    NSString *birthdayStr = [UserShareOnce shareOnce].birthday;
    if(![GlobalCommon stringEqualNull:birthdayStr]){
        birthdayStr = [birthdayStr stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    }else{
        birthdayStr= @"";
    }
    
    NSString *appSignStr = @"1";
    NSString *urlStr = [NSString stringWithFormat:@"%@user/info",DATAURL_PRE];
    NSDictionary *infodic = @{ @"body":@{
                                       @"userId":userSign,
                                       @"id":@"",
                                       @"dateBirth":birthdayStr,
                                       @"sex":sexStr,
                                       @"appSign":appSignStr,
                                       @"province":@"",
                                       @"city":@"" ,
                                       @"remark":@""}
                               };
    
    [[BuredPoint sharedYHBuriedPoint] submitLocationWithUrl:urlStr Dic:infodic successBlock:^(id  _Nonnull response) {
        NSLog(@"%@",response);
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];
    
    
 
  
    
    
    //=============================接口描述： 该接口用于记录用户使用app的设备信息=========================
    
    NSString *modelStr           =  [BuredPoint getCurrentDeviceModel];//型号
    NSString *resolutionStr     = [BuredPoint getScreenPix];//分辨率
    NSString *operatorStr       = [BuredPoint getOperator];//运营商
    NSString *network_methodStr = [GlobalCommon internetStatus];//联网方式


    NSString *deviceStr = [NSString stringWithFormat:@"%@user/device",DATAURL_PRE];
    NSDictionary *deviceDic = @{ @"body":@{
                                         @"id":@"",
                                         @"userId":userSign,
                                         @"brand":@"iPhone",
                                         @"model":modelStr,
                                         @"system":@"iOS",
                                         @"resolution":resolutionStr,
                                         @"operator":operatorStr,
                                         @"networkMethod":network_methodStr,
                                         @"remark":@""}
                                };

    [[BuredPoint sharedYHBuriedPoint] submitWithUrl:deviceStr dic:deviceDic successBlock:^(id  _Nonnull response) {
            NSLog(@"%@",response);
    } failureBlock:^(NSError * _Nonnull error) {

    }];
    
  
    
}

-(NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSArray *keyArray = [dic[@"body"] allKeys];
    for (NSString *keyStr in keyArray) {
        if ([dic[@"body"][keyStr] isEqualToString:@""]||!dic[@"body"][keyStr]) {
            NSMutableDictionary *bodyDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            NSMutableDictionary *myDic = [NSMutableDictionary dictionaryWithDictionary:dic[@"body"]];
            [myDic setValue:@"1" forKey:@"remark"];
            [bodyDic setValue:myDic forKeyPath:@"body"];
            dic = bodyDic.copy;
        }
    }
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *string =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    string =  [string stringByReplacingOccurrencesOfString:@"'\\'" withString:@""];
    string =  [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return string;
}



-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.endTimeStr = [GlobalCommon getCurrentTimes];
    [GlobalCommon pageDurationWithpageId:@"1" withstartTime:self.startTimeStr withendTime:self.endTimeStr];
}


@end
