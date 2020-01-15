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
@property (weak, nonatomic) IBOutlet UILabel *passLabel;
@property (weak, nonatomic) IBOutlet UILabel *blueLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *blue2;
@property (weak, nonatomic) IBOutlet UILabel *blue3;
@property (weak, nonatomic) IBOutlet UITextField *mCodeInputView;
@property (weak, nonatomic) IBOutlet UIButton *mBtnGetPwd;
@property (weak, nonatomic) IBOutlet UILabel *mPasswordLable;
@property (weak, nonatomic) IBOutlet UIButton *mConnectServicer;
@property (strong, nonatomic) IBOutlet UIControl *mControl;
@property (weak, nonatomic) IBOutlet UIView *bluebackView;
@property (weak, nonatomic) IBOutlet UIImageView *blueImage;
@property (weak, nonatomic) IBOutlet UIView *textBackView;
@property (weak, nonatomic) IBOutlet UIImageView *callImage;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UILabel *i9Label;

@end

@implementation FindBackPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.leftBtn.hidden = YES;
    self.rightBtn.hidden = YES;
    self.preBtn.hidden = NO;
    self.navTitleLabel.text = ModuleZW(@"找回灸头密码");
    self.mCodeInputView.placeholder = ModuleZW(@"请输入机身编码");
    self.passLabel.text = ModuleZW(@"通过机身编码找回密码");
    self.blueLabel.text = ModuleZW(@"若忘记密码，可用上述方式输入机身编码找回密码");
    self.phoneLabel.text = ModuleZW(@"联系客服");
    self.blue2.text = ModuleZW(@"若无法获机身编码，可拨打客服电话，提供灸头ID找回密码");
    self.blue3.text = ModuleZW(@"注:灸头ID在灸头网络列表中可见");
    [self.mBtnGetPwd setTitle:ModuleZW(@"找回密码") forState:(UIControlStateNormal)];
    [self.mBtnGetPwd.titleLabel setNumberOfLines:2];
    [self.mConnectServicer setTitle:ModuleZW(@"联系客服 ") forState:(UIControlStateNormal)];
    [self.mConnectServicer.titleLabel setFont:[UIFont systemFontOfSize:19/[UserShareOnce shareOnce].multipleFontSize]];
    //self.topView.hidden = YES;
    
    self.passLabel.font = [UIFont systemFontOfSize:16];
    self.mCodeInputView.font = [UIFont systemFontOfSize:13];
    self.blueLabel.font = [UIFont systemFontOfSize:11];
    self.phoneLabel.font = [UIFont systemFontOfSize:16];
    self.blue2.font = [UIFont systemFontOfSize:13];
    self.blue3.font = [UIFont systemFontOfSize:11];
    self.i9Label.font = [UIFont systemFontOfSize:13];
    [self.mBtnGetPwd.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [self.mConnectServicer.titleLabel setFont:[UIFont systemFontOfSize:19]];
    self.blueImage.image = [UIImage imageNamed:@"ic_password.png"];
   self.callImage.image = [UIImage imageNamed:@"ic_password.png"];
    
    [self initData];
    [self initView];
    // Do any additional setup after loading the view.
    [self.bluebackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(kNavBarHeight);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, Adapter(60)));
        make.leading.equalTo(self.view.mas_leading);
    }];
    
    [self.blueImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bluebackView.mas_top).offset(Adapter(15));
        make.size.mas_equalTo(CGSizeMake(Adapter(30), Adapter(30)));
        make.leading.equalTo(self.view.mas_leading).offset(Adapter(10));
    }];
    
    [self.passLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bluebackView.mas_top);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - Adapter(50), Adapter(60)));
        make.leading.equalTo(self.view.mas_leading).offset(Adapter(50));
    }];
    [self.textBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bluebackView.mas_bottom).offset(Adapter(10));
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - Adapter(100), Adapter(50)));
        make.leading.equalTo(self.view.mas_leading).offset(Adapter(10));
    }];
    
    [self.i9Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textBackView.mas_top).offset(Adapter(5));
        make.size.mas_equalTo(CGSizeMake(Adapter(50), Adapter(40)));
        make.leading.equalTo(self.view.mas_leading).offset(Adapter(5));
    }];
    
    [self.codeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textBackView.mas_top).offset(Adapter(5));
        make.size.mas_equalTo(CGSizeMake(ScreenWidth -  Adapter(160), Adapter(40)));
        make.leading.equalTo(self.view.mas_leading).offset(Adapter(60));
    }];
    
    [self.mBtnGetPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bluebackView.mas_bottom).offset(Adapter(10));
        make.size.mas_equalTo(CGSizeMake(Adapter(60), Adapter(50)));
        make.trailing.equalTo(self.view.mas_trailing).offset(Adapter(-10));
    }];
    [self.blueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textBackView.mas_bottom).offset(Adapter(10));
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - Adapter(20), Adapter(30)));
        make.leading.equalTo(self.view.mas_leading).offset(Adapter(10));
    }];
    [self.callImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.blueLabel.mas_bottom).offset(Adapter(20));
        make.size.mas_equalTo(CGSizeMake(Adapter(30), Adapter(30)));
        make.leading.equalTo(self.view.mas_leading).offset(Adapter(10));
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.blueLabel.mas_bottom).offset(Adapter(20));
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - Adapter(50), Adapter(30)));
        make.leading.equalTo(self.view.mas_leading).offset(Adapter(50));
    }];
    
    [self.blue2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneLabel.mas_bottom).offset(Adapter(20));
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - Adapter(20), Adapter(30)));
        make.leading.equalTo(self.view.mas_leading).offset(Adapter(10));
    }];
    
    [self.blue3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.blue2.mas_bottom).offset(Adapter(20));
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - Adapter(20), Adapter(20)));
        make.leading.equalTo(self.view.mas_leading).offset(Adapter(10));
    }];
    
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.blue3.mas_bottom).offset(Adapter(20));
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - Adapter(20), Adapter(40)));
        make.leading.equalTo(self.view.mas_leading).offset(Adapter(10));
    }];
    
    [self.mConnectServicer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomLabel.mas_bottom).offset(Adapter(20));
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - Adapter(80), Adapter(30)));
        make.leading.equalTo(self.view.mas_leading).offset(Adapter(40));
    }];
    
   
    
    
    
