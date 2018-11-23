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

@interface BlockViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain) UITableView *tableView;
@property (nonatomic,retain) NSMutableArray *dataArray;
@end

@implementation BlockViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navTitleLabel.text = @"我的卡包";
    self.view.backgroundColor=[UIColor whiteColor];
    UIImageView *blockImage = [[UIImageView alloc]initWithFrame:CGRectMake(17, kNavBarHeight+17, 20, 16)];
    blockImage.image = [UIImage imageNamed:@"wodekabaobao.png"];
    [self.view addSubview:blockImage];
    UILabel *blockLabel = [[UILabel alloc]initWithFrame:CGRectMake(52, blockImage.top, 60, 16)];
    blockLabel.text = @"绑定新卡";
    blockLabel.textColor = [UtilityFunc colorWithHexString:@"#666666"];
    blockLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:blockLabel];
    UIImageView *fengexianImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, blockImage.top+32, self.view.frame.size.width, 11)];
    fengexianImage.image = [UIImage imageNamed:@"wodekabaoxu.png"];
    [self.view addSubview:fengexianImage];
    UIImageView *nextImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 30, blockImage.top+1.5, 8, 13)];
    nextImage.image = [UIImage imageNamed:@"wodekabaoxia.png"];
    [self.view addSubview:nextImage];
    UIButton *dianjiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dianjiButton.frame = CGRectMake(0, kNavBarHeight, self.view.frame.size.width, 49);
    [dianjiButton addTarget:self action:@selector(dianjiButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dianjiButton];
    
    self.dataArray = [NSMutableArray array];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(17, kNavBarHeight+60, self.view.frame.size.width - 34, self.view.frame.size.height - kNavBarHeight-60) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellEditingStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 139 / 2 +10;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableView];
    [_tableView registerClass:[BlockTableViewCell class] forCellReuseIdentifier:@"CELL"];
    
}
- (void)dianjiButton{
    BoundBlockViewController *boundBlockVC = [[BoundBlockViewController alloc]init];
    [self.navigationController pushViewController:boundBlockVC animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BlockTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
