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
    
    listNamesArr = @[@[@"关于我们",@"隐私条款",@"会员章程",@"官方微信",@"官方微博",@"声明",@"帮助"],@[@"修改密码",@"注销"]];
    listImagesArr = @[@[@"private",@"refundRecord",@"returedGoodsRecord",@"1我的_100",@"integral",@"1我的_101",@"1我的_102"],@[@"1我的_103",@"1我的_104"]];
    self.navTitleLabel.text = @"设置";
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
                vc.titleStr = @"关于我们";
                vc.urlStr = [NSString stringWithFormat:@"%@upload/article/content/201602/60/1.html",URL_PRE];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1:
            {
                HeChangPackgeController *vc = [[HeChangPackgeController alloc] init];
                vc.noWebviewBack = YES;
                vc.progressType = progress2;
                vc.titleStr = @"隐私条款";
                vc.urlStr = [NSString stringWithFormat:@"%@upload/article/content/201602/61/1.html",URL_PRE];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:
            {
                HeChangPackgeController *vc = [[HeChangPackgeController alloc] init];
                vc.noWebviewBack = YES;
                vc.progressType = progress2;
                vc.titleStr = @"会员章程";
                vc.urlStr = [NSString stringWithFormat:@"%@upload/article/content/201602/62/1.html",URL_PRE];
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
                vc.titleStr = @"声明";
                vc.urlStr = [NSString stringWithFormat:@"%@upload/article/content/201602/63/1.html",URL_PRE];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 6:
            {
                HeChangPackgeController *vc = [[HeChangPackgeController alloc] init];
                vc.noWebviewBack = YES;
                vc.progressType = progress2;
                vc.titleStr = @"帮助";
                vc.urlStr = [NSString stringWithFormat:@"%@upload/article/content/201602/64/1.html",URL_PRE];
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
                    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认注销用户" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *alertAct1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    UIAlertAction *alertAct12 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        LoginViewController *loginview=[[LoginViewController alloc]init];
                        NSMutableDictionary* dicTmp = [UtilityFunc mutableDictionaryFromAppConfig];
                        if (dicTmp) {
                            [dicTmp setObject:@"" forKey:@"USERNAME"];
                            [dicTmp setObject:@"" forKey:@"PASSWORDAES"];
                            [dicTmp setValue:@"0" forKey:@"ischeck"];
                        }
                        
                        [UserShareOnce attemptDealloc];
                        [UserShareOnce shareOnce].wxName = nil;
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
