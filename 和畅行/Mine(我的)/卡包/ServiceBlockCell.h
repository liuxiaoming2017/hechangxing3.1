//
//  ServiceBlockCell.h
//  和畅行
//
//  Created by 刘晓明 on 2018/12/20.
//  Copyright © 2018 刘晓明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCY_UnderlineButton.h"
@class ServiceBlockCell;
@protocol ServiceBlockCellDelegate<NSObject>

- (void)selectTradeButton:(NSString *)btnStr;

@end

NS_ASSUME_NONNULL_BEGIN



@interface ServiceBlockCell : UITableViewCell

@property (nonatomic,strong) UILabel *typeLabel;
@property (nonatomic,strong) UILabel *contentLabel;

@property (nonatomic,strong) HCY_UnderlineButton *tradeBtn;
@property (nonatomic,weak) id<ServiceBlockCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
