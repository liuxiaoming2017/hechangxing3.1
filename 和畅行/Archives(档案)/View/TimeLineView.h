//
//  TimeLineView.h
//  和畅行
//
//  Created by 刘晓明 on 2018/11/7.
//  Copyright © 2018 刘晓明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthTipsModel.h"
@interface TimeLineView : UIView

@property (nonatomic,strong) HealthTipsModel*topModel;
@property (nonatomic,strong)  MBProgressHUD *hud;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic,assign)  NSInteger typeInteger;

-(void)relodTableViewWitDataArray:(NSMutableArray *)dataArray withType:(NSInteger)type;

- (id)initWithFrame:(CGRect)frame withData:(NSArray *)dataArr;
@end
