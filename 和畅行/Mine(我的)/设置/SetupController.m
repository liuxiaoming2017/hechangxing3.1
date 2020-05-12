//
//  SetupController.m
//  和畅行
//
//  Created by 刘晓明 on 2018/8/6.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "SetupController.h"
#import "MineCell.h"
#import "HeChangPackgeController.h"
#import "WeXinViewController.h"
#import "WeiBoViewController.h"
#import "WYViewController.h"
#import "LoginViewController.h"
#import "CustomNavigationController.h"
#import "FeedbackViewController.h"
#import "VersionUpdateView.h"

@interface SetupController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *listNamesArr;
@property (nonatomic,strong) NSArray *listImagesArr;
@property (nonatomic,strong) NSMutableArray *buttonArray;
@property (nonatomic,strong) UILabel *fontSizeLabel;
@property (nonatomic,assign)BOOL isPush;
@end

@implementation SetupController
@synthesize listNamesArr,listImagesArr;

- (void)goBack:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.isPush = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (!self.isPush) {
        self.endTimeStr = [GlobalCommon getCurrentTimes];
        [GlobalCommon pageDurationWithpageId:@"46" withstartTime:self.startTimeStr withendTime:self.endTimeStr];
    }
}




- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleLabel.text = ModuleZW(@"设置");
    self.view.backgroundColor = RGB_AppWhite;
    self.startTimeStr = [GlobalCommon getCurrentTimes];
    self.buttonArray = [NSMutableArray array];
    [self getPayRequest];
    
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSize:) name:@"CHANGESIZE" object:nil];
}
    
