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

@interface BlockViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain) UITableView *tableView;
@property (nonatomic,retain) NSMutableArray *dataArray;
@property (nonatomic,strong) UILabel *nullLabel;
//请求页数
@property (nonatomic,assign) NSInteger pageInteger;
@end

@implementation BlockViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self layoutView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.pageInteger = 1;

    [self getDatawithpageInteger:self.pageInteger];
}

-(void)layoutView {
    UIButton *marryStateBtn = [Tools creatButtonWithFrame:CGRectMake(ScreenWidth - 55, kNavBarHeight + 13, 36, 36) target:self sel:@selector(addAction) tag:1000 image:@"HCY_addcard" title:nil];
    [self.view addSubview:marryStateBtn];
    
    UILabel *blockLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, marryStateBtn.top, 100, 36)];
    blockLabel.text = @"我的卡包";
    blockLabel.textColor = [UtilityFunc colorWithHexString:@"#000000"];
    blockLabel.font = [UIFont systemFontOfSize:21];
    [self.view addSubview:blockLabel];
    
    self.nullLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, marryStateBtn.bottom , ScreenWidth, 200)];
    self.nullLabel.text = @"还没有卡\n快去添加新卡吧~";
    self.nullLabel.numberOfLines = 2;
    self.nullLabel.font = [UIFont systemFontOfSize:17];
    self.nullLabel.textAlignment = NSTextAlignmentCenter;
    self.nullLabel.textColor = [UtilityFunc colorWithHexString:@"#8E8F90"];
    [self.view addSubview:self.nullLabel];
    
    self.dataArray = [NSMutableArray array];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(17, kNavBarHeight+65, self.view.frame.size.width - 34, self.view.frame.size.height - kNavBarHeight-60) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 140;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableView];
    [self.tableView registerClass:[BlockTableViewCell class] forCellReuseIdentifier:@"BlockTableViewCell"];
    
    //下拉刷新
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"努力加载中..." forState:MJRefreshStateRefreshing];
    [header setTitle:@"松开即可刷新..." forState:MJRefreshStatePulling];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.font = [UIFont systemFontOfSize:14];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    header.stateLabel.textColor = RGB_TextAppBlue;
    header.lastUpdatedTimeLabel.textColor = RGB_TextAppBlue;
    self.tableView.mj_header = header;
    
//    //上拉加载
//    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataOther)];
//
//    [footer setTitle:@"上拉加载"   forState:MJRefreshStateIdle];
//    [footer setTitle:@"加载中..."  forState:MJRefreshStateRefreshing];
//    [footer setTitle:@"没有更多了"  forState:MJRefreshStateNoMoreData];
//    [footer setTitle:@"松开即可加载..."  forState:MJRefreshStatePulling];
//    footer.stateLabel.font = [UIFont systemFontOfSize:14];
//    footer.stateLabel.textColor = RGB_TextAppBlue;
//    self.tableView.mj_footer = footer;
    
    
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
    hud.label.text = @"加载中...";
    
    NSString *memberId = [NSString stringWithFormat:@"%@",[UserShareOnce shareOnce].uid];
    
    NSString *str = [NSString stringWithFormat:@"/member/cashcard/list/%@.jhtml",memberId];
    [[NetworkManager sharedNetworkManager] requestWithType:0 urlString:str parameters:nil successBlock:^(id response) {
        
        [hud hideAnimated:YES];
        NSLog(@"%@",response);
        if ([response[@"status"] integerValue] == 100){
                [self.dataArray removeAllObjects];
            NSArray *dataArray1 = [response valueForKey:@"data"];
            if (dataArray1.count <2){
                self.nullLabel.hidden = NO;
                self.tableView.hidden = YES;
                return ;
            }
            NSArray *dataArray = [response valueForKey:@"data"][1];
            for (NSDictionary *dic in dataArray ) {
                HYC_CardsModel *model = [[HYC_CardsModel alloc]init];
                [model yy_modelSetWithJSON:dic];
                [self.dataArray addObject:model];
            }
            
            
            if(self.dataArray.count < 1) {
                self.nullLabel.hidden = NO;
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
    BoundBlockViewController *boundBlockVC = [[BoundBlockViewController alloc]init];
    [self.navigationController pushViewController:boundBlockVC animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BlockTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BlockTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HYC_CardsModel *model =  _dataArray[indexPath.row];
    [cell setCarListDataWithModel:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HYC_CardsModel *model = self.dataArray[indexPath.row];
    
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



@end
