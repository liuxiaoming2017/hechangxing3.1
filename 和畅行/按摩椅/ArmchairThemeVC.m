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

@interface ArmchairThemeVC ()<UIScrollViewDelegate,GLYPageViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, assign) CGFloat      startOffsetX;
@property (nonatomic ,strong) GLYPageView  *pageView;
@property (nonatomic ,strong) UIScrollView *contentScrollView;

@property (nonatomic,strong) UICollectionView *collectionV;
@property (nonatomic,strong) NSArray *dataArr;
@end

@implementation ArmchairThemeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.preBtn.hidden = NO;
    self.leftBtn.hidden = YES;
    self.navTitleLabel.text = @"按摩椅";
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"armChair" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    NSMutableArray *mutableArr = [NSMutableArray arrayWithCapacity:0];
    NSArray *titleArr = @[@"专属",@"主题",@"区域",@"功效",@"场景"];
    for(NSString *key in titleArr){
        NSArray *arr = [dic objectForKey:key];
        [mutableArr addObject:arr];
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
    
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.startOffsetX = scrollView.contentOffset.x;
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

@end
