//
//  MoxaSettingViewController.m
//  MoxaAdvisor
//
//  Created by wangdong on 15/6/11.
//  Copyright (c) 2015年 jiudaifu. All rights reserved.
//

#import "MoxaSettingViewController.h"
#import "MoxaHelpViewController.h"
#import "UIImage+Util.h"
#import "i9_MoxaMainViewController.h"
#import "SetNetsPassWordViewController.h"
#import "FindBackPasswordViewController.h"
#import "ConfigUtil.h"
#import <moxibustion/moxibustion.h>

#define ICON_WITHD_SMALL 32
#define ICON_WITHD_BIG   35

@interface MoxaSettingViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSArray *iconArray;
@property (retain, nonatomic) NSArray *titleArray;
@property (assign, nonatomic) BOOL  isVoiceEn;
@property (retain, nonatomic) UIImageView *setSoundBtn;
@end

@implementation MoxaSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _iconArray = [[NSArray alloc]initWithObjects:
                  @"i9setPwd.png",
                  @"i9findpwd.png",
                  @"sound_open.png",
                  //                      @"ic_manage.png",
                  
                  @"ic_help.png", nil];
    _titleArray = [[NSArray alloc]initWithObjects:
                   
                  ModuleZW(@"设置灸头网络密码") ,
                  ModuleZW(@"找回灸头网络密码"),
                   ModuleZW(@"声音"),
                   //                       @"管理灸疗对象",
                   
                   ModuleZW(@"帮助"), nil];
    
    self.leftBtn.hidden = YES;
    self.rightBtn.hidden = YES;
    self.preBtn.hidden = NO;
    self.navTitleLabel.text = ModuleZW(@"设置");
    
    _isVoiceEn = [BlueToothCommon getMoxaVoiceEn];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.frame = CGRectMake(0, self.topView.bottom, ScreenWidth, 56*_iconArray.count);
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationItem.title = @"设置";
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index;
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"xcell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]
                        initWithStyle:UITableViewCellStyleValue1
                        reuseIdentifier:@"xcell"];
    }
   
    UIImage *image = [UIImage imageNamed:[_iconArray objectAtIndex:indexPath.row]];
    index = 2;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    if (indexPath.row == index){
        if(iPhone4 || iPhone5){
            cell.imageView.image = [[self getSettingVoiceIcon] transformWidth:ICON_WITHD_SMALL height:ICON_WITHD_SMALL scale:1.0];
        }else{
            cell.imageView.image = [[self getSettingVoiceIcon] transformWidth:ICON_WITHD_BIG height:ICON_WITHD_BIG scale:2.0];
            
        }
        
        _setSoundBtn = cell.imageView;
    }else{
        if(iPhone4 || iPhone5){
            cell.imageView.image = [image transformWidth:ICON_WITHD_SMALL height:ICON_WITHD_SMALL scale:2.0];
        }else{
            cell.imageView.image = [image transformWidth:ICON_WITHD_BIG height:ICON_WITHD_BIG scale:4.0];
        }
        
    }
    if(iPhone4 || iPhone5){
        cell.textLabel.font = [UIFont systemFontOfSize:16];
    }else{
        cell.textLabel.font = [UIFont systemFontOfSize:16];
    }
    cell.textLabel.text = [_titleArray objectAtIndex:indexPath.row];
    if (indexPath.row == index) {
        CGFloat height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
        UISwitch *uiswitch = [[UISwitch alloc]initWithFrame:CGRectMake(self.view.frame.size.width-80, (height - 32)/2, 32, 32)];
        [cell.contentView addSubview:uiswitch];
        [uiswitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [uiswitch setOn:_isVoiceEn];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(iPhone4 || iPhone5){
        return 44;
    }else{
        return 56;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//        if (indexPath.row == 0){
//            [self goToChooseMoxaModel];
//        }else
        if (indexPath.row == 0){
            [self goToSetNetsPassWordView];
        }else if (indexPath.row == 1){
            [self goToFindBackPasswordView];
        }
        else if (indexPath.row == 2){
            [self setSound];
        }
        else if (indexPath.row == 3) {
            [self goToMoxaHelpView];
        }
    
}

-(void)goToChooseMoxaModel{
}

-(void)goToRecipelView{
}

-(void)setSound{
    i9_MoxaMainViewController *vc = (i9_MoxaMainViewController*)_fatherVC;
    [vc controlSound];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)set68Password{
    [[NSNotificationCenter defaultCenter] postNotificationName:BROADCAST_MOXA_SETTING object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self, @"setpasswd", nil]];
}


-(void)goToMoxaHelpView{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    MoxaHelpViewController *vc = [[MoxaHelpViewController alloc]initWithNibName:@"MoxaHelp" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)goToSetNetsPassWordView{
    SetNetsPassWordViewController *vc = [[SetNetsPassWordViewController alloc] initWithNibName:@"SetNetsPassWordView" bundle:nil];
    vc.fatherVC = _fatherVC;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)goToFindBackPasswordView{
    FindBackPasswordViewController *vc = [[FindBackPasswordViewController alloc] initWithNibName:@"FindBackPasswordView" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)switchAction:(UISwitch*)sender {
    _isVoiceEn = sender.on;
    _bVoiceOn = _isVoiceEn;
    UITableViewCell *cell = (UITableViewCell *)[sender.superview superview];
    //cell.imageView.image = [[self getSettingVoiceIcon] transformWidth:32 height:32];
    cell.imageView.image = [[self getSettingVoiceIcon] transformWidth:ICON_WITHD_BIG height:ICON_WITHD_BIG scale:2.0];
    i9_MoxaMainViewController *vc = (i9_MoxaMainViewController*)_fatherVC;
    [vc controlSound];
    
}

-(UIImage *)getSettingVoiceIcon{
    if(_bVoiceOn){
        return [UIImage imageNamed:@"sound_open"];
    }else{
        return [UIImage imageNamed:@"sound_close"];
    }
}


- (void)dealloc {
    NSLog(@"");
}

@end
