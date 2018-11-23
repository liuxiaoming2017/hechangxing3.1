//
//  PrivateServiceViewController.m
//  
//
//  Created by ZhangYunguang on 15/11/25.
//
//

#import "PrivateServiceViewController.h"
#import "LoginViewController.h"
#import "BoundBlockViewController.h"
#import "PrivateServiceModel.h"
#import "SelectedAdvisorModel.h"
#import "PrivateCheckViewController.h"
#import "PrivateDoctorListViewController.h"

#define kSERVICE_LEVEL    @"/member/healthAdvisor/serviceLevelList.jhtml"  /* 用户星级 */
#define kADVISOR_CAREGOTY @"/member/healthAdvisor/categoryList.jhtml"      /* 顾问分类 */
#define kSELECTED_ADVISOR @"/member/healthAdvisor/getAdvisor.jhtml"        /* 已选顾问 */
#define kHEALTH_HINT      @"/member/healthAdvisor/healthTipList.jhtml"     /* 健康提示 */

#define kHINT_STRING @"您现在还没有选择私人医生，选择后私人医生回根据您的健康辨识报告给予合理的健康提示。"
#define kCELL @"cell"

@interface PrivateServiceViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_cateDataArr;
    NSMutableArray *_selectedDataArr;
    BOOL _isAdvisorDone;
    BOOL _isSelectedDone;
    BOOL _isExecuted;
    
    UITableView *_tableView;
    //NSMutableArray *_dataArr;
}
@property (nonatomic,retain) NSMutableArray *cateDataArr;
@property (nonatomic,retain) NSMutableArray *selectedDataArr;
@property (nonatomic,assign) BOOL isAdvisorDone; //顾问数据请求完成
@property (nonatomic,assign) BOOL isSelectedDone;//已选顾问请求完成
@property (nonatomic,assign) BOOL isExecuted;    //界面已经创建

@property (nonatomic,retain) UITableView *tableView;
//@property (nonatomic,retain) NSMutableArray *dataArr;
@end

@implementation PrivateServiceViewController
#pragma mark-dealloc
- (void)dealloc
{
    [self.cateDataArr release];
    [self.selectedDataArr release];
    [self.tableView release];
//    [self.dataArr release];
    [super dealloc];
}
#pragma mark-viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navTitleLabel.text = @"健康顾问团队";
    [self initWithData];
    
    //请求星级数据
    [ZYGASINetworking GET_Path:kSERVICE_LEVEL completed:^(id JSON, NSString *stringData) {
        //请求成功
        NSLog(@"服务等级数据： %@",JSON);
        if ([JSON[@"status"] integerValue] == 44) {
//            LoginViewController *login = [[LoginViewController alloc] init];
//            [self.navigationController pushViewController:login animated:YES];
//            [login release];
        }else if ([JSON[@"status"] integerValue] == 100){
            if (JSON[@"data"] != [NSNull null]) {
                if ([JSON[@"data"] count]) {
                    //已绑定现金卡
                    NSDictionary *dataDic = JSON[@"data"];
                    [self initWithCardWith:dataDic];
                }else{
                    //未绑定现金卡
                    [self initControllerWithoutCard];
                }
            }else{
                //未绑定现金卡
                [self initControllerWithoutCard];
            }
            
        }
        
    } failed:^(NSError *error) {
        //请求失败
        NSLog(@"服务等级数据请求失败%@",error);
        
    }];
    
}
//-(void)backClick:(UIButton *)button{
//    [self.navigationController popViewControllerAnimated:YES];
//}

