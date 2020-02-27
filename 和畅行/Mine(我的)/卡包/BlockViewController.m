//
//  BlockViewController.m
//  Voicediagno
//
//  Created by ZhangYunguang on 16/1/11.
//  Copyright © 2016年 ZhangYunguang. All rights reserved.
//

#import "BlockViewController.h"
#import "BlockTableViewCell.h"
#import "BoundBlockViewController.h"
#import "HCY_ActivationController.h"
#import "HCY_CarDetailController.h"
#import "HYC_CardsModel.h"
#import "LoginViewController.h"
#import "AllServiceCell.h"
#import "WXPhoneController.h"
@interface BlockViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain) UITableView *tableView;
@property (nonatomic,retain) NSMutableArray *dataArray;
@property (nonatomic,retain) NSMutableArray *servieArray;
@property (nonatomic,strong) UILabel *nullLabel;
//请求页数
@property (nonatomic,assign) NSInteger pageInteger;
@property (nonatomic,strong) UIView *listBackView;
@property (nonatomic,strong)UITableView *listTableView;
@end

@implementation BlockViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navTitleLabel.text = ModuleZW(@"我的卡包");
    self.startTimeStr = [GlobalCommon getCurrentTimes];
    [[NSNotificationCenter defaultCenter] addObserver :self selector:@selector(cardNameSuccess) name:@"cardNameSuccess" object:nil];
    [self getDatawithpageInteger:self.pageInteger];
    [self layoutView];
    
    
}

- (void)cardNameSuccess
{
    [self getDatawithpageInteger:self.pageInteger];
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.pageInteger = 1;

    
}

-(void)layoutView {
    UIButton *marryStateBtn = [Tools creatButtonWithFrame:CGRectMake(ScreenWidth - Adapter(55), kNavBarHeight + Adapter(13), Adapter(36), Adapter(36)) target:self sel:@selector(addAction) tag:1000 image:@"HCY_addcard" title:nil];
    [self.view addSubview:marryStateBtn];
    
    UIButton *allServiceBT = [Tools creatButtonWithFrame:CGRectMake(Adapter(20), kNavBarHeight + Adapter(13), Adapter(100), Adapter(36)) target:self sel:@selector(allServiceAction) tag:1000 image:nil title:ModuleZW(@"全部服务")];
    allServiceBT.backgroundColor = RGB_ButtonBlue;
    allServiceBT.layer.cornerRadius = allServiceBT.height/2;
    [allServiceBT.titleLabel setFont:[UIFont systemFontOfSize:16/[UserShareOnce shareOnce].multipleFontSize]];
    allServiceBT.layer.masksToBounds  = YES;
    [self.view addSubview:allServiceBT];
    
    UILabel *blockLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, marryStateBtn.top, 200, 36)];
    blockLabel.text = ModuleZW(@"我的卡包");
    blockLabel.textColor = [UtilityFunc colorWithHexString:@"#000000"];
    blockLabel.font = [UIFont systemFontOfSize:21];
    //[self.view addSubview:blockLabel];
    
    self.nullLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, marryStateBtn.bottom , ScreenWidth, Adapter(200))];
    self.nullLabel.text = ModuleZW(@"还没有卡\n快去添加新卡吧~");
    self.nullLabel.numberOfLines = 2;
    self.nullLabel.font = [UIFont systemFontOfSize:17];
    self.nullLabel.textAlignment = NSTextAlignmentCenter;
    self.nullLabel.textColor = [UtilityFunc colorWithHexString:@"#8E8F90"];
    [self.view addSubview:self.nullLabel];
    
    self.dataArray = [NSMutableArray array];
    self.servieArray = [NSMutableArray array];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavBarHeight+Adapter(65), ScreenWidth, self.view.frame.size.height - kNavBarHeight-Adapter(60)) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = Adapter(140);
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableView];
    [self.tableView registerClass:[BlockTableViewCell class] forCellReuseIdentifier:@"BlockTableViewCell"];
    
    //下拉刷新
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [header setTitle:ModuleZW(@"下拉刷新") forState:MJRefreshStateIdle];
    [header setTitle:ModuleZW(@"努力加载中...") forState:MJRefreshStateRefreshing];
    [header setTitle:ModuleZW(@"松开即可刷新...") forState:MJRefreshStatePulling];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.font = [UIFont systemFontOfSize:14];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    header.stateLabel.textColor = RGB_TextAppBlue;
    header.lastUpdatedTimeLabel.textColor = RGB_TextAppBlue;
    self.tableView.mj_header = header;
    
    self.pageInteger = 1;
}

