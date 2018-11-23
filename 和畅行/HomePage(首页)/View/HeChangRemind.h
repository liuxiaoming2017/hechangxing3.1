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
@property (nonatomic,strong) NSArray *dataArr;

- (id)initWithFrame:(CGRect)frame withDataArr:(NSArray *)arr;
- (void)updateViewWithData:(NSArray *)arr withHeight:(CGFloat)height;

@end
