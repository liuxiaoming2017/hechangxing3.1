//
//  MineViewController.m
//  和畅行
//
//  Created by 刘晓明 on 2018/7/2.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "MineViewController.h"
#import "MineCell.h"
#import "HeChangPackgeController.h"
#import "MyView.h"
#import "UIImageView+WebCache.h"
#import "PersonalInformationViewController.h"
#import "PrivateServiceViewController.h"
#import "BlockViewController.h"
#import "FamilyViewController.h"
#import "HealthLectureOrderViewController.h"
#import "CustomNavigationController.h"
#import "LeMedicineViewController.h"
#import "WenYinFileViewController.h"
#import "MyAvdisorysViewController.h"
#import "FeedbackViewController.h"
#import "SetupController.h"
#import "EDWKWebViewController.h"
#import "SportDemonstratesViewController.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *listNamesArr;
@property (nonatomic,strong) NSArray *listImagesArr;

@end

@implementation MineViewController
@synthesize listNamesArr,listImagesArr;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"personalInfoUpdateSuccess" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topView.backgroundColor = UIColorFromHex(0x1e82d2);
    self.navTitleLabel.text = @"我的";
    self.navTitleLabel.textColor = [UIColor whiteColor];
   // [self.leftBtn setImage:[UIImage imageNamed:@"user_01"] forState:UIControlStateNormal];
    [self.rightBtn setImage:[UIImage imageNamed:@"message_01"] forState:UIControlStateNormal];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
    [self changUserInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changUserInfo) name:@"personalInfoUpdateSuccess" object:nil];
}

- (void)createUI
{
    //0
//    listNamesArr = @[@"健康顾问团队",@"退款记录",@"退货记录",@"我的卡包",@"我的积分",@"家庭成员",@"视频预约",@"健康讲座",@"我的乐药",@"运动示范音",@"未发出的声音文件",@"预约挂号",@"健康提示",@"我的咨询",@"收货地址",@"意见反馈",@"收藏",@"设置"];
//    listImagesArr = @[@"private",@"refundRecord",@"returedGoodsRecord",@"1我的_100",@"integral",@"1我的_101",@"1我的_102",@"1我的_103",@"1我的_104",@"1我的_105",@"1我的_106",@"1我的_107",@"1我的_108",@"1我的_109",@"1我的_110",@"feedback",@"1我的_111",@"1我的_112"];
    listNamesArr = @[@"退款记录",@"退货记录",@"我的卡包",@"我的积分",@"家庭成员",@"健康讲座",@"我的乐药",@"运动示范音",@"未发出的声音文件",@"我的咨询",@"收货地址",@"意见反馈",@"收藏",@"设置"];
    listImagesArr = @[@"refundRecord",@"returedGoodsRecord",@"1我的_100",@"integral",@"1我的_101",@"1我的_103",@"1我的_104",@"1我的_105",@"1我的_106",@"1我的_109",@"1我的_110",@"feedback",@"1我的_111",@"1我的_112"];
    
    if([UserShareOnce shareOnce].isOnline){
        listNamesArr = @[@"退款记录",@"退货记录",@"我的积分",@"家庭成员",@"收货地址",@"意见反馈",@"收藏",@"设置"];
        listImagesArr = @[@"refundRecord",@"returedGoodsRecord",@"integral",@"1我的_101",@"1我的_110",@"feedback",@"1我的_111",@"1我的_112"];
    }
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, ScreenWidth, 80)];
    imageView.userInteractionEnabled = YES;
    imageView.tag = 1000;
    imageView.image = [UIImage imageNamed:@"1我的_05"];
    [self.view addSubview:imageView];
    
    UIView *middleView = [[UIView alloc] initWithFrame:CGRectMake(0, imageView.bottom, ScreenWidth, 47)];
    middleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:middleView];
    
    NSArray *titleArr = @[@"全部订单",@"待付款",@"待评价"];
    NSArray *imageArr = @[@"我的全部订单",@"我的待付款",@"我的待评价"];
    for (int i=0; i<titleArr.count; i++) {
        CGFloat x = ScreenWidth/3*i+ScreenWidth/6-12;
        UIImageView *vLine = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/3*(i+1), 10, 1, 30)];
        vLine.image = [UIImage imageNamed:@"我的vLine"];
        [middleView addSubview:vLine];
        UIButton *cateBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, vLine.top, 24, 20)];
        [cateBtn setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        cateBtn.tag = 666+i;
        [cateBtn addTarget:self action:@selector(MyBTnClick:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *lable = [Tools labelWith:titleArr[i] frame:CGRectMake(ScreenWidth/3*i, vLine.top+20, ScreenWidth/3, 10) textSize:10 textColor:[Tools colorWithHexString:@"#666666"] lines:1 aligment:NSTextAlignmentCenter];
        [middleView addSubview:lable];
        [middleView addSubview:cateBtn];
        
    }
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, middleView.bottom, self.view.frame.size.width, 8)];
    lineView.image = [UIImage imageNamed:@"healthLec"];
    [self.view addSubview:lineView];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, lineView.bottom, ScreenWidth, ScreenHeight-lineView.bottom-kNavBarHeight) style:UITableViewStylePlain];
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.view addSubview:self.tableView];
        
    });
    
    
}



