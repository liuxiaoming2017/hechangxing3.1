//
//  WriteleftTableViewCell.h
//  和畅行
//
//  Created by 出神入化 on 2019/4/26.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WriteleftTableViewCell : UITableViewCell
@property (nonatomic ,strong) UIView *backView;
@property (nonatomic ,strong) UILabel *typeLabel;
@property (nonatomic,strong) CALayer *subLayer;
@end

NS_ASSUME_NONNULL_END
