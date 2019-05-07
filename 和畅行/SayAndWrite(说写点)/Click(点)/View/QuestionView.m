//
//  QuestionView.m
//  和畅行
//
//  Created by 刘晓明 on 2018/7/12.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "QuestionView.h"

@interface QuestionView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionV;

@end

@implementation QuestionView
@synthesize collectionV;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        
    }
    return self;
}

- (void)initUI
{
    
}

- (void)createUI
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(ScreenWidth, ScreenHeight-kNavBarHeight);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    collectionV= [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, ScreenWidth, layout.itemSize.height) collectionViewLayout:layout];
    collectionV.delegate = self;
    collectionV.dataSource = self;
    collectionV.showsHorizontalScrollIndicator = NO;
    collectionV.backgroundColor = [UIColor clearColor];
    collectionV.pagingEnabled = YES;
    
    //[collectionV registerClass:[MySportCell class] forCellWithReuseIdentifier:@"cellId"];
    
    [self addSubview:collectionV];
    
    [collectionV reloadData];
}
@end
