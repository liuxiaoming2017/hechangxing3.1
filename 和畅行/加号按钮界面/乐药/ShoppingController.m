//
//  ShoppingController.m
//  和畅行
//
//  Created by 刘晓明 on 2019/1/18.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "ShoppingController.h"
#import "SongListModel.h"
#import "PayMentViewController.h"

@interface ShoppingController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *listTable;
@property (nonatomic,strong) UILabel *jinerLabel;
@end



@implementation ShoppingController
@synthesize listTable,jinerLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navTitleLabel.text = ModuleZW(@"购物车");
    
    listTable = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, self.view.frame.size.width, self.view.frame.size.height - kNavBarHeight -  44) style:UITableViewStylePlain];
    listTable.delegate = self;
    listTable.dataSource = self;
    listTable.rowHeight = 55;
    listTable.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:listTable];
    
    //[_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
    UIImageView *xiaofeijinerImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - kTabBarHeight, self.view.frame.size.width - 105, 44)];
    xiaofeijinerImage.image = [UIImage imageNamed:@"leyaoxiaofeijiner.png"];
    [self.view addSubview:xiaofeijinerImage];
   
    UIButton *jiesuanButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    jiesuanButton.frame = CGRectMake(self.view.frame.size.width -  105, self.view.frame.size.height - kTabBarHeight, 105, 44);
    [jiesuanButton addTarget:self action:@selector(qujiesuanButton) forControlEvents:(UIControlEventTouchUpInside)];
    [jiesuanButton setTitle:ModuleZW(@"去结算") forState:(UIControlStateNormal)];
    [jiesuanButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    jiesuanButton.backgroundColor = RGB(68, 204, 82);
    [self.view addSubview:jiesuanButton];
    
    UIImageView *gouwucheImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 12, 20, 20)];
    gouwucheImage.image = [UIImage imageNamed:@"leyaogouwuche.png"];
    [xiaofeijinerImage addSubview:gouwucheImage];
    
    UILabel *zongjinerLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 12, 40, 20)];
    zongjinerLabel.text = ModuleZW(@"总计: ");
    zongjinerLabel.textColor = [UIColor whiteColor];
    zongjinerLabel.font = [UIFont systemFontOfSize:13];
    [xiaofeijinerImage addSubview:zongjinerLabel];
    
    jinerLabel = [[UILabel alloc]initWithFrame:CGRectMake(zongjinerLabel.right, 12, 60, 20)];
    
    jinerLabel.text = [NSString stringWithFormat:@"¥%.2f",[UserShareOnce shareOnce].allYueYaoPrice];
    jinerLabel.textColor = [UIColor whiteColor];
    jinerLabel.font = [UIFont boldSystemFontOfSize:13];
    [xiaofeijinerImage addSubview:jinerLabel];
    
}

- (void)qujiesuanButton{
    if([UserShareOnce shareOnce].yueYaoBuyArr.count == 0){
        [GlobalCommon showMessage:ModuleZW(@"请去添加商品") duration:1.0];
        return;
    }
    PayMentViewController *payMentVC = [[PayMentViewController alloc]init];
    payMentVC.count = 12;
    [self.navigationController pushViewController:payMentVC animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"LeMedicineCell";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier];
        cell.backgroundColor=[UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    
    
    UIImageView *nameImage = [[UIImageView alloc]initWithFrame:CGRectMake(18, 9, 35, 36.5)];
    nameImage.image = [UIImage imageNamed:@"乐药购物车1及支付_03.png"];
    [cell addSubview:nameImage];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 20, 85, 15)];
    nameLabel.text = @"乐药名称：";
    nameLabel.textColor = [UtilityFunc colorWithHexString:@"#666666"];
    nameLabel.font = [UIFont systemFontOfSize:14];
   // [cell addSubview:nameLabel];
    
    UILabel *leyaoLabel = [[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth-150)/2.0, 20, 150, 15)];
    leyaoLabel.textColor = [UtilityFunc colorWithHexString:@"#333333"];
    leyaoLabel.font = [UIFont systemFontOfSize:14];
    SongListModel *model = [self.dataArr objectAtIndex:indexPath.row];
    leyaoLabel.text = model.title;
   
    [cell addSubview:leyaoLabel];
    
    UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 96, 20, 60, 15)];
    moneyLabel.text = [NSString stringWithFormat:@"%.2f",model.price];
    
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    moneyLabel.textColor = [UtilityFunc colorWithHexString:@"#ff9933"];
    moneyLabel.font = [UIFont systemFontOfSize:14];
    [cell addSubview:moneyLabel];
   
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame = CGRectMake(self.view.frame.size.width - 36, 19, 17, 17);
    [deleteButton setBackgroundImage:[UIImage imageNamed:@"111_106.png"] forState:UIControlStateNormal];
    deleteButton.tag = indexPath.row + 102200;
    [deleteButton addTarget:self action:@selector(deleteButton:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:deleteButton];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)deleteButton:(UIButton *)sender{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:ModuleZW(@"确定删除吗？") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAct1 = [UIAlertAction actionWithTitle:ModuleZW(@"取消") style:UIAlertActionStyleCancel handler:NULL];
    UIAlertAction *alertAct12 = [UIAlertAction actionWithTitle:ModuleZW(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        CGPoint point = sender.center;
        point = [self.listTable convertPoint:point fromView:sender.superview];
        NSIndexPath* indexpath = [self.listTable indexPathForRowAtPoint:point];
        
        SongListModel *model = [self.dataArr objectAtIndex:indexpath.row];
        
        [UserShareOnce shareOnce].allYueYaoPrice = [UserShareOnce shareOnce].allYueYaoPrice - model.price;
        
        if([UserShareOnce shareOnce].allYueYaoPrice <= 0){
            [UserShareOnce shareOnce].allYueYaoPrice = 0;
        }
        
        [self.dataArr removeObjectAtIndex:indexpath.row];
        
        [UserShareOnce shareOnce].yueYaoBuyArr = self.dataArr;
        
        self->jinerLabel.text = [NSString stringWithFormat:@"¥%.2f",[UserShareOnce shareOnce].allYueYaoPrice];
        [self->listTable reloadData];
        
    }];
    [alertVC addAction:alertAct1];
    [alertVC addAction:alertAct12];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertVC animated:YES completion:nil];
    });
    
    
    
    
}



@end
