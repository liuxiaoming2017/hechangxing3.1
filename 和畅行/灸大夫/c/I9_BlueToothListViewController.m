//
//  I9_BlueToothListViewController.m
//  MoxaYS
//
//  Created by xuzengjun on 16/9/19.
//  Copyright © 2016年 jiudaifu. All rights reserved.
//

#import "I9_BlueToothListViewController.h"
#import <moxibustion/moxibustion.h>
#import "i9_blelistViewCell.h"
#import "OMGToast.h"
#import "ConnectBtn.h"

@interface I9_BlueToothListViewController ()<i9_blelistCellDelegate>
@property (weak, nonatomic) IBOutlet UILabel *mCurrentConnect;
@property (weak, nonatomic) IBOutlet UITableView *mTableList;
@property (weak, nonatomic) IBOutlet UIButton *mRefreshBtn;
@property (nonatomic,retain) NSMutableArray  *deviceList;
@property (nonatomic,retain) NSMutableArray  *deviceMeshnameList;
@property (nonatomic,retain) NSString  *currDevDes;
@property (nonatomic,retain)UIAlertView *searchAlert;
@property (retain,nonatomic) BTDevItem *addDevice;
@property (weak, nonatomic) IBOutlet UILabel *titleLabelEn;

@end

@implementation I9_BlueToothListViewController
@synthesize mCurrentConnect = _mCurrentConnect;
@synthesize mTableList = _mTableList;
@synthesize mRefreshBtn = _mRefreshBtn;
@synthesize deviceList = _deviceList;
@synthesize deviceMeshnameList = _deviceMeshnameList;
@synthesize currDevDes = _currDevDes;
@synthesize searchAlert  = _searchAlert;
@synthesize deviceNetName = _deviceNetName;
@synthesize addDevice = _addDevice;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.leftBtn.hidden = YES;
    self.rightBtn.hidden = YES;
    self.preBtn.hidden = NO;
    self.navTitleLabel.text = ModuleZW(@"灸大夫隔物灸仪列表");
    self.navTitleLabel.font = [UIFont systemFontOfSize:17/[UserShareOnce shareOnce].fontSize];
    if(_deviceNetName != nil){
        _mCurrentConnect.text = [NSString stringWithFormat:@"%@:%@",ModuleZW(@"现连接灸头网络名称"),_deviceNetName];
    }else{
        _mCurrentConnect.text = ModuleZW(@"当前未连接设备");
    }
    _titleLabelEn.text = ModuleZW(@"灸头网络列表");
    _mTableList.dataSource = self;
    _mTableList.delegate = self;
    _deviceList = [NSMutableArray new];
    [_mRefreshBtn setTitle:ModuleZW(@"刷新列表") forState:(UIControlStateNormal)];
    _deviceMeshnameList = [NSMutableArray new];
    if (SUPPORT_YES == [[moxibustion getInstance] getBluetoothSupportState]
        && STATE_ON == [[moxibustion getInstance] getBluetoothOpenState])
    {
        [[moxibustion getInstance] discoverDevice];
        
        _searchAlert = [[UIAlertView alloc] initWithTitle:ModuleZW(@"提示") message:ModuleZW(@"正在努力搜索灸大夫隔物灸仪...") delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [_searchAlert show];
    }
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationItem.title = @"灸大夫隔物灸仪列表";
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)RefreshBtnOnclinck:(id)sender {
    if (SUPPORT_YES == [[moxibustion getInstance] getBluetoothSupportState]
        && STATE_ON == [[moxibustion getInstance] getBluetoothOpenState])
    {
        [[moxibustion getInstance] discoverDevice];
        
        _searchAlert = [[UIAlertView alloc] initWithTitle:ModuleZW(@"提示") message:ModuleZW(@"正在努力搜索灸大夫隔物灸仪...") delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [_searchAlert show];
    }
}

-(void)ChangeNameSuccess{
    [_searchAlert dismissWithClickedButtonIndex:0 animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)updateDeviceList
{
    [_deviceList removeAllObjects];
    [_deviceMeshnameList removeAllObjects];
    [_searchAlert dismissWithClickedButtonIndex:0 animated:NO];
    [_deviceList addObjectsFromArray:[[moxibustion getInstance] getDiscoveredDevices]];
    [_deviceMeshnameList addObjectsFromArray:[[moxibustion getInstance] getDiscoveredDevicesName]];
    [_mTableList reloadData];
}

-(void)ConnectResult:(NSString *)uuid{
    [_mTableList reloadData];
}

-(void)disConnectResult:(NSString *)uuid{
    [_mTableList reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _deviceMeshnameList.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *arry = [_deviceList objectAtIndex:section];
    return arry.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *BLEListTableIdentifier = @"i9_blelistviewcell";
    i9_blelistViewCell *cell = (i9_blelistViewCell *)[tableView dequeueReusableCellWithIdentifier:BLEListTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"i9_blelistviewcell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    int section = indexPath.section;
    int row = indexPath.row;
    BTDevItem *devcie = _deviceList[section][row];
//    CBPeripheral *pheral = [_deviceList objectAtIndex:indexPath.row];
//    i9_BluetoothPeripheralModule *module;
//    i9_BluetoothPeripheralModule *module = [[i9_BluetoothClientFactory getInstance] getPeripheralInfInArrByUUID:[[pheral identifier] UUIDString]];
//    NSString *str;
    NSString *name = [NSString stringWithFormat:@"%@:%@",ModuleZW(@"灸头ID"),devcie.bodyCode];
    cell.mMechineName.text = name;
    cell.delegate = self;
    cell.mContectBtn.section = section;
    cell.mContectBtn.row = row;
    if(_deviceNetName == nil){
         cell.mContectBtn.hidden = YES;
    }else{
        if([devcie.u_Name isEqualToString:_deviceNetName]){
            cell.mContectBtn.hidden = YES;
        }else{
            cell.mContectBtn.hidden = NO;
        }
    }
    return cell;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WID, 60)];
    [view setBackgroundColor:[UIColor whiteColor]];
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WID, 1)];
    [line1 setBackgroundColor:[UIColor colorWithRed:(230 / 255.0) green:(230 / 255.0) blue:(230 / 255.0) alpha:1.0]];
    [view addSubview:line1];
    
    UILabel *tittle =  [[UILabel alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WID - 70, 40)];
    tittle.text = [NSString stringWithFormat:@"%@:%@",ModuleZW(@"灸头网络名称"),[_deviceMeshnameList objectAtIndex:section]];
    [view addSubview:tittle];
    
    UIButton *contentBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WID - 48, 10, 40, 40)];
    contentBtn.tag = section;
    [contentBtn setBackgroundImage:[UIImage imageNamed:@"connect_device"] forState:UIControlStateNormal];
    [contentBtn addTarget:self action:@selector(ConnectNetWorkOnclinck:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:contentBtn];
    
    if(_deviceNetName == nil){
        contentBtn.hidden = NO;
    }else{
        NSString *netname = [_deviceMeshnameList objectAtIndex:section];
        if([netname isEqualToString:_deviceNetName]){
            contentBtn.hidden = YES;
        }else{
            contentBtn.hidden = NO;
        }
    }
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WID, 1)];
    [line setBackgroundColor:[UIColor colorWithRed:(230 / 255.0) green:(230 / 255.0) blue:(230 / 255.0) alpha:1.0]];
    [view addSubview:line];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 58.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)ConnectNetWorkOnclinck:(id)sender{
    UIButton *btn = (UIButton *)sender;
    int select = btn.tag;
    _addDevice = _deviceList[select][0];
    if( [[moxibustion getInstance] checkDoneedPwd:_addDevice]){
        [[moxibustion getInstance] disConnect];
        [self performSelector:@selector(reConnectDevice) withObject:nil afterDelay:0.7];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:ModuleZW(@"正在连接AJi9-%@灸头网络,请输入三位密码"),_addDevice.u_Name] message:@"" delegate:self cancelButtonTitle:ModuleZW(@"取消") otherButtonTitles:ModuleZW(@"完成"),nil];
        alert.tag = 2;
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *textField = [alert textFieldAtIndex:0];
        [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [textField setKeyboardType:UIKeyboardTypeDefault];
        [alert show];
    }
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length > 3) {
        textField.text = [textField.text substringToIndex:3];
    }
}

