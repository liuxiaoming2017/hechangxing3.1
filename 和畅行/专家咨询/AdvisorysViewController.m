//
//  AdvisorysViewController.m
//  Voicediagno
//
//  Created by ZhangYunguang on 16/1/13.
//  Copyright © 2016年 ZhangYunguang. All rights reserved.
//

#import "AdvisorysViewController.h"

#import "NSObject+SBJson.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"


#import "LoginViewController.h"
#import "CPTextViewPlaceholder.h"
#import "NSString+Emoji.h"
#import "TZImagePickerController.h"
#import "PYPhotoBrowser.h"
#import "AFNetworking.h"
#import"AdvisoryTableViewCell.h"


///弱引用/强引用
#define CCWeakSelf __weak typeof(self) weakSelf = self;
#define WIDTHS (self.view.frame.size.width -64)/4

@interface AdvisorysViewController ()<UIActionSheetDelegate,UIPickerViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,MBProgressHUDDelegate,UIScrollViewDelegate,UITextViewDelegate,TZImagePickerControllerDelegate,PYPhotosViewDelegate>
{
    NSString *CertificatesType;
    UIButton* Certificates_btn;
    UIButton* ivIDCard;
    MBProgressHUD* progress_;
    UIView *diView;
    int bntTag;
}

@property (nonatomic ,strong) UIButton *addButton;
@property( nonatomic ,copy)  NSString* UrlHttpImg;
@property (nonatomic,strong) NSString *pngFilePath;

@property (nonatomic ,strong) UIView *personView;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) UIView *showView;

@property (nonatomic ,strong) NSMutableArray *headArray;
@property (nonatomic ,strong) UILabel *nameLabel;
@property (nonatomic ,strong) UILabel *sexLabel;
@property (nonatomic ,strong) UILabel *phoneLabel;
@property (nonatomic ,strong) UIScrollView *scrollView1;
@property (nonatomic ,strong) UIView *imageShowView;
@property (nonatomic ,strong) UIView *imageShowscroll;
@property (nonatomic ,strong) NSString *memberChildId;
@property (nonatomic ,strong) UITextView *textView;
@property (nonatomic ,strong) UITextView *textViews;

@property(nonatomic,strong)NSMutableArray *photos;//放图片的数组
@property (nonatomic, weak) PYPhotosView *publishPhotosView;//属性 保存选择的图片
@property(nonatomic,assign)int repeatClickInt;
@property (nonatomic,strong)NSMutableArray *dataArr;
/**subId*/
@property (nonatomic,copy) NSString *subId;
@property (nonatomic,strong)UIButton *finishButton;
@property (nonatomic,strong)UIButton *choseButton;
@end

@implementation AdvisorysViewController

- (void)dealloc{
    self.photos = nil;
    self.headArray = nil;
    self.textView = nil;
    self.textViews = nil;
    self.publishPhotosView = nil;
}