//下拉加载
-(void)loadNewData {
    
    self.pageInteger = 1;
    [self getDatawithpageInteger:self.pageInteger];
}

//上拉刷新
-(void)loadMoreDataOther {
    
    self.pageInteger ++;
    [self getDatawithpageInteger:self.pageInteger];
    
}

-(void)getDatawithpageInteger:(NSInteger)integer {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = ModuleZW(@"加载中...");
    
    NSString *memberId = [NSString stringWithFormat:@"%@",[UserShareOnce shareOnce].uid];
    
    NSString *str = [NSString stringWithFormat:@"/member/cashcard/list/%@.jhtml",memberId];
    [[NetworkManager sharedNetworkManager] requestWithType:0 urlString:str parameters:nil successBlock:^(id response) {
        
        [hud hideAnimated:YES];
        NSLog(@"%@",response);
        if ([response[@"status"] integerValue] == 100){
            [self.dataArray removeAllObjects];
           [self.servieArray removeAllObjects];
        
            NSArray *oneArray = [[response valueForKey:@"data"] valueForKey:@"data"];
            NSArray *dataArray = [[response valueForKey:@"data"] valueForKey:@"attr_data"];
            NSArray *servieceArray  =  [[response valueForKey:@"data"] valueForKey:@"stat_data"];
            if ( dataArray.count == 0 && oneArray.count == 0){
                self.nullLabel.hidden = NO;
                self.tableView.hidden = YES;
            }
            
            for (NSDictionary *dic in oneArray ) {
                HYC_CardsModel *model = [[HYC_CardsModel alloc]init];
                [model yy_modelSetWithJSON:dic];
                model.kindStr = ModuleZW(@"现金卡");
                [self.dataArray addObject:model];
            }
            
            for (NSDictionary *dic in dataArray ) {
                HYC_CardsModel *model = [[HYC_CardsModel alloc]init];
                model.kindStr = ModuleZW(@"卡");
                [model yy_modelSetWithJSON:dic];
                [self.dataArray addObject:model];
            }
            
            for (NSDictionary *dic in servieceArray ) {
                HYC_CardsModel *model = [[HYC_CardsModel alloc]init];
                [model yy_modelSetWithJSON:dic];
                [self.servieArray addObject:model];
            }
            
            
            if(self.dataArray.count < 1) {
                self.nullLabel.hidden  = NO;
                self.tableView.hidden = YES;
            }else{
                self.nullLabel.hidden = YES;
                self.tableView.hidden = NO;
            }
            
            [self.tableView reloadData];
            
        }
    } failureBlock:^(NSError *error) {
        
        [hud hideAnimated:YES];
        NSLog(@"%@",error);
        [self showAlertWarmMessage:requestErrorMessage];
    }];
    
//    if (self.pageInteger == 1) {
        [self.tableView.mj_header endRefreshing];
//    }else {
//        [self.tableView.mj_footer endRefreshing];
//    }
    
}
- (void)addAction{
    if ([UserShareOnce shareOnce].username.length != 11) {
        [self showAlerVC];
        return;
    }
    BoundBlockViewController *boundBlockVC = [[BoundBlockViewController alloc]init];
    [self.navigationController pushViewController:boundBlockVC animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        return self.dataArray.count;
    }else{
        return self.servieArray.count;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView) {
        BlockTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BlockTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        HYC_CardsModel *model =  _dataArray[indexPath.row];
        [cell setCarListDataWithModel:model];
        return cell;
    }else{
        AllServiceCell * cell =[tableView dequeueReusableCellWithIdentifier:@"AllServiceCell"];
        if(cell==nil){
            cell = [[AllServiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AllServiceCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        HYC_CardsModel *model =  _servieArray[indexPath.row];
        [cell setAllServicValueWithModel:model];
        return cell;
    }
  
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.listTableView) return;
    
    HYC_CardsModel *model = self.dataArray[indexPath.row];
    NSLog(@"%@",self.dataArray);
    
    if([model.kindStr isEqualToString:ModuleZW(@"现金卡")] )return;
    
    if ([model.status isEqualToString:@"1"]) {
        
        HCY_ActivationController *activaTionVC = [[HCY_ActivationController alloc]init];
        activaTionVC.model = model;
        [self.navigationController pushViewController:activaTionVC animated:YES];
        
    }else {
        
        HCY_CarDetailController *detailVC = [[HCY_CarDetailController alloc]init];
        detailVC.model = model;
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }
    
   
}

//全部服务展示按钮
-(void)allServiceAction{
    
    if(!self.listBackView) {
        self.listBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        self.listBackView.backgroundColor = RGBA(0, 0, 0, 0.55);
        self.listBackView.hidden = NO;
        [self.view addSubview:self.listBackView];
        
        self.listTableView = [[UITableView alloc]initWithFrame:CGRectMake(Adapter(20), kNavBarHeight + Adapter(20)  , ScreenWidth - Adapter(40) , ScreenHeight - kTabBarHeight - kNavBarHeight - Adapter(20)) style:UITableViewStylePlain];
        self.listTableView.backgroundColor = UIColorFromHex(0Xffffff);
        self.listTableView.separatorStyle = UITableViewCellEditingStyleNone;
        self.listTableView.layer.cornerRadius = 8;
        self.listTableView.dataSource = self;
        self.listTableView.delegate = self;
        self.listTableView.estimatedRowHeight = Adapter(100);
        self.listTableView.contentInset = UIEdgeInsetsMake(Adapter(20), 0, Adapter(20), 0);
        [self.listBackView addSubview:self.listTableView];
        UIButton *closeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        closeButton.frame = CGRectMake(ScreenWidth - Adapter(40), kNavBarHeight -10, Adapter(30), Adapter(30));
        [closeButton setBackgroundImage:[UIImage imageNamed:@"消费记录取消icon"] forState:(UIControlStateNormal)];
        [[closeButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
            self.listBackView.hidden = YES;
        }];
        [self.listBackView addSubview:closeButton];
    }else{
        self.listBackView.hidden = NO;
    }
    
    [self.listTableView reloadData];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.listBackView&&self.listBackView.hidden == NO) {
        self.listBackView.hidden = YES;
    }
}

-(void)showAlerVC {
    UIAlertController *alVC= [UIAlertController alertControllerWithTitle:ModuleZW(@"提示") message:ModuleZW(@"您还没有绑定手机号码,绑定后才能享受服务,是否绑定?") preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:ModuleZW(@"确定") style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        WXPhoneController *vc = [[WXPhoneController alloc]init];
        vc.pushType = 0;
        [self presentViewController:vc animated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:ModuleZW(@"取消") style:(UIAlertActionStyleCancel) handler:nil];
    [alVC addAction:sureAction];
    [alVC addAction:cancelAction];
    [self presentViewController:alVC animated:YES completion:nil];
}
-(void)dealloc {
    
    
    
}
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.endTimeStr = [GlobalCommon getCurrentTimes];
    [GlobalCommon pageDurationWithpageId:@"37" withstartTime:self.startTimeStr withendTime:self.endTimeStr];
}

@end
