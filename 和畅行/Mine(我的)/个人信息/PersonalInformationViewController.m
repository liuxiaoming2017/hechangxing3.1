//
//  PersonalInformationViewController.m
//  Voicediagno
//
//  Created by ZhangYunguang on 15/11/24.
//  Copyright (c) 2015年 ZhangYunguang. All rights reserved.
//

#import "PersonalInformationViewController.h"
#import "Global.h"

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import <sys/utsname.h>

#import "ZHPickView.h"
#import "UIImageView+WebCache.h"
#import "PECropViewController.h"

#define currentMonth [currentMonthString integerValue]


@interface PersonalInformationViewController ()<ZHPickViewDelegate>
{
    NSString *_marryState;
    UIView *bottomView;
    UIView *backView;
}
    
    
@property(nonatomic,strong)ZHPickView *pickview;
@property(nonatomic,strong)NSIndexPath *indexPath;

@end

@implementation PersonalInformationViewController
@synthesize mobilestr;
@synthesize usernametr;
@synthesize Birthdaystr;
@synthesize genderstr;
@synthesize emailstr;
@synthesize idstr;
@synthesize regcodestr;
@synthesize datePicker;
@synthesize pRegistrationTF,pRegistrationnewTF,pyouxiangTF,pshenfenZTF;
@synthesize PersonInfoTableView=_PersonInfoTableView;
@synthesize customPicker=_customPicker;
@synthesize toolbarCancelDone=_toolbarCancelDone;
@synthesize pngFilePath;
@synthesize currentMonthString=_currentMonthString;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)goBack:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void) showHUD
{
    
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    
    
}
#pragma mark ------ 提交按钮
-(void)commitClick:(UIButton *)button{
    if ([Certificates_btn.titleLabel.text isEqualToString:@"请选择证件类型"]) {
       
        [self showAlertWarmMessage:@"请选择证件类型"];
        return;
    }
    
    if ([CertificatesType isEqualToString:@"idCard"]) {
        if (![UtilityFunc fitToChineseIDWithString:Certificates_Number_Tf.text]) {
            
            [self showAlertWarmMessage:@"请填写正确的证件号码"];
            return;
        }
        
    }
    
    [self showHUD];
    NSString *UrlPre=URL_PRE;
    NSString *aUrl = [NSString stringWithFormat:@"%@/member/update.jhtml",UrlPre];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:aUrl]];
    [request addRequestHeader:@"token" value:[UserShareOnce shareOnce].token];
    [request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]];
    [request setPostValue:[UserShareOnce shareOnce].uid forKey:@"id"];
    
    [request setPostValue:self.UrlHttpImg forKey:@"memberImage"];
    [request setPostValue:SexStr forKey:@"gender"];
    [request setPostValue:Yh_TF.text forKey:@"name"];
    [request setPostValue:mobile_Tf.textColor forKey:@"mobile"];
    [request setPostValue:TelephoneLb_Tf.text forKey:@"phone"];
    [request setPostValue:nation_Tf.text forKey:@"nation"];
    if ([[UserShareOnce shareOnce].marryState isEqualToString:@"已婚"]) {
        [request setPostValue:@(YES) forKey:@"isMarried"];
    }else if ([[UserShareOnce shareOnce].marryState isEqualToString:@"未婚"]){
        [request setPostValue:@(NO) forKey:@"isMarried"];
    }
    if (nation_Tf.text) {
        [request setPostValue:nation_Tf.text forKey:@"nation"];
    }
    [request addPostValue:[UserShareOnce shareOnce].token forKey:@"token"];
    [request setPostValue:AddressLb_Tf.text forKey:@"address"];
    [request setPostValue:CertificatesType forKey:@"identityType"];
    [request setPostValue:Certificates_Number_Tf.text forKey:@"idNumber"];
 
    [request setTimeOutSeconds:20];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestuserinfoError:)];
    [request setDidFinishSelector:@selector(requestuserinfoCompleted:)];
    [request startAsynchronous];
    
}

