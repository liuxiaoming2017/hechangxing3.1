//
//  HPITableViewCell.h
//  和畅行
//
//  Created by 出神入化 on 2019/4/30.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void  (^DeletActionBlock)(void);
@interface HPITableViewCell : UITableViewCell
@property (nonatomic,copy)DeletActionBlock deletBlock;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *stateLabel;
@property (nonatomic,strong)UIButton *deletButton;
@end

NS_ASSUME_NONNULL_END
