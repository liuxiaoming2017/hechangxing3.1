//
//  SHMessageInputView.m
//  SHChatUI
//
//  Created by CSH on 2018/6/5.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import "SHMessageInputView.h"
#import <AVFoundation/AVFoundation.h>

#import "SHShortVideoViewController.h"
#import "TZImagePickerController.h"
#import "JCHATAudioPlayerHelper.h"

@interface SHMessageInputView ()<
UITextViewDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
SHShareMenuViewDelegate, //菜单代理
TZImagePickerControllerDelegate
>

//改变输入状态按钮（语音、文字）
@property (nonatomic, strong) UIButton *changeBtn;
//语音输入按钮
@property (nonatomic, strong) UIButton *voiceBtn;
//文本输入框
@property (nonatomic, strong) UITextView *textView;
//表情按钮
@property (nonatomic, strong) UIButton *emojiBtn;
//菜单按钮
@property (nonatomic, strong) UIButton *menuBtn;

//其他输入控件
//表情控件
//@property (nonatomic, strong) SHEmotionKeyboard *emojiView;
//菜单控件
@property (nonatomic, strong) SHShareMenuView *menuView;

//其他
//@property (nonatomic, strong) SHVoiceRecordHelper *voiceRecordHelper;
@property (nonatomic, assign) CGFloat playTime;
@property (nonatomic, strong) NSTimer *playTimer;

@end

@implementation SHMessageInputView

static CGFloat start_maxy;

#pragma mark - 公共方法
#pragma mark 刷新界面
- (void)reloadView{
    //设置背景颜色
    self.backgroundColor = kInPutViewColor;
    
    //分割线
    self.layer.cornerRadius = 1;
    self.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4].CGColor;
    self.layer.borderWidth = 0.4;
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    start_maxy = self.maxY;
    
    //添加改变输入状态按钮（语音、文字）
    [self addSubview:self.changeBtn];
    //添加表情按钮
    //[self addSubview:self.emojiBtn];
    //添加菜单按钮
    [self addSubview:self.menuBtn];
    //添加文本输入框
    [self addSubview:self.textView];
    //添加语音输入框
    [self addSubview:self.voiceBtn];
    
    //设置输入框类型
    self.inputType = SHInputViewType_default;
    
    //设置录音代理
  //  self.voiceRecordHelper = [[SHVoiceRecordHelper alloc]initWithDelegate:self];
    
    //添加监听
    [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

#pragma mark - 懒加载
#pragma mark 改变输入状态按钮（语音、文字）
- (UIButton *)changeBtn{
    if (!_changeBtn) {
        ////改变输入状态按钮（语音、文字）
        _changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeBtn.frame = CGRectMake(kSHInPutSpace, self.height - kSHInPutSpace - kSHInPutIcon_WH, kSHInPutIcon_WH, kSHInPutIcon_WH);
        
        [_changeBtn setBackgroundImage:[self imageNamed:@"chat_voice.png"] forState:UIControlStateNormal];
        [_changeBtn setBackgroundImage:[self imageNamed:@"chat_keyboard.png"] forState:UIControlStateSelected];
        
        [_changeBtn addTarget:self action:@selector(changeClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _changeBtn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    }
    return _changeBtn;
}

- (UIImage *)imageNamed:(NSString *)name{
    
    return [UIImage imageNamed:[NSString stringWithFormat:@"SHChatUI.bundle/%@",name]];
}

#pragma mark 文本输入框
- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.frame = CGRectMake(2*kSHInPutSpace + kSHInPutIcon_WH, self.height - kSHInPutIcon_WH - kSHInPutSpace, self.menuBtn.x - self.changeBtn.maxX - 2*kSHInPutSpace, kSHInPutIcon_WH);
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:17];
        _textView.returnKeyType = UIReturnKeySend;
        _textView.autocorrectionType = UITextAutocorrectionTypeNo;
        _textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        //UITextView内部判断send按钮是否可以用
        _textView.enablesReturnKeyAutomatically = YES;
        
        _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        _textView.layer.cornerRadius = 4;
        _textView.layer.masksToBounds = YES;
        _textView.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.4] CGColor];
        _textView.layer.borderWidth = 1;
    }
    return _textView;
}

