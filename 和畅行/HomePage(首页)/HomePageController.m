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

@interface HomePageController ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *bgScrollView;
@property (nonatomic,strong) HeChangPackge *packgeView;
@property (nonatomic,strong) HeChangRemind *remindView;
@property (nonatomic,strong) ReadOrWriteView *readWriteView;
@property (nonatomic, strong) RecommendReadView *recommendView;



@end

@implementation HomePageController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    
    self.view.backgroundColor = UIColorFromHex(0xffffff);
    
    [self createTopView];
    [super viewDidLoad];
   
    self.topView.backgroundColor = [UIColor clearColor];
    
    [self requestPackgeNetWork];
  
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addGradientLayer
{
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 298/746.0*ScreenHeight-20)];
    //添加渐变色
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = imageV.bounds;
    gradientLayer.colors = [NSArray arrayWithObjects:(id)UIColorFromHex(0x1E82D2).CGColor,(id)UIColorFromHex(0x2B95EB).CGColor,(id)UIColorFromHex(0x05A1EE).CGColor, nil];
    gradientLayer.startPoint = CGPointMake(0.5, 0);
    gradientLayer.endPoint = CGPointMake(0.5, 1);
    gradientLayer.locations = @[@0,@0.5,@1.0];
    [imageV.layer addSublayer:gradientLayer];
    [self.view addSubview:imageV];
}

- (void)createTopView
{
    NSLog(@"w:%f,h:%f",ScreenWidth,ScreenHeight);
    
    [self addGradientLayer];
    
    self.packgeView = [[HeChangPackge alloc] initWithFrame:CGRectMake(0, -kNavBarHeight, ScreenWidth, 298/746.0*ScreenHeight)];
  
    
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
    } failureBlock:^(NSError *error) {
        
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