-(void)ConnectOnclink:(id)sender{
    ConnectBtn *btn = (ConnectBtn*)sender;
    _addDevice = _deviceList[btn.section][btn.row];
    NSString *src = [[[moxibustion getInstance] getConnectDevice].bodyCode substringToIndex:11];
    NSString *org = [_addDevice.bodyCode substringToIndex:11];
    if([org isEqualToString:src] || [_addDevice.password isEqualToString:@"0000"]){
        [self doConnectDevice];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:ModuleZW(@"正在添加灸头%@到当前灸头网络,请输入三位密码"),_addDevice.bodyCode] message:@"" delegate:self cancelButtonTitle:ModuleZW(@"取消") otherButtonTitles:ModuleZW(@"完成"),nil];
        alert.tag = 1;
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *textField = [alert textFieldAtIndex:0];
        [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [textField setKeyboardType:UIKeyboardTypeDefault];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == 1){
        if (buttonIndex == 1) {
            UITextField *textField = [alertView textFieldAtIndex:0];
            NSString *text = [textField text];
            if([text isEqualToString:[[moxibustion getInstance] getDevicePassWord:_addDevice]]){
                [self doConnectDevice];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ModuleZW(@"您输入的三位密码错误，请您再次输入") message:@"" delegate:self cancelButtonTitle:ModuleZW(@"取消") otherButtonTitles:ModuleZW(@"完成"),nil];
                alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                alert.tag = 1;
                UITextField *textField = [alert textFieldAtIndex:0];
                [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
                [textField setKeyboardType:UIKeyboardTypeDefault];
                [alert show];
            }
        }
    }else if(alertView.tag == 2){
        if (buttonIndex == 1) {
            UITextField *textField = [alertView textFieldAtIndex:0];
            NSString *text = [textField text];
            if([text isEqualToString:[[moxibustion getInstance] getDevicePassWord:_addDevice]]){
                [[moxibustion getInstance] disConnect];
                [self performSelector:@selector(reConnectDevice) withObject:nil afterDelay:0.7];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ModuleZW(@"您输入的三位密码错误，请您再次输入") message:@"" delegate:self cancelButtonTitle:ModuleZW(@"取消") otherButtonTitles:ModuleZW(@"完成"),nil];
                alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                alert.tag = 2;
                UITextField *textField = [alert textFieldAtIndex:0];
                [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
                [textField setKeyboardType:UIKeyboardTypeDefault];
                [alert show];
            }
        }
    }
}

-(void)reConnectDevice{
    [[moxibustion getInstance] connectOneDevices:_addDevice];
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)ChangeDeviceName{
    [[moxibustion getInstance] joinOneDevicesMesh:_addDevice];
}

-(void)doConnectDevice{
    _searchAlert = [[UIAlertView alloc] initWithTitle:ModuleZW(@"提示") message: ModuleZW(@"正在连接隔物灸仪") delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [_searchAlert show];
    [[moxibustion getInstance] disConnect];
    [self performSelector:@selector(ChangeDeviceName) withObject:nil afterDelay:0.8];
}

- (void)dealloc {
    NSLog(@"");
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
