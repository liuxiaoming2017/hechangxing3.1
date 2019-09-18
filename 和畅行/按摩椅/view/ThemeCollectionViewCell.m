//
//  ThemeCollectionViewCell.m
//  和畅行
//
//  Created by 刘晓明 on 2019/9/10.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "ThemeCollectionViewCell.h"
#import "SublayerView.h"
#import "ArmChairModel.h"

#define cellW 108
#define themeCellMargin (ScreenWidth-cellW*3)/4.0

@implementation ThemeCollectionViewCell

- (void)reloadDataWithArray:(NSArray *)array
{
    
    
    for(NSInteger i = 0;i<array.count;i++){

        ArmChairModel *model = [array objectAtIndex:i];
        NSInteger column = i / 3;
        NSInteger row = i % 3;
        SublayerView *layerView = [[SublayerView alloc] initWithFrame:CGRectMake(themeCellMargin+(108+themeCellMargin)*row, themeCellMargin + (115+themeCellMargin)*column, cellW, 115)];
        [layerView setImageVandTitleLabelwithModel:model];
        layerView.tag = 100 + i;
        [self addSubview:layerView];
        
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [layerView addGestureRecognizer:tapGesture];
    }
}

- (void)tapAction:(UITapGestureRecognizer *)gesture
{
    SublayerView *hh = (SublayerView *)[gesture view];
    if([self.delegate respondsToSelector:@selector(selectTackWithModel:)]){
        [self.delegate selectTackWithModel:hh.model];
    }
}

@end
