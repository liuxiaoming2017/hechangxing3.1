//
//  ArmchairThemeVC.m
//  和畅行
//
//  Created by 刘晓明 on 2019/9/10.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "ArmchairThemeVC.h"
#import "GLYPageView.h"
#import "ThemeCollectionViewCell.h"
#import "ArmchairDetailVC.h"

@interface ArmchairThemeVC ()<UIScrollViewDelegate,GLYPageViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,ThemeCollectionCellDelegate,MBProgressHUDDelegate>

@property (nonatomic, assign) CGFloat      startOffsetX;
@property (nonatomic ,strong) GLYPageView  *pageView;
@property (nonatomic ,strong) UIScrollView *contentScrollView;

@property (nonatomic,strong) UICollectionView *collectionV;
@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic, strong) OGA530Subscribe *subscribe;
@end

@implementation ArmchairThemeVC

- (void)dealloc
{
    self.collectionV = nil;
    self.dataArr = nil;
    self.pageView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"armChair" ofType:@"plist"];
//    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    NSMutableArray *mutableArr = [NSMutableArray arrayWithCapacity:0];
    NSArray *titleArr = @[@"专属",@"主题",@"区域",@"功效",@"场景"];
    for(NSString *key in titleArr){
        NSArray *arr = [self loadDataPlistWithStr:key];
        NSArray *arr2 = [ArmChairModel mj_objectArrayWithKeyValuesArray:arr];
        [mutableArr addObject:arr2];
    }

    self.dataArr = [mutableArr copy];
    
   
    
    self.pageView = [[GLYPageView alloc] initWithFrame:CGRectMake(0.f, kNavBarHeight, ScreenWidth, 50.f) titlesArray:titleArr];
    self.pageView.delegate = self;
    [self.pageView initalUI];
    [self.view addSubview:self.pageView];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(ScreenWidth, ScreenHeight-kNavBarHeight-50);
    //layout.itemSize = CGSizeMake(130, 106);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionV= [[UICollectionView alloc] initWithFrame:CGRectMake(0,kNavBarHeight+50, ScreenWidth, ScreenHeight-kNavBarHeight-50) collectionViewLayout:layout];
    self.collectionV.delegate = self;
    self.collectionV.dataSource = self;
    self.collectionV.showsHorizontalScrollIndicator = NO;
    self.collectionV.pagingEnabled = YES;
    self.collectionV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.collectionV];
    [self.collectionV registerClass:[ThemeCollectionViewCell class] forCellWithReuseIdentifier:@"MCContent"];
    
    __weak typeof(self) weakSelf = self;
    self.subscribe = [[OGA530Subscribe alloc] init];
    [[OGA530BluetoothManager shareInstance] addSubscribe:self.subscribe];
    [self.subscribe setRespondBlock:^(OGA530Respond * _Nonnull respond) {
        
        [weakSelf didUpdateValueForChair:respond];
    }];
    
}

- (void)didUpdateValueForChair:(OGA530Respond *)respond {
    
    self.rightBtn.selected = respond.powerOn;
    
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.startOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.pageView externalScrollView:scrollView totalPage:5 startOffsetX:scrollView.contentOffset.x];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.pageView externalScrollView:scrollView totalPage:5 startOffsetX:self.startOffsetX];
}

#pragma mark GLYPageViewDelegate
- (void)pageViewSelectdIndex:(NSInteger)index
{
    [self.collectionV setContentOffset:CGPointMake(index * ScreenWidth, 0)];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"row:%ld",indexPath.row);
    ThemeCollectionViewCell *cell = (ThemeCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"MCContent" forIndexPath:indexPath];
    //复用会存在问题
    for(UIView *view in cell.subviews) {
        [view removeFromSuperview];
    }
    [cell reloadDataWithArray:[self.dataArr objectAtIndex:indexPath.row]];
    cell.delegate = self;
    cell.highlighted = NO;
    return cell;
}
//将要加载某个Item时调用的方法
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
//将要加载头尾视图时调用的方法
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    
}

# pragma mark - ThemeCollectionCellDelegate
- (void)selectTackWithModel:(ArmChairModel *)model
{
    NSLog(@"modelname:%@,***command:%@",model.name,model.command);
    
//    ArmchairDetailVC *vc = [[ArmchairDetailVC alloc] initWithType:NO withTitleStr:model.name];
//    vc.armchairModel = model;
//    [vc commandActionWithModel:model];
//    [self.navigationController pushViewController:vc animated:YES];
//    return;
    
    NSString *statusStr = [self resultStringWithStatus];
    if(![statusStr isEqualToString:@""]){
        [GlobalCommon showMessage2:statusStr duration2:1.0];
        return;
    }else{
        self.armchairModel = model;
        if([OGA530BluetoothManager shareInstance].respondModel.powerOn == NO){
            [self showProgressHud];
            [[OGA530BluetoothManager shareInstance] sendCommand:k530Command_PowerOn success:^(BOOL success) {

            }];
        }else{

            [self nexttoVCwithModel:model];
        }
    }
 
    
}

- (void)nexttoVCwithModel:(ArmChairModel *)model
{
    ArmchairDetailVC *vc = [[ArmchairDetailVC alloc] initWithType:NO withTitleStr:model.name];
    vc.armchairModel = model;
    [vc commandActionWithModel:model];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showProgressHud
{
    MBProgressHUD *progressHud = [[MBProgressHUD alloc] initWithView:[[UIApplication sharedApplication] keyWindow]];
    progressHud.label.text = @"启动设备";
    progressHud.tag = 102;
    [[[UIApplication sharedApplication] keyWindow] addSubview:progressHud];
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:progressHud];
    progressHud.delegate = self;
    [progressHud showAnimated:YES];
    [progressHud hideAnimated:YES afterDelay:6.0];
    
}

# pragma mark - 提示框自动消失方法
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    hud = nil;
    if([OGA530BluetoothManager shareInstance].respondModel.powerOn == YES){
        
        [self nexttoVCwithModel:self.armchairModel];
        
    }
}

@end
