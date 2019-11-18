//
//  InformationController.m
//  Voicediagno
//
//  Created by 刘晓明 on 2018/5/18.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "InformationController.h"
#import "HYSegmentedControl.h"
#import "InformationCell.h"
#import "ArticleModel.h"
#import "InformationDedailssViewController.h"
#import "WKWebController.h"

@interface InformationController ()<UITableViewDelegate,UITableViewDataSource,HYSegmentedControlDelegate>

@property (nonatomic,strong) UIScrollView *bgScrollView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) HYSegmentedControl *headSegment;
@property (nonatomic,strong) NSArray *articleArr;
@property (nonatomic,strong) NSMutableArray *idArr;

@end

@implementation InformationController

@synthesize headSegment,articleArr,bgScrollView,idArr;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleLabel.text = @"meridians";
    self.idArr = [NSMutableArray arrayWithCapacity:0];
    [self requestParameterData];

}

- (void)createUIwithArr:(NSArray *)nameArr
{
    headSegment = [[HYSegmentedControl alloc] initWithOriginY:kNavBarHeight Titles:nameArr delegate:self];
    [headSegment setBtnorline:nameArr];
    [self.view addSubview:headSegment];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, headSegment.bottom, ScreenWidth, ScreenHeight-headSegment.bottom) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    [self hySegmentedControlSelectAtIndex:0];
}

#pragma mark - 获取请求文章列表的参数
- (void)requestParameterData
{
    NSString *UrlPre=URL_PRE;
    
    NSString *aUrlle= [NSString stringWithFormat:@"%@/article/healthCategoryList.jhtml",UrlPre];
    aUrlle = [aUrlle stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSDictionary *headDic = [NSDictionary dictionaryWithObject:@"ios_jlsl-yh-3" forKey:@"version"];
    
    __weak typeof(self) bself = self;
    
    [[NetworkManager sharedNetworkManager] requestWithCookieType:0 urlString:aUrlle headParameters:headDic parameters:nil successBlock:^(id result) {
        id status=[result objectForKey:@"status"];
        
        if ([status intValue] == 100)
        {
            NSMutableArray *nameArr = [NSMutableArray arrayWithCapacity:0];
            
            [nameArr addObject:@"热点"];
            
            [self->idArr addObject:@"hot"];
            NSArray *array = [result objectForKey:@"data"];
            if(array.count>0){
                for(NSDictionary *dic in array){
                    NSString *name = [dic objectForKey:@"name"];
                    [self->idArr addObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]];
                    
                    [nameArr addObject:name];
                    
                    
                }
            }
            [bself createUIwithArr:nameArr];
            
        }else{
            [bself showAlertWarmMessage:[result objectForKey:@"data"]];
        }
    } failureBlock:^(NSError *error) {
        [bself showAlertWarmMessage:requestErrorMessage];
    }];
    
}

#pragma mark - 请求文章数据
- (void)requestArticleDataWithUrl:(NSString *)urlStr
{
    NSDictionary *headDic = [NSDictionary dictionaryWithObject:@"ios_jlsl-yh-3" forKey:@"version"];
    
    __weak typeof(self) bself = self;
    
    [[NetworkManager sharedNetworkManager] requestWithType:0 urlString:urlStr parameters:nil successBlock:^(id result) {
        id status=[result objectForKey:@"status"];
        
        if ([status intValue] == 100)
        {
            NSArray *arr = [result objectForKey:@"data"];
            bself.articleArr = [ArticleModel articlesFromArray:arr];
            [bself.tableView reloadData];
        }else if ([status intValue]==44){
            [bself showAlertWarmMessage:@"登录超时，请重新登录"];
        }
        else{
            [bself showAlertWarmMessage:[result objectForKey:@"data"]];
        }
    } failureBlock:^(NSError *error) {
        [bself showAlertWarmMessage:requestErrorMessage];
    }];
    
    
}

#pragma mark - segmentDelegate
- (void)hySegmentedControlSelectAtIndex:(NSInteger)index
{
    
    NSString *urlStr= @"";
    if(index == 0){
        urlStr = [NSString stringWithFormat:@"%@/article/healthArticleList.jhtml",URL_PRE];
    }else{
        NSString *idStr = [idArr objectAtIndex:index];
        urlStr = [NSString stringWithFormat:@"%@/article/healthListByCategory/%@.jhtml",URL_PRE,idStr];
    }
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self requestArticleDataWithUrl:urlStr];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.articleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InformationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InformationCell"];
    if(cell == nil){
        cell = [[InformationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InformationCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if(self.articleArr.count > indexPath.row){
        ArticleModel *model = [self.articleArr objectAtIndex:indexPath.row];
        [cell setDataWithModel:model];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    InformationDedailssViewController *vc = [[InformationDedailssViewController alloc] init];
    WKWebController *vc = [[WKWebController alloc] init];
    ArticleModel *model = [self.articleArr objectAtIndex:indexPath.row];
    vc.titleStr = model.title;
    vc.dataStr = model.path;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
