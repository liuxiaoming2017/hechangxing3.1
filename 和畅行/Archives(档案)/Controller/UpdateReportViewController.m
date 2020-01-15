//
//  UpdateReportViewController.m
//  和畅行
//
//  Created by Wei Zhao on 2019/9/30.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "UpdateReportViewController.h"
#import "CPTextViewPlaceholder.h"
#import "PYPhotoBrowser.h"
#import "TZImagePickerController.h"
#import "AFHTTPSessionManager.h"
@interface UpdateReportViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate,MBProgressHUDDelegate,UIScrollViewDelegate,UITextViewDelegate,TZImagePickerControllerDelegate,PYPhotosViewDelegate>
@property (nonatomic ,strong) UITextView *textView;
@property (nonatomic ,strong) UITextView *textViews;
@property (nonatomic,strong)UIButton *finishButton;
@property (nonatomic,strong)UIButton *choseButton;
@property (nonatomic, weak) PYPhotosView *publishPhotosView;//属性 保存选择的图片
@property (nonatomic ,strong) UILabel *numberLabel;
@property (nonatomic,strong)UIButton *photoButton;
@property(nonatomic,assign)int repeatClickInt;
@property(nonatomic,strong)NSMutableArray * photos;//放图片的数组
@property(nonatomic,strong)UIImageView *backImageView;
@property(nonatomic,strong)UIView *backView;
@property (nonatomic,strong)UIView *uploadReportView;
@property (nonatomic,strong)UIScrollView *backScrollView;
@end

#define CCWeakSelf __weak typeof(self) weakSelf = self;
#define WIDTHS (self.view.frame.size.width -64)/4