//    [self.blueImage  mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.timeLabel.mas_bottom).offset(Adapter(5));
//        make.size.mas_equalTo(CGSizeMake(1, Adapter(20)));
//        make.left.equalTo(self.contentView.mas_left).offset(Adapter(30));
//    }];
//    [self.createDateLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(lineImageV.mas_bottom);
//        make.size.mas_equalTo(CGSizeMake(Adapter(60), Adapter(20)));
//        make.left.equalTo(self.contentView.mas_left);
//    }];
//    [self.lineImageV2  mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.createDateLabel.mas_bottom);
//        make.width.mas_equalTo(1);
//        make.left.equalTo(self.contentView.mas_left).offset(Adapter(30));
//        make.bottom.equalTo(self.contentView.mas_bottom);
//    }];
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
    
    if (![UserShareOnce shareOnce].languageType) {
        UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:ModuleZW(@"温馨提示") message:ModuleZW(@"请在法定工作日AM9:00-PM17:00拨打") preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cabcekAction  = [UIAlertAction actionWithTitle:ModuleZW(@"取消") style:(UIAlertActionStyleCancel) handler:nil];
        UIAlertAction *sureAction  = [UIAlertAction actionWithTitle:ModuleZW(@"确定") style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:4006776668"]];
        }];
        [alerVC addAction:cabcekAction];
        [alerVC addAction:sureAction];
        [self presentViewController:alerVC animated:YES completion:nil];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:4006776668"]];
    }

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
