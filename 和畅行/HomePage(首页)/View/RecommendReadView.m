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
#import "VersionUpdateView.h"

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
    titleLabel.text = ModuleZW(@"推荐阅读");
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didBecomeActiveNotification)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];

    
}




- (void)requestHealthHintData
{
    __weak typeof(self) weakSelf = self;
    
    NSString *aUrlle=@"/article/healthArticleList.jhtml?pageNumber=1";
    //NSString *aUrlle=@"/article/healthArticleList.jhtml";
    
    [[NetworkManager sharedNetworkManager] requestWithType:BAHttpRequestTypeHeadGet urlString:aUrlle parameters:nil successBlock:^(id response) {
        
        NSLog(@"%@",response);
        if ([response[@"status"] integerValue] == 100){
            
            for (NSDictionary *dic in [[response valueForKey:@"data"] valueForKey:@"content"]) {
                HCY_ConsultingModel *tipModel = [[HCY_ConsultingModel alloc] init];
                [tipModel yy_modelSetWithJSON:dic];
                [weakSelf.recommendArr addObject:tipModel];
            }
            [weakSelf.collectionV reloadData];
            
//            for (NSDictionary *dic in [response valueForKey:@"data"] ) {
//                HCY_ConsultingModel *tipModel = [[HCY_ConsultingModel alloc] init];
//                [tipModel yy_modelSetWithJSON:dic];
//                [weakSelf.recommendArr addObject:tipModel];
//            }
//            [weakSelf.collectionV reloadData];
        
        }
        [weakSelf checkHaveUpdate];

    } failureBlock:^(NSError *error) {
        NSLog(@"%@",error);
        [weakSelf checkHaveUpdate];
        [weakSelf showAlertWarmMessage:requestErrorMessage];
    }];
    

}


-(void)moreAction {
    
    InformationViewController *vc = [[InformationViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
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
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:ModuleZW(@"提示") message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAct1 = [UIAlertAction actionWithTitle:ModuleZW(@"确定") style:UIAlertActionStyleCancel handler:NULL];
    [alertVC addAction:alertAct1];
    [[self viewController] presentViewController:alertVC animated:YES completion:NULL];
}


- (void)tapGesture:(UITapGestureRecognizer *)tap
{
    
}


-(void)didBecomeActiveNotification{
    [self checkHaveUpdate];
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

# pragma mark - 检查更新
- (void)checkHaveUpdate
{
    //ios_hcy-oem-1.0 hcy_android_oem-oem-1.0
    NSString *nowVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *headStr = [NSString stringWithFormat:@"ios_hcy-oem-%@",nowVersion];
    //headStr = @"hcy_android_oem-oem-1.0";
    //为网络请求添加请求头
    NSDictionary *headDic = @{@"version":headStr,@"token":[UserShareOnce shareOnce].token,@"Cookie":[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]};
    
    __weak typeof(self) weakSelf = self;
    
    [[NetworkManager sharedNetworkManager] requestWithType:0 urlString:@"versions_update/updateVersion.jhtml" headParameters:headDic parameters:nil successBlock:^(id response2) {
        NSError *error = NULL;
        id response = [NSJSONSerialization JSONObjectWithData:response2 options:0 error:&error];
        if([[response objectForKey:@"status"] intValue] == 100){
            NSDictionary *dic = [response objectForKey:@"data"];
            NSInteger isUpdate = [[dic objectForKey:@"isUpdate"] integerValue];
            if(isUpdate == 1){
                
                NSString *downUrl = @"https://itunes.apple.com/cn/app/id1440487968";
                if([[UserShareOnce shareOnce].username isEqualToString:@"13665541112"] || [[UserShareOnce shareOnce].username isEqualToString:@"18163865881"]){
                    return ;
                }
                NSString *ytpeStr = [NSString stringWithFormat:@"%@",dic[@"isEnforcement"]];
//                [weakSelf showUpdateView:downUrl contentStr:dic[@"releaseContent"] typeStr:ytpeStr];
                
                NSLog(@"升级了");
            }else{
                
            }
        }
        
        NSLog(@"haha:%@",response);
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)showUpdateView:(NSString *)downUrl contentStr:(NSString *)contentStr typeStr:(NSString *)typeStr
{
    
    [GlobalCommon addMaskView];
    VersionUpdateView *updateView = [VersionUpdateView versionUpdateViewWithContent:contentStr type:typeStr];
    __weak __typeof(updateView)wupdateView = updateView;
    updateView.versionUpdateBlock = ^(BOOL isUpdate){
        
        if(isUpdate){
            NSURL *url = [NSURL URLWithString:downUrl];
            if (url) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
        
        [GlobalCommon removeMaskView];
        [wupdateView removeFromSuperview];
    };
    [[UIApplication sharedApplication].keyWindow addSubview:updateView];
    
}

@end
