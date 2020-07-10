//
//  JCHATSendMessageViewController.h
//  JPush IM
//
//  Created by Apple on 14/12/26.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCHATToolBar.h"
#import "JCHATMoreView.h"
#import "JCHATRecordAnimationView.h"
#import "JCHATChatModel.h"
#import "XHVoiceRecordHUD.h"
#import "XHVoiceRecordHelper.h"
#import "JCHATMessageTableView.h"
#import "JCHATMessageTableViewCell.h"
#import "JCHATPhotoPickerViewController.h"

#import "SayAndWriteController.h"

#define interval 60*2 //static =const
#define navigationRightButtonRect CGRectMake(0, 0, 14, 17)
#define messageTableColor [UIColor colorWithRed:236/255.0 green:237/255.0 blue:240/255.0 alpha:1]

static NSInteger const messagePageNumber = 25;
static NSInteger const messagefristPageNumber = 20;

@interface JCHATConversationViewController : SayAndWriteController <
UITableViewDataSource,
UITableViewDelegate,
SendMessageDelegate,
AddBtnDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
PictureDelegate,
playVoiceDelegate,
UIGestureRecognizerDelegate,
UIAlertViewDelegate,
JMessageDelegate,
UIScrollViewDelegate,
JCHATPhotoPickerViewControllerDelegate,
UITextViewDelegate>{
    
    
}

@property(strong, nonatomic) JCHATMessageTableView *messageTableView;

@property(nonatomic, assign) JPIMInputViewType textViewInputViewType;
@property(assign, nonatomic) BOOL barBottomFlag;
@property(nonatomic, strong, readwrite) XHVoiceRecordHUD *voiceRecordHUD;
@property(strong, nonatomic) JMSGConversation *conversation;
@property(strong, nonatomic) NSString *targetName;
@property(assign, nonatomic) BOOL isConversationChange;
@property(weak,nonatomic)id superViewController;

/**
 *  管理录音工具对象
 */
@property(nonatomic, strong) XHVoiceRecordHelper *voiceRecordHelper;

/**
 *  记录旧的textView contentSize Heigth
 */
@property(nonatomic, assign) CGFloat previousTextViewContentHeight;

- (void)setupView;
- (void)prepareImageMessage:(UIImage *)img;
@end
