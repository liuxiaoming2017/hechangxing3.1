//
//  MessageViewController.m
//  Voicediagno
//
//  Created by ZhangYunguang on 15/12/29.
//  Copyright © 2015年 ZhangYunguang. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageModel.h"
#import "MessageCell.h"
//#import "HealthLectureOrderViewController.h"
//#import "HealthOrderViewController.h"
//#import "MyVideoOrderController.h"
#import "NoMessageView.h"

#define kGET_MESSAGE @"/user_message/messages.jhtml"

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain) UITableView *tableView;
@property (nonatomic,retain) NSMutableArray *dataArr;
@end

@implementation MessageViewController
- (void)dealloc
{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navTitleLabel.text = @"消息中心";
    self.preBtn.hidden = NO;
    self.rightBtn.hidden = YES;
    self.leftBtn.hidden = YES;
    
    [self createTableView];
    [self redData];
    
}
#pragma mark - 返回按钮
-(void)goBack:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

//#pragma mark - 重写定制导航栏的方法
//-(void)customeNavigationBar{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 69)];
//    view.tag = 200;
//
//    view.backgroundColor = [Tools colorWithHexString:@"#009ef3"];
//    [self.view addSubview:view];
//
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 69, kScreenSize.width, 1)];
//    line.backgroundColor = [Tools colorWithHexString:@"#8ad7fa"];
//    [self.view addSubview:line];
//}

#pragma mark - 读取消息数据
-(void)redData{
    //读取存到本地的消息
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [docPath stringByAppendingPathComponent:@"messages.data"];
    NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];

    if (arr.count == 0) {
        UIView *noView = [NoMessageView createImageWith:200];
        [self.view addSubview:noView];
        return ;
    }
    [_dataArr setArray:arr];
    [_tableView reloadData];
}

#pragma mark - 创建tableView
-(void)createTableView{
    _dataArr = [[NSMutableArray alloc] init];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenSize.width, kScreenSize.height-kNavBarHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"MessageCell" bundle:nil] forCellReuseIdentifier:@"MessageCell"];
  
}
#pragma mark-tableView Delegate相关
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count ? _dataArr.count: 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_dataArr.count) {
        MessageModel *model = _dataArr[indexPath.row];
        if (model.isNewMessage) {
            cell.icon.image = [UIImage imageNamed:@"我的红点"];
        }
        cell.title.text = model.title;
        cell.content.text = model.content;
        cell.time.text = [Tools timeYMDStringFrom:model.createDate.doubleValue];
        if (![model.sendType isEqualToString:@"system"]) {
            cell.arrowImage.image = [UIImage imageNamed:@"cellArrow"];
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageModel *model = _dataArr[indexPath.row];
    model.isNewMessage = NO;
    [_dataArr replaceObjectAtIndex:indexPath.row withObject:model];
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    if ([model.sendType isEqualToString:@"lecture"]) {
        //健康讲座
//        HealthLectureOrderViewController *lecture = [[HealthLectureOrderViewController alloc] init];
//        lecture.jumpMethod = @"push";
//        [self.navigationController pushViewController:lecture animated:YES];
       
        
    }else if ([model.sendType isEqualToString:@"video"]){
        //视频预约
//        MyVideoOrderController *video = [[MyVideoOrderController alloc] init];
//        video.jumpMethod = @"push";
//        [self.navigationController pushViewController:video animated:YES];
        
    }else if ([model.sendType isEqualToString:@"bespoke"]){
        //预约挂号
//        HealthOrderViewController *order = [[HealthOrderViewController alloc] init];
//        order.jumpMethod = @"push";
//        [self.navigationController pushViewController:order animated:YES];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
