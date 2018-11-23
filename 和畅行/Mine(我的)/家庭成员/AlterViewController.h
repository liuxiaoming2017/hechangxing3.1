//
//  AlterViewController.h
//  Voicediagno
//
//  Created by ZhangYunguang on 16/1/11.
//  Copyright © 2016年 ZhangYunguang. All rights reserved.
//

#import "SayAndWriteController.h"
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface AlterViewController : SayAndWriteController<MBProgressHUDDelegate,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate>
{
    CGPoint ptCenterper;
    NSMutableArray* PersionInfoArray;
    UITextField* Yh_TF;
    UIButton* BirthDay_btn;
    UITextField* TelephoneLb_Tf;
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
    UIButton* ivIDCard;
    UIImage * TxImg;
    
    BOOL IsYiHun;
    NSString* IsYiBao;
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
@property (nonatomic ,retain) NSMutableArray *dataArray;//数据源数组
@property (nonatomic ,retain) NSMutableDictionary *dataDictionary;

@property (nonatomic,copy) NSString *category;


@end