-(void)changUserInfo
{
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:1000];
    for (UIView *view in imageView.subviews) {
        [view removeFromSuperview];
    }
    UIImage *personImg = [UIImage imageNamed:@"1我的_03"];
    MyView *userIcon = [[MyView alloc] initWithFrame:CGRectMake(15, 5, 70, 70)];
    if([[UserShareOnce shareOnce].memberImage isKindOfClass:[NSNull class]]){
        userIcon.image = personImg;
    }else{
        [userIcon sd_setImageWithURL:[NSURL URLWithString:[UserShareOnce shareOnce].memberImage] placeholderImage:personImg];
    }
    userIcon.clipsToBounds = YES;
    userIcon.layer.cornerRadius = userIcon.frame.size.width/2;
    userIcon.layer.borderWidth = 1.0f;
    userIcon.layer.borderColor = [UIColor whiteColor].CGColor;
    [userIcon addTarget:self action:@selector(loginClick)];
    [imageView addSubview:userIcon];
    
    NSString *dispalyName = nil;
    
    if ([UserShareOnce shareOnce].name!=nil &&! [[UserShareOnce shareOnce].name isKindOfClass:[NSNull class]]) {
        dispalyName =[NSString stringWithFormat:@"欢迎：%@", [UserShareOnce shareOnce].name];
    }else if (![[MemberUserShance shareOnce].name isKindOfClass:[NSNull class]] && [MemberUserShance shareOnce].name != nil){
        if ([[MemberUserShance shareOnce].name length] > 26) {
            dispalyName = [NSString stringWithFormat:@"欢迎: %@",[UserShareOnce shareOnce].wxName] ;
        }else{
            dispalyName = [NSString stringWithFormat:@"欢迎：%@", [MemberUserShance shareOnce].name];
        }
    }else  if([UserShareOnce shareOnce].wxName&&[UserShareOnce shareOnce].wxName.length!=0&&![[UserShareOnce shareOnce].wxName isKindOfClass:[NSNull class]]){
        dispalyName = [NSString stringWithFormat:@"欢迎: %@",[UserShareOnce shareOnce].wxName] ;
    }
    if (![GlobalCommon stringEqualNull:[UserShareOnce shareOnce].name]) {
        dispalyName = [UserShareOnce shareOnce].name;
    }else{
        dispalyName = [UserShareOnce shareOnce].username;
    }
    if(![GlobalCommon stringEqualNull:[UserShareOnce shareOnce].wxName]){
        dispalyName = [UserShareOnce shareOnce].wxName;
    }
    UILabel *userName = [Tools creatLabelWithFrame:CGRectMake(userIcon.right+20, userIcon.top+10, 130, 20) text:dispalyName textSize:14];
    userName.textColor = [UIColor whiteColor];;
    [imageView addSubview:userName];
    
    //显示子账户名字
    NSMutableString *memberStr = [[NSMutableString alloc] init];
    NSArray *member = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberChirldArr"];
    for (NSData *data in member) {
        ChildMemberModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (model.name.length > 26) {
            model.name = [UserShareOnce shareOnce].wxName;
        }
        [memberStr appendFormat:@",%@",model.name];
    }
    if(![GlobalCommon stringEqualNull:memberStr]){
        [memberStr deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    NSString *childStr = [NSString stringWithFormat:@"家庭成员: %@",memberStr];
    UILabel *memberLabel = [Tools labelWith:childStr frame:CGRectMake(userName.left, userName.bottom+5, ScreenWidth-105, 20) textSize:14 textColor:[UIColor whiteColor] lines:1 aligment:NSTextAlignmentLeft];
    [imageView addSubview:memberLabel];
    
}

# pragma mark - 点击头像或者登陆按钮
-(void)loginClick{
    PersonalInformationViewController * personInfoView=[[PersonalInformationViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:personInfoView];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 点击全部订单、待付款、待评价
-(void)MyBTnClick:(UIButton *)button{
    
    NSString *urlStr =  @"";
    NSString *titleStr = @"";
    switch (button.tag - 666) {
        case 0:
            titleStr = @"全部订单";
            urlStr = [NSString stringWithFormat:@"%@member/mobile/order/list.jhtml?type=all",URL_PRE];
            break;
        case 1:
            titleStr = @"待付款";
            urlStr = [NSString stringWithFormat:@"%@member/mobile/order/list.jhtml?type=unpaid",URL_PRE];
            break;
        case 2:
            titleStr = @"待评价";
            urlStr = [NSString stringWithFormat:@"%@member/mobile/order/list.jhtml?type=completed",URL_PRE];
            break;
        default:
            break;
    }
    EDWKWebViewController *vc = [[EDWKWebViewController alloc] initWithUrlString:urlStr];
    vc.isCollect = YES;
    vc.titleStr = titleStr;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    /*
    HeChangPackgeController *vc = [[HeChangPackgeController alloc] init];
    vc.noWebviewBack = YES;
    vc.progressType = progress2;
    switch (button.tag - 666) {
        case 0:
            vc.titleStr = @"全部订单";
            vc.urlStr = [NSString stringWithFormat:@"%@member/mobile/order/list.jhtml?type=all",URL_PRE];
            break;
        case 1:
            vc.titleStr = @"待付款";
            vc.urlStr = [NSString stringWithFormat:@"%@member/mobile/order/list.jhtml?type=unpaid",URL_PRE];
            break;
        case 2:
            vc.titleStr = @"待评价";
            vc.urlStr = [NSString stringWithFormat:@"%@member/mobile/order/list.jhtml?type=completed",URL_PRE];
            break;
        default:
            break;
    }
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
     */
}

#pragma mark  -------  UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return listNamesArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    MineCell *cell = (MineCell *)[tableView dequeueReusableCellWithIdentifier:@"kCELLID22"];
    if(cell == nil){
        cell = [[MineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kCELLID22"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    cell.iconImage.image = [UIImage imageNamed:listImagesArr[indexPath.row]];
    cell.titleLabel.text = listNamesArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    switch (indexPath.row) {
        case 0:
        {
           
                HeChangPackgeController *vc = [[HeChangPackgeController alloc] init];
                vc.noWebviewBack = YES;
                vc.progressType = progress2;
                vc.titleStr = @"退款记录";
                vc.urlStr = [NSString stringWithFormat:@"%@member/mobile/returns/list_refunds.jhtml",URL_PRE];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            
            
        }
            
            break;
        case 1:
        {
            
                HeChangPackgeController *vc = [[HeChangPackgeController alloc] init];
                vc.noWebviewBack = YES;
                vc.progressType = progress2;
                vc.titleStr = @"退货记录";
                vc.urlStr = [NSString stringWithFormat:@"%@member/mobile/returns/list_returns.jhtml",URL_PRE];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            
            
        }
            break;
        case 2:
        {
            BlockViewController *vc = [[BlockViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
            
            
        }
            break;
        case 3:
        {
            HeChangPackgeController *vc = [[HeChangPackgeController alloc] init];
            vc.noWebviewBack = YES;
            vc.progressType = progress2;
            vc.titleStr = @"我的积分";
            vc.urlStr = [NSString stringWithFormat:@"%@member/mobile/order/pointList.jhtml",URL_PRE];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }
            break;
        case 4:
        {
            FamilyViewController *vc = [[FamilyViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 5:
        {
            HealthLectureOrderViewController *healthOrder = [[HealthLectureOrderViewController alloc] init];
            healthOrder.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:healthOrder animated:YES];
            
            
        }
            break;
        case 6:{
            LeMedicineViewController *vc = [[LeMedicineViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 7:{
            SportDemonstratesViewController *vc = [[SportDemonstratesViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 8:
        {
            WenYinFileViewController *vc = [[WenYinFileViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 8+1:
        {
            MyAvdisorysViewController *vc = [[MyAvdisorysViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 9+1:
        {
            HeChangPackgeController *vc = [[HeChangPackgeController alloc] init];
            vc.noWebviewBack = YES;
            vc.progressType = progress2;
            vc.titleStr = @"收货地址";
            vc.urlStr = [NSString stringWithFormat:@"%@member/mobile/order/receiverlist.jhtml",URL_PRE];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 10+1:
        {
            FeedbackViewController *vc = [[FeedbackViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 11+1:
        {
            NSString *urlStr =  [NSString stringWithFormat:@"%@member/mobile/focus_ware/list.jhtml",URL_PRE];
            EDWKWebViewController *vc = [[EDWKWebViewController alloc] initWithUrlString:urlStr];
            vc.isCollect = YES;
            vc.titleStr = @"收藏";
            //            HeChangPackgeController *vc = [[HeChangPackgeController alloc] init];
            //            vc.noWebviewBack = YES;
            //            vc.progressType = progress2;
            //            vc.titleStr = @"收藏";
            //            vc.urlStr = [NSString stringWithFormat:@"%@member/mobile/focus_ware/list.jhtml",URL_PRE];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 12+1:
        {
            SetupController *vc = [[SetupController alloc] init];
            CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:vc];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:nav animated:YES completion:nil];
            });
            
        }
            break;
        case 16+1:
        {
            NSString *urlStr =  [NSString stringWithFormat:@"%@member/mobile/focus_ware/list.jhtml",URL_PRE];
            EDWKWebViewController *vc = [[EDWKWebViewController alloc] initWithUrlString:urlStr];
            vc.isCollect = YES;
            vc.titleStr = @"收藏";
//            HeChangPackgeController *vc = [[HeChangPackgeController alloc] init];
//            vc.noWebviewBack = YES;
//            vc.progressType = progress2;
//            vc.titleStr = @"收藏";
//            vc.urlStr = [NSString stringWithFormat:@"%@member/mobile/focus_ware/list.jhtml",URL_PRE];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 17+1:
        {
            SetupController *vc = [[SetupController alloc] init];
            CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:vc];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:nav animated:YES completion:nil];
            });
            
        }
            break;
        default:
            break;
    }
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
