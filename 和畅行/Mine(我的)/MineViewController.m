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
#import "BlockViewController.h"
#import "FamilyViewController.h"
#import "HealthLectureOrderViewController.h"
#import "CustomNavigationController.h"


#import "MyAvdisorysViewController.h"
#import "SetupController.h"
#import "EDWKWebViewController.h"


@interface MineViewController ()<UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *listNamesArr;
@property (nonatomic,strong) NSArray *listImagesArr;
@property (nonatomic,strong) MyView *userIcon;
@property (nonatomic,strong) UILabel *userNameLabel;
@property (nonatomic,strong) UIScrollView *backScrollView;
@property (nonatomic,strong) UIButton *collectBT;
@property (nonatomic,strong) UIButton *cardBT;
@property (nonatomic,strong) UIButton *integralsBT;
@property (nonatomic,strong) NSMutableArray *buttonArray;

@end

@implementation MineViewController
@synthesize listNamesArr,listImagesArr;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(253, 253, 253);
    self.topView.hidden = YES;
    self.buttonArray = [NSMutableArray array];
    self.startTimeStr = [GlobalCommon getCurrentTimes];
    [self createUI];
    [self changUserInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSize:) name:@"CHANGESIZE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changUserInfo) name:@"personalInfoUpdateSuccess" object:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestData];
    NSLog(@"%@",[UserShareOnce shareOnce].memberImage);
    if([[UserShareOnce shareOnce].memberImage isKindOfClass:[NSNull class]]){
        self.userIcon.image = [UIImage imageNamed:@"1我的_03"];
    }else{
        [self.userIcon sd_setImageWithURL:[NSURL URLWithString:[UserShareOnce shareOnce].memberImage] placeholderImage:[UIImage imageNamed:@"1我的_03"]];
    }
    
//    NSString *path = [ NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//    NSString *folderPath = [path stringByAppendingPathComponent:@"musicCache"];
//    NSLog(@"%fM",[GlobalCommon sizeAtPath:folderPath]);
    
    
}

-(void)requestData{
    
    NSString *uidStr = [UserShareOnce shareOnce].uid;
    NSString *memerIdStr = [NSString stringWithFormat:@"%@",[MemberUserShance shareOnce].idNum];
    NSString *url = [NSString stringWithFormat:@"member/mobile/focus_ware/getAmount.jhtml?memberChildId=%@&&memberId=%@",memerIdStr,uidStr];
    [[NetworkManager sharedNetworkManager] requestWithType:0 urlString:url parameters:nil successBlock:^(id response) {
        
        if ([response[@"status"] integerValue] == 100){
            NSDictionary *dic = response[@"data"];
            NSString *integralsStr = [NSString stringWithFormat:@"%@",dic[@"integrals"]];
            NSString *cardStr = [NSString stringWithFormat:@"%@",dic[@"card"]];
            NSString *collectStr = [NSString stringWithFormat:@"%@",dic[@"collect"]];
            if(![GlobalCommon  stringEqualNull:integralsStr]){
                [self.integralsBT setTitle:[NSString stringWithFormat:@"%@\n%@",dic[@"integrals"],ModuleZW(@"积分")] forState:(UIControlStateNormal)];
            }
            if(![GlobalCommon  stringEqualNull:cardStr]){
                [self.cardBT setTitle:[NSString stringWithFormat:@"%@\n%@",dic[@"card"],ModuleZW(@"卡包")] forState:(UIControlStateNormal)];
            }
            if(![GlobalCommon  stringEqualNull:collectStr]){
                [self.collectBT setTitle:[NSString stringWithFormat:@"%@\n%@",dic[@"collect"],ModuleZW(@"收藏")] forState:(UIControlStateNormal)];
            }

        }
        
        
    } failureBlock:^(NSError *error) {
        
        
    }];
    
}

