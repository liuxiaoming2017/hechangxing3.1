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
#import "WXPhoneController.h"
#define currentMonth [currentMonthString integerValue]


@interface PersonalInformationViewController ()<ZHPickViewDelegate,MBProgressHUDDelegate,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate>

//@property (nonatomic,strong)ZHPickView *pickview;
@property (nonatomic,strong)UIView *blackView;
@property (nonatomic,strong)UIButton *photoButton;
@property (nonatomic,strong)UIButton *brithdayButton;
@property (nonatomic,copy)NSString *urlHttpImg;
@property (nonatomic,copy)NSString *sexStr;
@property (nonatomic,copy)NSString *nameStr;
@property (nonatomic,copy)NSString *brithdayStr;
@property (nonatomic,copy)NSString *phoneStr;
@property (nonatomic,copy) NSString *pngFilePath;
@property (nonatomic,strong) UIDatePicker *datePicker;
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,copy)  NSString *dateString;

@end

@implementation PersonalInformationViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleLabel.text = ModuleZW(@"个人资料");
    [self layoutMineView];
}

-(void)layoutMineView{
    
    self.nameStr        = [NSString string];
    self.sexStr           = [NSString string];
    self.brithdayStr    = [NSString string];
    self.phoneStr       = [NSString string];
    if ([MemberUserShance shareOnce].name.length <  26) {
        self.nameStr = [MemberUserShance shareOnce].name;
    }else{
        self.nameStr = [UserShareOnce shareOnce].wxName;
    }
    if (![GlobalCommon stringEqualNull:[UserShareOnce shareOnce].gender]) {
        if ([[UserShareOnce shareOnce].gender isEqualToString:@"male"]) {
            self.sexStr  = ModuleZW(@"男");
        }else{
            self.sexStr   =  ModuleZW(@"女");
        }
    }else{
        self.sexStr = @"未设置";
    }
    
    if(![GlobalCommon stringEqualNull:[UserShareOnce shareOnce].birthday]){
        self.brithdayStr  = [UserShareOnce shareOnce].birthday;
    }else {
        self.brithdayStr  = ModuleZW(@"未设置");
    }
    
    
    if ([[UserShareOnce shareOnce].loginType isEqualToString:@"WX"]){
        if([self deptNumInputShouldNumber:[UserShareOnce shareOnce].username]){
            self.phoneStr  = [UserShareOnce shareOnce].username;
        }else{
            self.phoneStr = ModuleZW(@"未绑定");
        }
    }else{
        if (![GlobalCommon stringEqualNull:[UserShareOnce shareOnce].username]) {
            if([self deptNumInputShouldNumber:[UserShareOnce shareOnce].username]){
                self.phoneStr  = [UserShareOnce shareOnce].username;
            }else{
                self.phoneStr = @"";
            }
        }
    }
   
    NSArray *titleArray = @[ModuleZW(@"头像"),ModuleZW(@"昵称"),ModuleZW(@"性别"),ModuleZW(@"出生日期"),ModuleZW(@"手机号码")];
    NSArray *contentArray = @[@"",self.nameStr,self.sexStr,self.brithdayStr ,self.phoneStr ];
    
    for (int i = 0; i < titleArray.count; i++) {
        UILabel *leftLabel = [[UILabel alloc]init];
        leftLabel.text = titleArray[i];
        leftLabel.textColor =  RGB_TextDarkGray;
        leftLabel.font = [UIFont systemFontOfSize:16];
        if(i == 0){
            leftLabel.frame = CGRectMake(30, kNavBarHeight , 100, 90);
            UIButton *photoButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
            photoButton.frame = CGRectMake(ScreenWidth - 100, kNavBarHeight + 10, 70, 70);
            photoButton.layer.cornerRadius = 35;
            photoButton.layer.masksToBounds = YES;
            if (![GlobalCommon stringEqualNull:[UserShareOnce shareOnce].memberImage]) {
                self.urlHttpImg=[UserShareOnce shareOnce].memberImage;
                [photoButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[UserShareOnce shareOnce].memberImage] forState:(UIControlStateNormal)];
                
                 [photoButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[UserShareOnce shareOnce].memberImage]  forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"1我的_03"]];
            } else{
                [photoButton setBackgroundImage:[UIImage imageNamed:@"1我的_03"] forState:(UIControlStateNormal)];
            }
            [photoButton addTarget:self action:@selector(uploadImageClick) forControlEvents:(UIControlEventTouchUpInside)];
            
            UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(photoButton.right + 10, kNavBarHeight + 37.5 , 12, 15)];
            iconImageView.image = [UIImage imageNamed:@"1我的_09"];
            [self.view addSubview:iconImageView];
            [self.view addSubview:photoButton];
            self.photoButton = photoButton;
            
        }else {
            leftLabel.frame = CGRectMake(30, kNavBarHeight + 90 + 45 *(i-1), 110, 45);
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            button.frame = CGRectMake(leftLabel.right + 20, leftLabel.top, ScreenWidth - leftLabel.right - 50, 45);
            [button setTitle:contentArray[i] forState:(UIControlStateNormal)];
            [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
            [button setTitleColor: [UIColor blackColor] forState:(UIControlStateNormal)];
            [button.titleLabel setFrame:button.bounds];
            [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
            [[button rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
                switch (i) {
                    case 1: {
                        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"" message:nil preferredStyle:
                                                      UIAlertControllerStyleAlert];
                        [alertVc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                            textField.placeholder = ModuleZW(@"设置昵称");
                            [textField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
                            
                        }];
                        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                            self.nameStr = [[alertVc textFields] objectAtIndex:0].text;
                            [button setTitle:self.nameStr forState:(UIControlStateNormal)];
                            [self commitClick];
                        }];
                        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                        [alertVc addAction:action2];
                        [alertVc addAction:action1];
                        [self presentViewController:alertVc animated:YES completion:nil];
                    }
                        break;
                    case 2:
                        [self sexClick:x];
                        break;
                    case 3:
                        [self birthDayActive];
                        break;
                    case 4:
                        if ([[UserShareOnce shareOnce].loginType isEqualToString:@"WX"]){
                            if([UserShareOnce shareOnce].username.length != 11){
                                WXPhoneController *vc = [[WXPhoneController alloc]init];
                                [self.navigationController pushViewController:vc animated:YES];
                            }
                        }
                        break;
                    default:
                        break;
                }
            }];
            if(i == 3){
                _brithdayButton = button;
            }
            UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(button.width + 10, 15 , 12, 15)];
            iconImageView.image = [UIImage imageNamed:@"1我的_09"];
            [button addSubview:iconImageView];
            [self.view addSubview:button];

        }
        [self.view addSubview:leftLabel];
    }
    
    
}