-(void)backClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navTitleLabel.text = @"专家咨询";
    
    self.headArray = [[NSMutableArray alloc]init];
    self.dataArr = [NSMutableArray array];
    _memberChildId = [UserShareOnce shareOnce].mengberchildId;
    NSString *nameStr = [UserShareOnce shareOnce].name;
    if ([GlobalCommon stringEqualNull:nameStr]) {
        nameStr = [MemberUserShance shareOnce].name;
    }
    self.view.backgroundColor = [UIColor whiteColor];

    
    UIButton *choseButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    choseButton.backgroundColor = RGB(224, 224, 224);
    choseButton.frame = CGRectMake(0, kNavBarHeight, ScreenWidth, 50);
    [choseButton setTitle:nameStr forState:(UIControlStateNormal)];
    [choseButton setTitleColor: [UtilityFunc colorWithHexString:@"#666666"] forState:(UIControlStateNormal)];
    [choseButton addTarget:self action:@selector(chosePeople) forControlEvents:(UIControlEventTouchUpInside)];
    [choseButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [self.view addSubview:choseButton];
    self.choseButton = choseButton;
    choseButton.titleEdgeInsets = UIEdgeInsetsMake(0, -ScreenWidth + 150, 0, 0);
    
    UIImageView *leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15.5, 30, 21)];
    leftImageView.image = [UIImage imageNamed:@"221323_03.png"];
    [choseButton addSubview:leftImageView];
  
    UIImageView *peopleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 40 , 18, 18, 16)];
    peopleImageView.image = [UIImage imageNamed:@"HCY_right"];
    [choseButton addSubview:peopleImageView];
    
    _textView = [[CPTextViewPlaceholder alloc]initWithFrame:CGRectMake(10, choseButton.bottom+10, self.view.frame.size.width - 20, 100)];
    UIView *grayView=[[UIView alloc]initWithFrame:CGRectMake(0, choseButton.bottom, self.view.bounds.size.width, 40)];
    _textView.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChangess) name:UITextViewTextDidChangeNotification object:self.textView];
    
    grayView.backgroundColor=[UtilityFunc colorWithHexString:@"#f1f3f6"];
    _textView.tag = 123;
    _textView.inputAccessoryView=grayView;
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.textColor = [UtilityFunc colorWithHexString:@"#666666"];
    
    _textViews = [[UITextView alloc]initWithFrame:CGRectMake(10, choseButton.bottom+10, self.view.frame.size.width - 20, 100)];
    _textView.keyboardType = UIKeyboardTypeDefault;
    _textView.returnKeyType = UIReturnKeyDone;
    _textViews.text = @"请详细描述您的症状、疾病和身体状况。我们根据病情分诊到对应的大夫为您解答。";
    _textViews.font = [UIFont systemFontOfSize:15];
    _textViews.textColor = [UtilityFunc colorWithHexString:@"#666666"];
    [self.view addSubview:_textViews];
    _textView.backgroundColor = [UIColor clearColor];
//    _textViews.backgroundColor = [UIColor redColor];
    [self.view addSubview:_textView];
    
    // 1. 常见一个发布图片时的photosView
    PYPhotosView *publishPhotosView = [PYPhotosView photosView];
    publishPhotosView.py_x = 19;
    publishPhotosView.py_y = _textView.bottom+22;
    publishPhotosView.photoWidth = (ScreenWidth-10*2-5*3)/4.0;
    publishPhotosView.photoHeight = publishPhotosView.photoWidth;
    // 2.1 设置本地图片
    publishPhotosView.images = nil;
    // 3. 设置代理
    publishPhotosView.delegate = self;
    //publishPhotosView.backgroundColor = [UIColor blackColor];
    publishPhotosView.photosMaxCol = 4;//每行显示最大图片个数
    publishPhotosView.imagesMaxCountWhenWillCompose = 8;//最多选择图片的个数
    // 4. 添加photosView
    [self.view addSubview:publishPhotosView];
    self.publishPhotosView = publishPhotosView;
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.publishPhotosView.bottom+20, ScreenWidth, 120)];
    bottomView.tag = 2018;
    [self.view addSubview:bottomView];
    
    UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    photoButton.frame = CGRectMake(24, 0, 50, 50) ;
    [photoButton setBackgroundImage:[UIImage imageNamed:@"专家咨询11_023.png"] forState:UIControlStateNormal];
    [photoButton addTarget:self action:@selector(photoButton) forControlEvents:UIControlEventTouchUpInside];

    [bottomView addSubview:photoButton];
    
    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    finishButton.frame = CGRectMake(self.view.frame.size.width / 2 - 70,80, 140, 40);
    [finishButton setBackgroundColor:UIColorFromHex(0x1e82d2)];
    [finishButton setTitle:@"提交" forState:UIControlStateNormal];
    finishButton.layer.cornerRadius = 5.0;
    finishButton.clipsToBounds = YES;
    finishButton.alpha = 0.4;
    finishButton.userInteractionEnabled = NO;
    [finishButton addTarget:self action:@selector(finishButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:finishButton];
    self.finishButton = finishButton;
    
}

