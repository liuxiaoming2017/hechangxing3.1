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
#import "ResultSpeakController.h"


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
    self.navTitleLabel.text = ModuleZW(@"体征监检测");
    self.view.backgroundColor = RGB_AppWhite;
   
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    
    [self createUI];
  
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestNetwork];
}

- (void)createUI
{
    

    self.imageArr = @[@"血压icon",@"血糖icon"];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.topView.bottom, ScreenWidth, ScreenHeight - self.topView.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellAccessoryNone;
       self.tableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    //下拉刷新
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [header setTitle:ModuleZW(@"下拉刷新") forState:MJRefreshStateIdle];
    [header setTitle:ModuleZW(@"努力加载中...") forState:MJRefreshStateRefreshing];
    [header setTitle:ModuleZW(@"松开即可刷新...") forState:MJRefreshStatePulling];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.font = [UIFont systemFontOfSize:14];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    header.stateLabel.textColor = RGB_TextAppBlue;
    header.lastUpdatedTimeLabel.textColor = RGB_TextAppBlue;
    self.tableView.mj_header = header;
    
}

-(void)loadNewData{
         [self requestNetwork];
}

- (void)requestNetwork
{
    NSString *urlStr = [NSString stringWithFormat:@"/member/myreport/view/%@.jhtml",[MemberUserShance shareOnce].idNum];
    __weak typeof(self) weakSelf = self;
    //[self.archiveArr removeAllObjects];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = ModuleZW(@"加载中...");
    
    [[NetworkManager sharedNetworkManager] requestWithType:0 urlString:urlStr parameters:nil successBlock:^(id response) {
        [hud hideAnimated:YES];
        if([[response objectForKey:@"status"] integerValue] == 100){
            
            NSDictionary *data = [response objectForKey:@"data"];
 
            [self.dataArr removeAllObjects];
            NSArray *typeArray = @[@"bloodPressure",@"bloodSugar"];
            for (int i = 0; i < typeArray.count; i++) {
                TestValueModel *model = [[TestValueModel alloc] init];
                [model yy_modelSetWithDictionary:[data valueForKey:typeArray[i]]];
                [weakSelf.dataArr addObject:model];
            }
            [ weakSelf.tableView reloadData];
        }else{
            [weakSelf showAlertWarmMessage:[response objectForKey:@"data"]];
        }
        [weakSelf.tableView.mj_header endRefreshing];
    } failureBlock:^(NSError *error) {
        [hud hideAnimated:YES];
        [weakSelf showAlertWarmMessage:requestErrorMessage];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - tableview代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TestCell"];
    if(cell == nil){
        cell = [[TestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TestCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.iconImage.image = [UIImage imageNamed:self.imageArr[indexPath.row]];
    if(self.dataArr.count>0){
        cell.typeInt = 0;
        TestValueModel *model = [self.dataArr objectAtIndex:indexPath.row];
        if (indexPath.row == 0) {
            cell.leftLabel.hidden = NO;
            cell.rightLabel.hidden = NO;
            cell.left1Label.hidden = NO;
            cell.right1Label.hidden = NO;
            if ([GlobalCommon stringEqualNull:model.highPressure]) {
                model.highPressure = @"--";
            }
            if ([GlobalCommon stringEqualNull:model.lowPressure]) {
                model.lowPressure = @"--";
            }
            if ([GlobalCommon stringEqualNull:model.pulse]) {
                model.pulse = @"--";
            }
            cell.leftOneBlock = ^{
                if([[[NSUserDefaults standardUserDefaults] objectForKey:@"bloodNeverCaution"] isEqualToString:@"1"]){
                    PressureViewController *vc = [[PressureViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    BloodGuideViewController * vc1 = [[BloodGuideViewController alloc] init];
                    vc1.isBottom = YES;
                    vc1.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc1 animated:YES];
                }
            };
            
            cell.righOneBlock = ^{
                NSString *urlStr = [NSString stringWithFormat:@"%@subject_report/getreport.jhtml?mcId=%@&datatype=%@",URL_PRE,[MemberUserShance shareOnce].idNum,@(30)];
                ResultSpeakController *vc = [[ResultSpeakController alloc] init];
                vc.urlStr = urlStr;
                vc.popInt = 111;
                vc.titleStr = ModuleZW(@"血压监测");
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];

            };
                
            cell.leftLabel.text = [NSString stringWithFormat:@"%@mmHg",model.highPressure];
            cell.left1Label.text = ModuleZW(@"收缩压");
            cell.middLabel.text = [NSString stringWithFormat:@"%@mmHg",model.lowPressure];
            cell.midd1Label.text = ModuleZW(@"舒张压");
            cell.rightLabel.text =[NSString stringWithFormat:@"%@BMP",model.pulse];
            cell.right1Label.text = ModuleZW(@"心率");
            [cell.lefttBtn setTitle:@"血压检测" forState:(UIControlStateNormal)];
            [cell.rightBtn setTitle:@"血压监测" forState:(UIControlStateNormal)];
            int highPressure =[model.highPressure intValue];
            int lowPressure =[model.lowPressure intValue];
            if (lowPressure >=0&&lowPressure<=60){
                cell.arrowImageView.left = (ScreenWidth - 60)/6 + 10;
            }else if (lowPressure >=90){
                cell.arrowImageView.left = (ScreenWidth - 60)*5/6 + 10;
            }else{
                if(highPressure >=140){
                    cell.arrowImageView.left = (ScreenWidth - 60)*5/6 + 10;
                }else if(highPressure <=90){
                    cell.arrowImageView.left = (ScreenWidth - 60)/6 + 10;
                }else{
                    cell.arrowImageView.left = (ScreenWidth - 60)*3/6 + 10;
                }
            }
            
        }else if (indexPath.row == 1) {
            cell.typeInt = 1;
            cell.leftLabel.hidden = YES;
            cell.rightLabel.hidden = YES;
            cell.left1Label.hidden = YES;
            cell.right1Label.hidden = YES;
            [cell.lefttBtn setTitle:@"血糖检测" forState:(UIControlStateNormal)];
            [cell.rightBtn setTitle:@"血糖监测" forState:(UIControlStateNormal)];
            if (![GlobalCommon stringEqualNull:model.levels]){
                if ([model.levels floatValue] <3.9) {
                    cell.arrowImageView.left = (ScreenWidth - 60)/6 + 10;
                }else if ([model.levels intValue]  <=6.1){
                     cell.arrowImageView.left = (ScreenWidth - 60)*3/6 + 10;
                }else{
                     cell.arrowImageView.left = (ScreenWidth - 60)*5/6 + 10;
                }
                cell.middLabel.text = [NSString stringWithFormat:@"%@mmol",model.levels];

            }else{
                cell.middLabel.text = @"--mmol";

            }
            NSString *typeStr = [NSString string];
            if([model.type isEqualToString:@"beforeDawn"]){
                typeStr = @"凌晨";
            }else  if([model.type isEqualToString:@"beforeBreakfast"]){
                typeStr = @"早餐前";
            }else  if([model.type isEqualToString:@"afterBreakfast"]){
                typeStr = @"早餐后";
            }else  if([model.type isEqualToString:@"beforeLunch"]){
                typeStr = @"午餐前";
            }else  if([model.type isEqualToString:@"afterLunch"]){
                typeStr = @"午餐后";
            }else  if([model.type isEqualToString:@"beforeDinner"]){
                typeStr = @"晚餐前";
            }else  if([model.type isEqualToString:@"afterDinner"]){
                typeStr = @"晚餐后";
            }else  if([model.type isEqualToString:@"beforeSleep"]){
                typeStr = @"睡前";
            }

            cell.midd1Label.text = ModuleZW(typeStr);
           
            
            cell.leftTwoBlock = ^{
                SugerViewController *vc = [[SugerViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            };
            cell.righTwoBlock = ^{
           NSString  *urlStr = [NSString stringWithFormat:@"%@subject_report/getreport.jhtml?mcId=%@&datatype=%@",URL_PRE,[MemberUserShance shareOnce].idNum,@(60)];
                ResultSpeakController *vc = [[ResultSpeakController alloc] init];
                vc.urlStr = urlStr;
                vc.popInt = 111;
                vc.titleStr = ModuleZW(@"血糖监测");
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];

            };
        }
        if(model.createDate > 100){
            cell.dateLabel.text =
            [self compareCurrentTime:[NSString stringWithFormat:@"%ld",model.createDate]];
        }

    }
    return cell;
}


- (NSString *) compareCurrentTime:(NSString *)str
{
    NSTimeInterval time=[str doubleValue]/1000;//传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; //实例化一个NSDateFormatter对象
    //设定时间格式,这里可以设置成自己需要的格式
    NSString *dateStr = [NSString stringWithFormat:@"YYYY-MM-dd  HH:mm"];
    [dateFormatter setDateFormat:dateStr];
    NSString *timeString = [dateFormatter stringFromDate: detailDate];
    return  timeString;
}


@end