//选择性别
-(void)sexClick:(UIButton *)button{

    UIView *blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    blackView.backgroundColor = RGBA(0, 0, 0, 0.5);
    [self.view addSubview:blackView];
    self.blackView = blackView;
    //SexStr
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2-110, self.view.center.y-60, 220, 120)];
    imageView.alpha = 1;
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.image = [UIImage imageNamed:@"个人信息_弹出背景"];
    UIImageView *line = [Tools creatImageViewWithFrame:CGRectMake(0, 59.5, 220, 1) imageName:@"orderLine"];
    [imageView addSubview:line];
    imageView.userInteractionEnabled = YES;
    [blackView addSubview:imageView];
    
    NSArray *arr = @[ModuleZW(@"男"),ModuleZW(@"女")];
    for (int i=0; i<2; i++) {
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        btn.frame = CGRectMake(0, 60*i, 220, 59);
        [btn setTitle:arr[i] forState:(UIControlStateNormal)];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [[btn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [blackView removeFromSuperview];
            switch (i) {
                case 0:
                    [button setTitle:ModuleZW(@"男") forState:(UIControlStateNormal)];
                    self.sexStr = ModuleZW(@"男");
                    [self commitClick];
                    break;
                    
                case 1:
                    [button setTitle:ModuleZW(@"女") forState:(UIControlStateNormal)];
                    self.sexStr = ModuleZW(@"女");
                    [self commitClick];
                    break;
                    
                default:
                    break;
            }
            
        }];
        [imageView addSubview:btn];
    }
    
}



