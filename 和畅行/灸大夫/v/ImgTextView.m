//
//  ImgTextView.m
//  MoxaAdvisor
//
//  Created by wangdong on 15/4/20.
//  Copyright (c) 2015年 jiudaifu. All rights reserved.
//

#import "ImgTextView.h"
#import "UIImage+Util.h"
#import <moxibustion/BlueToothCommon.h>

@implementation ImgTextView
@synthesize imageView = _imageView;
@synthesize input = _input;
@synthesize mTittle = _mTittle;
@synthesize controlBtn = _controlBtn;
@synthesize maxLen;
@synthesize kbAction = _kbAction;
@synthesize delegate = _delegate;
@synthesize countDownTimer = _countDownTimer;
@synthesize needCountTime  = _needCountTime;
@synthesize countTime = _countTime;
@synthesize retainTime = _retainTime;
@synthesize controlBtnStr = _controlBtnStr;
@synthesize isLoginInput = _isLoginInput;

- (void)awakeFromNib {
    _kbAction = -1;
    _needCountTime = NO;
    _isLoginInput = NO;
    [super awakeFromNib];
    [[NSBundle mainBundle]loadNibNamed:@"ImgTextView" owner:self options:nil];
    [self addSubview:self.contentView];
    self.contentView.frame = CGRectMake(0, 0, self.width, self.height);
    _input.adjustsFontSizeToFitWidth = YES;
}

- (IBAction)ControlbtnOnclinck:(id)sender {
    if(_delegate != nil){
        [_delegate controlBtnOnclinck:_controlBtn];
    }
}

- (IBAction)TittleOnclinck:(id)sender {
    [self TittleLableOnclinck];
}

-(void)setNeedCountTime:(BOOL)needCountTime Time_:(int)second{
    _needCountTime = needCountTime;
    _countTime = second;
}

-(void)ControlBtnEnable:(BOOL)b{
    if(b){
        _controlBtn.hidden = NO;
    }else{
        _controlBtn.hidden = YES;
        CGRect frame = _input.frame;
        frame.size.width += _controlBtn.frame.size.width;
        _input.frame = frame;
    }
    
}

-(void)ControlBtnTouchEnable:(BOOL)b{
    if(b == YES){
        if(_countDownTimer != nil){
            return;
        }
        [_controlBtn setUserInteractionEnabled:YES];
        if(_isLoginInput){
            [_controlBtn setTitleColor:NORMAL_BTN_COLOR forState:UIControlStateNormal];
        }else{
            [_controlBtn setBackgroundColor:NORMAL_BTN_COLOR];
        }
        
    }else{
        [_controlBtn setUserInteractionEnabled:NO];
        if(_isLoginInput){
            [_controlBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }else{
            [_controlBtn setBackgroundColor:[UIColor grayColor]];
        }
        
    }
    if(!_isLoginInput){
        _controlBtn.layer.borderWidth = 0;
        _controlBtn.layer.cornerRadius = 4.0;
        _controlBtn.layer.masksToBounds = YES;
    }
}

-(void)startCountDown{
    if(_needCountTime){
        _retainTime = _countTime;
        _controlBtnStr = _controlBtn.titleLabel.text;
        [self ControlBtnTouchEnable:NO];
        [_controlBtn setTitle:[NSString stringWithFormat:@"%ds",_retainTime] forState:UIControlStateNormal];
        _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDownFired) userInfo:nil repeats:YES];
        [_countDownTimer fire];
    }
}

-(void)countDownFired{
    _retainTime -= 1;
    [_controlBtn setTitle:[NSString stringWithFormat:@"%ds",_retainTime] forState:UIControlStateNormal];
    if(_retainTime == 0){
        [_controlBtn setTitle:_controlBtnStr forState:UIControlStateNormal];
        [_countDownTimer invalidate];
        _countDownTimer = nil;
        [self ControlBtnTouchEnable:YES];
    }
}

- (void)setLImage:(UIImage*)img {
    _mTittle.hidden = YES;
    _imageView.hidden = NO;
    _imageView.image = img;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_imageView.image transformWidth:32.0 height:32.0];
}

- (void)setTittle:(NSString*)tittle imageName_:(NSString *)namestring{
    _imageView.hidden = YES;
    _mTittle.hidden = NO;
    [_mTittle setTitle:tittle forState:UIControlStateNormal];
    if(namestring != nil){
        [_mTittle setImage:[[UIImage imageNamed:namestring] transformWidth:12 height:12] forState:UIControlStateNormal];
    }else{
        [_mTittle setImage:nil forState:UIControlStateNormal];
    }
    [_imageView.image transformWidth:32.0 height:32.0];
}

- (void)setTittleEnable:(BOOL)b{
    if(b){
        [_mTittle setUserInteractionEnabled:YES];
    }else{
        [_mTittle setUserInteractionEnabled:NO];
    }
}


-(void)TittleLableOnclinck{
    if(_delegate != nil){
        [_delegate tittleLableOnclinck:_mTittle];
    }
}

- (void)setPlaceHolder:(NSString*)str {
    [_input setPlaceholder:str];
}

- (void)setInputText:(NSString*)text {
    [_input setText:text];
}

- (UITextField*)getInputView {
    return _input;
}

- (NSString*)getInputText {
    return [_input text];
}

- (void)setSecure:(BOOL)is {
    [_input setSecureTextEntry:is];
}

- (void)setKeyBoardType:(UIKeyboardType)type maxInputLen:(int)len {
    [_input setKeyboardType:type];
    
    if (len < 0) {
        maxLen = 16;
    }else{
        _input.delegate = self;
        maxLen = len;
    }
}

- (void)setKeyAction:(int)action {
    _kbAction = action;
}

- (int)getKeyAction {
    return _kbAction;
}

#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // check for total length
    NSUInteger len = textField.text.length - range.length + string.length;
    if(len > maxLen)return NO;
    if (_filterStr) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:_filterStr] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
    return YES;
}

//输入框编辑完成以后，将视图恢复到原始状态
//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"textFieldDidBeginEditing" object:self];
////    [_input resignFirstResponder];
//}

// became first responder
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"textFieldDidBeginEditing" object:self];
}

//点击return 按钮 去掉
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//点击屏幕空白处去掉键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_input resignFirstResponder];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