#pragma mark-初始化数据
-(void)initWithData{
    self.cateDataArr = [[NSMutableArray alloc] init];
    self.selectedDataArr = [[NSMutableArray alloc] init];
//    self.dataArr = [[NSMutableArray alloc] init];
    _isAdvisorDone = NO;
    _isSelectedDone = NO;
    _isExecuted = NO;
}
#pragma mark-无现金卡界面
-(void)initControllerWithoutCard{
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, kNavBarHeight+5, ScreenWidth, 42)];
    view.backgroundColor = [Tools colorWithHexString:@"#efeff4"];
    [self.view addSubview:view];
    
    NSMutableAttributedString *strContent = [[NSMutableAttributedString alloc] initWithString:@"星级：未绑定卡号"];
    UILabel *starLabel = [Tools labelWith:nil frame:CGRectMake(20, 14, 150, 14) textSize:12 textColor:[Tools colorWithHexString:@"#666666"] lines:1 aligment:NSTextAlignmentLeft];
    
    [strContent addAttribute:NSForegroundColorAttributeName value:[Tools colorWithHexString:@"#37befd"] range:NSMakeRange(3, 5)];
    starLabel.attributedText = strContent;
    [strContent release];
    [view addSubview:starLabel];
    [view release];
    
    
    UIButton *iconBtn = [Tools creatButtonWithFrame:CGRectMake(ScreenWidth
                                                               /2-40, 161, 80, 80) target:self sel:@selector(iconClick:) tag:11 image:@"添加现金卡头像" title:nil];
    [self.view addSubview:iconBtn];
    UIButton *bandCardBtn = [Tools creatButtonWithFrame:CGRectMake(ScreenWidth
                                                                   /2-70, 261, 140, 10) target:self sel:@selector(iconClick:) tag:12 image:@"" title:@"请绑定您的会员卡"];
    [bandCardBtn setTitleColor:[Tools colorWithHexString:@"#37befd"] forState:UIControlStateNormal];
    bandCardBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:bandCardBtn];
    
    UIImageView *lineView = [Tools creatImageViewWithFrame:CGRectMake(0, 321, ScreenWidth, 8) imageName:@"healthLec"];
    [self.view addSubview:lineView];
    
    UILabel *hintLabel = [Tools labelWith:@"医生提示：" frame:CGRectMake(20, 349, 80, 10) textSize:14 textColor:[Tools colorWithHexString:@"#37befd"] lines:1 aligment:NSTextAlignmentLeft];
    [self.view addSubview:hintLabel];
    
    UILabel *label = [Tools labelWith:kHINT_STRING frame:CGRectMake(20, 379, ScreenWidth-40, 50) textSize:14 textColor:[Tools colorWithHexString:@"#666666"] lines:0 aligment:NSTextAlignmentLeft];
    [self.view addSubview:label];
    
}

-(void)iconClick:(UIButton *)button{
    BoundBlockViewController *bound = [[BoundBlockViewController alloc] init];
    [self.navigationController pushViewController:bound animated:YES];
    [bound release];
}

#pragma mark- 有现金卡界面
-(void)initWithCardWith:(NSDictionary*)dic{
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, kNavBarHeight+5, ScreenWidth, 42)];
    view.backgroundColor = [Tools colorWithHexString:@"#efeff4"];
    [self.view addSubview:view];
    
    UILabel *starLabel = [Tools labelWith:@"星级：" frame:CGRectMake(20, 14, 45, 14) textSize:12 textColor:[Tools colorWithHexString:@"#666666"] lines:1 aligment:NSTextAlignmentLeft];
    [view addSubview:starLabel];
    
    
    for (int i=0; i<5; i++) {
        UIImageView *darkStar = [Tools creatImageViewWithFrame:CGRectMake(60+15*i, 14, 10, 10) imageName:@"星星_未点亮"];
        [view addSubview:darkStar];
    }
    int level = [dic[@"order"] intValue];
    for (int j=0; j<level; j++) {
        UIImageView *lightStar = [Tools creatImageViewWithFrame:CGRectMake(60+15*j, 14, 10, 10) imageName:@"星星_点亮"];
        [view addSubview:lightStar];
    }
    [view release];
    
    [ZYGASINetworking GET_Path:kADVISOR_CAREGOTY completed:^(id JSON, NSString *stringData) {
        NSLog(@"顾问分类数据请求成功%@",JSON);
        NSArray *data = JSON[@"data"];
        for (NSDictionary *dic in data) {
            PrivateServiceModel *model = [[PrivateServiceModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.cateDataArr addObject:model];
            [model release];
        }
        _isAdvisorDone = YES;
        if (_isSelectedDone && !_isExecuted) {
            [self createAdvisorView];
        }
    } failed:^(NSError *error) {
        NSLog(@"顾问分类数据请求错误：%@",error);
    }];
    
    [ZYGASINetworking GET_Path:kSELECTED_ADVISOR completed:^(id JSON, NSString *stringData) {
        NSLog(@"已选择顾问数据请求成功：%@",JSON);
        NSArray *data = JSON[@"data"];
        for (NSDictionary *dic in data) {
            SelectedAdvisorModel *model = [[SelectedAdvisorModel alloc] init];
            model.id = dic[@"id"];
            model.order = dic[@"order"];
            model.name = dic[@"name"];
            model.gender = dic[@"gender"];
            model.graduated = dic[@"graduated"];
            model.rank = dic[@"rank"];
            model.level= dic[@"level"];
            model.skill = dic[@"skill"];
            model.image = dic[@"image"];
            model.advisorCategory = dic[@"advisorCategory"];
            model.serviceLevel = dic[@"serviceLevel"];
            model.serviceNum = dic[@"serviceNum"];
            model.servicedNum = dic[@"servicedNum"];
            model.serviceOrder = dic[@"serviceOrder"];
            //[model setValuesForKeysWithDictionary:dic];
            [self.selectedDataArr addObject:model];
        }
        _isSelectedDone = YES;
        if (_isAdvisorDone && !_isExecuted) {
            [self createAdvisorView];
        }
    } failed:^(NSError *error) {
        NSLog(@"已选择顾问数据请求错误：%@",error);
    }];
    
}

