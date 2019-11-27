//
//  OGA730BThemeVC.m
//  和畅行
//
//  Created by 刘晓明 on 2019/11/18.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "OGA730BThemeVC.h"
#import "ArmChairModel.h"
#import "ArmchairHomeCell.h"

#import "OGA730BDetailVC.h"

@interface OGA730BThemeVC ()<UICollectionViewDelegate,UICollectionViewDataSource,MBProgressHUDDelegate>

@property (nonatomic,strong) UICollectionView *collectionV;
@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic, strong) OGASubscribe_730B *subscribe;

@end

@implementation OGA730BThemeVC

- (void)dealloc
{
    self.collectionV = nil;
    self.dataArr = nil;
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
    [[OGABluetoothManager_730B shareInstance] removeSubscribe:self.subscribe];
    self.subscribe = nil;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArr = [self loadMoreProgramsData];
    CGFloat cellWithW;
    if (ISPaid) {
        cellWithW = (ScreenWidth - Adapter(50))/4;
    }else{
        cellWithW = (ScreenWidth - Adapter(40))/3;
    }
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(cellWithW, cellWithW);
    layout.sectionInset = UIEdgeInsetsMake(Adapter(10), Adapter(10), Adapter(10), Adapter(10));
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionV= [[UICollectionView alloc] initWithFrame:CGRectMake(0,kNavBarHeight+Adapter(10), ScreenWidth, ScreenHeight-kNavBarHeight-Adapter(10)) collectionViewLayout:layout];
    self.collectionV.delegate = self;
    self.collectionV.dataSource = self;
    self.collectionV.showsHorizontalScrollIndicator = NO;
    self.collectionV.pagingEnabled = YES;
    self.collectionV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.collectionV];
    
    [self.collectionV registerClass:[ArmchairHomeCell class] forCellWithReuseIdentifier:@"cellId"];
    
}

- (void)viewDidAppear:(BOOL)animated;
{
    [super viewDidAppear:animated];
    if(!self.subscribe){
        __weak typeof(self) weakSelf = self;
        self.subscribe = [[OGASubscribe_730B alloc] init];
        [[OGABluetoothManager_730B shareInstance] addSubscribe:self.subscribe];
        
        [self.subscribe setRespondBlock:^(OGARespond_730B * _Nonnull respond) {
            [weakSelf didUpdateValueForChair:respond];
        }];
        
    }
}

- (void)didUpdateValueForChair:(OGARespond_730B *)respond {
    
    self.rightBtn.selected = [self chairPowerOnWithRespond:respond];
    
}

- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return Adapter(10);
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ArmchairHomeCell *cell = (ArmchairHomeCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    ArmChairModel *model = [self.dataArr objectAtIndex:indexPath.row];
    cell.imageV.image = [UIImage imageNamed:model.name];
    if([model.name isEqualToString:@"Neck&Shoulder"]){
        cell.titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:14*1.6];
    }
    cell.titleLabel.text = model.name;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ArmChairModel *model = [self.dataArr objectAtIndex:indexPath.row];
    
   
        NSString *statusStr = [self resultStringWithStatus];
    
        if(![statusStr isEqualToString:@""]){
            [GlobalCommon showMessage2:statusStr duration2:1.0];
            return;
        }else{
            self.armchairModel = model;
            
            if([self chairIsPowerOn] == NO){
                
                [self showProgressHud];
                
                [[OGABluetoothManager_730B shareInstance] sendShortCommand:k730Command_PowerOn success:^(BOOL success) {
                    NSLog(@"启动设备成功啦");
                }];
            }else{
                NSLog(@"开机了开机了");
                [self nextVCWithModel:model];
            }
        }
    
}

- (void)nextVCWithModel:(ArmChairModel *)model
{
        OGA730BDetailVC *vc = [[OGA730BDetailVC alloc] initWithType:NO withTitleStr:model.name];
        vc.armchairModel = model;
        [vc commandActionWithModel:model];
        [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)showProgressHud
{
    MBProgressHUD *progressHud = [[MBProgressHUD alloc] initWithView:[[UIApplication sharedApplication] keyWindow]];
    progressHud.label.text = startDevice;
    progressHud.tag = 102;
    [[[UIApplication sharedApplication] keyWindow] addSubview:progressHud];
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:progressHud];
    progressHud.delegate = self;
    [progressHud showAnimated:YES];
    [progressHud hideAnimated:YES afterDelay:4.0];
    
}

# pragma mark - 提示框自动消失方法
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    hud = nil;
    if([self chairIsPowerOn] == YES){
        
        [self nextVCWithModel:self.armchairModel];
        
    }
}
@end
