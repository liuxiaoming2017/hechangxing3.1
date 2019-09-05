//
//  HeChangRemind.h
//  和畅行
//
//  Created by 刘晓明 on 2018/7/9.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeChangRemind : UIView

@property(nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *timeLabel;

- (id)initWithFrame:(CGRect)frame withDataArr:(NSMutableArray *)arr;
- (void)updateViewWithData:(NSMutableArray *)arr withHeight:(CGFloat)height;

@end