@implementation UpdateReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.leftBtn.hidden = YES;
    self.preBtn.hidden = NO;
    self.navTitleLabel.text = ModuleZW(@"上传报告");
    [self layoutUploadReport];
}
//布局上传报告页面
-(void )layoutUploadReport{
    
    UIScrollView *backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, ScreenWidth, ScreenHeight - kNavBarHeight)];
    backScrollView.backgroundColor = RGB_AppWhite;
    [self.view addSubview:backScrollView];
    self.backScrollView = backScrollView;
    
    _uploadReportView = [[UIView alloc]initWithFrame: CGRectMake(0, 0, ScreenWidth, ScreenHeight-self.topView.bottom)];
    _uploadReportView.backgroundColor = RGB_AppWhite;
    [backScrollView addSubview:_uploadReportView];
    
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(Adapter(10), Adapter(10), ScreenWidth - Adapter(20), Adapter(300))];
    backImageView.backgroundColor = [UIColor whiteColor];
    backImageView.layer.cornerRadius = 10;
    backImageView.userInteractionEnabled = YES;
    backImageView.layer.shadowColor = RGB_TextGray.CGColor;
    backImageView.layer.shadowOffset = CGSizeMake(0,0);
    backImageView.layer.shadowOpacity = 0.5;
    backImageView.layer.shadowRadius = 5;
    
    [self.uploadReportView addSubview:backImageView];
    self.backImageView =  backImageView;
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(Adapter(10), Adapter(10), backImageView.width - Adapter(20), Adapter(210))];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.borderColor = RGB(221, 221, 221).CGColor;
    backView.layer.borderWidth =0.5;
    [backImageView addSubview:backView];
    self.backView = backView;
    
    _textView = [[CPTextViewPlaceholder alloc]initWithFrame:CGRectMake(Adapter(5), Adapter(5), backView.width - Adapter(10), Adapter(190))];
    _textView.delegate = self;
    _textView.textContainerInset = UIEdgeInsetsMake(Adapter(10), 0, Adapter(20), Adapter(10));
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChangess) name:UITextViewTextDidChangeNotification object:self.textView];
    
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.textColor = [UtilityFunc colorWithHexString:@"#666666"];
    
    _textViews = [[UITextView alloc]initWithFrame:CGRectMake(Adapter(10),Adapter(7.5), backView.width - Adapter(30), Adapter(25))];
    _textView.keyboardType = UIKeyboardTypeDefault;
    _textView.returnKeyType = UIReturnKeyDone;
    _textViews.text = ModuleZW(@"请输入报告说明内容");
    _textViews.font = [UIFont systemFontOfSize:15];
    _textViews.textColor =RGB(162, 162, 162);
    [backView addSubview:_textViews];
    _textView.backgroundColor = [UIColor clearColor];
    [backView addSubview:_textView];
    
    UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(backView.width - Adapter(100), backView.height - Adapter(20), Adapter(90), Adapter(20))];
    numberLabel.text = @"0/200";
    numberLabel.textColor =RGB(162, 162, 162);
    numberLabel.textAlignment = NSTextAlignmentRight;
    [backView addSubview:numberLabel];
    _numberLabel = numberLabel;
    
    // 1. 常见一个发布图片时的photosView
    PYPhotosView *publishPhotosView = [PYPhotosView photosView];
    publishPhotosView.py_x = Adapter(15);
    publishPhotosView.py_y = backView.bottom + Adapter(10);
    publishPhotosView.photoWidth = (backImageView.width-Adapter(50))/4 ;
    publishPhotosView.photoHeight = (backImageView.width-Adapter(50))/4 ;
    // 2.1 设置本地图片
    publishPhotosView.images = nil;
    publishPhotosView.hideDeleteView = YES;
    // 3. 设置代理
    publishPhotosView.delegate = self;
    //publishPhotosView.backgroundColor = [UIColor blackColor];
    publishPhotosView.photosMaxCol = 4;//每行显示最大图片个数
    publishPhotosView.imagesMaxCountWhenWillCompose = 9;//最多选择图片的个数
    // 4. 添加photosView
    [backImageView addSubview:publishPhotosView];
    self.publishPhotosView = publishPhotosView;
    
    
    UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    photoButton.frame = CGRectMake(backImageView.width/8-Adapter(20), backView.bottom + Adapter(20) , Adapter(40), Adapter(40)) ;
    [photoButton setBackgroundImage:[UIImage imageNamed:@"专家咨询添加图片"] forState:UIControlStateNormal];
    [photoButton addTarget:self action:@selector(photoAction:) forControlEvents:UIControlEventTouchUpInside];
    [backImageView addSubview:photoButton];
    self.photoButton = photoButton;
    
    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    finishButton.frame = CGRectMake(self.view.frame.size.width / 2 - Adapter(45),backImageView.bottom + Adapter(40), Adapter(90), Adapter(26));
    [finishButton setBackgroundColor:RGB_ButtonBlue];
    [finishButton setTitle:ModuleZW(@"提交") forState:UIControlStateNormal];
    [finishButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    finishButton.layer.cornerRadius = finishButton.height/2;;
    finishButton.clipsToBounds = YES;
    finishButton.alpha = 0.4;
    finishButton.userInteractionEnabled = NO;
    [finishButton addTarget:self action:@selector(finishButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.backScrollView addSubview:finishButton];
    self.finishButton = finishButton;
    
    self.backScrollView.contentSize = CGSizeMake(ScreenWidth, finishButton.bottom +60);
    
    
}

- (void)textDidChangess{
    _textViews.hidden = [_textViews hasText];
    
    
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

# pragma mark - 照片按钮事件
- (void)photoAction:(UIButton *)button{
    
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
    if(ISPaid)  {
        UIPopoverPresentationController *popover = alectSheet.popoverPresentationController;
        if (popover) {
            popover.sourceView = button;
            popover.sourceRect = button.bounds;
            popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
        }
    }
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
    imagePickerVc.maxImagesCount = 9 - self.photos.count;//最小照片必选张数,默认是0
    imagePickerVc.sortAscendingByModificationDate = NO;// 对照片排序，按修改时间升序，默认是YES。如果设置为NO,最新的照片会显示在最前面，内部的拍照按钮会排在第一个
    // 你可以通过block或者代理，来得到用户选择的照片.
    UIView *bottomView = [self.view viewWithTag:2018];
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets,BOOL isSelectOriginalPhoto){
        NSLog(@"选中图片photos === %@",photos);
        
        [weakSelf.photos addObjectsFromArray:photos];
        [self.publishPhotosView reloadDataWithImages:self.photos];
        [self updateThePage];
    }];
    [weakSelf presentViewController:imagePickerVc animated:YES completion:nil];
}

-(void)photosView:(PYPhotosView *)photosView didDeleteImageIndex:(NSInteger)imageIndex{
    NSLog(@"%lu",(unsigned long)self.photos.count);
    [self updateThePage];
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
    [self updateThePage];
    bottomView.top = self.publishPhotosView.bottom+Adapter(20);
    
}




- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowTabbar" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"6",@"index",nil]];
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)finishButtonAction{
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = ModuleZW(@"上传中…");
    NSString *str = [NSString stringWithFormat:@"%@/login/healthr/upload.jhtml",URL_PRE];
    __weak typeof(self) weakSelf = self;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:str parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i = 0; i<self.photos.count; i++) {
            NSData *imageData = UIImageJPEGRepresentation(self.photos[i], 1);
            [formData appendPartWithFileData:imageData name:@"myfiles" fileName:@"headimage.jpg" mimeType:@"image/jpeg"];
        }
        NSData *memberIDData = [[UserShareOnce shareOnce].uid dataUsingEncoding:NSUTF8StringEncoding];
        [formData appendPartWithFormData:memberIDData name:@"memberId"];
        NSData *contentData = [weakSelf.textView.text dataUsingEncoding:NSUTF8StringEncoding];
        [formData appendPartWithFormData:contentData name:@"content"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hideAnimated:YES];
        NSDictionary*jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves  error:nil];
        if ([[jsonDic valueForKey:@"status"] intValue]== 100) {
            UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:ModuleZW(@"提示") message:ModuleZW(@"上传成功") preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *suerAction = [UIAlertAction actionWithTitle:ModuleZW(@"确定") style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                if (self.returnTextBlock != nil) {
                    self.returnTextBlock();
                }
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alerVC addAction:suerAction];
            [self presentViewController:alerVC animated:YES completion:nil];
        } else  {
            NSString *str = [jsonDic objectForKey:@"message"];
            [self showAlertWarmMessage:str];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hideAnimated:YES];
    }];
    
    
    
    
}

-(void)publishTheinFormationwithDic:(NSDictionary *)dic {
    
}


-(void)updateThePage{
    if (self.photos.count < 4 ) {
        self.photoButton.hidden = NO;
        self.photoButton.left = (ScreenWidth - Adapter(20))/8-Adapter(20) + (((ScreenWidth - Adapter(20))-Adapter(50))/4 + Adapter(10))*self.photos.count;
        self.photoButton.top = self->_backView.bottom +Adapter(20);
        self.backImageView.height = Adapter(320);
    }else if (self.photos.count > 3&&self.photos.count < 8 ){
        self.photoButton.hidden = NO;
        self.photoButton.left = (ScreenWidth - Adapter(20))/8-Adapter(20) + (((ScreenWidth - Adapter(20))-Adapter(50))/4 + Adapter(10))*(self.photos.count%4);
        self.photoButton.top = self->_backView.bottom +Adapter(20) +  (self->_backImageView.width-Adapter(50))/4 +Adapter(10);
        self.backImageView.height = Adapter(320) + (self->_backImageView.width-Adapter(50))/4 + Adapter(10);
    } else if(self.photos.count == 8 ){
        self.photoButton.hidden = NO;
        self.backImageView.height = Adapter(320) + (self->_backImageView.width-Adapter(50))/2 + Adapter(20);
        self.photoButton.top = self->_backView.bottom +Adapter(30) +  (self->_backImageView.width-Adapter(50))/2 +Adapter(10);
        self.photoButton.left = _backImageView.width/8-Adapter(20);
    }else{
        self.photoButton.hidden = YES;
        self.backImageView.height = Adapter(320) + (self->_backImageView.width-Adapter(50))/2 + Adapter(20);
        self.photoButton.top = self->_backView.bottom +Adapter(20) +  (self->_backImageView.width-Adapter(50))/2 +Adapter(10);
        
    }
    if(self.photos.count>0){
        self.finishButton.alpha = 1;
        self.finishButton.userInteractionEnabled = YES;
    }else{
        self.textView.text = @"";
        _textViews.hidden = NO;
        self.finishButton.alpha = 0.4;
        self.finishButton.userInteractionEnabled = NO;
        self.numberLabel.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)[_textView.text length], 200];
        [self.publishPhotosView reloadDataWithImages:self.photos];
    }
    self.finishButton.top = self.backImageView.bottom+Adapter(40);
    self.backScrollView.contentSize = CGSizeMake(ScreenWidth, self.finishButton.bottom +60);
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [_textView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}


@end

