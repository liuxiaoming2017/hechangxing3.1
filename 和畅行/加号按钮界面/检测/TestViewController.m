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
            cell.dateLabel.text = [self intervalSinceNow:[NSString stringWithFormat:@"%ld",model.createDate]];
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
         BloodOxyNonDeviceViewController * vc = [[BloodOxyNonDeviceViewController alloc] init];
             __weak typeof(self) weakSelf = self;
            vc.abock = ^{
                [weakSelf requestNetwork];
            };
            [self.navigationController pushViewController:vc animated:YES];
            return;
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

-(NSString *)intervalSinceNow:(NSString *)aDate
{
    if (!aDate.length || [aDate isKindOfClass:[NSNull class]]) {
        return @"0";
    }
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//
//    NSDate *date = [dateFormatter dateFromString:aDate];
//
//
//    NSTimeInterval interval_1 = [date timeIntervalSince1970];
    aDate = [aDate substringToIndex:10];
    NSTimeInterval interval_1 = [aDate doubleValue];
    
    NSDate *nowdate = [NSDate date];
    NSTimeInterval interval_2 = [nowdate timeIntervalSince1970];
    
    NSTimeInterval diff  = interval_2 - interval_1;
    if (diff < 0)
        diff = 0;
    NSString *timeString = nil;
    
    if (diff/60 <= 1) {
        timeString = [NSString stringWithFormat:@"%f", diff];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString = [NSString stringWithFormat:NSLocalizedString(@"刚刚",nil)];
    }
    
    if (diff/60 > 1 && diff/3600 <= 1) {
        timeString = [NSString stringWithFormat:@"%f", diff/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString = [NSString stringWithFormat:@"%@%@", timeString, NSLocalizedString(@"分钟前",nil)];
    }
    
    if (diff/3600 > 1 && diff/86400 <= 1) {
        timeString = [NSString stringWithFormat:@"%f", diff/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString = [NSString stringWithFormat:@"%@%@", timeString, NSLocalizedString(@"小时前",nil)];
    }
    
    if (diff/86400 > 1 && diff/86400 <= 7)  {
        timeString = [NSString stringWithFormat:@"%f", diff/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString = [NSString stringWithFormat:@"%@%@", timeString, NSLocalizedString(@"天前",nil)];
    }else{
        timeString = @"7天前";
    }
    
    
//    if (diff/86400 > 2){
//        NSRange range;
//        range.length = 11;
//        range.location = 5;
//        {
//            timeString = [NSString stringWithFormat:@"%@", [aDate substringWithRange:range]];
//        }
//
//    }
//
//    if (diff/86400 >= 30) {
//        NSRange range;
//        range.length = 10;
//        range.location = 0;
//        timeString = [NSString stringWithFormat:@"%@", [aDate substringWithRange:range]];
//    }
    
    return timeString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