- (void)textDidChangess{
    _textViews.hidden = [_textViews hasText];
    if([_textView hasText]){
        self.finishButton.alpha = 1;
        self.finishButton.userInteractionEnabled = YES;
    }else{
        self.finishButton.alpha = 0.4;
        self.finishButton.userInteractionEnabled = NO;
    }
}


#pragma mark ----------   选择子成员
-(void)chosePeople {
    
    [self GetWithModifi];
    
}

#pragma mark ----------  收键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //关闭键盘的方法
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    // 不让输入表情
    
    if ([textView isFirstResponder]) {
        if ([[[textView textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textView textInputMode] primaryLanguage]) {
            NSLog(@"输入的是表情，返回NO");
            [self showAlertWarmMessage:@"不能输入表情"];
            return NO;
        }
    }
    return YES;
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    return  YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    [NSString stringValidateEmoji:textView.text];
}



- (void)finishButtonAction{
    if ([_textView.text isEqual:[NSNull null]]||_textView.text == nil||[_textView.text isEqualToString:@""]) {
        [self showAlertWarmMessage:@"抱歉，请填写你的症状"];
        
        return;
    }
    
    //[self uploadImageToServer];
    [self batchRequest];
    
    
    /*
    [NSString stringValidateEmoji:_textView.text];
    [self showHUD];
    NSString *UrlPre=URL_PRE;
    NSString *aUrl = [NSString stringWithFormat:@"%@/member/user_consultation/commit.jhtml",UrlPre];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:aUrl]];
    [request addRequestHeader:@"token" value:[UserShareOnce shareOnce].token];
    [request addRequestHeader:@"version" value:@"ios_jlsl-yh-3"];
    [request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]];
    [request setPostValue:_memberChildId forKey:@"memberChildId"];
    [request setPostValue:_textView.text forKey:@"content"];
    NSString *strings = @"";
    if (self.headArray.count == 0) {
        
    }else{
        for (int i = 0; i < self.headArray.count; i++) {
            if (i==0) {
                strings = [strings stringByAppendingString:self.headArray[i]];
            }else {
                strings = [strings stringByAppendingString:@","];
                strings = [strings stringByAppendingString:self.headArray[i]];
            }
            
        }
    }
    [request setPostValue:strings forKey:@"userConsultationImages"];
    [request setPostValue:[UserShareOnce shareOnce].token forKey:@"token"];
    [request setTimeOutSeconds:20];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestuserinfoErrorWithsUser:)];
    [request setDidFinishSelector:@selector(requestuserinfoCompletedWithUser:)];
    [request startAsynchronous];
     */
}
/*
- (void)requestuserinfoErrorWithsUser:(ASIHTTPRequest *)request
{
    [self hudWasHidden];
    
    [self showAlertWarmMessage:@"抱歉，请检查您的网络是否畅通"];
    
}
- (void)requestuserinfoCompletedWithUser:(ASIHTTPRequest *)request
{
    [self hudWasHidden];
    NSString* reqstr=[request responseString];
    NSLog(@"dic==%@",reqstr);
    NSDictionary * dic=[reqstr JSONValue];
    NSLog(@"dic==%@",dic);
    id status=[dic objectForKey:@"status"];
    NSLog(@"%@",status);
    if ([status intValue]==100) {
        [_imageShowView removeFromSuperview];
        [_imageShowscroll removeFromSuperview];
        [self.headArray removeAllObjects];
        _imageShowView = [[UIView alloc]initWithFrame:CGRectMake(24, 265, self.view.frame.size.width, 80)];
        [self.view addSubview:self.imageShowView];
        _imageShowscroll = [[UIView alloc]initWithFrame:CGRectMake(60, 325, self.view.frame.size.width - 60, 80)];
        [self.view addSubview:_imageShowscroll];
        

        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"信息提交成功"  preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *alertAct12 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        [alertVC addAction:alertAct12];
        [self presentViewController:alertVC animated:YES completion:NULL];
    }
    else if ([status intValue]==44)
    {
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"登录超时，请重新登录"  preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *alertAct12 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }];
        
        [alertVC addAction:alertAct12];
        [self presentViewController:alertVC animated:YES completion:NULL];
        
    }else{
        NSString *str = [dic objectForKey:@"data"];
        [self showAlertWarmMessage:str];
        
    }
    
}
*/

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(void) showHUD
{
    progress_ = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progress_];
    [self.view bringSubviewToFront:progress_];
    progress_.delegate = self;
    progress_.label.text = @"提交中...";
    [progress_ showAnimated:YES];
}

