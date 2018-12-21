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
@property (nonatomic, strong) MBProgressHUD *hud;


@end

@implementation HomePageController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromHex(0xffffff);
    self.topView.backgroundColor = [UIColor clearColor];

    [self createTopView];
   
    [self requestPackgeNetWork];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

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
            [self addGradientLayer];
            [self.readWriteView setButtonImageWithArray:self.homeImageArray];
        }else{
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
    if (_backImageModel.picurl==nil || [_backImageModel.picurl isKindOfClass:[NSNull class]]||_backImageModel.picurl.length == 0) {
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = self.imageV.bounds;
        gradientLayer.colors = [NSArray arrayWithObjects:(id)UIColorFromHex(0x1E82D2).CGColor,(id)UIColorFromHex(0x2B95EB).CGColor,(id)UIColorFromHex(0x05A1EE).CGColor, nil];
        gradientLayer.startPoint = CGPointMake(0.5, 0);
        gradientLayer.endPoint = CGPointMake(0.5, 1);
        gradientLayer.locations = @[@0,@0.5,@1.0];
        [self.imageV.layer addSublayer:gradientLayer];
    }else {
        
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@",URL_PRE,_backImageModel.picurl];
        NSURL *url = [NSURL URLWithString:imageUrl];
        [self.imageV sd_setImageWithURL:url];
        
        [self.packgeView.imageV sd_setImageWithURL:url];
    }
    
    [self.view addSubview:self.topView];
    self.packgeView.pushModel = self.pushModel;
    
    if (self.pushModel.picurl!=nil && ![self.pushModel.picurl isKindOfClass:[NSNull class]]&&self.pushModel.picurl.length != 0) {
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@",URL_PRE,self.pushModel.picurl];
        NSURL *url = [NSURL URLWithString:imageUrl];
        self.packgeView.toViewButton.frame = CGRectMake(ScreenWidth/2.0 - 136, self.imageV.bottom - 20, 272, 40);

        [self.packgeView.toViewButton sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
    }else {
        self.packgeView.toViewButton.frame = CGRectMake(ScreenWidth/2.0 - 136, self.imageV.bottom - 30, 272, 60);
        [self.packgeView.toViewButton setBackgroundImage:[UIImage imageNamed:@"和畅包"] forState:(UIControlStateNormal)];
    }
    
    
}

- (void)createTopView
{
    NSLog(@"w:%f,h:%f",ScreenWidth,ScreenHeight);
    
    self.homeImageArray = [NSMutableArray array];

    self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*274/414)];
//414.000000    274.005362
    self.imageV.userInteractionEnabled = YES;
    [self.view addSubview:self.imageV];
    
    
    self.packgeView = [[HeChangPackge alloc] initWithFrame:CGRectMake(0, -kNavBarHeight, ScreenWidth, ScreenWidth*274/414+20)];
  
    
    self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, ScreenWidth, ScreenHeight-kNavBarHeight-kTabBarHeight)];
    self.bgScrollView.showsVerticalScrollIndicator = NO;
    self.bgScrollView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    self.bgScrollView.bounces = YES;
    self.bgScrollView.contentSize = CGSizeMake(1, ScreenHeight+260);
    self.bgScrollView.delegate = self;
    [self.bgScrollView addSubview:self.packgeView];
    
    [self.view addSubview:self.bgScrollView];
    
    
    CGFloat imageWidth = (ScreenWidth - 10*4)/3.0;
    CGFloat imageHeight = imageWidth*76.8/97.7;
    
     self.readWriteView = [[ReadOrWriteView alloc] initWithFrame:CGRectMake(0, self.packgeView.bottom, ScreenWidth, imageHeight+10)];
    [self.bgScrollView addSubview:self.readWriteView];
    
    [self requestUI];

   
    
}

- (void)createMiddleView
{

    self.readWriteView = [[ReadOrWriteView alloc] initWithFrame:CGRectMake(14, 0, ScreenWidth-14*2, 260)];
    [self.bgScrollView addSubview:self.readWriteView];
    
    self.packgeView = [[HeChangPackge alloc] initWithFrame:CGRectMake(self.readWriteView.left, self.readWriteView.bottom+20, self.readWriteView.width, 150)];
    
    [self.bgScrollView addSubview:self.packgeView];
    
    
}

