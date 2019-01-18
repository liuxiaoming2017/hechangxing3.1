//
//  TestViewController.m
//  和畅行
//
//  Created by 刘晓明 on 2018/8/16.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "TestViewController.h"
#import "BloodGuideViewController.h"
#import "PressureViewController.h"
#import "TestCell.h"
#import "TemperNonDeviceViewController.h"
#import "BreathCheckViewController.h"
#import "SugerViewController.h"
#import "BloodOxyNonDeviceViewController.h"



@implementation TestValueModel

@end

@interface TestViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *titleArr;
@property (nonatomic,strong) NSArray *imageArr;
@property (nonatomic,strong) NSMutableArray *dataArr;
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleLabel.text = @"体征监检测";
    
    self.titleArr = @[@"血压",@"血糖",@"血氧",@"呼吸",@"体温"];
    self.imageArr = @[@"检测_血压",@"检测_血糖",@"检测_血氧",@"检测_呼吸",@"检测_体温"];
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    
    [self createUI];
  
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestNetwork];
}

- (void)createUI
{
    
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, kNavBarHeight, 160, 39)];
    topLabel.text = @"近期检测";
    topLabel.textAlignment=NSTextAlignmentLeft;
    topLabel.font=[UIFont systemFontOfSize:16.0];
    topLabel.textColor = UIColorFromHex(0x333333);
    topLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:topLabel];
    
    UIImageView *lineImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, topLabel.bottom, ScreenWidth, 1)];
    lineImageV.backgroundColor = UIColorFromHex(0xDADADA);
    [self.view addSubview:lineImageV];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, lineImageV.bottom, ScreenWidth, ScreenHeight-lineImageV.bottom) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.bounces = NO;
    [self.view addSubview:self.tableView];
}

- (void)requestNetwork
{
    NSString *urlStr = [NSString stringWithFormat:@"/member/myreport/view/%@.jhtml",[MemberUserShance shareOnce].idNum];
    __weak typeof(self) weakSelf = self;
    //[self.archiveArr removeAllObjects];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"加载中...";
    
    [[NetworkManager sharedNetworkManager] requestWithType:0 urlString:urlStr parameters:nil successBlock:^(id response) {
        [hud hideAnimated:YES];
        if([[response objectForKey:@"status"] integerValue] == 100){
            
            NSDictionary *data = [response objectForKey:@"data"];
 
            [self.dataArr removeAllObjects];
            NSArray *typeArray = @[@"bloodPressure",@"bloodSugar",@"oxygen",@"breathe",@"bodyTemperature"];
            for (int i = 0; i < typeArray.count; i++) {
                TestValueModel *model = [[TestValueModel alloc] init];
                [model yy_modelSetWithDictionary:[data valueForKey:typeArray[i]]];
                [weakSelf.dataArr addObject:model];
            }
            [ weakSelf.tableView reloadData];
        }else{
            [weakSelf showAlertWarmMessage:[response objectForKey:@"data"]];
        }
    } failureBlock:^(NSError *error) {
        [hud hideAnimated:YES];
        [weakSelf showAlertWarmMessage:requestErrorMessage];
    }];
}

#pragma mark - tableview代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TestCell"];
    if(cell == nil){
        cell = [[TestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TestCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.iconImage.image = [UIImage imageNamed:self.imageArr[indexPath.row]];
    cell.titleLabel.text = [self.titleArr objectAtIndex:indexPath.row];
    if(self.dataArr.count>0){
        TestValueModel *model = [self.dataArr objectAtIndex:indexPath.row];
        if(model.createDate == 0){
            cell.dateLabel.text = @"";
        }else{
            cell.dateLabel.text = [self updateTimeForRow:[NSString stringWithFormat:@"%ld",model.createDate]];
        }
       
        NSString *descrioTionStr = [NSString string];
        if (indexPath.row == 0) {
            if (![GlobalCommon stringEqualNull:model.highPressure]) {
                descrioTionStr = [NSString stringWithFormat:@"%@ - %@",model.highPressure,model.lowPressure];
            }else{
                descrioTionStr = @"尚未检测";
            }
        }else if (indexPath.row == 1) {
            if (![GlobalCommon stringEqualNull:model.levels]) {
                descrioTionStr = model.levels;
            }else{
                descrioTionStr = @"尚未检测";
            }
        }else if (indexPath.row == 2) {
            if (![GlobalCommon stringEqualNull:model.density]) {
                descrioTionStr = model.density;
            }else{
                descrioTionStr = @"尚未检测";
            }
        }else if (indexPath.row == 3) {
            if (![GlobalCommon stringEqualNull:model.nums]) {
                descrioTionStr = model.nums;
            }else{
                descrioTionStr = @"尚未检测";
            }
        }else if (indexPath.row == 4) {
            if (![GlobalCommon stringEqualNull:model.temperature]) {
                descrioTionStr = model.temperature;
            }else{
                descrioTionStr = @"尚未检测";
            }
        }
        cell.descriptionLabel.text = descrioTionStr;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc = nil;
    
    //[@"血压",@"血糖",@"血氧",@"呼吸",@"体温"];
    
    switch (indexPath.row) {
        case 0:
        {
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"bloodNeverCaution"] isEqualToString:@"1"]){
                vc = [[PressureViewController alloc] init];
            }else{
                BloodGuideViewController * vc1 = [[BloodGuideViewController alloc] init];
                vc1.isBottom = YES;
                vc1.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc1 animated:YES];
                return;
            }
        }
            break;
        case 1:
        {
            vc = [[SugerViewController alloc] init];
        }
            break;
        case 2:
        {
            vc = [[BloodOxyNonDeviceViewController alloc] init];
//             __weak typeof(self) weakSelf = self;
//            vc.abock = ^{
////                [weakSelf requestNetwork];
//            };
//            [self.navigationController pushViewController:vc animated:YES];
//            return;
        }
            break;
        case 3:
        {
            vc = [[BreathCheckViewController alloc] init];
        }
            break;
        case 4:
        {
            vc = [[TemperNonDeviceViewController alloc] init];
        }
            break;
            
        default:
            break;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSString *)updateTimeForRow:(NSString *)createTimeString {
    // 获取当前时时间戳 1466386762.345715 十位整数 6位小数
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // 创建歌曲时间戳(后台返回的时间 一般是13位数字)
    NSTimeInterval createTime = [createTimeString longLongValue]/1000;
    // 时间差
    NSTimeInterval time = currentTime - createTime;
    
    NSInteger sec = time/60;
    if (sec<60) {
        if (sec == 0){
            return [NSString stringWithFormat:@"刚刚"];
        }
        return [NSString stringWithFormat:@"%ld分钟前",sec];
    }
    
    // 秒转小时
    NSInteger hours = time/3600;
    if (hours<24) {
        return [NSString stringWithFormat:@"%ld小时前",hours];
    }
    //秒转天数
    NSInteger days = time/3600/24;
    if (days < 30) {
        return [NSString stringWithFormat:@"%ld天前",days];
    }
    //秒转月
    NSInteger months = time/3600/24/30;
    if (months < 12) {
        return [NSString stringWithFormat:@"%ld月前",months];
    }
    //秒转年
    NSInteger years = time/3600/24/30/12;
    return [NSString stringWithFormat:@"%ld年前",years];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
