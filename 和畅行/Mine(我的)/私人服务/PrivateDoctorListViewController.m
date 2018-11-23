//
//  PrivateDoctorListViewController.m
//  Voicediagno
//
//  Created by ZhangYunguang on 15/11/27.
//  Copyright © 2015年 ZhangYunguang. All rights reserved.
//

#import "PrivateDoctorListViewController.h"
#import "SelectedAdvisorModel.h"
#import "UIImageView+WebCache.h"
#import "PrivateCheckViewController.h"
//#import "JHRefresh.h"

#define kDOCTOR_LIST @"/member/healthAdvisor/healthAdvisorList.jhtml?categoryId=%@&pageNum=%d"
#define kCELL_REUSED @"collectionCell"

@interface PrivateDoctorListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView;
    NSMutableArray *_dataArr;
    int _currentPage;
    int _totalPages;
    BOOL _isLoadMore;
}
@property (nonatomic,retain) UICollectionView *collectionView;
@property (nonatomic,retain) NSMutableArray *dataArr;
@property (nonatomic,assign) int currentPage;
@end

@implementation PrivateDoctorListViewController

- (void)dealloc
{
    [self.collectionView release];
    [self.dataArr release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navTitleLabel.text = @"医生列表";
    
    [self initData];
    [self initWithController];
    
}
-(void)backClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initData{
    self.dataArr = [[NSMutableArray alloc] init];
    _currentPage = 1;
    _isLoadMore = NO;
    [ZYGASINetworking GET_Path:[NSString stringWithFormat:kDOCTOR_LIST,self.categoryId,_currentPage] completed:^(id JSON, NSString *stringData) {
        NSLog(@"私人医生数据请求成功：%@",JSON);
        NSDictionary *data = JSON[@"data"];
        _totalPages = [data[@"pageNumber"] intValue];
        NSArray *content = data[@"content"];
        for (NSDictionary *dic in content) {
            SelectedAdvisorModel *model = [[SelectedAdvisorModel alloc] init];
            //[model setValuesForKeysWithDictionary:dic];
            model.id = dic[@"id"];
            model.order = dic[@"order"];
            model.name = dic[@"name"];
            model.gender = dic[@"gender"];
            model.graduated = dic[@"graduated"];
            model.rank = dic[@"rank"];
            model.skill = dic[@"skill"];
            model.image = dic[@"image"];
            [self.dataArr addObject:model];
            [model release];
        }
        [self.collectionView reloadData];
    } failed:^(NSError *error) {
        NSLog(@"私人医生数据请求失败");
    }];
}
#pragma mark -- 下拉刷新和上拉加载更多
/*
-(void)createRefresh{
    __block typeof(self)weakSelf = self;
    [_collectionView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (_isLoadMore) {
            return ;
        }
        _isLoadMore = YES;
        if (_currentPage<_totalPages) {
            _currentPage ++;
            [ZYGASINetworking GET_Path:[NSString stringWithFormat:kDOCTOR_LIST,weakSelf.categoryId,_currentPage] completed:^(id JSON, NSString *stringData) {
                [self endRefreshing];
                NSLog(@"私人医生数据请求成功：%@",JSON);
                NSDictionary *data = JSON[@"data"];
                _totalPages = [data[@"pageNumber"] intValue];
                NSArray *content = data[@"content"];
                for (NSDictionary *dic in content) {
                    SelectedAdvisorModel *model = [[SelectedAdvisorModel alloc] init];
                    //[model setValuesForKeysWithDictionary:dic];
                    model.id = dic[@"id"];
                    model.order = dic[@"order"];
                    model.name = dic[@"name"];
                    model.gender = dic[@"gender"];
                    model.graduated = dic[@"graduated"];
                    model.rank = dic[@"rank"];
                    model.skill = dic[@"skill"];
                    model.image = dic[@"image"];
                    [self.dataArr addObject:model];
                    [model release];
                }
                [self.collectionView reloadData];
                
            } failed:^(NSError *error) {
                [self endRefreshing];
                NSLog(@"私人医生数据请求失败");
            }];
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
            hud.removeFromSuperViewOnHide =YES;
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"数据已全部加载";
            hud.minSize = CGSizeMake(132.f, 108.0f);
            [hud hide:YES afterDelay:2];
            [weakSelf endRefreshing];
        }
        
    }];
    
}
*/


-(void)endRefreshing{
    if (_isLoadMore) {
        _isLoadMore = NO;
        [_collectionView footerEndRefreshing];
    }
}
-(void)initWithController{
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 69, ScreenWidth, 42)];
    view.backgroundColor = [Tools colorWithHexString:@"#efeff4"];
    [self.view addSubview:view];
    
    UILabel *starLabel = [Tools labelWith:@"星级：" frame:CGRectMake(20, 14, 45, 14) textSize:12 textColor:[Tools colorWithHexString:@"#666666"] lines:1 aligment:NSTextAlignmentLeft];
    [view addSubview:starLabel];
    
    
    for (int i=0; i<5; i++) {
        UIImageView *darkStar = [Tools creatImageViewWithFrame:CGRectMake(60+15*i, 14, 10, 10) imageName:@"星星_未点亮"];
        [view addSubview:darkStar];
    }
    if (self.userlLevel != nil || ![self.userlLevel isKindOfClass:[NSNull class]]) {
        int level = self.userlLevel.intValue;
        for (int j=0; j<level; j++) {
            UIImageView *lightStar = [Tools creatImageViewWithFrame:CGRectMake(60+15*j, 14, 10, 10) imageName:@"星星_点亮"];
            [view addSubview:lightStar];
        }
    }
    
    [view release];
    
    //创建collectionView
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 111, ScreenWidth, ScreenHeight-111) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.alwaysBounceVertical = YES;
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCELL_REUSED];
   // [self createRefresh];
}
#pragma mark-UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.dataArr.count) {
        return self.dataArr.count;
    }
    return 0;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCELL_REUSED forIndexPath:indexPath];
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    UIImageView *backImage = [Tools creatImageViewWithFrame:cell.frame imageName:@"私人医生_医生背景"];
    [cell.contentView addSubview:backImage];
    UIImageView *iconImage = [Tools creatImageViewWithFrame:CGRectMake(5, 5, cell.frame.size.width-10, 60) imageName:@"私人医生_医生图标"];
    [backImage addSubview:iconImage];
    SelectedAdvisorModel *model = self.dataArr[indexPath.row];
    if (![model.image isKindOfClass:[NSNull class]]) {
        [iconImage sd_setImageWithURL:[NSURL URLWithString:model.image]];
    }
    UILabel *nameLabel = [Tools labelWith:model.name frame:CGRectMake(5, 66, iconImage.frame.size.width-10, 20) textSize:12 textColor:[Tools colorWithHexString:@"#333333"] lines:1 aligment:NSTextAlignmentCenter];
    [backImage addSubview:nameLabel];
    if (![model.rank isKindOfClass:[NSNull class]]) {
        UILabel *levelLabel = [Tools labelWith: model.rank frame:CGRectMake(5, 86, iconImage.frame.size.width-10, 20) textSize:11 textColor:[Tools colorWithHexString:@"#333333"] lines:1 aligment:NSTextAlignmentCenter];
        [backImage addSubview:levelLabel];
    }
    [cell sizeToFit];
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((ScreenWidth-20*4)/3, 106);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 5, 5, 5);
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 20;
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PrivateCheckViewController *check = [[PrivateCheckViewController alloc] init];
    SelectedAdvisorModel *selectedModel = self.dataArr[indexPath.row];
    check.model = selectedModel;
    check.category = @"add";
    [self.navigationController pushViewController:check animated:YES];
    [check release];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
