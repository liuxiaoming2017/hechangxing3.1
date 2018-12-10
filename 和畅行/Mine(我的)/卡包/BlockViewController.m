//
//  BlockViewController.m
//  Voicediagno
//
//  Created by ZhangYunguang on 16/1/11.
//  Copyright © 2016年 ZhangYunguang. All rights reserved.
//

#import "BlockViewController.h"
#import "BlockTableViewCell.h"
#import "BoundBlockViewController.h"
#import "HCY_ActivationController.h"
#import "HCY_CarDetailController.h"

@interface BlockViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain) UITableView *tableView;
@property (nonatomic,retain) NSMutableArray *dataArray;
@property (nonatomic,strong) UILabel *nullLabel;
@end

@implementation BlockViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navTitleLabel.text = @"我的卡包";
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    
    
    UIButton *marryStateBtn = [Tools creatButtonWithFrame:CGRectMake(ScreenWidth - 55, kNavBarHeight + 13, 36, 36) target:self sel:@selector(addAction) tag:1000 image:@"HCY_addcard" title:nil];
    [self.view addSubview:marryStateBtn];

    
    UILabel *blockLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, marryStateBtn.top, 100, 36)];
    blockLabel.text = @"我的卡包";
    blockLabel.textColor = [UtilityFunc colorWithHexString:@"#000000"];
    blockLabel.font = [UIFont systemFontOfSize:21];
    [self.view addSubview:blockLabel];
 
    
    UILabel *nullLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, marryStateBtn.bottom , ScreenWidth, 200)];
    nullLabel.text = @"还没有卡\n快去添加新卡吧~";
    nullLabel.numberOfLines = 2;
    nullLabel.font = [UIFont systemFontOfSize:17];
    nullLabel.textAlignment = NSTextAlignmentCenter;
    nullLabel.textColor = [UtilityFunc colorWithHexString:@"#8E8F90"];
//    [self.view addSubview:nullLabel];
   
    self.dataArray = [NSMutableArray array];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(17, kNavBarHeight+65, self.view.frame.size.width - 34, self.view.frame.size.height - kNavBarHeight-60) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellEditingStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 140;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableView];
    [_tableView registerClass:[BlockTableViewCell class] forCellReuseIdentifier:@"BlockTableViewCell"];
    
}
- (void)addAction{
    BoundBlockViewController *boundBlockVC = [[BoundBlockViewController alloc]init];
    [self.navigationController pushViewController:boundBlockVC animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BlockTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BlockTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == 0) {
        
        HCY_ActivationController *activaTionVC = [[HCY_ActivationController alloc]init];
        [self.navigationController pushViewController:activaTionVC animated:YES];
        
        
    }else {
        
        HCY_CarDetailController *detailVC = [[HCY_CarDetailController alloc]init];
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }
    
   
}



@end
