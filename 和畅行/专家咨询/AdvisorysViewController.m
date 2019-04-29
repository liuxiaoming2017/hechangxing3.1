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
@property (nonatomic,strong)UIButton *photoButton;
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
@property(nonatomic,assign)int repeatClickInt;
@property (nonatomic,strong)NSMutableArray *dataArr;
/**subId*/
@property (nonatomic,copy) NSString *subId;
@property (nonatomic,strong)UIButton *finishButton;
@property (nonatomic,strong)UIButton *choseButton;
@property (nonatomic, weak) PYPhotosView *publishPhotosView;//属性 保存选择的图片
@property (nonatomic ,strong) UILabel *numberLabel;
@end

@implementation AdvisorysViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleLabel.text = ModuleZW(@"图文咨询");
    self.view.backgroundColor = RGB_AppWhite;
    
    self.headArray = [[NSMutableArray alloc]init];
    self.dataArr = [NSMutableArray array];
    _memberChildId = [UserShareOnce shareOnce].mengberchildId;
    NSString *nameStr = [UserShareOnce shareOnce].name;
    if ([GlobalCommon stringEqualNull:nameStr]) {
        nameStr = [MemberUserShance shareOnce].name;
    }

    
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, kNavBarHeight + 10, ScreenWidth - 20, 245 + (ScreenWidth - 70)/4)];
    backImageView.backgroundColor = [UIColor whiteColor];
    backImageView.layer.cornerRadius = 10;
    backImageView.layer.masksToBounds = YES;
    backImageView.userInteractionEnabled = YES;
    [self insertSublayerWithImageView:backImageView with:self.view];
    [self.view addSubview:backImageView];
    
    _textView = [[CPTextViewPlaceholder alloc]initWithFrame:CGRectMake(15, 15, backImageView.width - 30, 210)];
    _textView.delegate = self;
    _textView.layer.borderColor = RGB(221, 221, 221).CGColor;
    _textView.textContainerInset = UIEdgeInsetsMake(10, 0, 20, 10);
    _textView.layer.borderWidth =0.5;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChangess) name:UITextViewTextDidChangeNotification object:self.textView];
    
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.textColor = [UtilityFunc colorWithHexString:@"#666666"];
    
    _textViews = [[UITextView alloc]initWithFrame:CGRectMake(15,15, backImageView.width - 30, 100)];
    _textView.keyboardType = UIKeyboardTypeDefault;
    _textView.returnKeyType = UIReturnKeyDone;
    _textViews.text = ModuleZW(@"请输入您想咨询的内容");
    _textViews.font = [UIFont systemFontOfSize:15];
    _textViews.textColor =RGB(162, 162, 162);
    [backImageView addSubview:_textViews];
    _textView.backgroundColor = [UIColor clearColor];
//    _textViews.backgroundColor = [UIColor redColor];
    [backImageView addSubview:_textView];
    
    UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(_textView.width - 100, _textView.height - 30, 90, 20)];
    numberLabel.text = @"0/200";
    numberLabel.textColor =RGB(162, 162, 162);
    numberLabel.textAlignment = NSTextAlignmentRight;
    [_textView addSubview:numberLabel];
    _numberLabel = numberLabel;
    
    // 1. 常见一个发布图片时的photosView
    PYPhotosView *publishPhotosView = [PYPhotosView photosView];
    publishPhotosView.py_x = 15;
    publishPhotosView.py_y = _textView.bottom + 10;
    publishPhotosView.photoWidth = (backImageView.width-50)/4 ;
    publishPhotosView.photoHeight = (backImageView.width-50)/4 ;
    // 2.1 设置本地图片
    publishPhotosView.images = nil;
    publishPhotosView.hideDeleteView = YES;
    // 3. 设置代理
    publishPhotosView.delegate = self;
    //publishPhotosView.backgroundColor = [UIColor blackColor];
    publishPhotosView.photosMaxCol = 4;//每行显示最大图片个数
    publishPhotosView.imagesMaxCountWhenWillCompose = 4;//最多选择图片的个数
    // 4. 添加photosView
    [backImageView addSubview:publishPhotosView];
    self.publishPhotosView = publishPhotosView;
    

    UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    photoButton.frame = CGRectMake(backImageView.width/8-20, _textView.bottom - 10 +  (backImageView.width-50)/8 , 40, 40) ;
    [photoButton setBackgroundImage:[UIImage imageNamed:@"专家咨询添加图片"] forState:UIControlStateNormal];
    [photoButton addTarget:self action:@selector(photoAction) forControlEvents:UIControlEventTouchUpInside];
    [backImageView addSubview:photoButton];
    self.photoButton = photoButton;
    
    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    finishButton.frame = CGRectMake(self.view.frame.size.width / 2 - 45,backImageView.bottom + 40, 90, 26);
    [finishButton setBackgroundColor:RGB_ButtonBlue];
    [finishButton setTitle:ModuleZW(@"提交") forState:UIControlStateNormal];
    [finishButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    finishButton.layer.cornerRadius = 13;
    finishButton.clipsToBounds = YES;
    finishButton.alpha = 0.4;
    finishButton.userInteractionEnabled = NO;
    [finishButton addTarget:self action:@selector(finishButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:finishButton];
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
    
    if (_textView.text.length > 200)
    {
        _textView.text = [_textView.text substringToIndex:200];
    }
    self.numberLabel.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)[_textView.text length], 200];
    
    if (_textView.text.length > 200)
    {
        NSRange rangeIndex = [_textView.text rangeOfComposedCharacterSequenceAtIndex:200];
        
        if (rangeIndex.length == 1)//字数超限
        {
            _textView.text = [_textView.text substringToIndex:200];
            //这里重新统计下字数，字数超限，我发现就不走textViewDidChange方法了，你若不统计字数，忽略这行
            self.numberLabel.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)_textView.text.length, 200];
        }else{
            NSRange rangeRange = [_textView.text rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 200)];
            _textView.text = [_textView.text substringWithRange:rangeRange];
        }
   }
    
}