-(void)createAdvisorView{
    _isExecuted = YES;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 111, ScreenWidth, 181) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCELL];
    
    UIImageView *lineView = [Tools creatImageViewWithFrame:CGRectMake(0, 293, ScreenWidth, 8) imageName:@"私人服务_line"];
    [self.view addSubview:lineView];
    UILabel *hintLabel = [Tools labelWith:@"医生提示：" frame:CGRectMake(20, 321, 80, 10) textSize:14 textColor:[Tools colorWithHexString:@"#37befd"] lines:1 aligment:NSTextAlignmentLeft];
    [self.view addSubview:hintLabel];
    //获取健康提示
    [ZYGASINetworking GET_Path:kHEALTH_HINT completed:^(id JSON, NSString *stringData) {
        NSLog(@"健康提示数据获取成功：%@",JSON);
        
        /*********************** 待处理 **************************/
        
        
        NSDictionary *dataDic = JSON[@"data"];
        NSArray *content = dataDic[@"content"];
        if (content.count < 1) {
            UILabel *tip = [Tools labelWith:@"暂时没有健康提示" frame:CGRectMake(40, 320, ScreenWidth-40,80) textSize:12 textColor:[Tools colorWithHexString:@"#747474"] lines:1 aligment:NSTextAlignmentLeft];
            [self.view addSubview:tip];
            return;
            
        }else{
            
            UILabel *hintLabel = [Tools labelWith:content[0][@"content"] frame:CGRectMake(20, 351, ScreenWidth-40, 10) textSize:13 textColor:[Tools colorWithHexString:@"#666666"] lines:0 aligment:NSTextAlignmentLeft];
            //动态计算label的高度
            CGRect tmpRect = [hintLabel.text boundingRectWithSize:CGSizeMake(ScreenWidth-40, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:hintLabel.font,NSFontAttributeName, nil] context:nil];
            CGFloat labelH = tmpRect.size.height;
            [hintLabel setFrame:CGRectMake(40, 351, ScreenWidth-40,labelH)];
            [self.view addSubview:hintLabel];
            
            NSString *time1 = [Tools timeYMDStringFrom:[content[0][@"modifyDate"] doubleValue]];
            NSString *time2 = [Tools timeHMStringFrom:[content[0][@"modifyDate"] doubleValue]];
            UILabel *dateLabel = [Tools labelWith:[NSString stringWithFormat:@"%@  %@",time1,time2] frame:CGRectMake(20, 351, ScreenWidth-40, 10) textSize:13 textColor:[Tools colorWithHexString:@"#666666"] lines:0 aligment:NSTextAlignmentLeft];
            
            [dateLabel setFrame:CGRectMake(ScreenWidth - 130, CGRectGetMaxY(hintLabel.frame) + 10, 130,labelH)];
            [self.view addSubview:dateLabel];
        }
    } failed:^(NSError *error) {
        NSLog(@"健康提示数据获取失败：%@",error);
    }];
}
#pragma mark-tableView Delegate相关
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.cateDataArr.count) {
        return self.cateDataArr.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45.25;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCELL];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCELL];
    }
    PrivateServiceModel *serviceModel = self.cateDataArr[indexPath.row];
    for (UIView *view in cell.subviews) {
        [view removeFromSuperview];
    }
    UILabel *titleLabel = [Tools labelWith:[NSString stringWithFormat:@"%@：",serviceModel.name] frame:CGRectMake(20, 13.625, 75, 18) textSize:14 textColor:[Tools colorWithHexString:@"#666666"] lines:1 aligment:NSTextAlignmentLeft];
    [cell addSubview:titleLabel];
    if (self.selectedDataArr.count) {//有已经选择的私人服务
        for (int i=0; i<self.selectedDataArr.count; i++) {
            SelectedAdvisorModel *advisorModel = self.selectedDataArr[i];
            if ([serviceModel.name isEqualToString:advisorModel.advisorCategory]) {
                //已经选择的服务
                UILabel *nameLabel = [Tools labelWith:advisorModel.name frame:CGRectMake(100, 13.625, 50, 18) textSize:14 textColor:[Tools colorWithHexString:@"#333"] lines:1 aligment:NSTextAlignmentLeft];
                [cell addSubview:nameLabel];
                UIButton *checkBtn = [Tools creatButtonWithFrame:CGRectMake(ScreenWidth-45-48.6*2, 13.625, 48.6, 18) target:self sel:@selector(checkBtnClick:) tag:11+i image:@"私人医生_查看" title:nil];
                [cell addSubview:checkBtn];
                UIButton *changeBtn = [Tools creatButtonWithFrame:CGRectMake(ScreenWidth-19-48.6, 13.625, 48.6, 18) target:self sel:@selector(addBtnClick:) tag:12+indexPath.row+50 image:@"私人医生_更改" title:nil];
                [cell addSubview:changeBtn];
                
                break;
            }else if (i == self.selectedDataArr.count-1){
                //未选择的服务
                UILabel *statusLabel = [Tools labelWith:@"未添加" frame:CGRectMake(100, 13.625, 50, 18) textSize:14 textColor:[Tools colorWithHexString:@"#37befd"] lines:1 aligment:NSTextAlignmentLeft];
                [cell addSubview:statusLabel];
                UIButton *addBtn = [Tools creatButtonWithFrame:CGRectMake(ScreenWidth-19-48.6, 13.625, 48.6, 18) target:self sel:@selector(addBtnClick:) tag:12+indexPath.row+50 image:@"私人医生_添加" title:nil];
                [cell addSubview:addBtn];
            }
        }
    }else{//用户没有选择私人服务
        UILabel *statusLabel = [Tools labelWith:@"未添加" frame:CGRectMake(100, 13.625, 50, 18) textSize:14 textColor:[Tools colorWithHexString:@"#37befd"] lines:1 aligment:NSTextAlignmentLeft];
        [cell addSubview:statusLabel];
        UIButton *addBtn = [Tools creatButtonWithFrame:CGRectMake(ScreenWidth-19-48.6, 13.625, 48.6, 18) target:self sel:@selector(addBtnClick:) tag:12+indexPath.row+50 image:@"私人医生_添加" title:nil];
        [cell addSubview:addBtn];
    }
    
    return cell;
}
    
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return;
}
#pragma mark-查看按钮
-(void)checkBtnClick:(UIButton *)button{
    PrivateCheckViewController *check = [[PrivateCheckViewController alloc] init];
    SelectedAdvisorModel *selectedModel = self.selectedDataArr[button.tag-11];
    check.model = selectedModel;
    [self.navigationController pushViewController:check animated:YES];
    [check release];
    
}
//#pragma mark-更改按钮
//-(void)changeBtnClick:(UIButton *)button{
//    PrivateDoctorListViewController *doctor = [[PrivateDoctorListViewController alloc] init];
//    doctor.requestType = @"change";
//    
//    
//    [self.navigationController pushViewController:doctor animated:YES];
//    [doctor release];
//}
#pragma mark-添加按钮
-(void)addBtnClick:(UIButton *)button{
    PrivateServiceModel *model = self.cateDataArr[button.tag-12-50];
    PrivateDoctorListViewController *doctor = [[PrivateDoctorListViewController alloc] init];
    doctor.categoryId = model.id;
    doctor.userlLevel = model.order;
    [self.navigationController pushViewController:doctor animated:YES];
    [doctor release];
}
#pragma mark-viewWiiDisappear
-(void)viewWillDisappear:(BOOL)animated{
    _isAdvisorDone = NO;
    _isSelectedDone = NO;
    _isExecuted = NO;
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
