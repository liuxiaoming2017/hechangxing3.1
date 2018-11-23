//
//  KeyBoardManager.h
//  MoxaAdvisor
//
//  Created by wangdong on 15/4/2.
//  Copyright (c) 2015年 jiudaifu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(int, KeyAction) {
    KEYACTION_NEXT,        // 下一步
    KEYACTION_COMPLETE     // 完成
};

typedef void (^DoneKeyActionBlock)(int action);
@interface KeyBoardManager : NSObject

@property (nonatomic, weak) UIViewController *vc;
@property (nonatomic, retain) NSMutableArray *respArray;
@property (nonatomic, assign) CGSize kbSize;
@property (retain, nonatomic) UIButton* doneInKeyboardButton;
@property (assign, nonatomic) int doneAction;
@property (assign, nonatomic) DoneKeyActionBlock doneKeyBlock;
@property (assign, nonatomic) BOOL completeKeyEn;

+ (KeyBoardManager *)sharedInstance;
- (void)configViewControl:(UIViewController*)vc responderView:(UIView*)resp, ... NS_REQUIRES_NIL_TERMINATION;
- (void)enInputAccessoryView:(id)edit;
- (void)addResponder:(UIView*)resp;
- (void)configDoneInKeyBoardButton:(int)action onClickDoneKey:(DoneKeyActionBlock)block;
- (void)setDoneKeyTitle:(NSString*)title;
//- (void)remove;

@end
