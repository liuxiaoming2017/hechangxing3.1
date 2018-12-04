//
//  TimeLineView.h
//  和畅行
//
//  Created by 刘晓明 on 2018/11/7.
//  Copyright © 2018 刘晓明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeLineView : UIView

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArr;


- (id)initWithFrame:(CGRect)frame withData:(NSArray *)dataArr;
@end
