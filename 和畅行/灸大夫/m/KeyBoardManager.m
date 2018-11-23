//
//  KeyBoardManager.m
//  MoxaAdvisor
//
//  Created by wangdong on 15/4/2.
//  Copyright (c) 2015年 jiudaifu. All rights reserved.
//

#import "KeyBoardManager.h"
#import "ImgTextView.h"
#import "UIButton+Bootstrap.h"
#import "UIView+FirstResponder.h"

@implementation KeyBoardManager
//@synthesize vc = _vc;
//@synthesize fview =_fview;
@synthesize respArray = _respArray;
@synthesize kbSize;
@synthesize doneInKeyboardButton;
@synthesize doneKeyBlock;

+ (KeyBoardManager *)sharedInstance {
    static KeyBoardManager *kb;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kb = [[KeyBoardManager alloc]init];
    });
    return kb;
}

- (void)configViewControl:(UIViewController*)vc responderView:(UIView*)resp, ... NS_REQUIRES_NIL_TERMINATION {
    kbSize.height = 0;
    _vc = vc;
    _respArray = [NSMutableArray arrayWithCapacity:5];
    // 定义一个指向可选参数列表的指针
    va_list args;
    // 获取第一个可选参数的地址，此时参数列表指针指向函数参数列表中的第一个可选参数
    va_start(args, resp);
    if(resp)
    {
        UIView *nextArg = resp;
        // 遍历参数列表中的参数，并使参数列表指针指向参数列表中的下一个参数
        do{
            [_respArray addObject:nextArg];
        }while((nextArg = va_arg(args, UIView *)));
    }
    // 结束可变参数的获取(清空参数列表)
    va_end(args);
    
    [self addNotification];
}

- (void)enInputAccessoryView:(id)edit {
    //定义一个toolBar
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    
    //设置style
    [topView setBarStyle:UIBarStyleDefault];
    
    //定义两个flexibleSpace的button，放在toolBar上，这样完成按钮就会在最右边
    UIBarButtonItem * button1 =[[UIBarButtonItem  alloc]initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem * button2 = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    //定义完成按钮
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone  target:self action:@selector(resignKeyboard)];
    
    //在toolBar上加上这些按钮
    NSArray * buttonsArray = [NSArray arrayWithObjects:button1,button2,doneButton,nil];
    [topView setItems:buttonsArray];
    if ([edit isKindOfClass:[UITextField class]] || [edit isKindOfClass:[UITextView class]]) {
        [edit setInputAccessoryView:topView];
    }
}

- (void)resignKeyboard {
    [[_vc.view findFirstResponder] resignFirstResponder];
}

- (void)addNotification {
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    //使用NSNotificationCenter
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(firstResponderChange:)
                                                 name:@"textFieldDidBeginEditing" object:nil];
}

- (void)addResponder:(UIView*)resp {
    [_respArray removeAllObjects];
    [_respArray addObject:resp];
}

- (void)configDoneInKeyBoardButton:(int)action onClickDoneKey:(DoneKeyActionBlock)block {
    //初始化
    doneKeyBlock = block;
    _doneAction = action;
    [self generateDoneKey];
}

- (void)setDoneKeyTitle:(NSString*)title {
    if (doneInKeyboardButton != nil) {
        [doneInKeyboardButton setTitle:title forState:UIControlStateNormal];
        [doneInKeyboardButton setTitle:title forState:UIControlStateHighlighted];
    }
}

- (void) addDoneButton{
    //获得键盘所在的window视图
    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    [tempWindow addSubview:doneInKeyboardButton];    // 注意这里直接加到window上
}

- (void)finishAction{
    if (doneKeyBlock != nil) {
        doneKeyBlock(_doneAction);
    }
}