-(void)layoutView{
        NSArray *changeArray = @[ModuleZW(@"修改密码"),ModuleZW(@"退出登录")];
        
        for (int i = 0 ; i < listNamesArr.count; i++) {
            UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth*0.037, kNavBarHeight +Adapter(10) + (ScreenWidth*0.16)*i, ScreenWidth - ScreenWidth*0.074, ScreenWidth*0.133)];
            backImageView.backgroundColor = [UIColor whiteColor];
            backImageView.layer.cornerRadius = Adapter(10);
            backImageView.layer.masksToBounds = YES;
            backImageView.userInteractionEnabled = YES;
            [self insertSublayerWithImageView:backImageView];
            [self.view addSubview:backImageView];
            
            UIButton *bottomButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
            bottomButton.frame = CGRectMake(0, 0,backImageView.width, ScreenWidth*0.133);
            [bottomButton setTitle:ModuleZW(listNamesArr[i]) forState:(UIControlStateNormal)];
            [bottomButton.titleLabel setTextAlignment:(NSTextAlignmentCenter)];
            [bottomButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [bottomButton setTitleColor: UIColorFromHex(0x8e8e93) forState:(UIControlStateNormal)];
            [bottomButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -bottomButton.currentImage.size.width,0,0)];
            [bottomButton.titleLabel setFrame:bottomButton.bounds];
            [bottomButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [bottomButton setTitleEdgeInsets:UIEdgeInsetsMake(0,10,0,0)];
            UIImageView *goImageView= [[UIImageView alloc]initWithFrame:CGRectMake(bottomButton.width - Adapter(25), bottomButton.height/2 - ScreenWidth*0.026, ScreenWidth*0.026, ScreenWidth*0.052)];
            goImageView.image = [UIImage imageNamed:@"1我的_09"];
            goImageView.userInteractionEnabled = YES;
            [bottomButton addSubview:goImageView];
            [self.buttonArray addObject:bottomButton];
            if (i == 2) {
                UILabel *fontSizeLabel = [[UILabel alloc]initWithFrame:CGRectMake(bottomButton.width - ScreenWidth*0.64, 0, ScreenWidth*0.56, ScreenWidth*0.133)];
                fontSizeLabel.textAlignment = NSTextAlignmentRight;
                fontSizeLabel.font = [UIFont systemFontOfSize:13];
                fontSizeLabel.textColor = RGB_TextGray;
                [bottomButton addSubview:fontSizeLabel];
                NSLog(@"%f",[UserShareOnce shareOnce].multipleFontSize);
                if ([UserShareOnce shareOnce].multipleFontSize > 0.99&&[UserShareOnce shareOnce].multipleFontSize < 1.01) {
                    fontSizeLabel.text = ModuleZW(@"小");
                }else  if ([UserShareOnce shareOnce].multipleFontSize >1.09 &&[UserShareOnce shareOnce].multipleFontSize < 1.11) {
                    fontSizeLabel.text = ModuleZW(@"中");
                }else  if ([UserShareOnce shareOnce].multipleFontSize >1.19 &&[UserShareOnce shareOnce].multipleFontSize < 1.21) {
                    fontSizeLabel.text = ModuleZW(@"大");
                }else  if ([UserShareOnce shareOnce].multipleFontSize >1.29 &&[UserShareOnce shareOnce].multipleFontSize < 1.31) {
                    fontSizeLabel.text = ModuleZW(@"特大");
                }else{
                    fontSizeLabel.text = ModuleZW(@"小");
                }
                self.fontSizeLabel = fontSizeLabel;
            }
            
            if ( i == 3 ) {
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                CFShow(CFBridgingRetain(infoDictionary));
                NSString *versionStr = [infoDictionary objectForKey:@"CFBundleShortVersionString"];//版本
                UILabel *fontSizeLabel = [[UILabel alloc]initWithFrame:CGRectMake(bottomButton.width -Adapter(200), 0, Adapter(170), ScreenWidth*0.133)];
                fontSizeLabel.textAlignment = NSTextAlignmentRight;
                fontSizeLabel.font = [UIFont systemFontOfSize:13];
                fontSizeLabel.textColor = RGB_TextGray;
                fontSizeLabel.text = versionStr;
                [bottomButton addSubview:fontSizeLabel];
            }
            [[bottomButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                self.isPush = YES;
                switch (i) {
                    case 0:
                    {
                        FeedbackViewController *faceVC = [[FeedbackViewController alloc]init];
                        [self.navigationController pushViewController:faceVC animated:YES];
                    }
                        break;
                    case 1:
                    {
                        HeChangPackgeController *vc = [[HeChangPackgeController alloc] init];
                        vc.noWebviewBack = YES;
                        vc.progressType = progress2;
                        vc.titleStr =ModuleZW(@"关于我们");
                        if([UserShareOnce shareOnce].languageType){
                            vc.urlStr = [NSString stringWithFormat:@"%@upload/article/content/201903/60/1.html",URL_PRE];
                        }else{
                            vc.urlStr = [NSString stringWithFormat:@"%@upload/article/content/201602/60/1.html",URL_PRE];
                        }
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    }
                        break;
                    case 2:
                    {
                        NSString *fontStr = [[NSUserDefaults standardUserDefaults]valueForKey:@"YHFont"];
                        CGFloat fontSize = 1.0;
                        if(![GlobalCommon stringEqualNull:fontStr]){
                            fontSize = [fontStr floatValue];
                        }
                        
                        UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:@"" message:ModuleZW(@"字体大小") preferredStyle:UIAlertControllerStyleActionSheet];
                        UIAlertAction *smallAction = [UIAlertAction actionWithTitle:ModuleZW(@"小") style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                            [[NSUserDefaults standardUserDefaults]setValue:@"1.0" forKey:@"YHFont"];
                            [UserShareOnce shareOnce].multipleFontSize = 1.0;
                            if(fontSize != 1.0){
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGESIZE" object:nil];
                                 self.fontSizeLabel.text = ModuleZW(@"小");
                                 self.fontSizeLabel .font = [UIFont systemFontOfSize:13];
                            }
                        }];
                        
                        UIAlertAction *middleAction = [UIAlertAction actionWithTitle:ModuleZW(@"中") style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                            [[NSUserDefaults standardUserDefaults]setValue:@"1.1" forKey:@"YHFont"];
                            [UserShareOnce shareOnce].multipleFontSize = 1.1;
                            if(fontSize != 1.1){
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGESIZE" object:nil];
                                self.fontSizeLabel.text = ModuleZW(@"中");
                                self.fontSizeLabel .font = [UIFont systemFontOfSize:13];
                            }
                        }];
                        UIAlertAction *bigAction = [UIAlertAction actionWithTitle:ModuleZW(@"大") style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                            [[NSUserDefaults standardUserDefaults]setValue:@"1.2" forKey:@"YHFont"];
                            [UserShareOnce shareOnce].multipleFontSize = 1.2;
                            if(fontSize != 1.2){
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGESIZE" object:nil];
                                self.fontSizeLabel.text = ModuleZW(@"大");
                                self.fontSizeLabel .font = [UIFont systemFontOfSize:13];
                            }
                        }];
                        UIAlertAction *superBigAction = [UIAlertAction actionWithTitle:ModuleZW(@"特大") style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                            [[NSUserDefaults standardUserDefaults]setValue:@"1.3" forKey:@"YHFont"];
                            [UserShareOnce shareOnce].multipleFontSize = 1.3;
                            if(fontSize != 1.3){
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGESIZE" object:nil];
                                self.fontSizeLabel.text = ModuleZW(@"特大");
                                self.fontSizeLabel .font = [UIFont systemFontOfSize:13];
                            }
                            
                        }];
                        
                        UIAlertAction *cencelAction = [UIAlertAction actionWithTitle:ModuleZW(@"取消") style:UIAlertActionStyleCancel handler:nil];
                        
                        [alerVC addAction:smallAction];
                        [alerVC addAction:middleAction];
                        [alerVC addAction:bigAction];
                        [alerVC addAction:superBigAction];
                        [alerVC addAction:cencelAction];
                        
                        if(ISPaid)  {
                            UIPopoverPresentationController *popover = alerVC.popoverPresentationController;
                            if (popover) {
                                popover.sourceView = x;
                                popover.sourceRect = x.bounds;
                                popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
                            }
                        }
                        [self presentViewController:alerVC animated:YES completion:nil];
                    }
                        break;
                        
                    case 3:
                    {
                        [self checkHaveUpdatewihType:1];
                    }
                        break;
                        
                    default:
                        break;
                }
            }];
            [backImageView addSubview:bottomButton];
            
            if(i < changeArray.count){
                UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
                button.frame = CGRectMake(ScreenWidth*0.08, backImageView.bottom + ScreenWidth*0.586 + 0.027*i, ScreenWidth - ScreenWidth*0.16, ScreenWidth*0.117);
                [button setTitle:changeArray[i] forState:(UIControlStateNormal)];
                [button.titleLabel setFont:[UIFont systemFontOfSize:18]];
                button.layer.cornerRadius = button.height/2;
                button.tag = 1000 + i;
                [self.buttonArray addObject:button];
                if(i == 0){
                    [button setBackgroundColor:UIColorFromHex(0X1e82d2)];
                }else{
                    [button setBackgroundColor:UIColorFromHex(0Xdd0707)];
                }
                [[button rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
                    if(i == 0){
                        WYViewController *vc = [[WYViewController alloc]init];
                        [self.navigationController pushViewController:vc animated:YES];
                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:ModuleZW(@"提示") message:ModuleZW(@"确认退出当前账号") preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *alertAct1 = [UIAlertAction actionWithTitle:ModuleZW(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                
                            }];
                            UIAlertAction *alertAct12 = [UIAlertAction actionWithTitle:ModuleZW(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                
                                LoginViewController *loginview=[[LoginViewController alloc]init];
                                NSMutableDictionary* dicTmp = [UtilityFunc mutableDictionaryFromAppConfig];
                                if (dicTmp) {
                                    [dicTmp setObject:@"" forKey:@"USERNAME"];
                                    [dicTmp setObject:@"" forKey:@"PASSWORDAES"];
                                    [dicTmp setValue:@"0" forKey:@"ischeck"];
                                }
                                [UtilityFunc updateAppConfigWithMutableDictionary:dicTmp];
                                CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:loginview];
                                
                                [UIApplication sharedApplication].keyWindow.rootViewController = nav;
                                //[self.navigationController pushViewController:loginview animated:YES];
                            }];
                            [alertVC addAction:alertAct1];
                            [alertVC addAction:alertAct12];
                            [self presentViewController:alertVC animated:YES completion:NULL];
                        });
                    }
                }];
                [self.view addSubview:button];
            }
        }
}
    
