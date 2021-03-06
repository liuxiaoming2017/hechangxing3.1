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

@end

@implementation SetupController
@synthesize listNamesArr,listImagesArr;

- (void)goBack:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}






- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.navTitleLabel.text = ModuleZW(@"设置");
    self.view.backgroundColor = RGB_AppWhite;
    
    [self getPayRequest];
    

  
   
   
}
    
-(void)layoutView{
        NSArray *changeArray = @[ModuleZW(@"修改密码"),ModuleZW(@"退出登录")];
        
        for (int i = 0 ; i < listNamesArr.count; i++) {
            UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(14, kNavBarHeight +10 + (10 + 50)*i, ScreenWidth - 28, 50)];
            backImageView.backgroundColor = [UIColor whiteColor];
            backImageView.layer.cornerRadius = 10;
            backImageView.layer.masksToBounds = YES;
            backImageView.userInteractionEnabled = YES;
            [self insertSublayerWithImageView:backImageView];
            [self.view addSubview:backImageView];
            
            UIButton *bottomButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
            bottomButton.frame = CGRectMake(0, 0,backImageView.width, 55);
            [bottomButton setTitle:ModuleZW(listNamesArr[i]) forState:(UIControlStateNormal)];
            [bottomButton setImage:[UIImage imageNamed:@"1我的_09"] forState:(UIControlStateNormal)];
            [bottomButton.titleLabel setTextAlignment:(NSTextAlignmentCenter)];
            [bottomButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [bottomButton setTitleColor: UIColorFromHex(0x8e8e93) forState:(UIControlStateNormal)];
            [bottomButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -bottomButton.currentImage.size.width,0,0)];
            [bottomButton.titleLabel setFrame:bottomButton.bounds];
            [bottomButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [bottomButton setTitleEdgeInsets:UIEdgeInsetsMake(0,10,0,0)];
            [bottomButton setImageEdgeInsets:UIEdgeInsetsMake(0, backImageView.width - 20 , 0, -backImageView.width + 40)];
            
            [[bottomButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
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
                button.frame = CGRectMake(30, backImageView.bottom + 220 + 10*i, ScreenWidth - 60, 44);
                [button setTitle:changeArray[i] forState:(UIControlStateNormal)];
                button.layer.cornerRadius = 22;
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
                            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:ModuleZW(@"提示") message:ModuleZW(@"确认注销用户") preferredStyle:UIAlertControllerStyleAlert];
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
    
    NSString *urlStr = @"/resources/isfree.jhtml";
    [[NetworkManager sharedNetworkManager] requestWithType:0 urlString:urlStr parameters:nil successBlock:^(id response) {
        id status=[response objectForKey:@"status"];
        if([status intValue] == 200){
            self->listNamesArr = @[@"意见反馈",@"关于我们",@"检查更新"];
        }else{
            self->listNamesArr = @[@"意见反馈",@"关于我们"];
        }
         [self layoutView];
    } failureBlock:^(NSError *error) {
        self->listNamesArr = @[@"意见反馈",@"关于我们"];
         [self layoutView];
    }];
}


# pragma mark - 检查更新
- (void)checkHaveUpdatewihType:(int)typeInt
{
    //ios_hcy-oem-1.0 hcy_android_oem-oem-1.0
    NSString *nowVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *headStr = [NSString stringWithFormat:@"ios_hcy-oem-%@",nowVersion];
    //headStr = @"hcy_android_oem-oem-1.0";
    //为网络请求添加请求头
    NSDictionary *headDic = @{@"version":headStr,@"token":[UserShareOnce shareOnce].token,@"Cookie":[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]};
    
    __weak typeof(self) weakSelf = self;
    
    [[NetworkManager sharedNetworkManager] requestWithType:0 urlString:@"versions_update/updateVersion.jhtml" headParameters:headDic parameters:nil successBlock:^(id response2) {
        NSError *error = NULL;
        id response = [NSJSONSerialization JSONObjectWithData:response2 options:0 error:&error];
        if([[response objectForKey:@"status"] intValue] == 100){
            NSDictionary *dic = [response objectForKey:@"data"];
            NSInteger isUpdate = [[dic objectForKey:@"isUpdate"] integerValue];
            if(isUpdate == 1){
                NSString *downUrl = @"https://itunes.apple.com/cn/app/id1440487968";
                if([[UserShareOnce shareOnce].username isEqualToString:@"13665541112"] || [[UserShareOnce shareOnce].username isEqualToString:@"18163865881"]){
                    return ;
                }
                NSString *ytpeStr = [NSString stringWithFormat:@"%@",dic[@"isEnforcement"]];
                NSString *textStr = dic[@"releaseContent"];
                if([GlobalCommon stringEqualNull:textStr]){
                    textStr = @"无";
                }
                [weakSelf showUpdateView:downUrl contentStr:textStr typeStr:ytpeStr];
                NSLog(@"升级了");
            }else{
                if(typeInt == 1){
                    [self showAlertWarmMessage:ModuleZW(@"已经是最新版本")];
                }
            }
        }
        
        NSLog(@"haha:%@",response);
        
    } failureBlock:^(NSError *error) {
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
                
              
                NSString *downloadStr = [NSString stringWithFormat:@"%@user/download",DATAURL_PRE];
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

@end