#pragma mark 语音输入按钮
- (UIButton *)voiceBtn{
    if (!_voiceBtn) {
        _voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _voiceBtn.frame = CGRectMake(self.textView.x, self.changeBtn.y, self.textView.width, kSHInPutIcon_WH);
        _voiceBtn.hidden = YES;
        //文字颜色
        [_voiceBtn setTitleColor:kRGB(76, 76, 76, 1) forState:UIControlStateNormal];
        [_voiceBtn setTitleColor:kRGB(76, 76, 76, 1) forState:UIControlStateHighlighted];
        //文字内容
        [_voiceBtn setTitle:@"Hold to Talk" forState:UIControlStateNormal];
        [_voiceBtn setTitle:@"Release to send" forState:UIControlStateHighlighted];
        //点击方式
//        [_voiceBtn addTarget:self action:@selector(beginRecordVoice:) forControlEvents:UIControlEventTouchDown];
//        [_voiceBtn addTarget:self action:@selector(endRecordVoice:) forControlEvents:UIControlEventTouchUpInside];
//        [_voiceBtn addTarget:self action:@selector(cancelRecordVoice:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel];
//        [_voiceBtn addTarget:self action:@selector(RemindDragExit:) forControlEvents:UIControlEventTouchDragExit];
//        [_voiceBtn addTarget:self action:@selector(RemindDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
        
        [_voiceBtn addTarget:self action:@selector(holdDownButtonTouchDown) forControlEvents:UIControlEventTouchDown];
        [_voiceBtn addTarget:self action:@selector(holdDownButtonTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
        [_voiceBtn addTarget:self action:@selector(holdDownButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [_voiceBtn addTarget:self action:@selector(holdDownDragOutside) forControlEvents:UIControlEventTouchDragExit];
        [_voiceBtn addTarget:self action:@selector(holdDownDragInside) forControlEvents:UIControlEventTouchDragEnter];
        
        _voiceBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        _voiceBtn.layer.cornerRadius = 4;
        _voiceBtn.layer.masksToBounds = YES;
        _voiceBtn.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.4] CGColor];
        _voiceBtn.layer.borderWidth = 1;
    }
    return _voiceBtn;
}

#pragma mark 菜单按钮
- (UIButton *)menuBtn{
    if (!_menuBtn) {
        _menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _menuBtn.frame = CGRectMake(self.width - kSHInPutSpace - kSHInPutIcon_WH, self.changeBtn.y, kSHInPutIcon_WH, kSHInPutIcon_WH);
        [_menuBtn setBackgroundImage:[self imageNamed:@"chat_menu.png"] forState:UIControlStateNormal];
        [_menuBtn addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
        _menuBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    }
    return _menuBtn;
}

#pragma mark 表情按钮
- (UIButton *)emojiBtn{
    if (!_emojiBtn) {
        _emojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _emojiBtn.frame = CGRectMake(self.width - 2*(kSHInPutIcon_WH + kSHInPutSpace), self.changeBtn.y, kSHInPutIcon_WH, kSHInPutIcon_WH);
        [_emojiBtn setBackgroundImage:[self imageNamed:@"chat_face.png"] forState:UIControlStateNormal];
        [_emojiBtn setBackgroundImage:[self imageNamed:@"chat_keyboard.png"] forState:UIControlStateSelected];
        [_menuBtn setBackgroundImage:[UIImage new] forState:UIControlStateHighlighted];
        [_emojiBtn addTarget:self action:@selector(emojiClick:) forControlEvents:UIControlEventTouchUpInside];
        _emojiBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    }
    return _emojiBtn;
}



#pragma mark 自定义多媒体菜单
- (SHShareMenuView *)menuView {
    
    if (!_menuView) {
        
        CGFloat shareMenuView_H;
        //计算多媒体菜单高度
        if (self.shareMenuItems.count <= kSHShareMenuPerRowItemCount) {
            shareMenuView_H = 2*KSHShareMenuItemTop + KSHShareMenuItemHeight;
            
        }else if (self.shareMenuItems.count <= kSHShareMenuPerRowItemCount*kSHShareMenuPerColum){
            shareMenuView_H = (KSHShareMenuItemTop + KSHShareMenuItemHeight)*kSHShareMenuPerColum + KSHShareMenuItemTop;
            
        }else{
            shareMenuView_H = (KSHShareMenuItemTop + KSHShareMenuItemHeight)*kSHShareMenuPerColum + kSHShareMenuPageControlHeight;
        }
        
        _menuView = [[SHShareMenuView alloc] initWithFrame:CGRectMake(0, 200, kSHWidth, shareMenuView_H)];
        _menuView.backgroundColor = kInPutViewColor;
        _menuView.hidden = YES;
        _menuView.delegate = self;
        _menuView.shareMenuItems = self.shareMenuItems;
        [_menuView reloadData];
        
        [self.superview addSubview:_menuView];
    }
    
    return _menuView;
}

#pragma mark - 按钮点击
#pragma mark 状态点击
- (void)changeClick:(UIButton *)btn{
    
    NSLog(@"改变输入与录音状态");
    
    if (self.changeBtn.selected) {
        //文本输入
        self.inputType = SHInputViewType_text;
    }else{
        //语音输入
        self.inputType = SHInputViewType_voice;
    }
}

#pragma mark 菜单点击
- (void)menuClick:(UIButton *)btn{
    NSLog(@"点击菜单");
    
    if (self.menuBtn.selected) {
        //文本输入
        self.inputType = SHInputViewType_text;
    }else{
        //菜单输入
        self.inputType = SHInputViewType_menu;
    }
    
}

#pragma mark 表情点击
- (void)emojiClick:(UIButton *)btn{
    NSLog(@"点击表情");
    
    if (self.emojiBtn.selected) {
        //文本输入
        self.inputType = SHInputViewType_text;
    }else{
        //表情输入
        self.inputType = SHInputViewType_emotion;
    }
}

#pragma mark - 监听实现
#pragma mark 监听输入框的位置
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"]) {
        //回调
        if ([self.delegate respondsToSelector:@selector(toolbarHeightChange)]) {
            [self.delegate toolbarHeightChange];
        }
    }
}

#pragma mark 监听输入框类型
- (void)setInputType:(SHInputViewType)inputType{
    
    if (_inputType == inputType) {
        return;
    }
    
    if (_inputType == SHInputViewType_voice && inputType == SHInputViewType_default) {
        _inputType = inputType;
        return;
    }
    
    _inputType = inputType;
    
    //初始化
    self.menuBtn.selected = NO;
    self.emojiBtn.selected = NO;
    self.changeBtn.selected = NO;
    
    self.textView.hidden  = YES;
    self.voiceBtn.hidden = YES;

    //self.menuView.hidden = YES;
    
    self.textView.inputView = nil;
    
    [self.textView resignFirstResponder];
    
    switch (inputType) {
        case SHInputViewType_default://默认
        {
            self.textView.hidden  = NO;
            if(self.menuView.hidden){
                [UIView animateWithDuration:0.25 animations:^{
                    self.y = start_maxy - self.height;
                }];
            }else{
                [UIView animateWithDuration:0.25 animations:^{
                    self.y = start_maxy - self.height;
                    self.menuView.y = self.superview.height-kSHBottomSafe;
                } completion:^(BOOL finished) {
                    self.menuView.hidden = YES;
                }];
            }
            
        }
            break;
        case SHInputViewType_text://文本
        {
            self.textView.hidden  = NO;
            
            [self.textView reloadInputViews];
            
            //弹出键盘
            [self.textView becomeFirstResponder];
        }
            break;
        case SHInputViewType_voice://语音
        {
            self.changeBtn.selected = YES;
            
            self.voiceBtn.hidden = NO;
            
            [UIView animateWithDuration:0.25 animations:^{
                self.y = start_maxy - self.height;
                self.menuView.y = self.superview.height-kSHBottomSafe;
            } completion:^(BOOL finished) {
                self.menuView.hidden = YES;
            }];
            
            [self remakesView];
        }
            break;
        case SHInputViewType_emotion://表情
        {
            self.emojiBtn.selected = YES;
            
            self.textView.hidden  = NO;
           
            
           
            [self.textView reloadInputViews];
            
            //弹出键盘
            [self.textView becomeFirstResponder];
            
            //位置变化
//            self.emojiView.y = self.superview.height;
//            [UIView animateWithDuration:0.25 animations:^{
//
//                self.y = start_maxy - self.height - self.emojiView.height;
//                self.emojiView.y = self.maxY;
//            }];
//
//            [self textViewDidChange:self.textView];
        }
            break;
        case SHInputViewType_menu://菜单
        {
            self.menuBtn.selected = YES;
            
            self.textView.hidden  = NO;
            self.menuView.hidden = NO;
            
            //位置变化
            self.menuView.y = self.superview.height-kSHBottomSafe;
            
            NSLog(@"height:%f",self.superview.height);
            
            [UIView animateWithDuration:0.25 animations:^{
                
                self.y = start_maxy - self.height - self.menuView.height;
                self.menuView.y = self.maxY;
            }];
            [self textViewDidChange:self.textView];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 处理外面的点击事件
- (void)dealWithTap
{
    
    [self.textView resignFirstResponder];
    
    switch (_inputType) {
        case SHInputViewType_default:
            
            break;
        case SHInputViewType_text:
            
            break;
        case SHInputViewType_voice:
            
            break;
        case SHInputViewType_emotion:
            
            break;
        case SHInputViewType_menu:
        {
            
            self.menuBtn.selected = NO;
            _inputType = SHInputViewType_default;
            [UIView animateWithDuration:0.25 animations:^{
                
               self.y = start_maxy - self.height;
                self.menuView.y = self.superview.height-kSHBottomSafe;
            } completion:^(BOOL finished) {
                self.menuView.hidden = YES;
            }];
        }
            break;
    }
}

#pragma mark - 发送消息
#pragma mark 发送文字
- (void)sendMessageWithText:(NSString *)text {
    
    if ([_delegate respondsToSelector:@selector(sendText:)]) {
        [_delegate sendText:text];
    }
    
    self.textView.text = @"";
    [self textViewDidChange:self.textView];
}

#pragma mark 发送语音
- (void)sendMessageWithVoice:(NSString *)voiceName duration:(NSString *)duration {
    
    if ([_delegate respondsToSelector:@selector(chatMessageWithSendVoice:duration:)]) {
        [_delegate chatMessageWithSendVoice:voiceName duration:duration];
    }
}

#pragma mark 发送图片
- (void)sendMessageWithImage:(UIImage *)image{
    
    if ([_delegate respondsToSelector:@selector(chatMessageWithSendImage:)]) {
        [_delegate chatMessageWithSendImage:image];
    }
    
}

#pragma mark 发送视频
- (void)sendMessageWithVideo:(NSString *)videoPath {
    
//    NSString *videoName = [self getFileNameWithContent:videoPath type:SHMessageFileType_video];
//
//    if ([_delegate respondsToSelector:@selector(chatMessageWithSendVideo:)]) {
//        [_delegate chatMessageWithSendVideo:videoName];
//    }
}

#pragma mark 发送位置
- (void)sendMessageWithLocation:(NSString *)locationName lon:(CGFloat)lon lat:(CGFloat)lat{
    
    if ([_delegate respondsToSelector:@selector(chatMessageWithSendLocation:lon:lat:)]) {
        [_delegate chatMessageWithSendLocation:locationName lon:lon lat:lat];
    }
}

#pragma mark 发送名片
- (void)sendMessageWithCard:(NSString *)card {
    
    if ([_delegate respondsToSelector:@selector(chatMessageWithSendCard:)]) {
        [_delegate chatMessageWithSendCard:card];
    }
}

#pragma mark 发送红包
- (void)sendMessageWithRedPackage:(NSString *)message {
    
    if ([_delegate respondsToSelector:@selector(chatMessageWithSendRedPackage:)]) {
        [_delegate chatMessageWithSendRedPackage:message];
    }
}

#pragma mark 发送Gif
- (void)sendMessageWithGif:(NSString *)gifName size:(CGSize)size{
    
    if ([_delegate respondsToSelector:@selector(chatMessageWithSendGif:size:)]) {
        [_delegate chatMessageWithSendGif:gifName size:size];
    }
}

#pragma mark - 菜单内容
#pragma mark 打开照片
//- (void)openPhoto{
//
//
//
//
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
//        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//        picker.view.backgroundColor = [UIColor whiteColor];
//        picker.delegate = self;
//        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//
//        [self.supVC presentViewController:picker animated:YES completion:nil];
//    }
//
//
//
//}

# pragma mark - 选取本地图片
-(void)openPhoto{
  
    __weak typeof(self) weakSelf = self;
    
   // NSMutableArray *photosArr = [NSMutableArray arrayWithCapacity:0];
    
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:4 delegate:weakSelf];
    imagePickerVc.maxImagesCount = 4;//最小照片必选张数,默认是0
    imagePickerVc.sortAscendingByModificationDate = NO;// 对照片排序，按修改时间升序，默认是YES。如果设置为NO
   
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets,BOOL isSelectOriginalPhoto){
        NSLog(@"选中图片photos === %@",photos);
        
       // [photosArr addObjectsFromArray:photos];
        
        if(photos.count>0){
            if (weakSelf.delegate &&[weakSelf.delegate respondsToSelector:@selector(chatMessageWithSendImageArr:)]) {
                [weakSelf.delegate chatMessageWithSendImageArr:photos];
            }
        }
        
    
    }];
    [weakSelf.supVC presentViewController:imagePickerVc animated:YES completion:nil];
    
}


# pragma mark - 拍照
- (void)takePhoto
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)
    {
        NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
        NSString *str = [NSString stringWithFormat:ModuleZW(@"请在iPhone的\"设置->隐私->相机\"选项中，允许%@访问您的摄像头。"),appName];

       // [self.viewController showAlertWarmMessage:str];
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.mediaTypes = [NSArray arrayWithObjects: @"public.image", nil];
    [self.supVC presentViewController:picker animated:YES completion:^{
    }];
}



- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //[picker dismissModalViewControllerAnimated:YES comp];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (self.delegate &&[self.delegate respondsToSelector:@selector(chatMessageWithSendImage:)]) {
        [self.delegate chatMessageWithSendImage:image];
    }
}

#pragma mark 打开定位
- (void)openLocation{
    
   
}

#pragma mark 打开名片
- (void)openCard{
    
    [self sendMessageWithCard:@"哈哈"];
}

#pragma mark 打开红包
- (void)openRedPaper{
    
    [self sendMessageWithRedPackage:@"恭喜发财，大吉大利"];
}



#pragma mark - UITextViewDelegate
#pragma mark 键盘上功能点击

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {//点击了发送
        //发送文字
        [self sendMessageWithText:textView.text];
        return NO;
    }
    return YES;
}

#pragma mark 开始编辑
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    if (self.inputType == SHInputViewType_default) {
        //输入文本
        self.inputType = SHInputViewType_text;
    }
    
    [self textViewDidChange:textView];
}

#pragma mark 文字改变
- (void)textViewDidChange:(UITextView *)textView{
    
    CGFloat padding = textView.textContainer.lineFragmentPadding;
    
    CGFloat maxH = ceil(textView.font.lineHeight*3 + 2*padding);
    
    CGFloat textH = [textView.text boundingRectWithSize:CGSizeMake(textView.width - 2*padding, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:textView.font} context:nil].size.height;
    textH = ceil(MIN(maxH, textH));
    textH = ceil(MAX(textH, kSHInPutIcon_WH));
    
    if (self.textView.height != textH) {
        self.y += (self.textView.height - textH);
        self.height = textH + 2*kSHInPutSpace;
        [textView scrollRangeToVisible:NSMakeRange(textView.text.length, 1)];
    }
}