-(void)getPayRequest {
    
    if([[UserShareOnce shareOnce].username isEqualToString:@"13665541112"] || [[UserShareOnce shareOnce].username isEqualToString:@"18163865881"]){
        self.listNamesArr = @[@"意见反馈",@"关于我们",@"字体大小"];
    }else if(![[NSUserDefaults standardUserDefaults] objectForKey:@"noAppstoreCheck"]){
        self.listNamesArr = @[@"意见反馈",@"关于我们",@"字体大小"];
    }else{
        self.listNamesArr = @[@"意见反馈",@"关于我们",@"字体大小",@"检查更新"];
    }
    
    [self layoutView];
    
}


# pragma mark - 检查更新
- (void)checkHaveUpdatewihType:(int)typeInt
{
    //ios_hcy-oem-1.0 hcy_android_oem-oem-1.0
    NSString *nowVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *headStr = [NSString stringWithFormat:@"ios_hcy-oem-%@",nowVersion];
    [GlobalCommon showMBHudWithView:self.view];
    //headStr = @"hcy_android_oem-oem-1.0";
    //为网络请求添加请求头
    NSDictionary *headDic = @{@"version":headStr,@"token":[UserShareOnce shareOnce].token,@"Cookie":[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]};
    
    __weak typeof(self) weakSelf = self;
    
    [[NetworkManager sharedNetworkManager] requestWithCookieType:0 urlString:@"versions_update/updateVersion.jhtml" headParameters:headDic parameters:nil successBlock:^(id response2) {
        NSError *error = NULL;
        id response = [NSJSONSerialization JSONObjectWithData:response2 options:0 error:&error];
        if([[response objectForKey:@"status"] intValue] == 100){
            NSDictionary *dic = [response objectForKey:@"data"];
            NSInteger isUpdate = [[dic objectForKey:@"isUpdate"] integerValue];
            if(isUpdate == 1){
                NSString *downUrl = @"https://itunes.apple.com/cn/app/id1440487968";
                if ([UserShareOnce shareOnce].languageType) {
                  downUrl  = @"https://apps.apple.com/cn/app/harmonyyi/id1477581955";
                }
                if([[UserShareOnce shareOnce].username isEqualToString:@"13665541112"] || [[UserShareOnce shareOnce].username isEqualToString:@"18163865881"]){
                    return ;
                }
                NSString *ytpeStr = [NSString stringWithFormat:@"%@",dic[@"isEnforcement"]];
                NSString *textStr = dic[@"releaseContent"];
                if([GlobalCommon stringEqualNull:textStr]){
                    textStr = @"无";
                }
                if([[UserShareOnce shareOnce].languageType isEqualToString:@"us-en"]){
                    NSString *englistStr = @"The latest version comes whether you update?";
                    [weakSelf showUpdateView:downUrl contentStr:englistStr typeStr:@"0"];
                }else{
                    [weakSelf showUpdateView:downUrl contentStr:textStr typeStr:@"0"];
                }
    
                NSLog(@"升级了");
            }else{
                if(typeInt == 1){
                    [self showAlertWarmMessage:ModuleZW(@"已经是最新版本")];
                }
            }
        }
        
        NSLog(@"haha:%@",response);
        [GlobalCommon hideMBHudWithView:self.view];
    } failureBlock:^(NSError *error) {
        [GlobalCommon hideMBHudWithView:self.view];
        [self showAlertWarmMessage:requestErrorMessage];
    }];
}