#pragma mark ------ 提交按钮
-(void)commitClick {
    
    NSString *sexStr = [NSString string];
    if([self.sexStr isEqualToString:ModuleZW(@"男")]){
        sexStr = @"male";
    }else if([self.sexStr isEqualToString:ModuleZW(@"女")]){
        sexStr = @"female";
    }else{
        sexStr = @"";
    }
   [GlobalCommon showMBHudWithView:self.view];
    NSString *UrlPre=URL_PRE;
    NSString *aUrl = [NSString stringWithFormat:@"%@/member/update.jhtml",UrlPre];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:aUrl]];
    [request addRequestHeader:@"token" value:[UserShareOnce shareOnce].token];
    [request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]];
    if([UserShareOnce shareOnce].languageType){
        [request addRequestHeader:@"language" value:[UserShareOnce shareOnce].languageType];
    }
    [request setPostValue:[UserShareOnce shareOnce].uid forKey:@"id"];
    [request setPostValue:self.urlHttpImg forKey:@"memberImage"];
    [request setPostValue:sexStr forKey:@"gender"];
    [request setPostValue:self.nameStr forKey:@"name"];
    [request setPostValue:_phoneStr forKey:@"mobile"];
    if ([_brithdayStr isEqualToString:@"请选择您的出生日期"]) {
        _brithdayStr = @"";
    }
    [request addPostValue:[UserShareOnce shareOnce].token forKey:@"token"];
    [request setPostValue:_brithdayStr forKey:@"birthday"];
    [request setTimeOutSeconds:20];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestuserinfoError:)];
    [request setDidFinishSelector:@selector(requestuserinfoCompleted:)];
    [request startAsynchronous];
    
}


//上传头像
- (void)uploadImageClick{
    
    
    UIAlertController *alVC = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *kakaAction= [UIAlertAction actionWithTitle:ModuleZW(@"拍照") style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
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
        
    }];
    UIAlertAction *photoAction= [UIAlertAction actionWithTitle:ModuleZW(@"选取照片") style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
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
        
    }];
    UIAlertAction *cancelAction= [UIAlertAction actionWithTitle:ModuleZW(@"取消") style:(UIAlertActionStyleCancel) handler:nil];
    
    [alVC addAction:kakaAction];
    [alVC addAction:photoAction];
    [alVC addAction:cancelAction];
    [self presentViewController:alVC animated:YES completion:nil];
    
}


#pragma mark Camera View Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker
   didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
  
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self openEditorWithImage:image];
    }];
    return;
}

#pragma mark -
- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
    [self.photoButton setBackgroundImage:croppedImage forState:(UIControlStateNormal)];
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
    if([UserShareOnce shareOnce].languageType){
        [request addRequestHeader:@"language" value:[UserShareOnce shareOnce].languageType];
    }
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
        self.urlHttpImg=[dic objectForKey:@"data"];
        [UserShareOnce shareOnce].memberImage = self.urlHttpImg;
    }
}
- (void)requestUpLoadError:(ASIHTTPRequest *)request
{
    NSLog(@"上传头像失败 --》 %@",request.error);
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowTabbar" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"6",@"index",nil]];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)textFieldDidChanged:(UITextField *)textField {
    UITextRange *selectedRange = textField.markedTextRange;
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    if (position) {
        return;
    }
    if (textField.text.length > 7) {
        textField.text = [textField.text substringToIndex:7];
    }
}

