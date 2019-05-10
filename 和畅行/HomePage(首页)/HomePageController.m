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


#import "SugerViewController.h"
#import "HCY_ActivityController.h"
#import "TestViewController.h"
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
    
    if ([UserShareOnce shareOnce].isRefresh){
        [self requestPackgeNetWork];
        // [self requestUI];
        [UserShareOnce shareOnce].isRefresh = NO;
    }
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
   
   // [self requestPackgeNetWork];
    [self handleNetworkGroup];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exchangeMemberChild:) name:exchangeMemberChildNotify object:nil];
    
    
//    TestViewController *nonDeviceCheck = [[TestViewController alloc] init];
//    nonDeviceCheck.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:nonDeviceCheck animated:YES];
}



- (void)exchangeMemberChild:(NSNotification *)notify
{
    if([[notify object] isKindOfClass:[self class]]){
        return;
    }
   
   [self requestPackgeNetWork];
}

//- (void)userBtnAction:(UIButton *)btn
//{
//    _isActivity = YES;
//    _havePackage = YES;
//    [self requestPackgeNetWork];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

# pragma mark - 活动数据的请求
-(void)requestUI {
    
    NSString *urlStr = @"mobile/index/indexpic.jhtml";
   
    [[NetworkManager sharedNetworkManager] requestWithType:0 urlString:urlStr parameters:nil successBlock:^(id response) {
        
        if([[response objectForKey:@"status"] integerValue] == 100){
            
            for (NSDictionary *dic in [response valueForKey:@"data"]) {
                HCY_HomeImageModel *model = [[HCY_HomeImageModel alloc]init];
                [model yy_modelSetWithJSON:dic];
                
                if([model.type isEqualToString:@"1"]){
                    self.backImageModel = model;
                }
                if ([model.type isEqualToString:@"2"]){
                    self.pushModel = model;
                }
                [self.homeImageArray addObject:model];
                
            }
            
            [self createTopViewWithStatus:YES];
            
            [self addGradientLayer];
            if (self.isRefresh == YES){
                [self.readWriteView setButtonImageWithArray:self.homeImageArray];
                self.isRefresh = NO;
            }
        }else{
            
            [self createTopViewWithStatus:NO];
            
            [self addGradientLayer];
            [self.readWriteView initWithUI];
        }
    } failureBlock:^(NSError *error) {
        [self addGradientLayer];
        [self.readWriteView initWithUI];
    }];
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
    self.packgeView.pushModel = self.pushModel;
    
    if (self.pushModel.picurl!=nil && ![self.pushModel.picurl isKindOfClass:[NSNull class]]&&self.pushModel.picurl.length != 0) {
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@",URL_PRE,self.pushModel.picurl];
        NSURL *url = [NSURL URLWithString:imageUrl];
        self.packgeView.toViewButton.frame = CGRectMake(ScreenWidth/2.0 - 136, self.imageV.bottom - 20, 272, 40);
        [self.packgeView.toViewButton sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
    }
    
    
}

- (void)createTopViewWithStatus:(BOOL)haveTest
{
    CGFloat imageWidth = (ScreenWidth - 10*4)/3.0;
    CGFloat imageHeight = imageWidth*76.8/97.7;
    
    if(!self.packgeView){
        self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*274/414)];
            //414.000000    274.005362
        self.imageV.userInteractionEnabled = YES;
        [self.view addSubview:self.imageV];
            
        self.packgeView = [[HeChangPackge alloc] initWithFrame:CGRectMake(0, -kNavBarHeight, ScreenWidth, ScreenWidth*274/414+20)];
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
        
        self.readWriteView = [[ReadOrWriteView alloc] initWithFrame:CGRectMake(0, _havePackage?self.packgeView.bottom+5:5, ScreenWidth, imageHeight+10)];
    
        [self.bgScrollView addSubview:self.readWriteView];
    }
    
    if(_isActivity){
        if(!self.activityImage){
            self.activityImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, self.readWriteView.bottom+10, ScreenWidth-30, 100)];
            HCY_HomeImageModel *model = self.pushModel?self.pushModel:self.backImageModel;
            [self.activityImage sd_setImageWithURL:[NSURL URLWithString:model.picurl] placeholderImage:[UIImage imageNamed:@"activityImage"]];
            self.activityImage.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(joinActivity)];
            [self.activityImage addGestureRecognizer:tap];
            
            [self.bgScrollView addSubview:self.activityImage];
        }
    }
   
    if(self.testActivityIndicator){
        self.testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.testActivityIndicator.center = CGPointMake(self.view.width/2 , self.readWriteView.bottom +100);//只能设置中心，不能设置大小
        [self.bgScrollView addSubview:self.testActivityIndicator];
        self.testActivityIndicator.color = RGB_TextAppBlue;
    }
    
    
    self.readWriteView.frame = CGRectMake(self.readWriteView.left, _havePackage?self.packgeView.bottom-65:5, self.readWriteView.width, self.readWriteView.height);
    NSLog(@"111:%@*****%@",NSStringFromCGRect(self.packgeView.frame),NSStringFromCGRect(self.readWriteView.frame));
    if(_isActivity){
        self.activityImage.frame = CGRectMake(self.activityImage.left, self.readWriteView.bottom+10, self.activityImage.width, self.activityImage.height);
    }
    self.remindView.frame = CGRectMake(self.remindView.left, _isActivity?self.activityImage.bottom+10:self.readWriteView.bottom+10, self.readWriteView.width, self.remindView.height);
    
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