- (void)showUpdateView:(NSString *)downUrl contentStr:(NSString *)contentStr typeStr:(NSString *)typeStr
{
    
    [GlobalCommon addMaskView];
    VersionUpdateView *updateView = [VersionUpdateView versionUpdateViewWithContent:contentStr type:typeStr];
    __weak __typeof(updateView)wupdateView = updateView;
    updateView.versionUpdateBlock = ^(BOOL isUpdate){
        
        if(isUpdate){
            NSURL *url = [NSURL URLWithString:downUrl];
            if (url) {
                //该接口用于记录用户使用app下载网站资源记录
                
                NSString *userSign = [UserShareOnce shareOnce].uid;
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                CFShow(CFBridgingRetain(infoDictionary));
                
                NSString *versionStr = [infoDictionary objectForKey:@"CFBundleShortVersionString"];//版本
                
                
                NSString *down_timeStr = [GlobalCommon getCurrentTimes];;//下载时间
                
              
                NSString *downloadStr = [NSString stringWithFormat:@"%@v1/user/download",DATAURL_PRE];
                NSDictionary *downloadDic = @{ @"body":@{@"channel":@"",
                                                         @"downTime":down_timeStr,
                                                         @"remark":@"",
                                                         @"userSign":userSign,
                                                         @"userSource":@"1",
                                                         @"version":versionStr}
                                               };
                [[BuredPoint sharedYHBuriedPoint] submitWithUrl:downloadStr dic:downloadDic successBlock:^(id  _Nonnull response) {

                } failureBlock:^(NSError * _Nonnull error) {

                }];
                
                [[UIApplication sharedApplication] openURL:url];
                
            }
        }
        
        
      
        [GlobalCommon removeMaskView];
        [wupdateView removeFromSuperview];
    };
    [[UIApplication sharedApplication].keyWindow addSubview:updateView];
    
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
    [self.view.layer insertSublayer:subLayer below:imageV.layer];
    
    
}

-(void)changeSize:(NSNotification *)notifi {
    for (UIButton *button in self.buttonArray ) {
        if(button.tag==1000||button.tag == 1001){
            [button.titleLabel setFont:[UIFont systemFontOfSize:18]];
        }else{
            [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        }
    }
}




@end