- (void)hudWasHidden
{
    
    // Remove HUD from screen when the HUD was hidded
    [progress_ removeFromSuperview];
    
    progress_ = nil;
    
}
# pragma mark - 照片按钮事件
- (void)photoButton{
    
    UIAlertController *alectSheet = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhoto];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"选取照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self getPhotos];
    }];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL];
    
    [alectSheet addAction:action1];
    [alectSheet addAction:action2];
    [alectSheet addAction:cancleAction];
    
    [self presentViewController:alectSheet animated:YES completion:NULL];
    
}

# pragma mark - 选取照片
- (void)selectImagePhotoLibrary
{
    if (self.repeatClickInt !=2) {
        self.repeatClickInt = 2;
        
    }
}

#pragma mark - PYPhotosViewDelegate
- (void)photosView:(PYPhotosView *)photosView didAddImageClickedWithImages:(NSMutableArray *)images{
    // 在这里做当点击添加图片按钮时，你想做的事。
    [self getPhotos];
}
// 进入预览图片时调用, 可以在此获得预览控制器，实现对导航栏的自定义
- (void)photosView:(PYPhotosView *)photosView didPreviewImagesWithPreviewControlelr:(PYPhotosPreviewController *)previewControlelr{
    NSLog(@"进入预览图片");
}

- (void)photosViewDeleteImageAction
{
    UIView *bottomView = [self.view viewWithTag:2018];
    bottomView.top = self.publishPhotosView.bottom+20;
    
    
    
}

# pragma mark - 选取本地图片
-(void)getPhotos{
    CCWeakSelf;
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9-weakSelf.photos.count delegate:weakSelf];
    imagePickerVc.maxImagesCount = 9;//最小照片必选张数,默认是0
    imagePickerVc.sortAscendingByModificationDate = NO;// 对照片排序，按修改时间升序，默认是YES。如果设置为NO,最新的照片会显示在最前面，内部的拍照按钮会排在第一个
    // 你可以通过block或者代理，来得到用户选择的照片.
    UIView *bottomView = [self.view viewWithTag:2018];
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets,BOOL isSelectOriginalPhoto){
        NSLog(@"选中图片photos === %@",photos);
        //        for (UIImage *image in photos) {
        //            [weakSelf requestData:image];//requestData:图片上传方法 在这里就不贴出来了
        //        }
        
        [weakSelf.photos addObjectsFromArray:photos];
        [self.publishPhotosView reloadDataWithImages:weakSelf.photos];
        bottomView.top = self.publishPhotosView.bottom+20;
    }];
    [weakSelf presentViewController:imagePickerVc animated:YES completion:nil];
}

-(NSMutableArray *)photos{
    if (_photos == nil) {
        _photos = [[NSMutableArray alloc]init];
        
    }
    return _photos;
}

