//
//  HeChangPackge.h
//  和畅行
//
//  Created by 刘晓明 on 2018/7/9.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HCY_HomeImageModel.h"
@interface HeChangPackge : UIView

@property(nonatomic,strong) UILabel *contentLabel;
@property(nonatomic,strong) UIImageView *imageV;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *remindLabel;
@property(nonatomic,strong) UIButton *toViewButton ;
@property(nonatomic,strong) HCY_HomeImageModel *pushModel;

//- (void)changePackgeTypeWithStatus:(NSInteger)status;

-(void)changeBackImageWithStr:(NSString *)str;

- (void)changePackgeTypeWithStatus:(NSInteger)status withXingStr:(NSString *)xingStr;
@end