#pragma mark 重制视图
- (void)remakesView{
    
    self.height = kSHInPutIcon_WH + 2*kSHInPutSpace;
    self.y = start_maxy - self.height;
}

#pragma mark - SHShareMenuViewDelegate
- (void)didSelecteShareMenuItem:(SHShareMenuItem *)menuItem index:(NSInteger)index{
    
//    if ([_delegate respondsToSelector:@selector(didSelecteMenuItem:index:)]) {
//        [_delegate didSelecteMenuItem:menuItem index:index];
//    }
    
    if(index == 0){
//        if (self.delegate &&[self.delegate respondsToSelector:@selector(photoClick)]) {
//          [self.delegate photoClick];
//        }
        [self openPhoto];
    }else if (index == 1){

        [self takePhoto];
    }else{
        
    }
    
}

#pragma mark - SHVoiceRecordHelperDelegate
//- (void)voiceRecordFinishWithVoicename:(NSString *)voiceName duration:(NSString *)duration{
//
//    //发送语音
//    [self sendMessageWithVoice:voiceName duration:duration];
//}

#pragma mark 时间太短
- (void)voiceRecordTimeShort
{
    //提示框
    [SHMessageVoiceHUD shareInstance].hudType = 3;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SHMessageVoiceHUD shareInstance].hudType = 0;
    });
}