- (void)createUI
{
    
    NSArray *numberArray = @[[NSString stringWithFormat:@"0\n%@",ModuleZW(@"收藏")],
                                              [NSString stringWithFormat:@"0\n%@",ModuleZW(@"卡包")],
                                              [NSString stringWithFormat:@"0\n%@",ModuleZW(@"积分")]];
    NSArray *titleArr           = @[@"待付款",@"待评价",
                                    @"退款/售后",@"全部订单"];
    NSArray *imageArr        = @[@"我的待付款",@"我的待评价",@"我的退款售后",@"我的全部订单"];
    //listNamesArr                  = @[@"咨询记录",@"地址管理",@"运动示范音",@"设置"];
    if(FIRST_FLAG){
       listNamesArr                  = @[@"咨询记录",@"地址管理",@"设置"];
    }else{
        listNamesArr                  = @[@"咨询记录",@"卡包",@"设置"];
    }
    
    UIScrollView *backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake( 0,-kStatusBarHeight, ScreenWidth, ScreenHeight+kStatusBarHeight - kTabBarHeight )];
    backScrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backScrollView];
    self.backScrollView = backScrollView;
    
    //顶部蓝色背景
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, Adapter(224)+kNavBarHeight)];
    if(!FIRST_FLAG){
        backImageView.height = Adapter(154)+kNavBarHeight;
    }
    backImageView.tag = 1000;
    backImageView.backgroundColor = RGB_ButtonBlue;
    backImageView.userInteractionEnabled = YES;
    [self insertSublayerWithImageView:backImageView];
    [backScrollView addSubview:backImageView];
    
    //头像
    MyView *userIcon = [[MyView alloc] initWithFrame:CGRectMake(ScreenWidth/2 - Adapter(35),kNavBarHeight, Adapter(70), Adapter(70))];
    if([[UserShareOnce shareOnce].memberImage isKindOfClass:[NSNull class]]){
        userIcon.image = [UIImage imageNamed:@"1我的_03"];
    }else{
        [userIcon sd_setImageWithURL:[NSURL URLWithString:[UserShareOnce shareOnce].memberImage] placeholderImage:[UIImage imageNamed:@"1我的_03"]];
    }
    userIcon.clipsToBounds = YES;
    userIcon.layer.cornerRadius = userIcon.frame.size.width/2;
    userIcon.layer.borderWidth = 1.0f;
    userIcon.layer.borderColor = [UIColor whiteColor].CGColor;
    [userIcon addTarget:self action:@selector(loginClick)];
    [backImageView addSubview:userIcon];
    self.userIcon = userIcon;
    
    NSString *dispalyName = [NSString string];
    if ([MemberUserShance shareOnce].name.length <  26) {
        dispalyName = [MemberUserShance shareOnce].name;
    }else{
        dispalyName = [UserShareOnce shareOnce].wxName;
    }
    if(![GlobalCommon stringEqualNull:[UserShareOnce shareOnce].name]&&[UserShareOnce shareOnce].name.length < 26){
        dispalyName = [UserShareOnce shareOnce].name;
    }
    UILabel *userName = [Tools creatLabelWithFrame:CGRectMake(Adapter(40), userIcon.bottom + Adapter(20), ScreenWidth - Adapter(80), Adapter(30)) text:dispalyName textSize:22];
    userName.textColor = [UIColor whiteColor];
    userName.textAlignment = NSTextAlignmentCenter;
    [backImageView addSubview:userName];
    self.userNameLabel = userName;
    
    //e(15 , backImageView.bottom-, ScreenWidth-35, 70)

    
    CGFloat marginBottom = FIRST_FLAG ? Adapter(60) : Adapter(25);
    
    UIImageView *buttonBackImageView = [[UIImageView alloc]initWithFrame:CGRectMake(Adapter(15), backImageView.bottom+ marginBottom, ScreenWidth - Adapter(30), listNamesArr.count*Adapter(58))];