# pragma mark - 和畅包网络请求
- (void)requestPackgeNetWork
{

    NSString *urlStr = @"member/new_ins/current.jhtml";
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [paramDic setObject:[MemberUserShance shareOnce].idNum forKey:@"memberChildId"];
    __weak typeof(self) weakSelf = self;
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.label.text = @"加载中...";
    [[NetworkManager sharedNetworkManager] requestWithType:0 urlString:urlStr parameters:paramDic successBlock:^(id response) {
        
        [weakSelf requestRemindNetWork];
        
        if([[response objectForKey:@"status"] integerValue] == 100){
            NSInteger status = [[response objectForKey:@"data"] integerValue];
            //status = arc4random() % 6 + 1;
            [weakSelf.packgeView changePackgeTypeWithStatus:status];
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
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [paramDic setObject:[MemberUserShance shareOnce].idNum forKey:@"memberChildId"];
    __weak typeof(self) weakSelf = self;
    
    [[NetworkManager sharedNetworkManager] requestWithType:0 urlString:urlStr parameters:paramDic successBlock:^(id response) {
        
        if([[response objectForKey:@"status"] integerValue] == 100){
            id listData = [[response objectForKey:@"data"] objectForKey:@"todolist"];
            NSMutableArray *mutableArr = [NSMutableArray arrayWithCapacity:0];
            if(listData != nil && ![listData isKindOfClass:[NSNull class]]){
                NSArray *listArr = (NSArray *)listData;
                NSLog(@"todolist");
                for(NSDictionary *dic in listArr){
                    RemindModel *model = [RemindModel mj_objectWithKeyValues:dic];
                    model.type = [GlobalCommon getRemindTRypeWithStr:model.type];
                    [mutableArr addObject:model];
                }
            }
            if([[response objectForKey:@"data"] objectForKey:@"jlbs"] == nil || [[[response objectForKey:@"data"] objectForKey:@"jlbs"] isKindOfClass:[NSNull class]]){
                RemindModel *model = [[RemindModel alloc] init];
                model.type = @"一说";
                model.advice = jlbsAdvice;
                [mutableArr addObject:model];
                NSLog(@"jlbs");
            }
            if([[response objectForKey:@"data"] objectForKey:@"tzbs"] == nil || [[[response objectForKey:@"data"] objectForKey:@"tzbs"] isKindOfClass:[NSNull class]]){
                RemindModel *model = [[RemindModel alloc] init];
                model.type = @"一点";
                model.advice = tzbsAdvice;
                [mutableArr addObject:model];
                NSLog(@"tzbs");
            }
            if([[response objectForKey:@"data"] objectForKey:@"zfbs"] == nil || [[[response objectForKey:@"data"] objectForKey:@"zfbs"] isKindOfClass:[NSNull class]]){
                RemindModel *model = [[RemindModel alloc] init];
                model.type = @"一写";
                model.advice = zfbsAdvice;
                [mutableArr addObject:model];
                NSLog(@"zfbs");
            }
            
            weakSelf.remindView.dataArr = mutableArr;
            dispatch_async(dispatch_get_main_queue(), ^{
                if(!weakSelf.remindView){
                    weakSelf.remindView = [[HeChangRemind alloc] initWithFrame:CGRectMake(weakSelf.packgeView.left, weakSelf.readWriteView.bottom+10, weakSelf.readWriteView.width, 58+mutableArr.count*45) withDataArr:mutableArr];
                    [weakSelf.bgScrollView addSubview:weakSelf.remindView];
                    
                    CGFloat width = (ScreenWidth - 23 - 10)/2.5;
                    weakSelf.recommendView = [[RecommendReadView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(weakSelf.remindView.frame)+10, ScreenWidth, width*0.75+7+40+55)];
                    [weakSelf.bgScrollView addSubview:self.recommendView];
                    weakSelf.bgScrollView.contentSize = CGSizeMake(1, self.recommendView.bottom+20);
                }else{
                    //weakSelf.remindView.height = 58+mutableArr.count*45;
                    [weakSelf.remindView updateViewWithData:mutableArr withHeight:58+mutableArr.count*45];
                    weakSelf.recommendView.frame = CGRectMake(0, weakSelf.remindView.bottom+10, weakSelf.recommendView.width, weakSelf.recommendView.height);
                }
                
                [weakSelf.bgScrollView setContentSize:CGSizeMake(1, weakSelf.recommendView.bottom+20)];
                
            });
            
        }else{
            [weakSelf showAlertWarmMessage:[response objectForKey:@"data"]];
        }
        [self.hud hideAnimated:YES];
    } failureBlock:^(NSError *error) {
        [self.hud hideAnimated:YES];
    }];
}

# pragma mark - 用户信息按钮
- (void)userBtnAction:(UIButton *)btn
{
    SubMemberView *subMember = [[SubMemberView alloc] initWithFrame:CGRectZero];
    __weak typeof(self) weakself = self;
    [subMember receiveSubIdWith:^(NSString *subId) {
        NSLog(@"%@",subId);
        [weakself requestPackgeNetWork];
        [subMember hideHintView];
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
