//
//  RecommendReadView.h
//  Voicediagno
//
//  Created by 刘晓明 on 2018/4/24.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendReadView : UIView
@property (nonatomic,strong) NSMutableArray*recommendArr;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UICollectionView *collectionV;
@end