#pragma mark - 录音touch事件
- (void)holdDownButtonTouchDown {
  if ([self.delegate respondsToSelector:@selector(didStartRecordingVoiceAction)]) {
    [[JCHATAudioPlayerHelper shareInstance] stopAudio];
    [self.delegate didStartRecordingVoiceAction];
  }
}


- (void)holdDownButtonTouchUpOutside {
  if ([self.delegate respondsToSelector:@selector(didCancelRecordingVoiceAction)]) {
    [self.delegate didCancelRecordingVoiceAction];
  }
}

- (void)holdDownButtonTouchUpInside {
  if ([self.delegate respondsToSelector:@selector(didFinishRecordingVoiceAction)]) {
    [self.delegate didFinishRecordingVoiceAction];
  }
}

- (void)holdDownDragOutside {
  if ([self.delegate respondsToSelector:@selector(didDragOutsideAction)]) {
    [self.delegate didDragOutsideAction];
  }
}

- (void)holdDownDragInside {
  if ([self.delegate respondsToSelector:@selector(didDragInsideAction)]) {
    [self.delegate didDragInsideAction];
  }
}






#pragma mark 开始录音
- (void)beginRecordVoice:(UIButton *)button {
    
//    //录音的时候停止播放
//    [[SHAudioPlayerHelper shareInstance] stopAudio];
//
//    //检查权限
//    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
//
//        if (granted) {//获取权限
//
//            //用户同意获取数据
//            [SHMessageVoiceHUD shareInstance].hudType = 1;
//
//            //开始录音
//            [self.voiceRecordHelper startRecord];
//
//            if (self.playTimer) {
//                [self.playTimer invalidate];
//                self.playTimer = nil;
//            }
//
//            self.playTime = 0;
//            self.playTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(countVoiceTest) userInfo:nil repeats:YES];
//        }else{
//
//            dispatch_async(dispatch_get_main_queue(), ^{
//                UIAlertView *ale = [[UIAlertView alloc]initWithTitle:@"提示" message:@"开启权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [ale show];
//            });
//        }
//    }];
}