# pragma mark - 网络请求修改
- (void)handleNetworkGroup
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t serialQueue = dispatch_queue_create("com.wzb.test.www", DISPATCH_QUEUE_SERIAL);
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_group_enter(group);
    dispatch_group_async(group, serialQueue, ^{
        NSString *urlStr = @"member/new_ins/current.jhtml";
        NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
        if ([MemberUserShance shareOnce].idNum){
            [paramDic setObject:[MemberUserShance shareOnce].idNum forKey:@"memberChildId"];
            [paramDic setObject:@"1" forKey:@"isnew"];
        }else {
            return;
        }
        
        [self.testActivityIndicator startAnimating];
        [[NetworkManager sharedNetworkManager] requestWithType:0 urlString:urlStr parameters:paramDic successBlock:^(id response) {
            
            dispatch_group_leave(group);
            
            if([[response objectForKey:@"status"] integerValue] == 100){
                NSInteger status = [[[response objectForKey:@"data"] objectForKey:@"num"] integerValue];
               
                    if(status >=0 && status <= 11){
                        
                        self->_havePackage = YES;
                        
                        if([response objectForKey:@"data"]!=nil && [[response objectForKey:@"data"] isKindOfClass:[NSDictionary class]]){
                            weakSelf.packageDic = [response objectForKey:@"data"];
                        }else{
                            weakSelf.packageDic = nil;
                        }
                    }else{ //未做检测，不显示和畅包
                       self->_havePackage = NO;
                    }
               
            }else{
                [weakSelf showAlertWarmMessage:[response objectForKey:@"data"]];
            }
        } failureBlock:^(NSError *error) {
            dispatch_group_leave(group);
        }];
        
    });
    
    dispatch_group_enter(group);
    dispatch_group_async(group, serialQueue, ^{
        
        NSString *urlStr = @"mobile/index/indexpic.jhtml";
        
        [[NetworkManager sharedNetworkManager] requestWithType:0 urlString:urlStr parameters:nil successBlock:^(id response) {
            
            if([[response objectForKey:@"status"] integerValue] == 100){
                self->_isActivity = YES;
                for (NSDictionary *dic in [response valueForKey:@"data"]) {
                    HCY_HomeImageModel *model = [[HCY_HomeImageModel alloc]init];
                    [model yy_modelSetWithJSON:dic];
                    
                    if([model.type isEqualToString:@"1"]){
                        weakSelf.backImageModel = model;
                    }
                    if ([model.type isEqualToString:@"2"]){
                        weakSelf.pushModel = model;
                    }
                    [weakSelf.homeImageArray addObject:model];
                    
                }
               
            }else{
                self->_isActivity = NO;
            }
            
            dispatch_group_leave(group);
            
        } failureBlock:^(NSError *error) {
            dispatch_group_leave(group);
            self->_isActivity = NO;
            
        }];
    });
    
    
    //所有请求成功后
    dispatch_group_notify(group, serialQueue, ^{
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            [weakSelf requestRemindNetWork];
            dispatch_async(dispatch_get_main_queue(), ^{
                
            // 刷新UI
            [weakSelf createTopViewWithStatus:self->_isActivity];
            
            if(self->_havePackage){
                if(weakSelf.packageDic){
                    NSInteger status = [[self.packageDic objectForKey:@"num"] integerValue];
                    [weakSelf.packgeView changePackgeTypeWithStatus:status withXingStr:[self.packageDic objectForKey:@"name"]];
                }
                
            }
            if(self->_isActivity){
                [weakSelf addGradientLayer];
                if (self.isRefresh == YES){
                    [weakSelf.readWriteView setButtonImageWithArray:self.homeImageArray];
                    self.isRefresh = NO;
                }
            }else{
                [weakSelf addGradientLayer];
                [weakSelf.readWriteView initWithUI];
            }
            
            });
        
        });
        
    });
        
        
   
}