- (void)dealloc
{
   
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navTitleLabel.text = @"个人信息";
    //self.view.backgroundColor=[UtilityFunc colorWithHexString:@"##f2f1ef"];
    self.view.backgroundColor = [UIColor whiteColor];
    _marryState = [[NSString alloc] init];
    
    UIImageView *infoView = [Tools creatImageViewWithFrame:CGRectMake(0, 0, ScreenWidth, 92.5) imageName:@"个人信息_背景"];
    infoView.userInteractionEnabled = YES;
    iconImage = [Tools creatImageViewWithFrame:CGRectMake(20, 11.25, 70, 70) imageName:@"1我的_03"];
    iconImage.clipsToBounds = YES;
    iconImage.layer.cornerRadius = iconImage.frame.size.width/2;
    iconImage.layer.borderWidth = 1.0f;
    iconImage.layer.borderColor = [UIColor whiteColor].CGColor;
    [infoView addSubview:iconImage];
   
    UIButton* commitBtn=[Tools creatButtonWithFrame:CGRectMake(ScreenWidth/2-100, ScreenHeight-60, 200, 40) target:self sel:@selector(commitClick:) tag:11 image:@"个人信息_提交" title:nil];
    [self.view addSubview:commitBtn];
    
    UIButton *uploadImageBtn = [Tools creatButtonWithFrame:CGRectMake(ScreenWidth-208, 26.25, 70, 30) target:self sel:@selector(uploadImageClick:) tag:13 image:@"个人信息_上传头像" title:nil];
    [infoView addSubview:uploadImageBtn];
    
    UIButton *sexBtn = [Tools creatButtonWithFrame:CGRectMake(ScreenWidth-108, 26.25, 70, 30) target:self sel:@selector(sexClick:) tag:14 image:@"个人信息_性别" title:nil];
    [infoView addSubview:sexBtn];
    
    
    UITableView *tableview=[[UITableView alloc]initWithFrame:CGRectMake(0,kNavBarHeight, ScreenWidth, ScreenHeight-kNavBarHeight-80) style:UITableViewStylePlain];
    tableview.delegate=self;
    tableview.dataSource=self;
    tableview.bounces = NO;
    tableview.showsVerticalScrollIndicator = NO;
    tableview.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    // tableview.separatorColor =[UIColor clearColor];
    tableview.backgroundColor=[UIColor clearColor];
    //_PersonInfoTableView=tableview;
    tableview.tableHeaderView = infoView;
    [self.view addSubview:tableview];
    
    UITapGestureRecognizer *tapSCR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScreen:)];
    [tableview addGestureRecognizer:tapSCR];
    
    
    
    
    PersionInfoArray=[NSMutableArray new];
    [PersionInfoArray addObject:@"手机号码"];
    [PersionInfoArray addObject:@"真实姓名"];
    [PersionInfoArray addObject:@"婚姻状况"];
    [PersionInfoArray addObject:@"民       族"];
    [PersionInfoArray addObject:@"居住地址"];
    [PersionInfoArray addObject:@"固定电话"];
    [PersionInfoArray addObject:@"证件类型"];
    [PersionInfoArray addObject:@"证件号码"];
    
    ptCenterper=self.view.center;
    
    if ([UserShareOnce shareOnce].memberImage== (id)[NSNull null]) {
        
        iconImage.image = [UIImage imageNamed:@"1我的_03"];
    }
    else{
        self.UrlHttpImg=[UserShareOnce shareOnce].memberImage;
       
        [iconImage sd_setImageWithURL:[NSURL URLWithString:[UserShareOnce shareOnce].memberImage] placeholderImage:[UIImage imageNamed:@"1我的_03"]];
        
        
    }
    
//    SexStr=[UserShareOnce shareOnce].gender;
//  初始化性别
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([UserShareOnce shareOnce].gender != (id)[NSNull null]) {
        if ([[UserShareOnce shareOnce].gender isEqualToString:@"male"]) {
            btn.tag = 61;
            [self chooseSax:btn];
        }else{
            btn.tag = 62;
            [self chooseSax:btn];
        }
    }
    
    //IsYiBao=@"1";
    
    bottomView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:bottomView];
    backView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:backView];
    [backView setHidden:YES];
    [bottomView setHidden:YES];
    bottomView.backgroundColor = [UIColor blackColor];
    bottomView.alpha = 0.5;
    backView.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [backView addGestureRecognizer:tap];
   
    
    

}

