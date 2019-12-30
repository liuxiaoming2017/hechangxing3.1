//
//  IjoouSetCollectionViewCell.h
//  HarmonyYi
//
//  Created by Wei Zhao on 2019/12/13.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface IjoouSetCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) UIImageView *imageV;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *temperatureLabel;
@property (nonatomic,strong) UIImageView *selectImageView;
@property (nonatomic,strong) CALayer *subLayer;
@property (nonatomic,assign) BOOL isChooes;
@end

NS_ASSUME_NONNULL_END
