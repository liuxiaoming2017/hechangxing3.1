//
//  AllServiceCell.h
//  和畅行
//
//  Created by Wei Zhao on 2019/9/4.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYC_CardsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface AllServiceCell : UITableViewCell
@property (nonatomic,strong) UILabel *typeLabel;
@property (nonatomic,strong) UILabel *numberLabel;


-(void)setAllServicValueWithModel:(HYC_CardsModel *)model;

@end


NS_ASSUME_NONNULL_END