-(void)tapClick:(UITapGestureRecognizer *)tap{
    [bottomView setHidden:YES];
    [backView setHidden:YES];
    for (UIView *view in backView.subviews) {
        [view removeFromSuperview];
    }
}
//点击私人服务
-(void)privateSeviceClick:(UIButton *)button{
    
}
//选择性别
-(void)sexClick:(UIButton *)button{
    [bottomView setHidden:NO];
    [backView setHidden:NO];
    for (UIView *view in backView.subviews) {
        [view removeFromSuperview];
    }
    
    //SexStr
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2-110, self.view.center.y-60, 220, 120)];
    imageView.alpha = 1;
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.image = [UIImage imageNamed:@"个人信息_弹出背景"];
    [backView addSubview:imageView];
    UIImageView *line = [Tools creatImageViewWithFrame:CGRectMake(0, 59.5, 220, 1) imageName:@"orderLine"];
    [imageView addSubview:line];
    imageView.userInteractionEnabled = YES;
    
    NSArray *arr = @[@"男",@"女"];
    for (int i=0; i<2; i++) {
        UIButton *btn = [Tools creatButtonWithFrame:CGRectMake(0, 60*i, 220, 59) target:self sel:@selector(chooseSax:) tag:61+i image:nil title:arr[i]];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [imageView addSubview:btn];
    }
    
}
-(void)chooseSax:(UIButton *)button{
    UIButton *sexBtn = (UIButton *)[self.view viewWithTag:14];
    switch (button.tag) {
        case 61:
        {//男
            [sexBtn setImage:[UIImage imageNamed:@"个人信息_性别"] forState:UIControlStateNormal];
            SexStr = @"male";
        }
            break;
        case 62:
        {//女
            [sexBtn setImage:[UIImage imageNamed:@"个人信息_08 - 女"] forState:UIControlStateNormal];
            SexStr = @"female";
        }
            break;
            
        default:
            break;
    }
    [bottomView setHidden:YES];
    [backView setHidden:YES];
    for (UIView *view in backView.subviews) {
        [view removeFromSuperview];
    }
}
//点击选择婚姻状况按钮
-(void)marryBtnClick:(UIButton *)button{
    [bottomView setHidden:NO];
    [backView setHidden:NO];
    for (UIView *view in backView.subviews) {
        [view removeFromSuperview];
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2-110, self.view.center.y-60, 220, 120)];
    imageView.alpha = 1;
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.image = [UIImage imageNamed:@"个人信息_弹出背景"];
    [backView addSubview:imageView];
    UIImageView *line = [Tools creatImageViewWithFrame:CGRectMake(0, 59.5, 220, 1) imageName:@"orderLine"];
    [imageView addSubview:line];
    imageView.userInteractionEnabled = YES;
    
    NSArray *arr = @[@"已婚",@"未婚"];
    for (int i=0; i<2; i++) {
        UIButton *btn = [Tools creatButtonWithFrame:CGRectMake(0, 60*i, 220, 59) target:self sel:@selector(chooseMarry:) tag:51+i image:nil title:arr[i]];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [imageView addSubview:btn];
    }
    
    
}
-(void)chooseMarry:(UIButton *)button{
    UIButton *marryStatuBtn = (UIButton *)[self.view viewWithTag:31];
    [marryStatuBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    switch (button.tag) {
        case 51:
        {//已婚
            [marryStatuBtn setTitle:@"已婚" forState:UIControlStateNormal];
            [UserShareOnce shareOnce].marryState = @"已婚";
        }
            break;
        case 52:
        {//未婚
            [marryStatuBtn setTitle:@"未婚" forState:UIControlStateNormal];
            [UserShareOnce shareOnce].marryState = @"未婚";
        }
            break;
            
        default:
            break;
    }
    [bottomView setHidden:YES];
    [backView setHidden:YES];
    for (UIView *view in backView.subviews) {
        [view removeFromSuperview];
    }
}

//上传头像
- (IBAction)uploadImageClick:(UIButton *)sender {
    
    if (SelectTF!=nil) {
        [SelectTF resignFirstResponder];
        [self restoreView];
    }
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"选取照片", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view]; // show from our table view (pops up in the middle of the table)
    
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(actionSheet.tag==10006)
    {
        if (buttonIndex==0) {
            CertificatesType=@"idCard";
        }
        if (buttonIndex==1) {
            CertificatesType=@"officerCard";
        }
        if (buttonIndex==2) {
            CertificatesType=@"passport";
        }
        if (buttonIndex==3) {
            CertificatesType=@"elseCard";
        }
        [Certificates_btn setTitle:[actionSheet buttonTitleAtIndex:buttonIndex] forState:UIControlStateNormal];
        [Certificates_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    else
    {
        if (buttonIndex == 0)
        {
            
            //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
            
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
                
                UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
                //pickerContro = imagePicker;
                imagePicker.delegate = self;
                imagePicker.allowsEditing = YES;
                imagePicker.sourceType = sourceType;
                const CGFloat cRed   = 232.0/255.0;
                const CGFloat cGreen = 149.0/255.0;
                const CGFloat cBlue  = 0.0/255.0;
                imagePicker.navigationBar.tintColor = [UIColor colorWithRed:cRed green:cGreen blue:cBlue alpha:1];
                //  [self.navigationController presentModalViewController:imagePicker animated:YES];
                
                [self presentViewController:imagePicker
                                   animated:YES
                                 completion:^(void){
                                     //Code
                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"HideTabbar" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"6",@"index",nil]];
                                 }];
                
               
            }
            
            
        }
        else if (buttonIndex == 1)
        {
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
            // pickerContro = imagePicker;
            const CGFloat cRed   = 232.0/255.0;
            const CGFloat cGreen = 149.0/255.0;
            const CGFloat cBlue  = 0.0/255.0;
            imagePicker.navigationBar.tintColor = [UIColor colorWithRed:cRed green:cGreen blue:cBlue alpha:1];
            imagePicker.navigationBar.barStyle = UIBarStyleBlackOpaque;
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = sourceType;
            // [[[UIApplication sharedApplication] keyWindow] addSubview:imagePicker.view];
            //[self.navigationController presentModalViewController:imagePicker animated:YES];
            [self presentViewController:imagePicker
                               animated:YES
                             completion:^(void){
                                 //Code
                                 [[NSNotificationCenter defaultCenter] postNotificationName:@"HideTabbar" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"6",@"index",nil]];
                             }];
        }
        else
        {
        }
    }
}

#pragma mark Camera View Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker
   didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
  
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self openEditorWithImage:image];
    }];
    return;
    
