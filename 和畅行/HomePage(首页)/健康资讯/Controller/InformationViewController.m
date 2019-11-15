//
//  InformationViewController.m
//  Voicediagno
//
//  Created by 李传铎 on 15/9/22.
//  Copyright (c) 2015年 李传铎. All rights reserved.
//

#import "InformationViewController.h"
#import "HYSegmentedControl.h"

#import "NSObject+SBJson.h"
#import "SBJson.h"
#import "MBProgressHUD.h"
#import "FSSegmentTitleView.h"
#import "LoginViewController.h"
#import "UIImageView+WebCache.h"
#import "HeChangPackgeController.h"
#import "HealthLectureViewController.h"
#import "InformationCell.h"

@interface InformationViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,FSSegmentTitleViewDelegate>


{
    MBProgressHUD* progress_;
    
}
@property (nonatomic,strong)  FSSegmentTitleView *BaoGaosegment;
@property (nonatomic ,strong) UITableView *healthTableView;
@property (nonatomic,strong) UIScrollView* BaoGaoScroll;
@property (nonatomic,strong) UIView * BaoGaoview;
@property (nonatomic ,strong) NSMutableArray *hotArray;
@property (nonatomic ,strong) NSMutableArray *healthArray;
@property (nonatomic ,strong) NSMutableArray *idArray;
@property (nonatomic,strong)UIView *noView;
@property (nonatomic ,strong) UIView *healthView;
@property (nonatomic,assign) NSInteger pageInteger;
@property (nonatomic,assign) NSInteger typeInteger;
@property (nonatomic,copy) NSString * typeStr;;

@end

@implementation InformationViewController
- (void)dealloc{
    self.BaoGaosegment = nil;
    self.healthTableView = nil;
    self.BaoGaoScroll = nil;
    self.BaoGaoview = nil;
    self.hotArray = nil;
    self.healthArray = nil;
    self.idArray = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _pageInteger = 0;
    _typeInteger = 0;
    _typeStr = nil;
    _idArray = [[NSMutableArray alloc]init];
    self.navTitleLabel.text = ModuleZW(@"健康资讯");
    self.hotArray = [[NSMutableArray alloc]init];
    self.healthArray = [NSMutableArray array];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.noView = [NoMessageView createImageWith:150.0f];
    [self.view addSubview:self.noView ];
    
    [self huoquwenzhangCanshu];


}





- (void)huoquwenzhangCanshu{
    NSString *headYUrl = @"/article/healthCategoryList.jhtml";
    
    __weak typeof(self) weakSelf = self;
    [[NetworkManager sharedNetworkManager] requestWithType:BAHttpRequestTypeHeadGet urlString:headYUrl parameters:nil successBlock:^(id response) {
        [self hudWasHidden];
        id status=[response objectForKey:@"status"];
        if ([status intValue] == 100)
        {
            NSArray *array = [response objectForKey:@"data"];
            NSMutableArray *daArray = [[NSMutableArray alloc]init];
            [weakSelf.idArray addObject:@"hot"];
            [weakSelf.idArray addObject:@"10"];
            [daArray addObject:ModuleZW(@"最新资讯")];
            if(array.count >0){
                for (NSDictionary *Dic in array) {
                    [daArray addObject:[NSString stringWithFormat:@"%@",[Dic objectForKey:@"name"]]];
                    [weakSelf.idArray addObject:[NSString stringWithFormat:@"%@",[Dic objectForKey:@"id"]]];
                }
            }
            
            [self huoquwenzhang:daArray];
        }
        else  {
            [self showAlertWarmMessage:requestErrorMessage];
        }
    
    } failureBlock:^(NSError *error) {
        [self hudWasHidden];
        [self showAlertWarmMessage:requestErrorMessage];
    }];

}


- (void)huoquwenzhang:(NSArray *)array{
    
    
    UILabel* lb=[[UILabel alloc] init];
    lb.frame=CGRectMake(0, kNavBarHeight, ScreenWidth, 1);
    [self.view addSubview:lb];

    
    _BaoGaosegment = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, self.topView.bottom, CGRectGetWidth(self.view.bounds), 30) titles:array delegate:self indicatorType:FSIndicatorTypeEqualTitle];
    _BaoGaosegment.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_BaoGaosegment];

    _healthTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _BaoGaosegment.bottom + 10, ScreenWidth, ScreenHeight-_BaoGaosegment.bottom - 10) style:UITableViewStylePlain];
    _healthTableView.tableFooterView = [[UIView alloc]init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _healthTableView.rowHeight = 85;
    _healthTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _healthTableView.backgroundView = nil;
    _healthTableView.backgroundColor = [UIColor clearColor];
    _healthTableView.delegate = self;
    _healthTableView.dataSource = self;
    [self.view addSubview:_healthTableView];

    [self FSSegmentTitleView:self.BaoGaosegment startIndex:0 endIndex:0];
    
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
    self.healthTableView.mj_header = header;
    
    //上拉加载
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataOther)];
    [footer setTitle:ModuleZW(@"上拉加载")   forState:MJRefreshStateIdle];
    [footer setTitle:ModuleZW(@"加载中...")  forState:MJRefreshStateRefreshing];
    [footer setTitle:ModuleZW(@"没有更多了")  forState:MJRefreshStateNoMoreData];
    [footer setTitle:ModuleZW(@"松开即可加载...")  forState:MJRefreshStatePulling];
    footer.stateLabel.font = [UIFont systemFontOfSize:14];
    footer.stateLabel.textColor = RGB_TextAppBlue;
    self.healthTableView.mj_footer = footer;
    
    
}

