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
@property (nonatomic,strong) UIScrollView *bgScrollView;

@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation ArmchairHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(14,kNavBarHeight+20,107.5,115);
    
    view.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    view.layer.cornerRadius = 8;
    [self.bgScrollView addSubview:view];
    
    [self createBottomView];
    
}

- (void)initUI
{
    self.preBtn.hidden = NO;
    self.leftBtn.hidden = YES;
    self.navTitleLabel.text = @"按摩椅";
    
    if (!self.bgScrollView){
        self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, ScreenWidth, ScreenHeight-kNavBarHeight)];
        self.bgScrollView.showsVerticalScrollIndicator = NO;
        
        self.bgScrollView.backgroundColor = [UIColor whiteColor];
        self.bgScrollView.bounces = YES;
        self.bgScrollView.contentSize = CGSizeMake(1, ScreenHeight-kNavBarHeight);
        [self.view addSubview:self.bgScrollView];
    }
}

- (void)createBottomView
{
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.frame = CGRectMake(140.5,109,240.5+15,115);
    label1.numberOfLines = 0;
    [self.bgScrollView addSubview:label1];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.lineSpacing = 5;
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"1、鉴于您体质检测为上宫；\n2、鉴于您酸痛检测为100；\n3、我们建议您用这个按摩手法。"attributes: @{NSFontAttributeName: [UIFont systemFontOfSize:15],NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0],NSParagraphStyleAttributeName:paragraphStyle.copy}];
    
    label1.attributedText = string;
    label1.textAlignment = NSTextAlignmentLeft;
    label1.alpha = 1.0;
    
    
    CGFloat margin = ((ScreenWidth-107*3)/4.0);
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(margin,kNavBarHeight+100,120,24);
    label.font = [UIFont systemFontOfSize:16];
    label.text = @"按摩手法";
    label.textAlignment = NSTextAlignmentLeft;
    label.alpha = 1.0;
    [self.bgScrollView addSubview:label];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(107+margin, 111+margin);
    //layout.itemSize = CGSizeMake(130, 106);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionV= [[UICollectionView alloc] initWithFrame:CGRectMake(margin/2.0,label.bottom+10, ScreenWidth-margin, 125*4) collectionViewLayout:layout];
    self.collectionV.delegate = self;
    self.collectionV.dataSource = self;
    self.collectionV.showsHorizontalScrollIndicator = NO;
    self.collectionV.backgroundColor = [UIColor clearColor];
    self.collectionV.scrollEnabled = NO;
    
    [self.collectionV registerClass:[ArmchairHomeCell class] forCellWithReuseIdentifier:@"cellId"];
    
    [self.bgScrollView addSubview:self.collectionV];
    
    self.bgScrollView.contentSize = CGSizeMake(1, self.collectionV.bottom+10);
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
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