//    [picker dismissViewControllerAnimated:YES completion:nil];
//    iconImage.image = [info objectForKey:UIImagePickerControllerEditedImage];
//    //[ivIDCard setImage: [info objectForKey:UIImagePickerControllerEditedImage] forState:UIControlStateNormal];
//
//    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    self.pngFilePath = [NSString stringWithFormat:@"%@/usertouxiang.png",docDir];
//
//    NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation([info objectForKey:UIImagePickerControllerEditedImage])];
//    [data1 writeToFile:self.pngFilePath atomically:YES];
//
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowTabbar" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"6",@"index",nil]];
//    [self UpLoadImgHttp];
}

#pragma mark -

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
    iconImage.image = croppedImage;
    CGSize imagesize = croppedImage.size;
    imagesize.width = 300;
    imagesize.height = imagesize.width*croppedImage.size.height/croppedImage.size.width;
    if (croppedImage) {
        croppedImage = [GlobalCommon imageWithImage:croppedImage scaledToSize:imagesize];
        NSData *imageData = UIImageJPEGRepresentation(croppedImage, 0.3);
        
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        self.pngFilePath = [NSString stringWithFormat:@"%@/usertouxiang.png",docDir];
        
        [imageData writeToFile:self.pngFilePath atomically:YES];
        
        [self UpLoadImgHttp];
        
    }
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark -
- (void)openEditorWithImage:(UIImage *)image
{
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = image;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    
    controller.cropView.aspectRatio = 1.0f;
    
    [self presentViewController:navigationController animated:YES completion:NULL];
    
}

-(void) UpLoadImgHttp
{
    [GlobalCommon showMBHudWithView:self.view];
    NSString *UrlPre=URL_PRE;
    NSString *aUrlle= [NSString stringWithFormat:@"%@/member/fileUpload/upload.jhtml",UrlPre];
    aUrlle = [aUrlle stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url1 = [NSURL URLWithString:aUrlle];
    ASIFormDataRequest *request=[[ASIFormDataRequest alloc]initWithURL:url1];
    [request addRequestHeader:@"token" value:[UserShareOnce shareOnce].token];
    [request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]];
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    [request addPostValue:@"image" forKey:@"fileType"];
    [request addPostValue:[UserShareOnce shareOnce].token forKey:@"token"];
    [request setFile:self.pngFilePath forKey:@"file"];//可以上传图片
    [request setDidFailSelector:@selector(requestUpLoadError:)];//requestLoginError
    [request setDidFinishSelector:@selector(requestUpLoadCompleted:)];
    [request startAsynchronous];
   
}
- (void)requestUpLoadCompleted:(ASIHTTPRequest *)request
{
    [GlobalCommon hideMBHudWithView:self.view];
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    id status=[dic objectForKey:@"status"];
    if ([status intValue]==100)
    {
        self.UrlHttpImg=[dic objectForKey:@"data"];
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"uploadImageSuccess" object:nil];
    }
    else
    {
        //[GlobalCommon hideMBHudWithView:self.view];
    }
}
- (void)requestUpLoadError:(ASIHTTPRequest *)request
{
    NSLog(@"上传头像失败 --》 %@",request.error);
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowTabbar" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"6",@"index",nil]];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    //[picker dismissModalViewControllerAnimated:YES];
}