# pragma mark ----- 下拉加载
-(void)loadNewData {
    
    self.pageInteger = 1;
    if(self.typeInteger == 0){
        _typeStr = nil;
    }
    [self requestHealthHintDataRefreshWithString:_typeStr];
}

# pragma mark ----- 上拉加载
-(void)loadMoreDataOther {
    self.pageInteger ++;
    if(self.typeInteger == 0){
        _typeStr = nil;
    }
    [self requestHealthHintDataLoadingWithString:_typeStr];
    
}

- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.pageInteger = 1;
//   [self.healthTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
   
    if (endIndex == 0) {
        self.typeInteger = 0;
        self.healthView.hidden = YES;
        self.healthTableView.hidden = NO;
        [self requestHealthHintDataRefreshWithString:nil];
//    }else if(endIndex == 2){
//        self.typeInteger = 1;
//        HealthLectureViewController *vc = [[HealthLectureViewController alloc]init];
//        [self addChildViewController:vc];
//        vc.view.frame =  CGRectMake(0, _BaoGaosegment.bottom, ScreenWidth, ScreenHeight-_BaoGaosegment.bottom);
//        [self.view addSubview:vc.view];
//        self.healthView  = vc.view;
//        [vc didMoveToParentViewController:self];
//        if ([UserShareOnce shareOnce].languageType){
//            self.healthView.hidden = YES;
//            self.healthTableView.hidden = NO;
//            _typeStr = [self.idArray objectAtIndex:endIndex];
//            [self requestHealthHintDataRefreshWithString:_typeStr];
//        }else{
//            self.healthView.hidden = NO;
//            self.healthTableView.hidden = YES;
//            self.noView.hidden = YES;
//        }
    }else{
        self.typeInteger = 2;
        self.healthView.hidden = YES;
        self.healthTableView.hidden = NO;
        _typeStr = [self.idArray objectAtIndex:endIndex];
        [self requestHealthHintDataRefreshWithString:_typeStr];
    }
    
    
}