# pragma mark - 拍照
- (void)takePhoto
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)
    {
        NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
        NSString *str = [NSString stringWithFormat:@"%@%@%@",NSLocalizedString(@"请在iPhone的\"设置->隐私->相机\"选项中，允许", nil),appName,NSLocalizedString(@"访问您的摄像头。", nil)];
        [self showAlertWarmMessage:str];
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.mediaTypes = [NSArray arrayWithObjects: @"public.image", nil];
    [self presentViewController:picker animated:YES completion:^{
    }];
}



- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //[picker dismissModalViewControllerAnimated:YES comp];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
     UIView *bottomView = [self.view viewWithTag:2018];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.photos addObject:image];
    [self.publishPhotosView reloadDataWithImages:self.photos];
    bottomView.top = self.publishPhotosView.bottom+20;
    
}

//该方法弃用
- (void)uploadImageToServer
{
    NSString *aUrlle= [NSString stringWithFormat:@"%@/member/fileUpload/upload.jhtml",URL_PRE];
    aUrlle = [aUrlle stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 30;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [paramDic setObject:[UserShareOnce shareOnce].token forKey:@"token"];
    [paramDic setObject:@"image" forKey:@"fileType"];
    __weak typeof(self) weakSelf = self;
    [manager POST:aUrlle parameters:paramDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for(NSInteger i=0;i<[weakSelf.photos count];i++){
            UIImage *image = weakSelf.photos[i];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.4);
            NSString *fileName = [NSString  stringWithFormat:@"%@.png", [self getNowTimeTimestamp3]];
            [weakSelf.headArray addObject:fileName];
            NSLog(@"fileName:%@",fileName);
             //NSString *imageName = [NSString stringWithFormat:@"file_%ld", i];
            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/png/jpg/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"respond:%@",responseObject);
        //[weakSelf.headArray addObject:[responseObject objectForKey:@"data"]];
        [weakSelf uploadTextServer];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf showAlertWarmMessage:@"上传失败,请检查网络"];
    }];
    
}