-(void) birthDayActive
{
    [self layoutDataView];
    
}
- (void)requestuserinfoCompleted:(ASIHTTPRequest *)request
{
    [GlobalCommon hideMBHudWithView:self.view];
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    NSLog(@"dic==%@",dic);
    id status=[dic objectForKey:@"status"];
    if ([status intValue]==100) {
        
        [UserShareOnce shareOnce].name=_nameStr;
        [UserShareOnce shareOnce].gender=_sexStr;
        [UserShareOnce shareOnce].birthday=_brithdayStr;
        [UserShareOnce shareOnce].username=_phoneStr;
        [UserShareOnce shareOnce].memberImage=self.urlHttpImg;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"personalInfoUpdateSuccess" object:nil];

        
    } else {
        [self showAlertWarmMessage:[dic objectForKey:@"data"]];
    }
}

- (void)requestuserinfoError:(ASIHTTPRequest *)request
{
    [GlobalCommon hideMBHudWithView:self.view];
}

- (BOOL) deptNumInputShouldNumber:(NSString *)str
{
    if (str.length == 0) {
        return NO;
    }
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:str]) {
        return YES;
    }
    return NO;
}

-(void)layoutDataView{
    

    if(!_backView){
        UIView *backView  = [[UIView alloc]initWithFrame:self.view.bounds];
        backView.backgroundColor = RGBA(0, 0, 0, 0.4);
        [self.view addSubview:backView];
        _backView = backView;
        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(10, ScreenHeight - 290, ScreenWidth - 20, 280)];
        bottomView.backgroundColor = [UIColor whiteColor];
        bottomView.layer.cornerRadius = 15;
        [backView addSubview:bottomView];
        
        UILabel *dataLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, 100, 30)];
        dataLabel.textColor = RGB_TextGray;
        dataLabel.font = [UIFont systemFontOfSize:14];
        [bottomView addSubview:dataLabel];
//        _datatypeLabel = dataLabel;
        
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(bottomView.width/2 - 0.25,bottomView.height - 36, 0.5, 32)];
        lineView.backgroundColor = RGB(230, 230, 230);
        [bottomView addSubview:lineView];
        
        self.datePicker = [[UIDatePicker alloc] init];
        self.datePicker.frame = CGRectMake(30, 40, bottomView.width - 80, 200);
        if([UserShareOnce shareOnce].languageType){
            self.datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"us"];
        }else{
            self.datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        }
        self.datePicker.datePickerMode =  UIDatePickerModeDate;
        [self.datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
        [self.datePicker setMaximumDate:[NSDate date]];
        [bottomView addSubview:self.datePicker];
    
        
        NSArray *buttonTitleArray = @[ModuleZW(@"取消"),ModuleZW(@"确定")];
        for (int i = 0; i < 2; i++) {
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            button.frame = CGRectMake(40 + (bottomView.width/2-40)*i  , bottomView.height - 40, (bottomView.width - 80)/2, 40);
            [button setTitle:buttonTitleArray[i] forState:(UIControlStateNormal)];
            [button setTitleColor:UIColorFromHex(0Xffa200) forState:(UIControlStateNormal)];
            [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
            [[button rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
                if(i == 1){
                    self.brithdayStr = self.dateString;
                    [self->_brithdayButton setTitle:self->_brithdayStr forState:(UIControlStateNormal)];
                     [self commitClick];
                }
                backView.hidden = YES;
            }];
            [bottomView addSubview:button];
        }
    }else{
        _backView.hidden = NO;

      
    }
    
    if(self.brithdayStr.length > 7){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY/MM/dd"];
        NSDate *tempDate = [dateFormatter dateFromString:_brithdayStr];
        [self.datePicker setDate:tempDate animated:YES];
    }
}

- (void)dateChange:(UIDatePicker *)datePicker {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"yyyy/MM/dd";
    NSString *dateStr = [formatter  stringFromDate:datePicker.date];
    self.dateString = dateStr;
 
    
}

- (void)goBack:(UIButton *)btn
{
    if(_datePicker){
        [_datePicker removeFromSuperview];
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
