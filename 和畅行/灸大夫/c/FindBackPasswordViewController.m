//
//  FindBackPasswordViewController.m
//  MoxaYS
//
//  Created by xuzengjun on 16/11/29.
//  Copyright © 2016年 jiudaifu. All rights reserved.
//

#import "FindBackPasswordViewController.h"
#import "KeyBoardManager.h"
#import <moxibustion/moxibustion.h>
#import "OMGToast.h"
#import "UIView+FirstResponder.h"
#import "PubFunc.h"

@interface FindBackPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *mCodeInputView;
@property (weak, nonatomic) IBOutlet UIButton *mBtnGetPwd;
@property (weak, nonatomic) IBOutlet UILabel *mPasswordLable;
@property (weak, nonatomic) IBOutlet UIButton *mConnectServicer;
@property (strong, nonatomic) IBOutlet UIControl *mControl;

@end

@implementation FindBackPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.topView.backgroundColor = UIColorFromHex(0x1e82d2);
    self.leftBtn.hidden = YES;
    self.rightBtn.hidden = YES;
    self.preBtn.hidden = NO;
    self.navTitleLabel.text = ModuleZW(@"找回灸头密码");
    self.navTitleLabel.textColor = [UIColor whiteColor];
    //self.topView.hidden = YES;
    
    [self initData];
    [self initView];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationItem.title = @"找回灸头密码";
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(void)initView{
    if(iPhone4){
        _mPasswordLable.font = [UIFont systemFontOfSize:24.0];
    }else if(iPhone5){
        _mPasswordLable.font = [UIFont systemFontOfSize:28.0];
    }else{
        _mPasswordLable.font = [UIFont systemFontOfSize:30.0];
    }
    //_mPasswordLable.text = [NSString stringWithFormat:@"%@:%@",@"此设备的密码为",@"111"];
    [_mControl addTarget:self action:@selector(onClickControl:) forControlEvents:UIControlEventTouchUpInside];
    _mBtnGetPwd.layer.masksToBounds = YES;
    _mBtnGetPwd.layer.cornerRadius = 5;
    
    _mConnectServicer.layer.masksToBounds = YES;
    _mConnectServicer.layer.cornerRadius = 6;
    
    [[KeyBoardManager sharedInstance] configViewControl:self responderView:_mCodeInputView, nil];
}

-(void)initData{
    if (SUPPORT_YES == [[moxibustion getInstance] getBluetoothSupportState]
        && STATE_ON == [[moxibustion getInstance] getBluetoothOpenState])
    {
        [[moxibustion getInstance] discoverDevice];
    }

}

- (IBAction)onClickControl:(id)sender {
    [[self.view findFirstResponder] resignFirstResponder];
}

- (IBAction)mGetpwdOnclinck:(id)sender {
    NSString *code = _mCodeInputView.text;
    if(![[moxibustion getInstance] isValidMachineCode:code]){
        [OMGToast showWithText:ModuleZW(@"请输入正确的机身编码") duration:1.5f];
        return;
    }
    if([[moxibustion getInstance] getDiscoveredDevicesName].count == 0){
        [OMGToast showWithText:ModuleZW(@"您周围没有可搜寻的设备") duration:1.5f];
        return;
    }
    NSString *pwd = [[moxibustion getInstance] getPassWord:code];
    if(pwd != nil){
        _mPasswordLable.text = [NSString stringWithFormat:@"%@:%@",ModuleZW(@"此设备的密码为"),pwd];
    }else{
        [OMGToast showWithText:ModuleZW(@"您输入的设备不在连接范围") duration:1.5f];
    }
}


- (IBAction)mConnectServiceOnclinck:(id)sender {
    NSMutableString * strPhone =[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4006776668"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strPhone]];
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