//之前的方法
/*
-(void) UpLoadImgHttp
{
    [self showHUD];
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
    [request setDidFailSelector:@selector(requestUpLoadsError:)];//requestLoginError
    [request setDidFinishSelector:@selector(requestUpLoadCompleted:)];
    [request startAsynchronous];
   
}



- (void)requestUpLoadCompleted:(ASIHTTPRequest *)request
{
    [self hudWasHidden];
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    id status=[dic objectForKey:@"status"];
    if ([status intValue]==100)
    {
        [self.headArray addObject:[dic objectForKey:@"data"]];
        
        if (self.headArray.count >4 ) {
            
            
            self.scrollView1.contentSize = CGSizeMake(50 + (self.headArray.count - 4) * (WIDTHS +10), 0);
            UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
            imageButton.frame = CGRectMake(24 + (self.headArray.count - 5) *(WIDTHS +10),0, WIDTHS, 80);
            
            
            // UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(24 + (self.headArray.count - 5) *60,0, 50, 50)];
            NSURL *url = [NSURL URLWithString:[dic objectForKey:@"data"]];
            NSData *data = [NSData dataWithContentsOfURL:url];
            // imageV.image = [UIImage imageWithData:data];
            [imageButton setBackgroundImage:[UIImage imageWithData:data]  forState:UIControlStateNormal];
            [imageButton addTarget:self action:@selector(buttonImage:) forControlEvents:UIControlEventTouchUpInside];
            imageButton.tag = 4000 +self.headArray.count;
            [self.scrollView1 addSubview:imageButton];
            
        }else{
            // UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake((self.headArray.count - 1) *60, 0, 50, 50)];
            UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
            imageButton.frame = CGRectMake((self.headArray.count - 1) *(WIDTHS + 10), 0, WIDTHS, 80);
            
            NSURL *url = [NSURL URLWithString:[dic objectForKey:@"data"]];
            NSData *data = [NSData dataWithContentsOfURL:url];
            //imageV.image = [UIImage imageWithData:data];
            [imageButton setBackgroundImage:[UIImage imageWithData:data]  forState:UIControlStateNormal];
            [imageButton addTarget:self action:@selector(buttonImage:) forControlEvents:UIControlEventTouchUpInside];
            imageButton.tag = 4000 +self.headArray.count;
            [_imageShowView addSubview:imageButton];
            //[_imageShowView addSubview:imageV];
        }
        
        
    }
    else
    {
        [self hudWasHidden];
    }
}
- (void)buttonImage:(UIButton *)sender{
    bntTag =  (int)sender.tag - 4001;
    if (sender.selected ) {
        sender.selected = NO;
        
    }else{
        sender.selected = YES;
        diView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [self.view addSubview:diView];
        diView.backgroundColor = [UIColor blackColor];
        diView.alpha = 1;
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, (self.view.frame.size.height - self.view.frame.size.width) / 2, self.view.frame.size.width, self.view.frame.size.width)];
        imageview.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.headArray[bntTag]]]];
        [diView addSubview:imageview];
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [diView addGestureRecognizer: tap];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(self.view.frame.size.width  / 2 - 20, self.view.frame.size.height - 62, 30, 30);
        [button setBackgroundImage:[UIImage imageNamed:@"shanchutu.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonWithdelegates) forControlEvents:UIControlEventTouchUpInside];
        [diView addSubview:button];
    }
}
- (void)buttonWithdelegates{
    [self.headArray removeObjectAtIndex:bntTag];
    if (bntTag > 3) {
        for(id tmpView in [_imageShowscroll subviews])
        {
            //找到要删除的子视图的对象
            if([tmpView isKindOfClass:[UIButton class]])
            {
                UIButton *imgView = (UIButton *)tmpView;
                if(imgView.tag == 4001+bntTag)   //判断是否满足自己要删除的子视图的条件
                {
                    [imgView removeFromSuperview]; //删除子视图
                    
                    break;  //跳出for循环，因为子视图已经找到，无须往下遍历
                }
            }
        }
    }else {
        for(id tmpView in [_imageShowView subviews])
        {
            //找到要删除的子视图的对象
            if([tmpView isKindOfClass:[UIButton class]])
            {
                UIButton *imgView = (UIButton *)tmpView;
                if(imgView.tag == 4001+bntTag)   //判断是否满足自己要删除的子视图的条件
                {
                    [imgView removeFromSuperview]; //删除子视图
                    
                    break;  //跳出for循环，因为子视图已经找到，无须往下遍历
                }
            }
        }
    }
    
    
    if (self.headArray.count > 3 && bntTag < 4) {
        
        //            UIButton *button = (UIButton *)[self.view viewWithTag:4002+bntTag+i];
        //            button.frame = CGRectMake((bntTag+i) *60, 0, 50, 50);
        UIButton *button = (UIButton *)[self.view viewWithTag:4005];
        button.frame = CGRectMake(3 *(WIDTHS + 10), 0, WIDTHS, 80);
        for(id tmpView in [_imageShowView subviews])
        {
            //找到要删除的子视图的对象
            if([tmpView isKindOfClass:[UIButton class]])
            {
                UIButton *imgView = (UIButton *)tmpView;
                if(imgView.tag == 4005)   //判断是否满足自己要删除的子视图的条件
                {
                    [imgView removeFromSuperview]; //删除子视图
                    break;  //跳出for循环，因为子视图已经找到，无须往下遍历
                }
            }
        }
        
        button.tag= 4004;
        [_imageShowView addSubview:button];
        for (int i = 0; i < 4 - bntTag; i ++) {
            UIButton *button = (UIButton *)[self.view viewWithTag:4002+bntTag+i];
            button.frame = CGRectMake((bntTag+i) *(WIDTHS + 10), 0, WIDTHS, 80);
            button.tag = 4001 +bntTag+i;
        }
        for (int i = 4; i < self.headArray.count ; i++) {
            UIButton *button = (UIButton *)[self.view viewWithTag:4002+i];
            button.frame = CGRectMake(24 + (i - 4) *(WIDTHS + 10),0, WIDTHS, 80);
            button.tag = 4001 +i;
        }
        
    } else if(self.headArray.count > 3&&bntTag > 3){
        for (int i = bntTag; i < self.headArray.count ; i++) {
            UIButton *button = (UIButton *)[self.view viewWithTag:4002+i];
            button.frame = CGRectMake(24 + (i - 4) *(WIDTHS + 10),0, WIDTHS, 80);
            button.tag = 4001 +i;
        }
        
    }
    else if (self.headArray.count < 4){
        for (int i = 0; i < self.headArray.count - bntTag; i ++) {
            UIButton *button = (UIButton *)[self.view viewWithTag:4002+bntTag+i];
            button.frame = CGRectMake((bntTag+i) *(WIDTHS + 10), 0, WIDTHS, 80);
            button.tag = 4001 +bntTag+i;
        }
        
    }
    diView.hidden = YES;
}
-(void)hideImage:(UITapGestureRecognizer*)tap{
    diView.hidden = YES;
}
- (void)requestUpLoadsError:(ASIHTTPRequest *)request
{
    [self hudWasHidden];
   
    [self showAlertWarmMessage:@"抱歉，请检查您的网络是否畅通"];
   
}
*/

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowTabbar" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"6",@"index",nil]];
    [picker dismissViewControllerAnimated:YES completion:nil];
}