#pragma mark ----------  收键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //关闭键盘的方法
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
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
        [self showAlertWarmMessage:ModuleZW(@"抱歉，请填写你的症状")];
        
        return;
    }
    
    [self batchRequest];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(void) showHUD
{
    progress_ = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progress_];
    [self.view bringSubviewToFront:progress_];
    progress_.delegate = self;
    progress_.label.text = ModuleZW(@"提交中...");
    [progress_ showAnimated:YES];
}

- (void)hudWasHidden
{
    
    // Remove HUD from screen when the HUD was hidded
    [progress_ removeFromSuperview];
    
    progress_ = nil;
    
}
# pragma mark - 照片按钮事件
- (void)photoAction{
    
    UIAlertController *alectSheet = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:ModuleZW(@"拍照") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhoto];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:ModuleZW(@"选取照片") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self getPhotos];
    }];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:ModuleZW(@"取消") style:UIAlertActionStyleCancel handler:NULL];
    
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
    imagePickerVc.maxImagesCount = 4;//最小照片必选张数,默认是0
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
        if (self.photos.count < 4 ) {
            self.photoButton.hidden = NO;
            self.photoButton.left = (ScreenWidth - 20)/8-20 + (((ScreenWidth - 20)-50)/4 + 10)*self.photos.count;
        }else{
            self.photoButton.hidden = YES;
        }
        bottomView.top = self.publishPhotosView.bottom+20;
    }];
    [weakSelf presentViewController:imagePickerVc animated:YES completion:nil];
}

-(void)photosView:(PYPhotosView *)photosView didDeleteImageIndex:(NSInteger)imageIndex{
    if (self.photos.count < 4 ) {
        self.photoButton.hidden = NO;
        self.photoButton.left = (ScreenWidth - 20)/8-20 + (((ScreenWidth - 20)-50)/4 + 10)*self.photos.count;
    }else{
        self.photoButton.hidden = YES;
    }
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
        NSString *str = [NSString stringWithFormat:ModuleZW(@"请在iPhone的\"设置->隐私->相机\"选项中，允许%@访问您的摄像头。"),appName];

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
        [weakSelf showAlertWarmMessage:ModuleZW(@"上传失败,请检查网络")];
    }];
    
}

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
            
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:ModuleZW(@"你的咨询信息已提交,医生会在第一时间给予回复") preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAct1 = [UIAlertAction actionWithTitle:ModuleZW(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
            [alertVC addAction:alertAct1];
            [weakSelf presentViewController:alertVC animated:YES completion:NULL];
            
        }else{
            [weakSelf showAlertWarmMessage:[response objectForKey:@"data"]];
        }
        
    } failureBlock:^(NSError *error) {
        [weakSelf hudWasHidden];
        [weakSelf showAlertWarmMessage:ModuleZW(@"上传失败,请检查网络")];
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
        hud.label.text = ModuleZW(@"当前账户已过期，请重新登录");  //提示的内容
        hud.minSize = CGSizeMake(132.f, 108.0f);
        [hud hideAnimated:YES afterDelay:2];
        
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
    }
}
-(void)backClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
