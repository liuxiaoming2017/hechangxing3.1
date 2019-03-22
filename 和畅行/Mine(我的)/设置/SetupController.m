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
    
    listNamesArr = @[@[ModuleZW(@"关于我们"),ModuleZW(@"隐私条款"),ModuleZW(@"会员章程"),ModuleZW(@"官方微信"),ModuleZW(@"官方微博"),ModuleZW(@"声明"),ModuleZW(@"帮助")],@[ModuleZW(@"修改密码"),ModuleZW(@"注销")]];
    listImagesArr = @[@[@"关于我们icon",@"隐私条款icon",@"会员章程icon",@"官方微信icon",@"官方微博icon",@"声明icon",@"帮助icon"],@[@"修改密码icon",@"注销icon"]];
    self.navTitleLabel.text = ModuleZW(@"设置");
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, ScreenWidth, ScreenHeight-kNavBarHeight) style:UITableViewStylePlain];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

#pragma mark  -------  UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 7;
    }
    else if (section==1) {
        return 2;
    }else{
        
        return 4;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 1){
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 12)];
        view.image = [UIImage imageNamed:@"healthLec"];
        
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }
    return 12;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MineCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"kCELLID"];
    if(!cell){
        cell = [[MineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kCELLID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    cell.iconImage.image = [UIImage imageNamed:[listImagesArr[indexPath.section] objectAtIndex:indexPath.row]];
    cell.titleLabel.text = [listNamesArr[indexPath.section] objectAtIndex:indexPath.row];
    if(indexPath.section == 0){
        NSArray *arr = [listImagesArr objectAtIndex:indexPath.section];
        if(indexPath.row == arr.count - 1){
            cell.lineImageV.hidden = YES;
        }else{
            cell.lineImageV.hidden = NO;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        switch (indexPath.row) {
            case 0:
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
            case 1:
            {
                HeChangPackgeController *vc = [[HeChangPackgeController alloc] init];
                vc.noWebviewBack = YES;
                vc.progressType = progress2;
                vc.titleStr =ModuleZW(@"隐私条款");
                if([UserShareOnce shareOnce].languageType){
                    vc.urlStr = [NSString stringWithFormat:@"%@upload/article/content/201903/61/1.html",URL_PRE];
                }else{
                    vc.urlStr = [NSString stringWithFormat:@"%@upload/article/content/201602/61/1.html",URL_PRE];
                }
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:
            {
                HeChangPackgeController *vc = [[HeChangPackgeController alloc] init];
                vc.noWebviewBack = YES;
                vc.progressType = progress2;
                vc.titleStr = ModuleZW(@"会员章程");
                if([UserShareOnce shareOnce].languageType){
                    vc.urlStr = [NSString stringWithFormat:@"%@upload/article/content/201903/62/1.html",URL_PRE];
                }else{
                    vc.urlStr = [NSString stringWithFormat:@"%@upload/article/content/201602/62/1.html",URL_PRE];
                }
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 3:
            {
                WeXinViewController *vc = [[WeXinViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 4:
            {
                WeiBoViewController *vc = [[WeiBoViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 5:
            {
                HeChangPackgeController *vc = [[HeChangPackgeController alloc] init];
                vc.noWebviewBack = YES;
                vc.progressType = progress2;
                vc.titleStr = ModuleZW(@"声明");
                if([UserShareOnce shareOnce].languageType){
                    vc.urlStr = [NSString stringWithFormat:@"%@upload/article/content/201903/63/1.html",URL_PRE];
                }else{
                    vc.urlStr = [NSString stringWithFormat:@"%@upload/article/content/201602/63/1.html",URL_PRE];
                }
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 6:
            {
                HeChangPackgeController *vc = [[HeChangPackgeController alloc] init];
                vc.noWebviewBack = YES;
                vc.progressType = progress2;
                vc.titleStr = ModuleZW(@"帮助");
                if([UserShareOnce shareOnce].languageType){
                    vc.urlStr = [NSString stringWithFormat:@"%@upload/article/content/201903/64/1.html",URL_PRE];
                }else{
                    vc.urlStr = [NSString stringWithFormat:@"%@upload/article/content/201602/64/1.html",URL_PRE];
                }
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            default:
                break;
        }
    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
            {
                WYViewController *vc = [[WYViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1:
            {
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
                        
//                        unsigned int count = 0;
//                        Ivar *varc = class_copyIvarList([UserShareOnce class], &count);
//                        NSString *key;
//                        for(int i = 0; i < count; i++) {
//                            Ivar thisIvar = varc[i];
//                                    key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];  //获取成员变量的名字
//                            [[UserShareOnce shareOnce] setValue:@"" forKey:key];
//                         }
//                        free(varc);
                        
                        [UserShareOnce attemptDealloc];
                        [MemberUserShance attemptDealloc];
                        [UtilityFunc updateAppConfigWithMutableDictionary:dicTmp];
                        CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:loginview];
                        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"memberChirldArr"];
                        [[NSUserDefaults standardUserDefaults]  setValue: nil forKey:@"Physical"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [UIApplication sharedApplication].keyWindow.rootViewController = nav;
                        //[self.navigationController pushViewController:loginview animated:YES];
                    }];
                    [alertVC addAction:alertAct1];
                    [alertVC addAction:alertAct12];
                    [self presentViewController:alertVC animated:YES completion:NULL];
                });
               
            }
                break;
            default:
                break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
