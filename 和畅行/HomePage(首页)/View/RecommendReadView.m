//
//  RecommendReadView.m
//  Voicediagno
//
//  Created by 刘晓明 on 2018/4/24.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "RecommendReadView.h"
#import "RecommendCollectCell.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "InformationDedailssViewController.h"
#import "UIImageView+WebCache.h"
#import "NSObject+SBJson.h"
#import "WKWebController.h"
#import "InformationViewController.h"
#import "HCY_ConsultingModel.h"
#import "XZMRefresh.h"

@interface RecommendReadView()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) UICollectionView *collectionV;

@end

@implementation RecommendReadView




- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.backgroundColor = UIColorFromHex(0xFFFFFF);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, 15, 200, 25)];
    //titleLabel.textColor = UIColorFromHex(0x7D7D7D);
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.text = @"推荐阅读";
    [self addSubview:titleLabel];
    
    UIButton *moreButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    moreButton.frame = CGRectMake(self.width - 90, 15, 90, 20);
    [moreButton setImage:[UIImage imageNamed:@"HCY_right"] forState:(UIControlStateNormal)];
    [moreButton addTarget:self action:@selector(moreAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:moreButton];
    
    CGFloat width = (ScreenWidth - 23 - 10)/2.5;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(width, width*0.62+7+40);
    //layout.itemSize = CGSizeMake(130, 106);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 10);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.recommendArr = [NSMutableArray array];
    
    self.collectionV= [[UICollectionView alloc] initWithFrame:CGRectMake(23, 40+10, self.bounds.size.width-23*2, layout.itemSize.height) collectionViewLayout:layout];
    self.collectionV.delegate = self;
    self.collectionV.dataSource = self;
    self.collectionV.showsHorizontalScrollIndicator = NO;
    self.collectionV.backgroundColor = [UIColor clearColor];
    
    
    
    [self.collectionV registerClass:[RecommendCollectCell class] forCellWithReuseIdentifier:@"cellId"];
    
    [self addSubview:self.collectionV];
    [self requestHealthHintData];
    

}




- (void)requestHealthHintData
{
    __weak typeof(self) weakSelf = self;
    
  NSString *aUrlle=@"/article/healthArticleList.jhtml?pageNumber=1";
    
    [[NetworkManager sharedNetworkManager] requestWithType:0 urlString:aUrlle parameters:nil successBlock:^(id response) {
        
        NSLog(@"%@",response);
        if ([response[@"status"] integerValue] == 100){
            
            for (NSDictionary *dic in [[response valueForKey:@"data"] valueForKey:@"content"]) {
                HCY_ConsultingModel *tipModel = [[HCY_ConsultingModel alloc] init];
                [tipModel yy_modelSetWithJSON:dic];
                [weakSelf.recommendArr addObject:tipModel];
            }
            [weakSelf.collectionV reloadData];
        
        }
      

    } failureBlock:^(NSError *error) {
        NSLog(@"%@",error);
        [weakSelf showAlertWarmMessage:requestErrorMessage];
    }];
    

}

-(void)moreAction {
    
    InformationViewController *vc = [[InformationViewController alloc] init];
    [[self viewController].navigationController pushViewController:vc animated:YES];
    
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.recommendArr count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HCY_ConsultingModel *tipModel = self.recommendArr[indexPath.row];
    RecommendCollectCell *cell = (RecommendCollectCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    cell.imageV.hidden = NO;
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:tipModel.picture]];
    cell.titleLabel.text = tipModel.title;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //InformationDedailssViewController *vc = [[InformationDedailssViewController alloc] init];
    HCY_ConsultingModel *tipModel = self.recommendArr[indexPath.row];
    WKWebController *vc = [[WKWebController alloc] init];
    vc.titleStr =tipModel.title;
    vc.dataStr = tipModel.path;
    vc.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

- (void)showAlertWarmMessage:(NSString *)message
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAct1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:NULL];
    [alertVC addAction:alertAct1];
    [[self viewController] presentViewController:alertVC animated:YES completion:NULL];
}


- (void)tapGesture:(UITapGestureRecognizer *)tap
{
    
}

@end
