//
//  PersonalInformationViewController.h
//  Voicediagno
//
//  Created by ZhangYunguang on 15/11/24.
//  Copyright (c) 2015年 ZhangYunguang. All rights reserved.
//

#import "SayAndWriteController.h"

@interface PersonalInformationViewController : SayAndWriteController<MBProgressHUDDelegate,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate>


{
    CGPoint ptCenterper;
    NSMutableArray* PersionInfoArray;
    UITextField* Yh_TF;
    UIButton* BirthDay_btn;
    UITextField *mobile_Tf;//手机
    UITextField* TelephoneLb_Tf;//固话
    UITextField *nation_Tf;//民族
    UIButton* Certificates_btn;
    UITextField* AddressLb_Tf;
    UITextField* Certificates_Number_Tf;
    NSMutableArray *yearArray;
    NSMutableArray *monthArray;
    NSMutableArray *DaysArray;
    //  NSString *currentMonthString;
    
    int selectedYearRow;
    int selectedMonthRow;
    int selectedDayRow;
    
    BOOL firstTimeLoad;
    
    NSString *CertificatesType;
    NSString* SexStr;
    UIImageView *iconImage;
    UIImage * TxImg;
    
    BOOL IsYiHun;
    //NSString* IsYiBao;
    UITextField* SelectTF;
    MBProgressHUD* progress_;
    
}
@property( nonatomic,retain)UITableView* PersonInfoTableView;
@property( nonatomic ,retain) NSString* mobilestr;
@property( nonatomic ,retain) NSString* usernametr;
@property( nonatomic ,retain) NSString* Birthdaystr;
@property( nonatomic , retain) NSString* genderstr;
@property( nonatomic , retain) NSString* emailstr;
@property( nonatomic , retain) NSString* idstr;
@property( nonatomic , retain) NSString* regcodestr;
@property(nonatomic,retain)UITextField* pRegistrationTF;
@property(nonatomic,retain)UITextField* pRegistrationnewTF;
@property(nonatomic,retain)UITextField* pyouxiangTF;
@property(nonatomic,retain)UITextField* pshenfenZTF;
@property (nonatomic,retain) UIDatePicker *datePicker;
@property (nonatomic,retain) NSString *pngFilePath;
@property (strong, nonatomic)  UIPickerView *customPicker;
@property (strong, nonatomic)  UIToolbar *toolbarCancelDone;
@property( nonatomic ,copy)  NSString* UrlHttpImg;
@property( nonatomic ,retain) NSString *currentMonthString;


@end
