//
//  ArmchairHomeVC.m
//  和畅行
//
//  Created by 刘晓明 on 2019/9/2.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "ArmchairHomeVC.h"
#import "ArmchairHomeCell.h"

@interface ArmchairHomeVC ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) UICollectionView *collectionV;

@end

@implementation ArmchairHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(100, 125);
    //layout.itemSize = CGSizeMake(130, 106);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 10);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionV= [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, ScreenWidth, ScreenHeight-kNavBarHeight) collectionViewLayout:layout];
    self.collectionV.delegate = self;
    self.collectionV.dataSource = self;
    self.collectionV.showsHorizontalScrollIndicator = NO;
    self.collectionV.backgroundColor = [UIColor clearColor];
    
    
    
    [self.collectionV registerClass:[ArmchairHomeCell class] forCellWithReuseIdentifier:@"cellId"];
    
    [self.view addSubview:self.collectionV];
    
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 30;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ArmchairHomeCell *cell = (ArmchairHomeCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    cell.imageV.image = [UIImage imageNamed:@"一写"];
    cell.titleLabel.text = @"哈哈哈哈";
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //InformationDedailssViewController *vc = [[InformationDedailssViewController alloc] init];
    
}


@end