#pragma mark 停止录音
//- (void)endRecordVoice:(UIButton *)button {
//    //隐藏提示框
//    [SHMessageVoiceHUD shareInstance].hudType = 0;
//
//    if (self.playTimer) {
//        [self.voiceRecordHelper stopRecord];
//
//        [self.playTimer invalidate];
//        self.playTimer = nil;
//    }
//}

#pragma mark 取消录音
//- (void)cancelRecordVoice:(UIButton *)button {
//    //隐藏提示框
//    [SHMessageVoiceHUD shareInstance].hudType = 0;
//
//    if (self.playTimer) {
//        [self.voiceRecordHelper cancelRecord];
//
//        [self.playTimer invalidate];
//        self.playTimer = nil;
//    }
//}

#pragma mark 离开提示
- (void)RemindDragExit:(UIButton *)button {
    
    [SHMessageVoiceHUD shareInstance].hudType = 2;
}

#pragma mark 按住提示
- (void)RemindDragEnter:(UIButton *)button {
    
    [SHMessageVoiceHUD shareInstance].hudType = 1;
}

#pragma mark 声音检测
- (void)countVoiceTest {
    
//    self.playTime += 0.05;
//
//    int meters = [self.voiceRecordHelper peekRecorderVoiceMetersWithMax:7];
//    //声波显示
//    [[SHMessageVoiceHUD shareInstance] showVoiceMeters:meters];
//
//    if (self.playTime >= kSHMaxRecordTime) {//超过最大时间停止
//
//        self.playTime = 0;
//        [self.playTimer invalidate];
//
//        [SHMessageVoiceHUD shareInstance].hudType = 4;
//
//        //停止录音
//        [self endRecordVoice:self.voiceBtn];
//    }
    
}

@end