//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    UIView *responderView = nil;
    UIView *inputView = nil;
    NSLog(@"----_respArray.count = %d",_respArray.count);
    for (UIView *view in _respArray) {
//                if ([view isKindOfClass:[UITextView class]] || [view isKindOfClass:[UITextField class]]) {
//                    responderView = view;
//                    break;
//                }
        if([view firstResponderSuperView] != nil){
            responderView = view;
            break;
        }
    }
    
    if (responderView == nil) {
        NSLog(@"no find firstResponder");
        return;
    }
    
    if ([responderView isKindOfClass:[UITextView class]] || [responderView isKindOfClass:[UITextField class]]) {
        inputView = nil;
    }else{
        for (UIView *subView in responderView.subviews) {
            if ([subView isKindOfClass:[UITextView class]] || [subView isKindOfClass:[UITextField class]]){
                inputView = subView;
                break;
            }
        }
    }
    
    
    NSDictionary* info = [aNotification userInfo];
    kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    

    CGRect frame = responderView.frame;
    frame.origin.y = responderView.frame.origin.y;
    int offset;
    if(inputView == nil){
        offset = frame.origin.y + responderView.frame.size.height - (_vc.view.frame.size.height - kbSize.height);
    }else{
        offset = frame.origin.y + inputView.frame.size.height  + inputView.frame.origin.y - (_vc.view.frame.size.height - kbSize.height);
    }
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        _vc.view.frame = CGRectMake(0.0f, -offset, _vc.view.frame.size.width, _vc.view.frame.size.height);
    
    [UIView commitAnimations];
    
    if (doneInKeyboardButton){
        NSInteger animationCurve = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animationDuration];//设置添加按钮的动画时间
        [UIView setAnimationCurve:(UIViewAnimationCurve)animationCurve];//设置添加按钮的动画类型
        
        //设置自定制按钮的添加位置(这里为数字键盘添加“完成”按钮)
        doneInKeyboardButton.transform=CGAffineTransformTranslate(doneInKeyboardButton.transform, 0, -53);
        
        [UIView commitAnimations];
    }
}

//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    _vc.view.frame = CGRectMake(0, 0, _vc.view.frame.size.width, _vc.view.frame.size.height);
    // NSNotification中的 userInfo字典中包含键盘的位置和大小等信息
    NSDictionary *userInfo = [aNotification userInfo];
    // UIKeyboardAnimationDurationUserInfoKey 对应键盘收起的动画时间
    CGFloat animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [self doneKeyDismiss:animationDuration];
}

- (void)generateDoneKey {
    if (doneInKeyboardButton == nil)
    {
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        doneInKeyboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [doneInKeyboardButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [doneInKeyboardButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        if (_doneAction == KEYACTION_NEXT) {
            [self setDoneKeyTitle:@"完成"];
        }else if(_doneAction == KEYACTION_COMPLETE) {
            [self setDoneKeyTitle:@"完成"];
        }
        doneInKeyboardButton.frame = CGRectMake(0, screenHeight, 106, 53);
        
        doneInKeyboardButton.adjustsImageWhenHighlighted = NO;
        [doneInKeyboardButton addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
        
        //每次必须从新设定“完成”按钮的初始化坐标位置
        doneInKeyboardButton.frame = CGRectMake(0, screenHeight, 106, 53);
        
        //由于ios8下，键盘所在的window视图还没有初始化完成，调用在下一次 runloop 下获得键盘所在的window视图
        [self performSelector:@selector(addDoneButton) withObject:nil afterDelay:0.0f];
    }
}

- (void)doneKeyDismiss:(CGFloat)duration {
    if (doneInKeyboardButton != nil) {
        if (doneInKeyboardButton.superview)
        {
            [UIView animateWithDuration:duration animations:^{
                //动画内容，将自定制按钮移回初始位置
                doneInKeyboardButton.transform=CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                //动画结束后移除自定制的按钮
                [doneInKeyboardButton removeFromSuperview];
                doneInKeyboardButton = nil;
            }];
        }
    }
}

- (void)firstResponderChange:(NSNotification*)aNotification {
    UIView *view = [aNotification object];
    CGRect frame = view.frame;
    frame.origin.y = view.frame.origin.y;
    int offset = frame.origin.y + view.frame.size.height - (_vc.view.frame.size.height - kbSize.height);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        _vc.view.frame = CGRectMake(0.0f, -offset, _vc.view.frame.size.width, _vc.view.frame.size.height);
    else
        _vc.view.frame = CGRectMake(0, 0, _vc.view.frame.size.width, _vc.view.frame.size.height);
    [UIView commitAnimations];
    
    if ([view respondsToSelector:@selector(getKeyAction)]) {
        if ([view isKindOfClass:[ImgTextView class]]) {
            int action = [((ImgTextView*)view) getKeyAction];
            if (action == KEYACTION_NEXT || action == KEYACTION_COMPLETE) {
                _doneAction = action;
                [self generateDoneKey];
            }
        }
    }
}

//- (void)remove {
//    _vc = nil;
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification
//                                                  object:nil];//object 与注册时相同
//
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification
//                                                  object:nil];//object 与注册时相同
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"textFieldDidBeginEditing"
//                                                  object:nil];//object 与注册时相同
//}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification
                                                  object:nil];//object 与注册时相同
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification
                                                  object:nil];//object 与注册时相同
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"textFieldDidBeginEditing"
                                                  object:nil];//object 与注册时相同
}

@end