#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 47;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return PersionInfoArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 0.000001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LeMedicineCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier];
        cell.backgroundColor=[UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    if (indexPath.row==0) {

        UILabel* TxLb=[[UILabel alloc] init];
        TxLb.frame=CGRectMake(20.4, (cell.frame.size.height-21)/2, 65, 21);
        TxLb.text=[PersionInfoArray objectAtIndex:indexPath.row];
        TxLb.font=[UIFont systemFontOfSize:14];
        TxLb.textColor=[UtilityFunc colorWithHexString:@"#333333"];
        [cell addSubview:TxLb];
        TxLb.backgroundColor=[UIColor whiteColor];



        mobile_Tf=[[UITextField alloc] init];
        mobile_Tf.frame=CGRectMake(TxLb.frame.origin.x+TxLb.frame.size.width+5, (cell.frame.size.height-21)/2, ScreenWidth-TxLb.frame.origin.x-TxLb.frame.size.width-5-20.5, 21);
        mobile_Tf.returnKeyType=UIReturnKeyNext;
        mobile_Tf.delegate=self;
        mobile_Tf.placeholder=@"填写手机号码";
        mobile_Tf.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
        [mobile_Tf setValue:[UtilityFunc colorWithHexString:@"#666666"] forKeyPath:@"_placeholderLabel.textColor"];
        [mobile_Tf setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
        if ([UserShareOnce shareOnce].phone== (id)[NSNull null]) {

        }
        else{
            mobile_Tf.text=[UserShareOnce shareOnce].username;

        }
        mobile_Tf.font=[UIFont systemFontOfSize:14];
        [cell addSubview:mobile_Tf];

    }
    else  if(indexPath.row==1){

        UILabel* nameLb=[[UILabel alloc] init];
        nameLb.frame=CGRectMake(20.4, (cell.frame.size.height-21)/2, 65, 21);
        nameLb.text=[PersionInfoArray objectAtIndex:indexPath.row];
        nameLb.font=[UIFont systemFontOfSize:14];
        nameLb.textColor=[UtilityFunc colorWithHexString:@"#333333"];
        [cell addSubview:nameLb];
        nameLb.backgroundColor=[UIColor whiteColor];

        Yh_TF=[[UITextField alloc] init];
        Yh_TF.frame=CGRectMake(nameLb.frame.origin.x+nameLb.frame.size.width+5, (cell.frame.size.height-21)/2, ScreenWidth-nameLb.frame.origin.x-nameLb.frame.size.width-5-20.5, 21);
        Yh_TF.placeholder=@"填写您的真实姓名";
        NSString *str = [UserShareOnce shareOnce].name;
        if (str == nil || [str isKindOfClass:[NSNull class]] ||str.length == 0) {
            //Yh_TF.text=@"";
        }else{
            Yh_TF.text=[NSString stringWithString:str];
        }
        [Yh_TF setValue:[UtilityFunc colorWithHexString:@"#666666"] forKeyPath:@"_placeholderLabel.textColor"];
        [Yh_TF setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
        Yh_TF.returnKeyType=UIReturnKeyNext;
        Yh_TF.delegate=self;
        [cell addSubview:Yh_TF];
        Yh_TF.font=[UIFont systemFontOfSize:14];



    }
    else if (indexPath.row==2)
    {
        UILabel* marryLabel=[[UILabel alloc] init];
        marryLabel.frame=CGRectMake(20.4, (cell.frame.size.height-21)/2, 65, 21);
        marryLabel.text=[PersionInfoArray objectAtIndex:indexPath.row];
        marryLabel.font=[UIFont systemFontOfSize:14];
        marryLabel.textColor=[UtilityFunc colorWithHexString:@"#333333"];
        [cell addSubview:marryLabel];
        marryLabel.backgroundColor=[UIColor whiteColor];

        UIButton *marryStateBtn = [Tools creatButtonWithFrame:CGRectMake(marryLabel.frame.origin.x+marryLabel.frame.size.width+5, (cell.frame.size.height-21)/2, ScreenWidth-marryLabel.frame.origin.x-marryLabel.frame.size.width-5-20.5, 21) target:self sel:@selector(marryBtnClick:) tag:31 image:nil title:@"请选择您的婚否情况"];
        
        marryStateBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [marryStateBtn setTitleColor:[UtilityFunc colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        marryStateBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [marryStateBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 80)];
        if (([UserShareOnce shareOnce].marryState != nil && ![[UserShareOnce shareOnce].marryState isKindOfClass:[NSNull class]])) {
            NSLog(@"婚姻状况：%@",[UserShareOnce shareOnce].marryState);
            [marryStateBtn setTitle:[UserShareOnce shareOnce].marryState forState:UIControlStateNormal];
            [marryStateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        [cell addSubview:marryStateBtn];




    }
    else if (indexPath.row==3)
    {
        UILabel* nationLabel=[[UILabel alloc] init];
        nationLabel.frame=CGRectMake(20.4, (cell.frame.size.height-21)/2, 65, 21);
        nationLabel.text=[PersionInfoArray objectAtIndex:indexPath.row];
        nationLabel.font=[UIFont systemFontOfSize:14];
        nationLabel.textColor=[UtilityFunc colorWithHexString:@"#333333"];
        [cell addSubview:nationLabel];
        nationLabel.backgroundColor=[UIColor whiteColor];

        nation_Tf=[[UITextField alloc] init];
        nation_Tf.frame=CGRectMake(nationLabel.frame.origin.x+nationLabel.frame.size.width+5, (cell.frame.size.height-21)/2, ScreenWidth-nationLabel.frame.origin.x-nationLabel.frame.size.width-5-20.5, 21);
        nation_Tf.placeholder=@"请输入您的民族";
        NSLog(@"haha:%@",[UserShareOnce shareOnce].nation);
        if ([[UserShareOnce shareOnce].nation isKindOfClass:[NSNull class]] || [UserShareOnce shareOnce].nation == nil) {
            //nation_Tf.text=@"";
        }else{
            nation_Tf.text=[NSString stringWithString:[UserShareOnce shareOnce].nation];
        }
        [nation_Tf setValue:[UtilityFunc colorWithHexString:@"#666666"] forKeyPath:@"_placeholderLabel.textColor"];
        [nation_Tf setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
        nation_Tf.returnKeyType=UIReturnKeyNext;
        nation_Tf.delegate=self;
       [cell addSubview:nation_Tf];
        nation_Tf.font=[UIFont systemFontOfSize:14];


    }
    else if (indexPath.row==4)
    {
        UILabel* AddressLb=[[UILabel alloc] init];
        AddressLb.frame=CGRectMake(20.4, (cell.frame.size.height-21)/2, 65, 21);
        AddressLb.text=[PersionInfoArray objectAtIndex:indexPath.row];
        AddressLb.font=[UIFont systemFontOfSize:14];
        AddressLb.textColor=[UtilityFunc colorWithHexString:@"#333333"];
        [cell addSubview:AddressLb];
        AddressLb.backgroundColor=[UIColor whiteColor];


        AddressLb_Tf=[[UITextField alloc] init];
        AddressLb_Tf.frame=CGRectMake(AddressLb.frame.origin.x+AddressLb.frame.size.width+5,  (cell.frame.size.height-21)/2, ScreenWidth-AddressLb.frame.origin.x-AddressLb.frame.size.width-5-20.5, 21);
        AddressLb_Tf.delegate=self;
        AddressLb_Tf.placeholder=@"请输入您的居住地址";
        if ([UserShareOnce shareOnce].address== (id)[NSNull null]) {

        }
        else
        {
            AddressLb_Tf.text=[UserShareOnce shareOnce].address;
        }
        AddressLb_Tf.returnKeyType=UIReturnKeyDone;
        [AddressLb_Tf setValue:[UtilityFunc colorWithHexString:@"#666666"] forKeyPath:@"_placeholderLabel.textColor"];
        [AddressLb_Tf setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];

        [cell addSubview:AddressLb_Tf];
        AddressLb_Tf.font=[UIFont systemFontOfSize:14];




    }
    else if (indexPath.row==5)
    {
        UILabel* TelephoneLb=[[UILabel alloc] init];
        TelephoneLb.frame=CGRectMake(20.4, (cell.frame.size.height-21)/2, 65, 21);
        TelephoneLb.text=[PersionInfoArray objectAtIndex:indexPath.row];
        TelephoneLb.font=[UIFont systemFontOfSize:14];
        TelephoneLb.textColor=[UtilityFunc colorWithHexString:@"#333333"];
        [cell addSubview:TelephoneLb];
        TelephoneLb.backgroundColor=[UIColor whiteColor];


        TelephoneLb_Tf=[[UITextField alloc] init];
        TelephoneLb_Tf.frame=CGRectMake(TelephoneLb.frame.origin.x+TelephoneLb.frame.size.width+5,  (cell.frame.size.height-21)/2, ScreenWidth-TelephoneLb.frame.origin.x-TelephoneLb.frame.size.width-5-20.5, 21);
        TelephoneLb_Tf.returnKeyType=UIReturnKeyDone;
        TelephoneLb_Tf.delegate=self;
        TelephoneLb_Tf.placeholder=@"请输入您的固定电话";
        TelephoneLb_Tf.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
        [TelephoneLb_Tf setValue:[UtilityFunc colorWithHexString:@"#666666"] forKeyPath:@"_placeholderLabel.textColor"];
        [TelephoneLb_Tf setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
        if ([UserShareOnce shareOnce].phone== (id)[NSNull null]) {

        }
        else{
            TelephoneLb_Tf.text=[UserShareOnce shareOnce].phone;

        }
        TelephoneLb_Tf.font=[UIFont systemFontOfSize:14];
        [cell addSubview:TelephoneLb_Tf];


    }
    else if (indexPath.row==6)
    {
        UILabel* CertificatesLb=[[UILabel alloc] init];
        CertificatesLb.frame=CGRectMake(20.4, (cell.frame.size.height-21)/2, 65, 21);
        CertificatesLb.text=[PersionInfoArray objectAtIndex:indexPath.row];
        CertificatesLb.font=[UIFont systemFontOfSize:14];
        CertificatesLb.textColor=[UtilityFunc colorWithHexString:@"#333333"];
        [cell addSubview:CertificatesLb];
        CertificatesLb.backgroundColor=[UIColor whiteColor];


        Certificates_btn=[UIButton buttonWithType:UIButtonTypeCustom];
        Certificates_btn.frame=CGRectMake(CertificatesLb.frame.origin.x+CertificatesLb.frame.size.width+5,  (cell.frame.size.height-21)/2, ScreenWidth-CertificatesLb.frame.origin.x-CertificatesLb.frame.size.width-5-20.5, 21);
        [cell addSubview:Certificates_btn];
        Certificates_btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [Certificates_btn setTitle:@"请选择您的证件类型" forState:UIControlStateNormal];
        [Certificates_btn setTitleColor:[UtilityFunc colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        [Certificates_btn addTarget:self action:@selector(CertificatesAactive:) forControlEvents:UIControlEventTouchUpInside];
        Certificates_btn.titleLabel.font=[UIFont systemFontOfSize:14];

        if ([UserShareOnce shareOnce].identityType == (id)[NSNull null]) {
            [Certificates_btn setTitle:@"请选择您的证件类型" forState:UIControlStateNormal];
        }else{
            if ([[UserShareOnce shareOnce].identityType isEqualToString:@"idCard"]) {
                [Certificates_btn setTitle:@"身份证" forState:UIControlStateNormal];
            }else if ([[UserShareOnce shareOnce].identityType isEqualToString:@"officerCard"])
            {
                [Certificates_btn setTitle:@"军官证" forState:UIControlStateNormal];
            }
            else if ([[UserShareOnce shareOnce].identityType isEqualToString:@"passport"])
            {
                [Certificates_btn setTitle:@"护照" forState:UIControlStateNormal];
            }
            else{
                [Certificates_btn setTitle:@"其他" forState:UIControlStateNormal];
            }
            [Certificates_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    else if (indexPath.row==7)
    {
        UILabel* Certificates_NumberLb=[[UILabel alloc] init];
        Certificates_NumberLb.frame=CGRectMake(20.4, (cell.frame.size.height-21)/2, 65, 21);
        Certificates_NumberLb.text=[PersionInfoArray objectAtIndex:indexPath.row];
        Certificates_NumberLb.font=[UIFont systemFontOfSize:14];
        Certificates_NumberLb.textColor=[UtilityFunc colorWithHexString:@"#333333"];
        [cell addSubview:Certificates_NumberLb];
        Certificates_NumberLb.backgroundColor=[UIColor whiteColor];


        Certificates_Number_Tf=[[UITextField alloc] init];
        Certificates_Number_Tf.frame=CGRectMake(Certificates_NumberLb.frame.origin.x+Certificates_NumberLb.frame.size.width+5,  (cell.frame.size.height-21)/2, ScreenWidth-Certificates_NumberLb.frame.origin.x-Certificates_NumberLb.frame.size.width-5-20.5, 21);
        Certificates_Number_Tf.delegate=self;
        Certificates_Number_Tf.returnKeyType=UIReturnKeyDone;
        Certificates_Number_Tf.placeholder=@"请输入您的证件号码";
        if ([UserShareOnce shareOnce].idNumber== (id)[NSNull null] || [UserShareOnce shareOnce].idNumber == nil) {

        }else{

            Certificates_Number_Tf.text=[NSString stringWithString:[UserShareOnce shareOnce].idNumber];
        }
        [Certificates_Number_Tf setValue:[UtilityFunc colorWithHexString:@"#666666"] forKeyPath:@"_placeholderLabel.textColor"];
        [Certificates_Number_Tf setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
        [cell addSubview:Certificates_Number_Tf];
        Certificates_Number_Tf.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
        Certificates_Number_Tf.textColor=[UIColor blackColor];
        Certificates_Number_Tf.font=[UIFont systemFontOfSize:14];

    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor whiteColor];
    return cell;
}

//-(void)SegSexAction:(UISegmentedControl *)Seg{
//    NSInteger Index = Seg.selectedSegmentIndex;
//    switch (Index) {
//        case 0:
//        {
//            SexStr=@"male";
//            break;
//        }
//        case 1:
//        {
//            SexStr=@"female";
//            break;
//        }
//        default:
//            break;
//    }
//    
//    //NSLog(@"Seg.selectedSegmentIndex:%ld",Index);
//}
//-(void)YiHunSexAction:(UISegmentedControl *)Seg{
//    NSInteger Index = Seg.selectedSegmentIndex;
//    switch (Index) {
//        case 0:
//        {
//            
////            IsYiBao=@"1";
//            break;
//        }
//        case 1:
//        {
//            
////            IsYiBao=@"0";
//            break;
//        }
//        default:
//            break;
//    }
//    
//    // NSLog(@"Seg.selectedSegmentIndex:%ld",Index);
//}
-(void)AcceptAction:(id)sender
{
    
    if ([Certificates_btn.titleLabel.text isEqualToString:@"请选择证件类型"]) {
        [self showAlertWarmMessage:@"请选择证件类型"];
        
        return;
    }
    
    if ([CertificatesType isEqualToString:@"idCard"]) {
        if (![UtilityFunc fitToChineseIDWithString:Certificates_Number_Tf.text]) {
            
            [self showAlertWarmMessage:@"请填写正确的证件号码"];
            return;
        }
        
    }
    
    [GlobalCommon showMBHudWithView:self.view];
    NSString *UrlPre=URL_PRE;
    NSString *aUrl = [NSString stringWithFormat:@"%@/member/update.jhtml",UrlPre];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:aUrl]];
    [request addRequestHeader:@"token" value:[UserShareOnce shareOnce].token];
    [request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]];
    [request setPostValue:[UserShareOnce shareOnce].uid forKey:@"id"];
    
    [request setPostValue:self.UrlHttpImg forKey:@"memberImage"];
    [request setPostValue:SexStr forKey:@"gender"];
    [request setPostValue:Yh_TF.text forKey:@"name"];
    [request setPostValue:[UserShareOnce shareOnce].username forKey:@"mobile"];
    [request setPostValue:TelephoneLb_Tf.text forKey:@"phone"];
    [request setPostValue:self.genderstr forKey:@"nation"];
    //[request setPostValue:@"" forKey:@"isMarried"];
    [request addPostValue:[UserShareOnce shareOnce].token forKey:@"token"];
    [request setPostValue:AddressLb_Tf.text forKey:@"address"];
    [request setPostValue:CertificatesType forKey:@"identityType"];
    [request setPostValue:Certificates_Number_Tf.text forKey:@"idNumber"];
    //[request setPostValue:IsYiBao forKey:@"isMedicare"];
    if ([BirthDay_btn.titleLabel.text isEqualToString:@"请选择生日"]) {
        BirthDay_btn.titleLabel.text=@"";
    }
    [request setPostValue:BirthDay_btn.titleLabel.text forKey:@"birthday"];
    [request setTimeOutSeconds:20];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestuserinfoError:)];
    [request setDidFinishSelector:@selector(requestuserinfoCompleted:)];
    [request startAsynchronous];
}
-(void)CertificatesAactive:(id)sender
{
    if (SelectTF!=nil) {
        [SelectTF resignFirstResponder];
        [self restoreView];
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil
                                                    otherButtonTitles:@"身份证", @"军官证",@"护照",@"其它" ,nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    actionSheet.tag=10006;
    
    actionSheet.title=@"证件类型";
    //actionSheet.destructiveButtonIndex = 1;	// make the second button red (destructive)
    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]]; // show from our table view (pops up in the middle of the table)
   
    
}
-(void) BirthDayActive:(id)sender
{
    if (SelectTF!=nil) {
        [SelectTF resignFirstResponder];
        [self restoreView];
    }
    NSDate *date=[NSDate dateWithTimeIntervalSinceNow:9000000];
    _pickview=[[ZHPickView alloc] initDatePickWithDate:date datePickerMode:UIDatePickerModeDate isHaveNavControler:NO];
    _pickview.delegate=self;
    [_pickview show];
    
}
- (void)requestuserinfoCompleted:(ASIHTTPRequest *)request
{
    [GlobalCommon hideMBHudWithView:self.view];
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    NSLog(@"dic==%@",dic);
    id status=[dic objectForKey:@"status"];
    if ([status intValue]==100) {
        
        [UserShareOnce shareOnce].name=Yh_TF.text;
        [UserShareOnce shareOnce].gender=SexStr;
        [UserShareOnce shareOnce].birthday=BirthDay_btn.titleLabel.text;
        [UserShareOnce shareOnce].address=AddressLb_Tf.text;
        [UserShareOnce shareOnce].phone=TelephoneLb_Tf.text;
        [UserShareOnce shareOnce].identityType=CertificatesType;
        [UserShareOnce shareOnce].idNumber=Certificates_Number_Tf.text;
        //[UserShareOnce shareOnce].isMedicare=IsYiBao;
        [UserShareOnce shareOnce].memberImage=self.UrlHttpImg;
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"personalInfoUpdateSuccess" object:nil];
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"信息更新成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [av show];
        av.tag=10007;
        
        
    }
    else
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:[dic objectForKey:@"data"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [av show];
       
    }
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // alert.tag=10002;
    if (alertView.tag==10007)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)requestuserinfoError:(ASIHTTPRequest *)request
{
    [GlobalCommon hideMBHudWithView:self.view];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    SelectTF=textField;
    if (textField==Yh_TF || textField == mobile_Tf || textField == nation_Tf) {
        return;
    }
    [ self resizeViewForInput:nil ];
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //关闭键盘的方法
    //[[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [mobile_Tf resignFirstResponder];
    [Yh_TF resignFirstResponder];
    [nation_Tf resignFirstResponder];
    [AddressLb_Tf resignFirstResponder];
    [TelephoneLb_Tf resignFirstResponder];
    [Certificates_Number_Tf resignFirstResponder];
    [ self restoreView];
}

-(void)tapScreen:(UITapGestureRecognizer *)tap{
    [mobile_Tf resignFirstResponder];
    [Yh_TF resignFirstResponder];
    [nation_Tf resignFirstResponder];
    [AddressLb_Tf resignFirstResponder];
    [TelephoneLb_Tf resignFirstResponder];
    [Certificates_Number_Tf resignFirstResponder];
    [ self restoreView];
}
-(void)resizeViewForInput:(id)sender
{
    [UIView beginAnimations:@"resize for input" context:nil];
    [UIView setAnimationDuration:0.3f];
    self.view.center = CGPointMake(ptCenterper.x, ptCenterper.y-170);
    [UIView commitAnimations];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self restoreView];
    return YES;
}
-(void)restoreView
{
    [UIView beginAnimations:@"resize for input" context:nil];
    [UIView setAnimationDuration:0.3f];
    self.view.center = CGPointMake(ptCenterper.x, ptCenterper.y);
    [UIView commitAnimations];
}
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    
    NSLog(@"ddfdfd=%@",resultString);
    [BirthDay_btn setTitle:resultString forState:UIControlStateNormal];
    // UITableViewCell * cell=[self.tableView cellForRowAtIndexPath:_indexPath];
    //cell.detailTextLabel.text=resultString;
}




@end