# pragma mark - 上传多张图片
- (void)batchRequest {
    // 需要上传的数据
    NSArray* images = self.photos;
    
    // 准备保存结果的数组，元素个数与上传的图片个数相同，先用 NSNull 占位
    NSMutableArray* result = [NSMutableArray array];
    for (NSInteger i=0;i<images.count;i++) {
        [result addObject:[NSNull null]];
    }
    [self showHUD];
    dispatch_group_t group = dispatch_group_create();
    
    for (NSInteger i = 0; i < images.count; i++) {
        
        dispatch_group_enter(group);
        __weak typeof(self) weakSelf = self;
        NSURLSessionUploadTask* uploadTask = [self uploadTaskWithImage:images[i] completion:^(NSURLResponse *response, NSDictionary* responseObject, NSError *error) {
            if (error) {
                NSLog(@"第 %d 张图片上传失败: %@", (int)i + 1, error);
                [weakSelf hudWasHidden];
                dispatch_group_leave(group);
            } else {
                NSLog(@"第 %d 张图片上传成功: %@", (int)i + 1, responseObject);
                @synchronized (result) { // NSMutableArray 是线程不安全的，所以加个同步锁
                    result[i] = responseObject;
                }
                dispatch_group_leave(group);
            }
        }];
        [uploadTask resume];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"上传完成!");
        
        BOOL isSuccess = YES;
        for (id response in result) {
            if([[response objectForKey:@"status"] intValue] == 100){
                [self.headArray addObject:[response objectForKey:@"data"]];
            }else{
                isSuccess = NO;
                [self hudWasHidden];
                [self showAlertWarmMessage:[response objectForKey:@"data"]];
                return ;
            }
            NSLog(@"%@", response);
        }
        if(isSuccess){
            [self uploadTextServer];
        }
    });

}

- (NSURLSessionUploadTask*)uploadTaskWithImage:(UIImage*)image completion:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionBlock {
    // 构造 NSURLRequest
    NSError* error = NULL;
    NSString *aUrlle= [NSString stringWithFormat:@"%@/member/fileUpload/upload.jhtml",URL_PRE];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [paramDic setObject:[UserShareOnce shareOnce].token forKey:@"token"];
    [paramDic setObject:@"image" forKey:@"fileType"];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:aUrlle parameters:paramDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData* imageData = UIImageJPEGRepresentation(image, 0.4);
        NSString *fileName = [NSString  stringWithFormat:@"%@.png", [self getNowTimeTimestamp3]];
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/png/jpg/jpeg"];
    } error:&error];
    
    // 可在此处配置验证信息
    
    // 将 NSURLRequest 与 completionBlock 包装为 NSURLSessionUploadTask
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
    } completionHandler:completionBlock];
    
    return uploadTask;
}

