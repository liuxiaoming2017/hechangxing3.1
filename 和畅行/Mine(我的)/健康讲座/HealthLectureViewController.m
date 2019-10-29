//
//  HealthLectureViewController.m
//  Voicediagno
//
//  Created by Mymac on 15/10/23.
//  Copyright (c) 2015年 Mymac. All rights reserved.
//

#import "HealthLectureViewController.h"
#import "HealthLectureModel.h"
#import "LectureDetailViewController.h"
#import "DateManager.h"

@interface HealthLectureViewController ()
{
    ASIHTTPRequest *_request;
    MBProgressHUD *_progress;
}
@end

@implementation HealthLectureViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initWithController];
    [self downloadDatas];
}
#pragma mark -------- 初始化界面
-(void)initWithController{
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, kScreenSize.width, 10)];
    lineView.image = [UIImage imageNamed:@"healthLec"];
    [self.view addSubview:lineView];
    [self.view bringSubviewToFront:lineView];
    UILabel *titleLabel = [Tools labelWith:@"讲座说明：" frame:CGRectMake(5, 25, 100, 10) textSize:11 textColor:[Tools colorWithHexString:@"#666666"] lines:1 aligment:NSTextAlignmentLeft];
    [self.view addSubview:titleLabel];
    UILabel *contentLabel = [Tools labelWith:@"在线预约养生类、慢病类、职业防护类、两性保健类、亲子健康类等健康主题的讲座或沙龙服务。" frame:CGRectMake(15, 40, kScreenSize.width-25, 50) textSize:11 textColor:[Tools colorWithHexString:@"#333"] lines:0 aligment:NSTextAlignmentLeft];
    [self.view addSubview:contentLabel];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 95, kScreenSize.width, 25)];
    imageView.backgroundColor = [Tools colorWithHexString:@"#616161"];
    [self.view addSubview:imageView];
    
    NSArray *categoryLabel = @[@"主讲人",@"讲座地址",@"讲座课题",@"开讲日期",@"时间",@"价格"];
    CGFloat width = kScreenSize.width/6.0f;
    for (int i=0; i<6; i++) {
        UILabel *label = [Tools labelWith:categoryLabel[i] frame:CGRectMake(width*i, 0, width, 25) textSize:11 textColor:[Tools colorWithHexString:@"#abafaf"] lines:1 aligment:NSTextAlignmentCenter];
        [imageView addSubview:label];
    }

}

#pragma mark -------- 请求数据
-(void)downloadDatas{
    NSString *str = [[NSString alloc] initWithFormat:@"%@/lecture/list.jhtml",URL_PRE];
    _request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:str]];
    [_request addRequestHeader:@"version" value:@"ios_hcy-yh-1.0"];
    _request.timeOutSeconds = 20;
    _request.requestMethod = @"GET";
    _request.delegate = self;
    [_request startAsynchronous];
    
    _progress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_progress];
    [self.view bringSubviewToFront:_progress];
    _progress.delegate = self;
    _progress.labelText = @"加载中...";
    [_progress show:YES];
}

-(void)hudWasHidden:(MBProgressHUD *)hud{
    [_progress removeFromSuperview];
    _progress = nil;
}

-(void)requestFinished:(ASIHTTPRequest *)request{
    [self hudWasHidden:nil];
    NSString *requestStr = [request responseString];
    NSDictionary *dic = [requestStr JSONValue];
    NSArray *data = dic[@"data"];
    _dataArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dataDic in data) {
        HealthLectureModel *model = [[HealthLectureModel alloc] init];
        [model setValuesForKeysWithDictionary:dataDic];
        if ([DateManager getNowTimestamp] <= model.lectureDate.doubleValue) {
            [_dataArr addObject:model];
        }
    }
    //请求成功，创建tableView
    [self createTableView];
}
-(void)requestFailed:(ASIHTTPRequest *)request{
    [self hudWasHidden:nil];
    NSLog(@"%@",request.error);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.removeFromSuperViewOnHide =YES;
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"数据请求失败";
    hud.minSize = CGSizeMake(132.f, 108.0f);
    [hud hide:YES afterDelay:2];
    
}

#pragma mark ------ tableView相关
-(void) createTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 120, kScreenSize.width, kScreenSize.height-120) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0f;
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    HealthLectureModel *model = [self.dataArr objectAtIndex:indexPath.row];
    NSString *beginDate = [Tools timeYMDStringFrom:model.beginDate.doubleValue];
    NSString *time = [Tools timeHMStringFrom:model.lectureDate.doubleValue];
    NSString *price = nil;
    if (model.price.doubleValue != 0) {
        price = [[NSString alloc] initWithFormat:@"￥%.2f",model.price.doubleValue];
    }else{
        price = [[NSString alloc] initWithFormat:@"免费"];
    }
    NSArray *titlesArr = @[model.talker,model.area,model.title,beginDate,time,price];
    CGFloat width = kScreenSize.width/6.0f;
    for (int i=0; i<6; i++) {
        UILabel *label = [Tools labelWith:titlesArr[i] frame:CGRectMake(width*i, 5, width, 70) textSize:11 textColor:[Tools colorWithHexString:@"#333"] lines:0 aligment:NSTextAlignmentCenter];
        [cell addSubview:label];
        if (i==0) {
            label.textColor = [Tools colorWithHexString:@"#666"];
        }
        if (i==3 || i==4) {
            label.font = [UIFont systemFontOfSize:9];
        }
        if (i==5) {
            label.font = [UIFont systemFontOfSize:10];
            if ([price isEqualToString:@"免费"]) {
                label.textColor = [Tools colorWithHexString:@"#4fd164"];
            }else{
                label.textColor = [Tools colorWithHexString:@"#ff9933"];
            }
        }
    }
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 78, kScreenSize.width, 2)];
    lineView.image = [UIImage imageNamed:@"健康讲座线"];
    [cell addSubview:lineView];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    HealthLectureModel *model = [self.dataArr objectAtIndex:indexPath.row];
    LectureDetailViewController *lecture = [[LectureDetailViewController alloc] init];
    lecture.url = model.path;
    lecture.price = model.price.floatValue;
    lecture.leftPassengers = model.laveListeners.integerValue;
    lecture.model = model;
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:lecture];
//    [self presentViewController:nav animated:YES completion:nil];
    [self.navigationController pushViewController:lecture animated:YES];

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