-(void)addChildVc:(UIViewController*)vc view:(UIView *)view {
    BOOL needAddToParent = !vc.parentViewController;
    if (needAddToParent) [self addChildViewController:vc];
    vc.view.frame = view.bounds;
    [view addSubview:vc.view];
    if (needAddToParent) [vc didMoveToParentViewController:self];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
//    [self.healthArray removeAllObjects];
//    [self.healthTableView reloadData];
//    //通过最终得到的偏移量offset值，来确定pageContntrol当前应该显示第几个圆点
//
//    NSInteger index = scrollView.contentOffset.x / CGRectGetWidth(scrollView.bounds);
//
//    [_BaoGaosegment changeSegmentedControlWithIndex:index];
    
}
# pragma mark - 最新资讯
 - (void)requestHealthHintDataRefreshWithString:(NSString *)string{
    [self showHUD];
     NSString *aUrlle = [NSString string];
     if ([GlobalCommon stringEqualNull:string]) {
         aUrlle = [NSString stringWithFormat:@"/article/healthArticleList.jhtml?pageNumber=%ld",(long)self.pageInteger];
     }else{
         //
         aUrlle= [NSString stringWithFormat:@"/article/healthListByCategory/%@.jhtml?pageNumber=%ld",string,(long)self.pageInteger];
         aUrlle = [aUrlle stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

     }
    
    [[NetworkManager sharedNetworkManager] requestWithType:BAHttpRequestTypeHeadGet urlString:aUrlle parameters:nil successBlock:^(id response) {
        
        [self hudWasHidden];
        NSLog(@"%@",response);
        if ([response[@"status"] integerValue] == 100){
           
            [self.healthArray removeAllObjects];
            [self.healthArray addObjectsFromArray:[[response valueForKey:@"data"] valueForKey:@"content"]];
            [self.healthTableView reloadData];
            if (self.healthArray.count > 0) {
                self.noView.hidden = YES;
                NSIndexPath* indexPat = [NSIndexPath indexPathForRow:0 inSection:0];
                [self.healthTableView scrollToRowAtIndexPath:indexPat atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }else{
                self.noView.hidden = NO;
            }
                
                
           
            
        }
    } failureBlock:^(NSError *error) {
        [self hudWasHidden];
        [self showAlertWarmMessage:requestErrorMessage];
    }];
    [self.healthTableView.mj_header endRefreshing];

}

- (void)requestHealthHintDataLoadingWithString:(NSString *)string{
    [self showHUD];
    NSString *aUrlle = [NSString string];
    if ([GlobalCommon stringEqualNull:string]) {
        aUrlle = [NSString stringWithFormat:@"/article/healthArticleList.jhtml?pageNumber=%ld",(long)self.pageInteger];
    }else{
        aUrlle= [NSString stringWithFormat:@"/article/healthListByCategory/%@.jhtml?pageNumber=%ld",string,(long)self.pageInteger];
        aUrlle = [aUrlle stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    }
    
    
    
    [[NetworkManager sharedNetworkManager] requestWithType:BAHttpRequestTypeHeadGet urlString:aUrlle parameters:nil successBlock:^(id response) {
        
        [self hudWasHidden];
        NSLog(@"%@",response);
        if ([response[@"status"] integerValue] == 100){
            
             [self.healthArray addObjectsFromArray:[[response valueForKey:@"data"] valueForKey:@"content"]];
//            for (NSDictionary *dic  in [[response valueForKey:@"data"] valueForKey:@"content"]) {
//                [self.healthArray addObject:dic];
//            }
            
            [self.healthTableView reloadData];
            
        }
    } failureBlock:^(NSError *error) {
        [self hudWasHidden];
        [self showAlertWarmMessage:requestErrorMessage];
    }];
    [self.healthTableView.mj_footer endRefreshing];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.healthArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    InformationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InformationCell"];
    if(cell == nil){
        cell = [[InformationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InformationCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if(self.healthArray.count > indexPath.row){
        ArticleModel *model = [self.healthArray objectAtIndex:indexPath.row];
        [cell setDataWithModel:model];
    }
    
    /*
    static NSString *CellIdentifier = @"LeMedicineCell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1
                                          reuseIdentifier:CellIdentifier];
            cell.backgroundColor=[UIColor whiteColor];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
        }
        else
        {
            while ([cell.contentView.subviews lastObject] != nil)
            {
                
                [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
            }

    }
        UIImageView *hotImage = [[UIImageView alloc]initWithFrame:CGRectMake(17, 7, 80, 70)];

        [hotImage sd_setImageWithURL:[NSURL URLWithString:[self.healthArray[indexPath.row]objectForKey:@"picture"]]];
        [cell addSubview:hotImage];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(118, 15, self.view.frame.size.width - 135, 15)];
        titleLabel.textColor = [UtilityFunc colorWithHexString:@"#4b4a4a"];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.text = [self.healthArray[indexPath.row]objectForKey:@"title"];
        [cell addSubview:titleLabel];
        
        UILabel *hotLabel = [[UILabel alloc]initWithFrame:CGRectMake(118, 42, self.view.frame.size.width - 135, 15)];
        hotLabel.font = [UIFont systemFontOfSize:11];
        hotLabel.textColor = [UtilityFunc colorWithHexString:@"#838383"];
        if ([[self.healthArray[indexPath.row]objectForKey:@"seoDescription"]isEqual:[NSNull null]]) {
            hotLabel.text = [self.healthArray[indexPath.row]objectForKey:@"title"];
        }else{
        hotLabel.text = [self.healthArray[indexPath.row]objectForKey:@"seoDescription"];
        }
        [cell addSubview:hotLabel];
        NSDate *data = [[NSDate alloc]initWithTimeIntervalSince1970:[[self.healthArray[indexPath.row]objectForKey:@"createDate" ] doubleValue]/1000.00];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [formatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];//location设置为中国
        
        NSString *confromTimespStr = [formatter stringFromDate:data];
        
        
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 217, 60, 200, 15)];
        timeLabel.textAlignment = NSTextAlignmentRight;
        timeLabel.textColor = [UtilityFunc colorWithHexString:@"#666666"];
        timeLabel.font = [UIFont systemFontOfSize:9];
        timeLabel.text = confromTimespStr;
        [cell addSubview:timeLabel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        */
        
        
        return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HeChangPackgeController *vc = [[HeChangPackgeController alloc] init];
    vc.titleStr = ModuleZW(@"健康资讯");
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",URL_PRE,[self.healthArray[indexPath.row] objectForKey:@"path"]];
    vc.urlStr = urlStr;
    [self.navigationController pushViewController:vc animated:YES];
    
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
    
    [progress_ removeFromSuperview];
    
    progress_ = nil;
    
}


@end