//    UIImageView *buttonBackImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, backImageView.bottom+ 60, ScreenWidth - 30, listNamesArr.count*58)];
    buttonBackImageView.backgroundColor = [UIColor whiteColor];
    buttonBackImageView.userInteractionEnabled = YES;
    buttonBackImageView.layer.cornerRadius = Adapter(10);
    buttonBackImageView.layer.masksToBounds = YES;
    [backScrollView addSubview:buttonBackImageView];
    [self insertSublayerWithImageView:buttonBackImageView];
    
    backScrollView.contentSize = CGSizeMake(0, buttonBackImageView.bottom + Adapter(20));
    
if(FIRST_FLAG){ //英文版没有
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(Adapter(15) , backImageView.bottom-Adapter(35), ScreenWidth-Adapter(35), Adapter(70))];
    imageV.layer.cornerRadius = Adapter(10.0);
    imageV.userInteractionEnabled = YES;
    imageV.layer.masksToBounds = YES;
    imageV.backgroundColor = [UIColor whiteColor];
    [backScrollView addSubview:imageV];
    [self insertSublayerWithImageView:imageV];
    
    for (int i=0; i<titleArr.count; i++) {
        
        if (i < numberArray.count){
            UIButton *numberButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
            numberButton.frame = CGRectMake(Adapter(15) + (ScreenWidth - Adapter(30))*i/3, userName.bottom + Adapter(10), (ScreenWidth - Adapter(30))/3, Adapter(50));
            [numberButton setTitle:numberArray[i] forState:(UIControlStateNormal)];
            [numberButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            [numberButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [numberButton.titleLabel setTextAlignment:(NSTextAlignmentCenter)];
            [numberButton.titleLabel setNumberOfLines:2];
            numberButton.tag = 111 + i;
            if(i== 0){
                self.collectBT = numberButton;
            }else if(i == 1) {
                self.cardBT = numberButton;
            }else{
                self.integralsBT = numberButton;
            }
            [self.self.buttonArray addObject:numberButton];
            [[numberButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                if(x.tag == 111){
                    NSString *urlStr =  [NSString stringWithFormat:@"%@member/mobile/focus_ware/list.jhtml",URL_PRE];
                    EDWKWebViewController *vc = [[EDWKWebViewController alloc] initWithUrlString:urlStr];
                    vc.isCollect = YES;
                    vc.pageIDStr = @"36";
                    vc.startTimeStr = self.startTimeStr;
                    vc.titleStr =ModuleZW( @"收藏");
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }else  if(x.tag == 112){
                    BlockViewController *vc = [[BlockViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    HeChangPackgeController *vc = [[HeChangPackgeController alloc] init];
                    vc.noWebviewBack = YES;
                    vc.progressType = progress2;
                    vc.titleStr = ModuleZW(@"我的积分");
                    vc.urlStr = [NSString stringWithFormat:@"%@member/mobile/order/pointList.jhtml",URL_PRE];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }];
            [backImageView addSubview:numberButton];
        }
        if(i < titleArr.count){
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            button.frame = CGRectMake(imageV.width*i/titleArr.count , 0, imageV.width/titleArr.count, imageV.height);
            [self.buttonArray addObject:button];
            UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(imageV.width*(2*i+1)/8 -ScreenWidth*0.03,Adapter(10), Adapter(20),Adapter(20))];
            iconImageView.image = [UIImage imageNamed:imageArr[i]];
            iconImageView.userInteractionEnabled = YES;
            [imageV addSubview:iconImageView];
            
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 + imageV.width*i/titleArr.count , iconImageView.bottom , imageV.width/titleArr.count, imageV.height - Adapter(16) - iconImageView.height)];
            titleLabel.text = ModuleZW(titleArr[i]);
            titleLabel.textAlignment =NSTextAlignmentCenter;
            titleLabel.textColor = UIColorFromHex(0X7f7f7f);
            titleLabel.numberOfLines = 2;
            if (ISPaid) {
                titleLabel.font = [UIFont systemFontOfSize:15/[UserShareOnce shareOnce].multipleFontSize];
            }else{
                titleLabel.font = [UIFont systemFontOfSize:14/[UserShareOnce shareOnce].fontSize];
            }
            [imageV addSubview:titleLabel];
            
            
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                
                NSString *urlStr =  @"";
                NSString *titleStr = @"";
                NSString *pageIDStr = @"";
                switch (i) {
                    case 0:
                        pageIDStr = @"39";
                        titleStr = ModuleZW(@"待付款");
                        urlStr = [NSString stringWithFormat:@"%@member/mobile/order/list.jhtml?type=unpaid",URL_PRE];
                        break;
                    case 1:
                        pageIDStr = @"40";
                        titleStr = ModuleZW( @"待评价");
                        urlStr = [NSString stringWithFormat:@"%@member/mobile/order/list.jhtml?type=completed",URL_PRE];
                        break;
                    case 2:
                        pageIDStr = @"41";
                        titleStr = ModuleZW( @"退款记录");
                        urlStr = [NSString stringWithFormat:@"%@member/mobile/order/list.jhtml?type=refund&",URL_PRE];
                        break;
                    case 3:
                        pageIDStr = @"42";
                        titleStr = ModuleZW(@"全部订单");
                        urlStr = [NSString stringWithFormat:@"%@member/mobile/order/list.jhtml?type=all",URL_PRE];
                        break;
                    default:
                        break;
                }
                EDWKWebViewController *vc = [[EDWKWebViewController alloc] initWithUrlString:urlStr];
                vc.isCollect = YES;
                vc.titleStr = titleStr;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }];
            [imageV addSubview:button];
        }
    }
} ////英文版没有
    
    
    for (int i=0; i<listNamesArr.count; i++) {
        
        UIButton *bottomButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        //bottomButton.frame = CGRectMake(Adapter(20), buttonBackImageView.height/listNamesArr.count*i,ScreenWidth - Adapter(40), Adapter(58));
        bottomButton.frame = CGRectMake(Adapter(20), buttonBackImageView.height/listNamesArr.count*i,ScreenWidth - Adapter(40), Adapter(58));
        [bottomButton setTitle:ModuleZW(listNamesArr[i]) forState:(UIControlStateNormal)];
        [bottomButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [bottomButton setTitleColor: UIColorFromHex(0x8e8e93) forState:(UIControlStateNormal)];
        [bottomButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -bottomButton.currentImage.size.width,0,0)];
        [bottomButton.titleLabel setFrame:bottomButton.bounds];
        [bottomButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        UIImageView *goImageView= [[UIImageView alloc]initWithFrame:CGRectMake(bottomButton.width - Adapter(25), bottomButton.height/2 - ScreenWidth*0.026, ScreenWidth*0.026, ScreenWidth*0.052)];
        goImageView.image = [UIImage imageNamed:@"1我的_09"];
        goImageView.userInteractionEnabled = YES;
        [bottomButton addSubview:goImageView];
        [self.buttonArray addObject:bottomButton];
        [[bottomButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            switch (i) {
//                case 0: {
//                    [self showAlertWarmMessage:ModuleZW(@"尚未开放...")];
//                }
//                    break;
                case 0: {
                    MyAvdisorysViewController *vc = [[MyAvdisorysViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 1: {
                    if(FIRST_FLAG){
                        HeChangPackgeController *vc = [[HeChangPackgeController alloc] init];
                        vc.noWebviewBack = YES;
                        vc.progressType = progress2;
                        vc.titleStr = ModuleZW(@"收货地址");
                        vc.urlStr = [NSString stringWithFormat:@"%@member/mobile/order/receiverlist.jhtml",URL_PRE];
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    }else{
                        BlockViewController *vc = [[BlockViewController alloc] init];
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    
                }
                    break;
                case 3:  {
                    
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    //__weak typeof(self) weakSelf = self;
                    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
//                        [self removeCacheBlock:^(NSString *blockParam) {
//
//                        }];
                    dispatch_async(dispatch_get_main_queue(), ^{
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                        });
                    });
                
                }
                    break;
                case 2: {
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
        }];
        [buttonBackImageView addSubview:bottomButton];
    }
    
    NSLog(@"%@",backScrollView.subviews);
    
}

- (void)removeCacheBlock:(void(^)(NSString * blockParam))callBack{
    
    NSString *path = [ NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *folderPath = [path stringByAppendingPathComponent:@"musicCache"];
    NSArray *arr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:nil];
    for (NSString *filePath in arr) {
        NSString *fileName = [NSString stringWithFormat:@"%@/%@", folderPath, filePath];
        [[NSFileManager defaultManager] removeItemAtPath:fileName error:nil];
    }
//    long ff = 0;
//    for(long i=0;i<3000;i++){
//        ff = ff + i;
//        NSLog(@"ff:%ld",ff);
//    }
    callBack(@"在方法中 调用了block");
}


-(void)changUserInfo
{
    if([[UserShareOnce shareOnce].memberImage isKindOfClass:[NSNull class]]){
        self.userIcon.image = [UIImage imageNamed:@"1我的_03"];
    }else{
        [self.userIcon sd_setImageWithURL:[NSURL URLWithString:[UserShareOnce shareOnce].memberImage] placeholderImage:[UIImage imageNamed:@"1我的_03"]];
    }
    
    if ([MemberUserShance shareOnce].name.length <  26) {
        self.userNameLabel.text  = [MemberUserShance shareOnce].name;
    }else{
        self.userNameLabel.text  = [UserShareOnce shareOnce].wxName;
    }
    if(![GlobalCommon stringEqualNull:[UserShareOnce shareOnce].name]&&[UserShareOnce shareOnce].name.length < 26){
        self.userNameLabel.text  = [UserShareOnce shareOnce].name;
    }
    
    
}

# pragma mark - 点击头像或者登陆按钮
-(void)loginClick{
    PersonalInformationViewController * personInfoView=[[PersonalInformationViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:personInfoView];
    [self presentViewController:nav animated:YES completion:nil];
    NSString *photoStr = [GlobalCommon getCurrentTimes];
    [GlobalCommon pageDurationWithpageId:@"35" withstartTime:photoStr withendTime:photoStr];

    
}

-(void)insertSublayerWithImageView:(UIImageView *)imageV
{
    CALayer *subLayer=[CALayer layer];
    CGRect fixframe = imageV.frame;
    subLayer.frame= fixframe;
    subLayer.cornerRadius=8;
    subLayer.backgroundColor=[UIColorFromHex(0xffffff) colorWithAlphaComponent:1.0].CGColor;
    
    subLayer.masksToBounds=NO;
    subLayer.shadowColor = [UIColor lightGrayColor].CGColor;//shadowColor阴影颜色
    subLayer.shadowOffset = CGSizeMake(0,1);//shadowOffset阴影偏移,x向右偏移3，y向下偏移2，默认(0, -3),这个跟shadowRadius配合使用
    subLayer.shadowOpacity = 0.4;//阴影透明度，默认0
    subLayer.shadowRadius = 4;//阴影半径，默认3
    [self.backScrollView.layer insertSublayer:subLayer below:imageV.layer];
  
    
}

-(void)changeSize:(NSNotification *)notifi {
    self.userNameLabel.font = [UIFont systemFontOfSize:22];
    for (UIButton *button in self.buttonArray) {
         [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.endTimeStr = [GlobalCommon getCurrentTimes];
    [GlobalCommon pageDurationWithpageId:@"5" withstartTime:self.startTimeStr withendTime:self.endTimeStr];
}


@end
