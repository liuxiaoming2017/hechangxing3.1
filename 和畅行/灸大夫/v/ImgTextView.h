//
//  ImgTextView.h
//  MoxaAdvisor
//
//  Created by wangdong on 15/4/20.
//  Copyright (c) 2015年 jiudaifu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ControlBtnDelegate <NSObject>

-(void)controlBtnOnclinck:(id)sender;

-(void)tittleLableOnclinck:(id)sender;

@end

@interface ImgTextView : UIView <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *input;
@property (weak, nonatomic) IBOutlet UIButton *mTittle;
@property (weak, nonatomic) IBOutlet UIButton *controlBtn;
@property (strong, nonatomic) NSString *filterStr;
@property (nonatomic, assign) int maxLen;
@property (assign, nonatomic) int kbAction;
@property (weak, nonatomic) id <ControlBtnDelegate> delegate;
@property (retain,nonatomic) NSTimer *countDownTimer;
@property (assign,nonatomic) BOOL needCountTime;
@property (assign,nonatomic) int countTime;
@property (assign,nonatomic) int retainTime;
@property (retain, nonatomic) NSString *controlBtnStr;
@property (assign,nonatomic) BOOL isLoginInput;

- (void)setLImage:(UIImage*)img;
- (void)setTittle:(NSString*)tittle imageName_:(NSString *)namestring;
- (void)setPlaceHolder:(NSString*)str;
- (void)setInputText:(NSString*)text;
- (void)ControlBtnEnable:(BOOL)b;
-(void)ControlBtnTouchEnable:(BOOL)b;
- (void)setNeedCountTime:(BOOL)needCountTime Time_:(int)second;
- (void)startCountDown;
- (void)setTittleEnable:(BOOL)b;
- (UITextField*)getInputView;
- (NSString*)getInputText;
- (void)setSecure:(BOOL)is;
- (void)setKeyAction:(int)action;
- (int)getKeyAction;
- (void)setKeyBoardType:(UIKeyboardType)type maxInputLen:(int)len;

@end
