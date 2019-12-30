//
//  IjoouCollectionCell.h
//  HarmonyYi
//
//  Created by Wei Zhao on 2019/12/11.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QQBatteryView.h"
NS_ASSUME_NONNULL_BEGIN
typedef void  (^SelectedBlock)(void);
@interface IjoouCollectionCell : UICollectionViewCell
@property (nonatomic,copy)SelectedBlock selectedBlock;
@property (nonatomic,strong) UIImageView *imageV;
@property (nonatomic,strong) QQBatteryView *voltameterView;
@property (nonatomic,strong) UILabel *titleLabel1;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *temperatureLabel;
@property (nonatomic,strong) UIButton *selectedBT;
@property (nonatomic,strong) CALayer *subLayer;
@end

NS_ASSUME_NONNULL_END