# pragma mark - 和畅包网络请求
- (void)requestPackgeNetWork
{
    NSLog(@"------%@",[UserShareOnce shareOnce].uid);
    NSString *urlStr = @"member/new_ins/current.jhtml";
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    if ([MemberUserShance shareOnce].idNum){
        [paramDic setObject:[MemberUserShance shareOnce].idNum forKey:@"memberChildId"];
        [paramDic setObject:@"1" forKey:@"isnew"];
    }else {
        return;
    }
    __weak typeof(self) weakSelf = self;
     [self.testActivityIndicator startAnimating];
    [[NetworkManager sharedNetworkManager] requestWithType:0 urlString:urlStr parameters:paramDic successBlock:^(id response) {
        
        [weakSelf requestRemindNetWork];
      //  [weakSelf requestUI];
        
        if([[response objectForKey:@"status"] integerValue] == 100){
            NSInteger status = [[[response objectForKey:@"data"] objectForKey:@"num"] integerValue];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(status >=0 && status <= 11){
                    
                    self->_havePackage = YES;
                   // [weakSelf createTopViewWithStatus:YES];
                    if(weakSelf.packgeView){
                        [weakSelf.packgeView changePackgeTypeWithStatus:status withXingStr:[[response objectForKey:@"data"] objectForKey:@"name"]];
                    }
                }else{ //未做检测，不显示和畅包
                    //[weakSelf createTopViewWithStatus:NO];
                    self->_havePackage = NO;
//                    [weakSelf createTopViewWithStatus:YES];
//                    [self addGradientLayer];
                }
            });
        }else{
            [weakSelf showAlertWarmMessage:[response objectForKey:@"data"]];
        }
    } failureBlock:^(NSError *error) {
        [weakSelf requestRemindNetWork];
    }];
}

# pragma mark - 和畅提醒网络请求
- (void)requestRemindNetWork
{
    
    NSString *urlStr = @"member/new_ins/tips.jhtml";
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
                NSArray *nameArr = @[ModuleZW(@"一说"),ModuleZW(@"一点"),ModuleZW(@"一写")];
                NSArray *adviceArr = @[jlbsAdvice,tzbsAdvice,zfbsAdvice];
                for(NSInteger i=0;i<nameArr.count;i++){
                    RemindModel *model = [[RemindModel alloc] init];
                     model.type =[nameArr objectAtIndex:i];
                    model.advice = [adviceArr objectAtIndex:i];
                    model.isDone = NO;
                    [mutableArr addObject:model];
                }
            }
            
            /*
            if([[response objectForKey:@"data"] objectForKey:@"jlbs"] == nil || [[[response objectForKey:@"data"] objectForKey:@"jlbs"] isKindOfClass:[NSNull class]]){
                RemindModel *model = [[RemindModel alloc] init];
                model.type =ModuleZW(@"一说");
                model.advice = jlbsAdvice;
                model.notTest = YES;
                [mutableArr addObject:model];
                NSLog(@"jlbs");
                
            }
            if([[response objectForKey:@"data"] objectForKey:@"tzbs"] == nil || [[[response objectForKey:@"data"] objectForKey:@"tzbs"] isKindOfClass:[NSNull class]]){
                RemindModel *model = [[RemindModel alloc] init];
                model.type = ModuleZW(@"一点");
                model.advice = tzbsAdvice;
                model.notTest = YES;
                [mutableArr addObject:model];
                NSLog(@"tzbs");
            }
            if([[response objectForKey:@"data"] objectForKey:@"zfbs"] == nil || [[[response objectForKey:@"data"] objectForKey:@"zfbs"] isKindOfClass:[NSNull class]]){
                RemindModel *model = [[RemindModel alloc] init];
                model.type =ModuleZW( @"一写");
                model.advice = zfbsAdvice;
                model.notTest = YES;
                [mutableArr addObject:model];
                NSLog(@"zfbs");
            }
            */
            
            weakSelf.remindView.dataArr = mutableArr;
            dispatch_async(dispatch_get_main_queue(), ^{
                if(!weakSelf.remindView){
                    weakSelf.remindView = [[HeChangRemind alloc] initWithFrame:CGRectMake(weakSelf.packgeView.left,   weakSelf.activityImage?weakSelf.activityImage.bottom+10:weakSelf.readWriteView.bottom+10, weakSelf.readWriteView.width, 58+mutableArr.count*(45+14)) withDataArr:mutableArr];
                    
                    [weakSelf.bgScrollView addSubview:weakSelf.remindView];
                    
                    CGFloat width = (ScreenWidth - 23 - 10)/2.5;
                    weakSelf.recommendView = [[RecommendReadView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(weakSelf.remindView.frame)+10, ScreenWidth, width*0.75+7+40+55)];
                    [weakSelf.bgScrollView addSubview:self.recommendView];
                    weakSelf.bgScrollView.contentSize = CGSizeMake(1, self.recommendView.bottom+20);
                }else{
                    [weakSelf.remindView updateViewWithData:mutableArr withHeight:58+mutableArr.count*(45+14)];
                    weakSelf.recommendView.frame = CGRectMake(0, weakSelf.remindView.bottom+10, weakSelf.recommendView.width, weakSelf.recommendView.height);
                }
                
                [weakSelf.bgScrollView setContentSize:CGSizeMake(1, weakSelf.recommendView.bottom+20)];
                
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




@end