# pragma mark - 上传文字
- (void)uploadTextServer
{
    NSString *aUrl = [NSString stringWithFormat:@"member/user_consultation/commit.jhtml"];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [paramDic setObject:[MemberUserShance shareOnce].idNum forKey:@"memberChildId"];
    [paramDic setObject:[UserShareOnce shareOnce].token forKey:@"token"];
    [paramDic setObject:_textView.text forKey:@"content"];
    NSString *strings = @"";
    if (self.headArray.count == 0) {
        
    }else{
        for (int i = 0; i < self.headArray.count; i++) {
            if (i==0) {
                strings = [strings stringByAppendingString:self.headArray[i]];
            }else {
                strings = [strings stringByAppendingString:@","];
                strings = [strings stringByAppendingString:self.headArray[i]];
            }
            
        }
    }
    [paramDic setObject:strings forKey:@"userConsultationImages"];
    __weak typeof(self) weakSelf = self;
    [[NetworkManager sharedNetworkManager] requestWithType:BAHttpRequestTypePost urlString:aUrl parameters:paramDic successBlock:^(id response) {
        [weakSelf hudWasHidden];
        if([[response objectForKey:@"status"] intValue] == 100){
            
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"你的咨询信息已提交,医生会在第一时间给予回复" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAct1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
            [alertVC addAction:alertAct1];
            [weakSelf presentViewController:alertVC animated:YES completion:NULL];
            
        }else{
            [weakSelf showAlertWarmMessage:[response objectForKey:@"data"]];
        }
        
    } failureBlock:^(NSError *error) {
        [weakSelf hudWasHidden];
        [weakSelf showAlertWarmMessage:@"上传失败,请检查网络!"];
    }];
    
}

-(NSString *)getNowTimeTimestamp3{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    
    return timeSp;
}

#pragma mark -------- 选择子账户
-(void)GetWithModifi
{
    
    if([GlobalCommon isManyMember]){
        __weak typeof(self) weakSelf = self;
        SubMemberView *subMember = [[SubMemberView alloc] initWithFrame:CGRectZero];
        [subMember receiveSubIdWith:^(NSString *subId) {
            NSLog(@"%@",subId);
            if ([subId isEqualToString:@"user is out of date"]) {
                //登录超时
                
            }else{
                [weakSelf requestNetworkData:subId];
            }
            [subMember hideHintView];
        }];
        
        [subMember receiveNameWith:^(NSString *nameString) {
            [weakSelf.choseButton setTitle:nameString forState:(UIControlStateNormal)];
        }];
    }else{
        [self requestNetworkData:[NSString stringWithFormat:@"%@",[MemberUserShance shareOnce].idNum]];
    }
}

- (void)requestNetworkData:(NSString *)subId
{
    //得到子账户的id
    self.subId = subId;
}


- (void)requestResourceslistFinish:(ASIHTTPRequest *)request
{
    // [self hudWasHidden:nil];
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    id status=[dic objectForKey:@"status"];
    if ([status intValue]==100)
    {
        _personView.hidden = NO;
        _showView.hidden = NO;
        [self.view bringSubviewToFront:_personView];
        [self.view bringSubviewToFront:_showView];
        
        self.dataArr=[dic objectForKey:@"data"];
        [self.tableView reloadData];
    }
    else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.removeFromSuperViewOnHide =YES;
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"当前账户已过期，请重新登录";  //提示的内容
        hud.minSize = CGSizeMake(132.f, 108.0f);
        [hud hideAnimated:YES afterDelay:2];
        
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
