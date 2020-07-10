//
//  JCHATSendMessageViewController.m
//  JPush IM
//
//  Created by Apple on 14/12/26.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "JCHATConversationViewController.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "JCHATFileManager.h"
#import "JCHATShowTimeCell.h"
#import "JCHATDetailsInfoViewController.h"
#import "JCHATGroupSettingCtl.h"
#import "AppDelegate.h"
//#import "MBProgressHUD+Add.h"
#import "UIImage+ResizeMagick.h"
//#import "JCHATPersonViewController.h"
#import "JCHATFriendDetailViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <JMessage/JMSGConversation.h>
#import "JCHATStringUtils.h"
//#import "JCHATAlreadyLoginViewController.h"
#import <UIKit/UIPrintInfo.h>
#import "JCHATLoadMessageTableViewCell.h"
#import "JCHATSendMsgManager.h"
#import "JCHATGroupDetailViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

#import "SHMessageInputView.h"

@interface JCHATConversationViewController ()<SHMessageInputViewDelegate//输入框代理
> {
    
@private
    BOOL isNoOtherMessage;
    NSInteger messageOffset;
    NSMutableArray *_imgDataArr;
    JMSGConversation *_conversation;//
    NSMutableDictionary *_allMessageDic; //缓存所有的message model
    NSMutableArray *_allmessageIdArr; //按序缓存后有的messageId， 于allMessage 一起使用
    NSMutableArray *_userArr;//
    UIButton *_rightBtn;
    NSMutableDictionary *_refreshAvatarUsersDic;
}

//下方工具栏
@property (nonatomic,strong)SHMessageInputView *chatInputView;

@end


@implementation JCHATConversationViewController//change name chatcontroller
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    _refreshAvatarUsersDic = [NSMutableDictionary dictionary];
    _allMessageDic = [NSMutableDictionary dictionary];
    _allmessageIdArr = [NSMutableArray array];
    _imgDataArr = [NSMutableArray array];
    
    if(self.conversation){
        self.navTitleLabel.text = _conversation.title;
        [self setupView];
        [self addNotification];
        [self addDelegate];
        [self getGroupMemberListWithGetMessageFlag:YES];
    }else{
        [self connectContactWithName:@""];
    }
    
    //添加键盘监听
    [self addKeyboardNote];
    
}

- (JCHATMessageTableView *)messageTableView
{
    
    
    if(!_messageTableView){
        JCHATMessageTableView *tableView = [[JCHATMessageTableView alloc] initWithFrame:CGRectMake(0, self.topView.bottom, ScreenWidth, ScreenHeight-self.topView.height-kTabBarHeight)];
        _messageTableView = tableView;
        _messageTableView.userInteractionEnabled = YES;
         _messageTableView.showsVerticalScrollIndicator = NO;
         _messageTableView.delegate = self;
         _messageTableView.dataSource = self;
         _messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
         _messageTableView.backgroundColor = messageTableColor;
        _messageTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:_messageTableView];
    }
    return _messageTableView;
}



#pragma mark 下方输入框
- (SHMessageInputView *)chatInputView{
    
    if (!_chatInputView) {
        _chatInputView = [[SHMessageInputView alloc]init];
        _chatInputView.frame = CGRectMake(0, self.view.height - kSHInPutHeight - kSHBottomSafe, kSHWidth, kSHInPutHeight);
        _chatInputView.delegate = self;
        _chatInputView.supVC = self;
        
        //图标
        NSArray *plugIcons = @[@"sharemore_pic.png", @"sharemore_video.png"];
        //标题
        NSArray *plugTitle = @[@"Album", @"Camera"];
        
        // 添加第三方接入数据
        NSMutableArray *shareMenuItems = [NSMutableArray array];
        
        //配置Item按钮
        [plugIcons enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop)  {
            
            SHShareMenuItem *shareMenuItem = [[SHShareMenuItem alloc] initWithIcon:[UIImage imageNamed:[NSString stringWithFormat:@"SHChatUI.bundle/%@",obj]] title:plugTitle[idx]];
            [shareMenuItems addObject:shareMenuItem];
        }];
        
        _chatInputView.shareMenuItems = shareMenuItems;
        [_chatInputView reloadView];
        
        if (kSHBottomSafe) {
            UIView *view = [[UIView alloc]init];
            view.frame = CGRectMake(0, _chatInputView.maxY, kSHWidth, kSHBottomSafe);
            view.backgroundColor = kInPutViewColor;
            [self.view addSubview:view];
        }
    }
    return _chatInputView;
}

# pragma mark - 获取联系人列表
- (void)networkContact
{
    
    
    [[NetworkManager sharedNetworkManager] requestWithType:0 urlString:@"doctor/alllist.jhtml" parameters:nil successBlock:^(id response) {
        if([[response objectForKey:@"status"] intValue] == 100){
            NSDictionary *dic = [[response objectForKey:@"data"] objectAtIndex:0];
            NSString *name = [dic objectForKey:@"imUsername"];
            [self connectContactWithName:name];
        }
    } failureBlock:^(NSError *error) {
        
    }];
}

# pragma mark - 发起通话连接
- (void)connectContactWithName:(NSString *)name
{
    __weak typeof(self) weakSelf = self;
    [JMSGConversation createSingleConversationWithUsername:@"lxm2020" appKey:JMESSAGE_APPKEY completionHandler:^(id resultObject, NSError *error) {
        if(error == nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                JMSGConversation *conversation = resultObject;
                weakSelf.navTitleLabel.text = conversation.title;
                [weakSelf setupView];
                [weakSelf addNotification];
                [weakSelf addDelegate];
                [weakSelf getGroupMemberListWithGetMessageFlag:YES];
            });
        }else{
            
        }
    }];
}


- (void)viewWillAppear:(BOOL)animated {
  //DDLogDebug(@"Event - viewWillAppear");
  [super viewWillAppear:animated];
  
    kWEAKSELF
    [_conversation refreshTargetInfoFromServer:^(id resultObject, NSError *error) {
        //DDLogDebug(@"refresh nav right button");
        kSTRONGSELF
       // [strongSelf.navigationController setNavigationBarHidden:NO];
        // 禁用 iOS7 返回手势
        if ([strongSelf.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            strongSelf.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
        
        if (strongSelf.conversation.conversationType == kJMSGConversationTypeGroup) {
            [strongSelf updateGroupConversationTittle:nil];
        } else {
            strongSelf.title = [resultObject title];
        }
        [self->_messageTableView reloadData];
    }];
  
}

- (void)updateGroupConversationTittle:(JMSGGroup *)newGroup {
  JMSGGroup *group;
  if (newGroup == nil) {
    group = self.conversation.target;
  } else {
    group = newGroup;
  }
  
  if ([group.name isEqualToString:@""]) {
    self.title = @"群聊";
  } else {
    self.title = group.name;
  }
  self.title = [NSString stringWithFormat:@"%@(%lu)",self.title,(unsigned long)[group.memberArray count]];
  [self getGroupMemberListWithGetMessageFlag:NO];
  if (self.isConversationChange) {
    [self cleanMessageCache];
    [self getPageMessage];
    self.isConversationChange = NO;
  }
}

- (void)viewDidLayoutSubviews {
  //DDLogDebug(@"Event - viewDidLayoutSubviews");
  [self scrollToBottomAnimated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
  //DDLogDebug(@"Event - viewWillDisappear");
  [super viewWillDisappear:animated];
  [_conversation clearUnreadCount];
  [[JCHATAudioPlayerHelper shareInstance] stopAudio];
  [[JCHATAudioPlayerHelper shareInstance] setDelegate:nil];
}

#pragma mark --释放内存
- (void)dealloc {
    //DDLogDebug(@"Action -- dealloc");
    //  [[NSNotificationCenter defaultCenter] removeObserver:self name:kAlertToSendImage object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //remove delegate
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAlertToSendImage object:self];
    [JMessage removeDelegate:self withConversation:_conversation];
}

- (void)setupView {
 // [self setupNavigation];
    self.view.backgroundColor = messageTableColor;
    [self.view addSubview:self.messageTableView];
    [self.view addSubview:self.chatInputView];
    
    UITapGestureRecognizer *gesture =[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(tapClick:)];
    [self.view addGestureRecognizer:gesture];
}



#pragma mark - 键盘通知
#pragma mark 添加键盘通知
- (void)addKeyboardNote {
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    // 1.显示键盘
    [center addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    
    // 2.隐藏键盘
    [center addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark 键盘通知执行
- (void)keyboardChange:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect newFrame = self.chatInputView.frame;
    newFrame.origin.y = keyboardEndFrame.origin.y - newFrame.size.height;
    
    if ([notification.name isEqualToString:@"UIKeyboardWillHideNotification"]) {
        newFrame.origin.y -= kSHBottomSafe;
    }
    self.chatInputView.frame = newFrame;
    
    [UIView commitAnimations];
}

#pragma mark 工具栏高度改变
- (void)toolbarHeightChange{
    
    //改变聊天界面高度
    CGRect frame = self.messageTableView.frame;
    frame.size.height = self.chatInputView.y-kNavBarHeight;
    self.messageTableView.frame = frame;
    
     NSLog(@"********frame:%@",NSStringFromCGRect(frame));
    
    [self.view layoutIfNeeded];
    //滚动到底部
    [self scrollToEnd];
}

#pragma mark - ScrollVIewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //默认输入
    self.chatInputView.inputType = SHInputViewType_default;
}

- (void)setupNavigation {
  //self.navigationController.navigationBar.translucent = NO;
    
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];

    
//  _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//  [_rightBtn setFrame:navigationRightButtonRect];
//  if (_conversation.conversationType == kJMSGConversationTypeSingle) {
//    [_rightBtn setImage:[UIImage imageNamed:@"userDetail"] forState:UIControlStateNormal];
//  } else {
//      [_rightBtn setImage:[UIImage imageNamed:@"groupDetail"] forState:UIControlStateNormal];
//      [self updateGroupConversationTittle:nil];
//    if ([((JMSGGroup *)_conversation.target) isMyselfGroupMember]) {
//      _rightBtn.hidden = YES;
//    }
//  }
  
  [_conversation clearUnreadCount];
  
//  [_rightBtn addTarget:self action:@selector(addFriends) forControlEvents:UIControlEventTouchUpInside];
//  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];//为导航栏添加右侧按钮
    
  UIButton *leftBtn =[UIButton buttonWithType:UIButtonTypeCustom];
  [leftBtn setFrame:CGRectMake(0, kStatusBarHeight+2, Adapter(40), 40)];
  [leftBtn setImage:[UIImage imageNamed:@"黑色返回"] forState:UIControlStateNormal];
 // [leftBtn setImageEdgeInsets:kGoBackBtnImageOffset];

  [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];//为导航栏添加左侧按钮
  self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)getGroupMemberListWithGetMessageFlag:(BOOL)getMesageFlag {
  if (self.conversation && self.conversation.conversationType == kJMSGConversationTypeGroup) {
    JMSGGroup *group = nil;
    group = self.conversation.target;
    _userArr = [NSMutableArray arrayWithArray:[group memberArray]];
    [self isContantMeWithUserArr:_userArr];
    if (getMesageFlag) {
      [self getPageMessage];
    }
  } else {
    if (getMesageFlag) {
      [self getPageMessage];
    }
    [self hidenDetailBtn:NO];
  }
}

- (void)isContantMeWithUserArr:(NSMutableArray *)userArr {
  BOOL hideFlag = YES;
  for (NSInteger i =0; i< [userArr count]; i++) {
    JMSGUser *user = [userArr objectAtIndex:i];
    if ([user.username isEqualToString:[JMSGUser myInfo].username]) {
      hideFlag = NO;
      break;
    }
  }
    if (!hideFlag) {
        [self reloadAllCellAvatarImage];
    }
  [self hidenDetailBtn:hideFlag];
}

- (void)hidenDetailBtn:(BOOL)flag {
    [_rightBtn setHidden:flag];
}

- (void)setTitleWithUser:(JMSGUser *)user {
  self.title = _conversation.title;
}

#pragma mark --JMessageDelegate
- (void)onSendMessageResponse:(JMSGMessage *)message error:(NSError *)error {
  //DDLogDebug(@"Event - sendMessageResponse");
    
  if (message != nil) {
    NSLog(@"发送的 Message:  %@",message);
  }
    [self relayoutTableCellWithMessage:message];
  
  if (error != nil) {
    //DDLogDebug(@"Send response error - %@", error);
    [_conversation clearUnreadCount];
    NSString *alert = [JCHATStringUtils errorAlert:error];
    if (alert == nil) {
      alert = [error description];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    //[MBProgressHUD showMessage:alert view:self.view];
    return;
  }
    
  JCHATChatModel *model = _allMessageDic[message.msgId];
  if (!model) {
    return;
  }
}

#pragma mark --收到消息
- (void)onReceiveMessage:(JMSGMessage *)message error:(NSError *)error {
    
    if (message != nil) {
    }
    if (error != nil) {
        JCHATChatModel *model = [[JCHATChatModel alloc] init];
        [model setErrorMessageChatModelWithError:error];
        [self addMessage:model];
        return;
    }

    if (![self.conversation isMessageForThisConversation:message]) {
        return;
    }

    if (message.contentType == kJMSGContentTypeCustom) {
        return;
    }
    //DDLogDebug(@"Event - receiveMessageNotification");
    
    kWEAKSELF
    JCHATMAINTHREAD((^{
        kSTRONGSELF
        if (!message) {
          //DDLogWarn(@"get the nil message .");
          return;
        }

//        if (_allMessageDic[message.msgId] != nil) {
//          //DDLogDebug(@"该条消息已加载");
//          return;
//        }

        if (message.contentType == kJMSGContentTypeEventNotification) {
          if (((JMSGEventContent *)message.content).eventType == kJMSGEventNotificationRemoveGroupMembers
              && ![((JMSGGroup *)self->_conversation.target) isMyselfGroupMember]) {
            [strongSelf setupNavigation];
          }
        }

        if (self->_conversation.conversationType == kJMSGConversationTypeSingle) {
        } else if (![((JMSGGroup *)self->_conversation.target).gid isEqualToString:((JMSGGroup *)message.target).gid]){
          return;
        }
        
        JCHATChatModel *model = [self->_allMessageDic objectForKey:message.msgId];
        if (model) {// 说明已经加载，说明可能是同步下来的多媒体消息，下载完成，然后再次收到就去刷新
            model.message = message;
            [strongSelf refreshCellMessageMediaWithChatModel:model];
        }else{
            
            NSString *firstMsgId = [self->_allmessageIdArr firstObject];
            JCHATChatModel *firstModel = [self->_allMessageDic objectForKey:firstMsgId];
            if (message.timestamp < firstModel.message.timestamp) {
                // 比数组中最老的消息时间都小的，无需加入界面显示，下次翻页时会加载
                return ;
            }
            
            model = [[JCHATChatModel alloc] init];
            [model setChatModelWith:message conversationType:self->_conversation];
            if (message.contentType == kJMSGContentTypeImage) {
                [self->_imgDataArr addObject:model];
            }
            model.photoIndex = [self->_imgDataArr count] -1;
            [strongSelf addmessageShowTimeData:message.timestamp];
            [strongSelf addMessage:model];
            
            BOOL isHaveCache = NO;
            NSString *key = [NSString stringWithFormat:@"%@_%@",message.fromUser.username,message.fromUser.appKey];
            NSMutableArray *messages = self->_refreshAvatarUsersDic[key];
            if (messages) {
                isHaveCache = YES;
                [messages addObject:message];
            }else{
                messages = [NSMutableArray array];
                [messages addObject:message];
            }
            if (messages.count > 10) {
                [messages removeObjectAtIndex:0];
            }
            [self->_refreshAvatarUsersDic setObject:messages forKey:key];
            
            [strongSelf chcekReceiveMessageAvatarWithReceiveNewMessage:message];
//            if (!isHaveCache) {
//                [strongSelf performSelector:@selector(chcekReceiveMessageAvatarWithReceiveNewMessage:) withObject:message afterDelay:1.5];
//            }
        }
  }));
}

- (void)onReceiveMessageDownloadFailed:(JMSGMessage *)message {
  if (![self.conversation isMessageForThisConversation:message]) {
    return;
  }
  
  //DDLogDebug(@"Event - receiveMessageNotification");
  JCHATMAINTHREAD((^{
      if (!message) {
          //DDLogWarn(@"get the nil message .");
          return;
      }
      
      if (self->_conversation.conversationType == kJMSGConversationTypeSingle) {
      } else if (![((JMSGGroup *)self->_conversation.target).gid isEqualToString:((JMSGGroup *)message.target).gid]){
          return;
      }
    
      JCHATChatModel *model = [self->_allMessageDic objectForKey:message.msgId];
      if (model) {// 说明已经加载，说明可能是同步下来的多媒体消息，下载完成，然后再次收到就去刷新
          model.message = message;
          [self refreshCellMessageMediaWithChatModel:model];
      }else{
          model = [[JCHATChatModel alloc] init];
          [model setChatModelWith:message conversationType:self->_conversation];
          if (message.contentType == kJMSGContentTypeImage) {
              [self->_imgDataArr addObject:model];
          }
          model.photoIndex = [self->_imgDataArr count] -1;
          [self addmessageShowTimeData:message.timestamp];
          [self addMessage:model];
      }
    
  }));
}
- (void)onSyncOfflineMessageConversation:(JMSGConversation *)conversation
                         offlineMessages:(NSArray<__kindof JMSGMessage *> *)offlineMessages {
    //DDLogDebug(@"Action -- onSyncOfflineMessageConversation:offlineMessages:");
    
    if (conversation.conversationType != self.conversation.conversationType) {
        return ;
    }
    BOOL isThisConversation = NO;
    if (conversation.conversationType == kJMSGConversationTypeSingle) {
        JMSGUser *user1 = (JMSGUser *)conversation.target;
        JMSGUser *user2 = (JMSGUser *)self.conversation.target;
        if ([user1.username isEqualToString:user2.username] &&
            [user1.appKey isEqualToString:user2.appKey]) {
            isThisConversation = YES;
        }
    }else{
        JMSGGroup *group1 = (JMSGGroup *)conversation.target;
        JMSGGroup *group2 = (JMSGGroup *)conversation.target;
        if ([group1.gid isEqualToString:group2.gid]) {
            isThisConversation = YES;
        }
    }
    
    if (!isThisConversation) {
        return ;
    }
    
    NSMutableArray *pathsArray = [NSMutableArray array];
    NSMutableArray *allSyncMessages = [NSMutableArray arrayWithArray:offlineMessages];
    for (int i = 0; i< allSyncMessages.count; i++) {
        JMSGMessage *message = allSyncMessages[i];
        JCHATChatModel *model = [[JCHATChatModel alloc] init];
        [model setChatModelWith:message conversationType:_conversation];
        if (message.contentType == kJMSGContentTypeImage) {
            [_imgDataArr addObject:model];
        }
        model.photoIndex = [_imgDataArr count] -1;
        
        [_allMessageDic setObject:model forKey:model.message.msgId];
        [_allmessageIdArr addObject:model.message.msgId];
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:[_allmessageIdArr count]-1 inSection:0];
        [pathsArray addObject:path];
    }
    if (pathsArray.count) {
        [_messageTableView beginUpdates];
        [_messageTableView insertRowsAtIndexPaths:pathsArray withRowAnimation:UITableViewRowAnimationNone];
        [_messageTableView endUpdates];
        [self scrollToEnd];
    }
}

- (void)onSyncRoamingMessageConversation:(JMSGConversation *)conversation {
    //DDLogDebug(@"Action -- onSyncRoamingMessageConversation:");
    
    if (conversation.conversationType != self.conversation.conversationType) {
        return ;
    }
    BOOL isThisConversation = NO;
    if (conversation.conversationType == kJMSGConversationTypeSingle) {
        JMSGUser *user1 = (JMSGUser *)conversation.target;
        JMSGUser *user2 = (JMSGUser *)self.conversation.target;
        if ([user1.username isEqualToString:user2.username] &&
            [user1.appKey isEqualToString:user2.appKey]) {
            isThisConversation = YES;
        }
    }else{
        JMSGGroup *group1 = (JMSGGroup *)conversation.target;
        JMSGGroup *group2 = (JMSGGroup *)conversation.target;
        if ([group1.gid isEqualToString:group2.gid]) {
            isThisConversation = YES;
        }
    }
    
    if (!isThisConversation) {
        return ;
    }
    
    isNoOtherMessage = NO;
    messageOffset = 0;
    [_imgDataArr removeAllObjects];
    [_userArr removeAllObjects];
    
    [_allMessageDic removeAllObjects];
    [_allmessageIdArr removeAllObjects];
    [_imgDataArr removeAllObjects];
    
    [self getGroupMemberListWithGetMessageFlag:YES];
}

- (void)onGroupInfoChanged:(JMSGGroup *)group {
  [self updateGroupConversationTittle:group];
}

- (void)relayoutTableCellWithMessage:(JMSGMessage *) message{
    //DDLogDebug(@"relayoutTableCellWithMessage: msgid:%@",message.msgId);
    if ([message.msgId isEqualToString:@""]) {
        return;
    }
    
    JCHATChatModel *model = _allMessageDic[message.msgId];
    if (model) {
        model.message = message;
        [_allMessageDic setObject:model forKey:message.msgId];
    }
    
    NSInteger index = [_allmessageIdArr indexOfObject:message.msgId];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    JCHATMessageTableViewCell *tableviewcell = [_messageTableView cellForRowAtIndexPath:indexPath];
    tableviewcell.model = model;
    [tableviewcell layoutAllView];
    
//    [_messageTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
}
#pragma marks -- UIAlertViewDelegate --
//根据被点击按钮的索引处理点击事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == 0) {
    [self.navigationController popViewControllerAnimated:NO];//目的回到根视图
    //[MBProgressHUD showMessage:@"正在退出登录！" view:self.view];
    //DDLogDebug(@"Logout anyway.");
    
//    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
//    if ([appDelegate.tabBarCtl.loginIdentify isEqualToString:kFirstLogin]) {
//      [self.navigationController.navigationController popToViewController:[self.navigationController.navigationController.childViewControllers objectAtIndex:0] animated:YES];
//    }
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kuserName];
    //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    [JMSGUser logout:^(id resultObject, NSError *error) {
      //DDLogDebug(@"Logout callback with - %@", error);
    }];
    
//    JCHATAlreadyLoginViewController *loginCtl = [[JCHATAlreadyLoginViewController alloc] init];
//    loginCtl.hidesBottomBarWhenPushed = YES;
//    UINavigationController *navLogin = [[UINavigationController alloc] initWithRootViewController:loginCtl];
//    appDelegate.window.rootViewController = navLogin;
  }
}
#pragma mark --获取对应消息的索引
- (NSInteger )getIndexWithMessageId:(NSString *)messageID {
  for (NSInteger i=0; i< [_allmessageIdArr count]; i++) {
    NSString *getMessageID = _allmessageIdArr[i];
    if ([getMessageID isEqualToString:messageID]) {
      return i;
    }
  }
  return 0;
}

- (bool)checkDevice:(NSString *)name {
  NSString *deviceType = [UIDevice currentDevice].model;
  //DDLogDebug(@"deviceType = %@", deviceType);
  NSRange range = [deviceType rangeOfString:name];
  return range.location != NSNotFound;
}

#pragma mark -- 清空消息缓存
- (void)cleanMessageCache {
  [_allMessageDic removeAllObjects];
  [_allmessageIdArr removeAllObjects];
  [self.messageTableView reloadData];
}

#pragma mark --添加message
- (void)addMessage:(JCHATChatModel *)model {
  if (model.isTime) {
    [_allMessageDic setObject:model forKey:model.timeId];
    [_allmessageIdArr addObject:model.timeId];
    [self addCellToTabel];
    return;
  }
  [_allMessageDic setObject:model forKey:model.message.msgId];
  [_allmessageIdArr addObject:model.message.msgId];
  [self addCellToTabel];
}

NSInteger sortMessageType(id object1,id object2,void *cha) {
  JMSGMessage *message1 = (JMSGMessage *)object1;
  JMSGMessage *message2 = (JMSGMessage *)object2;
  if([message1.timestamp integerValue] > [message2.timestamp integerValue]) {
    return NSOrderedDescending;
  } else if([message1.timestamp integerValue] < [message2.timestamp integerValue]) {
    return NSOrderedAscending;
  }
  return NSOrderedSame;
}

- (void)AlertToSendImage:(NSNotification *)notification {
  UIImage *img = notification.object;
  [self prepareImageMessage:img];
}

- (void)deleteMessage:(NSNotification *)notification {
  JMSGMessage *message = notification.object;
  [_conversation deleteMessageWithMessageId:message.msgId];
  [_allMessageDic removeObjectForKey:message.msgId];
  [_allmessageIdArr removeObject:message.msgId];
  [_messageTableView loadMoreMessage];
}

#pragma mark --排序conversation
- (NSMutableArray *)sortMessage:(NSMutableArray *)messageArr {
  NSArray *sortResultArr = [messageArr sortedArrayUsingFunction:sortMessageType context:nil];
  return [NSMutableArray arrayWithArray:sortResultArr];
}

#pragma mark 获取消息数据
- (void)getPageMessage {
  //DDLogDebug(@"Action - getAllMessage");
  [self cleanMessageCache];
  NSMutableArray * arrList = [[NSMutableArray alloc] init];
  [_allmessageIdArr addObject:[[NSObject alloc] init]];
  
  messageOffset = messagefristPageNumber;
  [arrList addObjectsFromArray:[[[_conversation messageArrayFromNewestWithOffset:@0 limit:@(messageOffset)] reverseObjectEnumerator] allObjects]];
  if ([arrList count] < messagefristPageNumber) {
    isNoOtherMessage = YES;
    [_allmessageIdArr removeObjectAtIndex:0];
  }
  
  for (NSInteger i=0; i< [arrList count]; i++) {
    JMSGMessage *message = [arrList objectAtIndex:i];
    JCHATChatModel *model = [[JCHATChatModel alloc] init];
    [model setChatModelWith:message conversationType:_conversation];
    if (message.contentType == kJMSGContentTypeImage) {
      [_imgDataArr addObject:model];
      model.photoIndex = [_imgDataArr count] - 1;
    }
    
    [self dataMessageShowTime:message.timestamp];
    [_allMessageDic setObject:model forKey:model.message.msgId];
    [_allmessageIdArr addObject:model.message.msgId];
  }
  [_messageTableView reloadData];
  [self scrollToBottomAnimated:NO];
}

- (void)flashToLoadMessage {
    NSMutableArray * arrList = @[].mutableCopy;
    NSArray *newMessageArr = [_conversation messageArrayFromNewestWithOffset:@(messageOffset) limit:@(messagePageNumber)];
    [arrList addObjectsFromArray:newMessageArr];
    if ([arrList count] < messagePageNumber) {// 判断还有没有新数据
        isNoOtherMessage = YES;
        [_allmessageIdArr removeObjectAtIndex:0];
    }
    
    messageOffset += messagePageNumber;
    for (NSInteger i = 0; i < [arrList count]; i++) {
        JMSGMessage *message = arrList[i];
        JCHATChatModel *model = [[JCHATChatModel alloc] init];
        [model setChatModelWith:message conversationType:_conversation];
        
        if (message.contentType == kJMSGContentTypeImage) {
            [_imgDataArr insertObject:model atIndex:0];
            model.photoIndex = [_imgDataArr count] - 1;
        }
        
        [_allMessageDic setObject:model forKey:model.message.msgId];
        [_allmessageIdArr insertObject:model.message.msgId atIndex: isNoOtherMessage?0:1];
        [self dataMessageShowTimeToTop:message.timestamp];// FIXME:
    }
    
    [_messageTableView loadMoreMessage];
}

- (JMSGUser *)getAvatarWithTargetId:(NSString *)targetId {
    
  for (NSInteger i=0; i<[_userArr count]; i++) {
    JMSGUser *user = [_userArr objectAtIndex:i];
    if ([user.username isEqualToString:targetId]) {
      return user;
    }
  }
  return nil;
}

- (XHVoiceRecordHelper *)voiceRecordHelper {
  if (!_voiceRecordHelper) {
    WEAKSELF
    _voiceRecordHelper = [[XHVoiceRecordHelper alloc] init];
    
    _voiceRecordHelper.maxTimeStopRecorderCompletion = ^{
      //DDLogDebug(@"已经达到最大限制时间了，进入下一步的提示");
      __strong __typeof(weakSelf)strongSelf = weakSelf;
      [strongSelf finishRecorded];
    };
    
    _voiceRecordHelper.peakPowerForChannel = ^(float peakPowerForChannel) {
      __strong __typeof(weakSelf)strongSelf = weakSelf;
      strongSelf.voiceRecordHUD.peakPower = peakPowerForChannel;
    };
    
    _voiceRecordHelper.maxRecordTime = kVoiceRecorderTotalTime;
  }
  return _voiceRecordHelper;
}

- (XHVoiceRecordHUD *)voiceRecordHUD {
  if (!_voiceRecordHUD) {
    _voiceRecordHUD = [[XHVoiceRecordHUD alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
  }
  return _voiceRecordHUD;
}

- (void)goBack:(UIButton *)btn
{
    if ([[JCHATAudioPlayerHelper shareInstance] isPlaying]) {
      [[JCHATAudioPlayerHelper shareInstance] stopAudio];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backClick {
  if ([[JCHATAudioPlayerHelper shareInstance] isPlaying]) {
    [[JCHATAudioPlayerHelper shareInstance] stopAudio];
  }
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)pressVoiceBtnToHideKeyBoard {///!!!

 
}

- (void)switchToTextInputMode {
    
}
#pragma mark --增加朋友
- (void)addFriends
{
    JCHATGroupDetailViewController *groupDetailCtl = [[JCHATGroupDetailViewController alloc] init];
    groupDetailCtl.hidesBottomBarWhenPushed = YES;
    groupDetailCtl.conversation = _conversation;
    groupDetailCtl.sendMessageCtl = self;
    [self.navigationController pushViewController:groupDetailCtl animated:YES];
}

- (void)JCHATPhotoPickerViewController:(JCHATPhotoSelectViewController *)PhotoPickerVC
selectedPhotoArray:(NSArray *)selected_photo_array
{
    
}


#pragma mark --发送图片
- (void)chatMessageWithSendImage:(UIImage *)image
{
    [self prepareImageMessage:image];
}

- (void)chatMessageWithSendImageArr:(NSArray *)imageArr
{
    for (UIImage *image in imageArr) {
      [self prepareImageMessage:image];
    }
}

- (void)prepareImageMessage:(UIImage *)img {
  
  img = [img resizedImageByWidth:upLoadImgWidth];
  
  JMSGMessage* message = nil;
  JCHATChatModel *model = [[JCHATChatModel alloc] init];
  JMSGImageContent *imageContent = [[JMSGImageContent alloc] initWithImageData:UIImagePNGRepresentation(img)];
  if (imageContent) {
    message = [_conversation createMessageWithContent:imageContent];
    [[JCHATSendMsgManager ins] addMessage:message withConversation:_conversation];
    [self addmessageShowTimeData:message.timestamp];
    [model setChatModelWith:message conversationType:_conversation];
    [_imgDataArr addObject:model];
    model.photoIndex = [_imgDataArr count] - 1;
    [model setupImageSize];
    [self addMessage:model];
  }
}

#pragma mark --
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
  [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --add Delegate
- (void)addDelegate {
  [JMessage addDelegate:self withConversation:self.conversation];
}

#pragma mark --加载通知
- (void)addNotification{
  //给键盘注册通知
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(inputKeyboardWillShow:)
   
                                               name:UIKeyboardWillShowNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(inputKeyboardWillHide:)
                                               name:UIKeyboardWillHideNotification
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(cleanMessageCache)
                                               name:kDeleteAllMessage
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(AlertToSendImage:)
                                               name:kAlertToSendImage
                                             object:nil];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(deleteMessage:)
                                               name:kDeleteMessage
                                             object:nil];


}

- (void)inputKeyboardWillShow:(NSNotification *)notification{
  _barBottomFlag=NO;
 
  CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
  
  [UIView animateWithDuration:animationTime animations:^{
    [self.view layoutIfNeeded];
  }];
  [self scrollToEnd];//!
}

- (void)inputKeyboardWillHide:(NSNotification *)notification {
  CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    kWEAKSELF
  [UIView animateWithDuration:animationTime animations:^{
    
    [weakSelf.view layoutIfNeeded];
  }];
  [self scrollToBottomAnimated:NO];
}

#pragma mark --发送文本
- (void)sendText:(NSString *)text {
  [self prepareTextMessage:text];
}


#pragma mark --返回下面的位置
- (void)dropToolBar {
  _barBottomFlag =YES;
  _previousTextViewContentHeight = 31;
 
  [_messageTableView reloadData];
  [UIView animateWithDuration:0.3 animations:^{
    
  }];
}

- (void)dropToolBarNoAnimate {
  _barBottomFlag =YES;
  _previousTextViewContentHeight = 31;
 
  [_messageTableView reloadData];
  
}


#pragma mark ----发送文本消息
- (void)prepareTextMessage:(NSString *)text {
    
    //DDLogDebug(@"Action - prepareTextMessage");
    if ([text isEqualToString:@""] || text == nil) {
        return;
    }
    [[JCHATSendMsgManager ins] updateConversation:_conversation withDraft:@""];
    JMSGMessage *message = nil;
    JMSGTextContent *textContent = [[JMSGTextContent alloc] initWithText:text];
    JCHATChatModel *model = [[JCHATChatModel alloc] init];
    
    message = [_conversation createMessageWithContent:textContent];//!
    
    [_conversation sendMessage:message];
    
    [self addmessageShowTimeData:message.timestamp];
    [model setChatModelWith:message conversationType:_conversation];
    [self addMessage:model];
}

#pragma mark -- 刷新对应的
- (void)addCellToTabel {
  NSIndexPath *path = [NSIndexPath indexPathForRow:[_allmessageIdArr count]-1 inSection:0];
  [_messageTableView beginUpdates];
  [_messageTableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
  [_messageTableView endUpdates];
  [self scrollToEnd];
}

#pragma mark ---比较和上一条消息时间超过5分钟之内增加时间model
- (void)addmessageShowTimeData:(NSNumber *)timeNumber{
  NSString *messageId = [_allmessageIdArr lastObject];
  JCHATChatModel *lastModel = _allMessageDic[messageId];
  NSTimeInterval timeInterVal = [timeNumber longLongValue];
    
  if ([_allmessageIdArr count] > 0 && lastModel.isTime == NO) {
      
    NSDate* lastdate = [NSDate dateWithTimeIntervalSince1970:[lastModel.messageTime longLongValue]/1000];
    NSDate* currentDate = [NSDate dateWithTimeIntervalSince1970:timeInterVal/1000];
    NSTimeInterval timeBetween = [currentDate timeIntervalSinceDate:lastdate];
    if (fabs(timeBetween) > interval) {
      [self addTimeData:timeInterVal];
    }
  } else if ([_allmessageIdArr count] == 0) {//首条消息显示时间
    [self addTimeData:timeInterVal];
  } else {
    //DDLogDebug(@"不用显示时间");
  }
}

#pragma mark ---比较和上一条消息时间超过5分钟之内增加时间model
- (void)dataMessageShowTime:(NSNumber *)timeNumber{
  NSString *messageId = [_allmessageIdArr lastObject];
  JCHATChatModel *lastModel = _allMessageDic[messageId];
  NSTimeInterval timeInterVal = [timeNumber longLongValue];
    
  if ([_allmessageIdArr count]>0 && lastModel.isTime == NO) {
    NSDate* lastdate = [NSDate dateWithTimeIntervalSince1970:[lastModel.messageTime longLongValue]/1000];
    NSDate* currentDate = [NSDate dateWithTimeIntervalSince1970:timeInterVal/1000];
    NSTimeInterval timeBetween = [currentDate timeIntervalSinceDate:lastdate];
    if (fabs(timeBetween) > interval) {
      JCHATChatModel *timeModel =[[JCHATChatModel alloc] init];
      timeModel.timeId = [self getTimeId];
      timeModel.isTime = YES;
      timeModel.messageTime = @(timeInterVal);
      timeModel.contentHeight = [timeModel getTextHeight];//!
      [_allMessageDic setObject:timeModel forKey:timeModel.timeId];
      [_allmessageIdArr addObject:timeModel.timeId];
    }
  } else if ([_allmessageIdArr count] ==0) {//首条消息显示时间
    JCHATChatModel *timeModel =[[JCHATChatModel alloc] init];
    timeModel.timeId = [self getTimeId];
    timeModel.isTime = YES;
    timeModel.messageTime = @(timeInterVal);
    timeModel.contentHeight = [timeModel getTextHeight];//!
    [_allMessageDic setObject:timeModel forKey:timeModel.timeId];
    [_allmessageIdArr addObject:timeModel.timeId];
  } else {
    //DDLogDebug(@"不用显示时间");
  }
}

- (void)dataMessageShowTimeToTop:(NSNumber *)timeNumber{
  NSString *messageId = [_allmessageIdArr lastObject];
  JCHATChatModel *lastModel = _allMessageDic[messageId];
  NSTimeInterval timeInterVal = [timeNumber longLongValue];
  if ([_allmessageIdArr count]>0 && lastModel.isTime == NO) {
    NSDate* lastdate = [NSDate dateWithTimeIntervalSince1970:[lastModel.messageTime doubleValue]];
    NSDate* currentDate = [NSDate dateWithTimeIntervalSince1970:timeInterVal];
    NSTimeInterval timeBetween = [currentDate timeIntervalSinceDate:lastdate];
    if (fabs(timeBetween) > interval) {
      JCHATChatModel *timeModel =[[JCHATChatModel alloc] init];
      timeModel.timeId = [self getTimeId];
      timeModel.isTime = YES;
      timeModel.messageTime = @(timeInterVal);
      timeModel.contentHeight = [timeModel getTextHeight];
      [_allMessageDic setObject:timeModel forKey:timeModel.timeId];
      [_allmessageIdArr insertObject:timeModel.timeId atIndex: isNoOtherMessage?0:1];
    }
  } else if ([_allmessageIdArr count] ==0) {//首条消息显示时间
    JCHATChatModel *timeModel =[[JCHATChatModel alloc] init];
    timeModel.timeId = [self getTimeId];
    timeModel.isTime = YES;
    timeModel.messageTime = @(timeInterVal);
    timeModel.contentHeight = [timeModel getTextHeight];
    [_allMessageDic setObject:timeModel forKey:timeModel.timeId];
    [_allmessageIdArr insertObject:timeModel.timeId atIndex: isNoOtherMessage?0:1];
  } else {
    //DDLogDebug(@"不用显示时间");
  }
}

- (void)addTimeData:(NSTimeInterval)timeInterVal {
  JCHATChatModel *timeModel =[[JCHATChatModel alloc] init];
  timeModel.timeId = [self getTimeId];
  timeModel.isTime = YES;
  timeModel.messageTime = @(timeInterVal);
  timeModel.contentHeight = [timeModel getTextHeight];//!
  [self addMessage:timeModel];
}

- (NSString *)getTimeId {
  NSString *timeId = [NSString stringWithFormat:@"%d",arc4random()%1000000];
  return timeId;
}

#pragma mark -- 点击空白处
- (void)tapClick:(UIGestureRecognizer *)gesture {

    
    [self.chatInputView dealWithTap];
    
}

#pragma mark --滑动至尾端
- (void)scrollToEnd {
  if ([_allmessageIdArr count] != 0) {
    [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_allmessageIdArr count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
  }
}

#pragma mark - tableView datasoce
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (!isNoOtherMessage) {
    if (indexPath.row == 0) { //这个是第 0 行 用于刷新
      return 40;
    }
  }
    
    if (indexPath.row >= _allmessageIdArr.count) {
        //DDLogDebug(@"1.index %ld beyond bounds %ld",indexPath.row,_allmessageIdArr.count);
        return 40;
    }
  NSString *messageId = _allmessageIdArr[indexPath.row];
  JCHATChatModel *model = _allMessageDic[messageId];
  if (model.isTime == YES) {
    return 31+6;
  }
  
  if (model.message.contentType == kJMSGContentTypeEventNotification) {
    return model.contentHeight + 17;
  }
  
  if (model.message.contentType == kJMSGContentTypeText) {
    return model.contentHeight + 17;
  } else if (model.message.contentType == kJMSGContentTypeImage ||
             model.message.contentType == kJMSGContentTypeFile ||
             model.message.contentType == kJMSGContentTypeLocation) {
    if (model.imageSize.height == 0) {
      [model setupImageSize];
    }
    return model.imageSize.height < 44?59:model.imageSize.height + 14;
    
  } else if (model.message.contentType == kJMSGContentTypeVoice) {
    return 69;
  }  else {
    return 49;
  }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_allmessageIdArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!isNoOtherMessage) {
        if (indexPath.row == 0) {
          static NSString *cellLoadIdentifier = @"loadCell"; //name
          JCHATLoadMessageTableViewCell *cell = (JCHATLoadMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellLoadIdentifier];
          
          if (cell == nil) {
            cell = [[JCHATLoadMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellLoadIdentifier];
          }
          [cell startLoading];
            [self flashToLoadMessage];
//          [self performSelector:@selector(flashToLoadMessage) withObject:nil afterDelay:0];
          return cell;
        }
    }
    if (indexPath.row >= _allmessageIdArr.count) {
        //DDLogDebug(@"2.index %ld beyond bounds %ld",indexPath.row,_allmessageIdArr.count);
        return nil;
    }
    NSString *messageId = _allmessageIdArr[indexPath.row];
    if (!messageId) {
        //DDLogDebug(@"messageId is nil%@",messageId);
        return nil;
    }

    JCHATChatModel *model = _allMessageDic[messageId];
    if (!model) {
        //DDLogDebug(@"JCHATChatModel is nil%@", messageId);
        return nil;
    }

    if (model.isTime == YES || model.message.contentType == kJMSGContentTypeEventNotification || model.isErrorMessage) {
        static NSString *cellIdentifier = @"timeCell";
        JCHATShowTimeCell *cell = (JCHATShowTimeCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];

        if (cell == nil) {
          cell = [[[NSBundle mainBundle] loadNibNamed:@"JCHATShowTimeCell" owner:nil options:nil] lastObject];
          cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        if (model.isErrorMessage) {
          cell.messageTimeLabel.text = [NSString stringWithFormat:@"%@ 错误码:%ld",st_receiveErrorMessageDes,model.messageError.code];
          return cell;
        }

        if (model.message.contentType == kJMSGContentTypeEventNotification) {
          cell.messageTimeLabel.text = [((JMSGEventContent *)model.message.content) showEventNotification];
        } else {
          cell.messageTimeLabel.text = [JCHATStringUtils getFriendlyDateString:[model.messageTime longLongValue]];
        }
        return cell;

    } else {
        static NSString *cellIdentifier = @"MessageCell";
        JCHATMessageTableViewCell *cell = (JCHATMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];

        if (cell == nil) {
          cell = [[JCHATMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
          cell.conversation = _conversation;
        }

        [cell setCellData:model delegate:self indexPath:indexPath];
        
        kWEAKSELF
        cell.messageTableViewCellRefreshMediaMessage = ^(JCHATChatModel *cellModel,BOOL isShouldRefresh){
            if (isShouldRefresh) {
                [weakSelf refreshCellMessageMediaWithChatModel:cellModel];
            }
        };
        
        return cell;
    }
}

#pragma mark - 检查并刷新消息图片图片
- (void)refreshCellMessageMediaWithChatModel:(JCHATChatModel *)model {
    //DDLogDebug(@"Action - refreshCellMessageMediaWithChatModel:");
    
    if (!model) {
        return ;
    }
    if (!model.message || ![self.conversation isMessageForThisConversation:model.message]) {
        return ;
    }
    NSString *msgId = model.message.msgId;
    JMSGMessage *db_message = [self.conversation messageWithMessageId:msgId];
    if (!db_message || !db_message.msgId) {
        return ;
    }
    
    model.message = db_message;
    [_allMessageDic setObject:model forKey:model.message.msgId];
    //[_allmessageIdArr addObject:model.message.msgId];msgId 不会变化所以不用去修改
    
    // 1.method
//    [self.messageTableView reloadData];
    
    // 2.method
//    NSArray *cellArray = [_messageTableView visibleCells];
//    for (id temp in cellArray) {
//        if ([temp isKindOfClass:[JCHATMessageTableViewCell class]]) {
//            JCHATMessageTableViewCell *cell = (JCHATMessageTableViewCell *)temp;
//            if ([cell.model.message.msgId isEqualToString:msgId]) {
//                cell.model = model;
//                [cell layoutAllView];
//            }
//        }
//    }
    // 3.在cell 里面刷新
}
#pragma mark - 检查并刷新头像
- (void)chcekReceiveMessageAvatarWithReceiveNewMessage:(JMSGMessage *)message {
    //DDLogDebug(@"chcekReceiveMessageAvatarWithReceiveNewMessage:%@",message.serverMessageId);
    if (!message || !message.fromUser) {
        return ;
    }
    
    JMSGMessage *lastMessage = message;
    JMSGUser *fromUser = lastMessage.fromUser;
    [fromUser thumbAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
        if (error == nil && [objectId isEqualToString:fromUser.username]) {
            if (data != nil) {
                NSUInteger lenght = data.length;
                [self refreshVisibleRowsAvatarWithNewMessage:lastMessage avatarDataLength:lenght];
            }
        }
    }];
//    NSString *key = [NSString stringWithFormat:@"%@_%@",message.fromUser.username,message.fromUser.appKey];
//    NSMutableArray *messages = _refreshAvatarUsersDic[key];
//    if (messages.count > 0) {
//        JMSGMessage *lastMessage = [messages lastObject];
//        JMSGUser *fromUser = lastMessage.fromUser;
//        [fromUser thumbAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
//            if (error == nil && [objectId isEqualToString:fromUser.username]) {
//                if (data != nil) {
//                    NSUInteger lenght = data.length;
//                    [self refreshVisibleRowsAvatarWithNewMessage:lastMessage avatarDataLength:lenght];
//                }
//            }
//            [_refreshAvatarUsersDic removeObjectForKey:key];
//        }];
//    }
}

- (void)refreshVisibleRowsAvatarWithNewMessage:(JMSGMessage *)message avatarDataLength:(NSUInteger)length {
    
    //DDLogDebug(@"refreshVisibleRowsAvatarWithNewMessage::%@",message.serverMessageId);
    
    NSString *username_appkey = [NSString stringWithFormat:@"%@_%@",message.fromUser.username,message.fromUser.appKey];
    NSString *msgId = message.msgId;
    
    NSArray *indexPaths = [[_messageTableView indexPathsForVisibleRows] mutableCopy];
    NSMutableArray *reloadIndexPaths = [NSMutableArray array];
    for (int i = 0; i < indexPaths.count; i++) {
        NSIndexPath *indexPath = indexPaths[i];
        JCHATMessageTableViewCell *cell = [_messageTableView cellForRowAtIndexPath:indexPath];
        JCHATChatModel *cellModel = cell.model;
        JMSGUser *cellUser = cell.model.message.fromUser;
        NSString *key = [NSString stringWithFormat:@"%@_%@",cellUser.username,cellUser.appKey];
        
        if (![username_appkey isEqualToString:key]) {
            continue ;
        }
        if (cellModel.avatarDataLength != length) {
            JMSGMessage *dbMessage = [self.conversation messageWithMessageId:msgId];
            JCHATChatModel *model = [_allMessageDic objectForKey:msgId];
            model.message = dbMessage;
            [_allMessageDic setObject:model forKey:msgId];
            [reloadIndexPaths addObject:indexPath];
        }
    }
    
    if (reloadIndexPaths.count > 0) {
        [_messageTableView reloadRowsAtIndexPaths:reloadIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)reloadAllCellAvatarImage {
    //DDLogDebug(@"Action -reloadAllCellAvatarImage");
    
    for (int i = 0; i < _allmessageIdArr.count; i++) {
        NSString *msgid = [_allmessageIdArr objectAtIndex:i];
        JCHATChatModel *model = [_allMessageDic objectForKey:msgid];
        if (model.message.isReceived && !model.message.fromUser.avatar) {
            JMSGMessage *message = [self.conversation messageWithMessageId:msgid];
            model.message = message;
            [_allMessageDic setObject:model forKey:msgid];
        }
    }
    
    NSArray *cellArray = [_messageTableView visibleCells];
    for (id temp in cellArray) {
        if ([temp isKindOfClass:[JCHATMessageTableViewCell class]]) {
            JCHATMessageTableViewCell *cell = (JCHATMessageTableViewCell *)temp;
            if (cell.model.message.isReceived) {
                [cell reloadAvatarImage];
            }
        }
    }
}

#pragma mark -PlayVoiceDelegate

- (void)successionalPlayVoice:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
  if ([_allmessageIdArr count] - 1 > indexPath.row) {
    NSString *messageId = _allmessageIdArr[indexPath.row + 1];
    JCHATChatModel *model = _allMessageDic[ messageId];
    
    if (model.message.contentType == kJMSGContentTypeVoice && model.message.flag) {
      JCHATMessageTableViewCell *voiceCell =(JCHATMessageTableViewCell *)[self.messageTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
      [voiceCell playVoice];
    }
  }
}

- (void)setMessageIDWithMessage:(JMSGMessage *)message chatModel:(JCHATChatModel * __strong *)chatModel index:(NSInteger)index {
  [_allMessageDic removeObjectForKey:(*chatModel).message.msgId];
  [_allMessageDic setObject:*chatModel forKey:message.msgId];
  
  if ([_allmessageIdArr count] > index) {
    [_allmessageIdArr removeObjectAtIndex:index];
    [_allmessageIdArr insertObject:message.msgId atIndex:index];
  }
}

- (void)selectHeadView:(JCHATChatModel *)model {
  if (!model.message.fromUser) {
    //[MBProgressHUD showMessage:@"该用户为API用户" view:self.view];
    return;
  }
  
  if (![model.message isReceived]) {
//    JCHATPersonViewController *personCtl =[[JCHATPersonViewController alloc] init];
//    personCtl.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:personCtl animated:YES];
  } else {
    JCHATFriendDetailViewController *friendCtl = [[JCHATFriendDetailViewController alloc]initWithNibName:@"JCHATFriendDetailViewController" bundle:nil];
    if (self.conversation.conversationType == kJMSGConversationTypeSingle) {
      friendCtl.userInfo = model.message.fromUser;
      friendCtl.isGroupFlag = NO;
    } else {
      friendCtl.userInfo = model.message.fromUser;
      friendCtl.isGroupFlag = YES;
    }
    
    [self.navigationController pushViewController:friendCtl animated:YES];
  }
}

#pragma mark -连续播放语音
- (void)getContinuePlay:(UITableViewCell *)cell
              indexPath:(NSIndexPath *)indexPath {
  JCHATMessageTableViewCell *tempCell = (JCHATMessageTableViewCell *) cell;
  if ([_allmessageIdArr count] - 1 > indexPath.row) {
    NSString *messageId = _allmessageIdArr[indexPath.row + 1];
    JCHATChatModel *model = _allMessageDic[ messageId];
    if (model.message.contentType == kJMSGContentTypeVoice && [model.message.flag isEqualToNumber:@(0)] && [model.message isReceived]) {
      if ([[JCHATAudioPlayerHelper shareInstance] isPlaying]) {
        tempCell.continuePlayer = YES;
      }else {
        tempCell.continuePlayer = NO;
      }
    }
  }
}

#pragma mark 预览图片 PictureDelegate
//PictureDelegate
- (void)tapPicture:(NSIndexPath *)index tapView:(UIImageView *)tapView tableViewCell:(UITableViewCell *)tableViewCell {
 
  JCHATMessageTableViewCell *cell =(JCHATMessageTableViewCell *)tableViewCell;
  NSInteger count = _imgDataArr.count;
  NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
  for (int i = 0; i<count; i++) {
    JCHATChatModel *messageObject = [_imgDataArr objectAtIndex:i];
    MJPhoto *photo = [[MJPhoto alloc] init];
    photo.message = messageObject;
    photo.srcImageView = tapView; // 来源于哪个UIImageView
    [photos addObject:photo];
  }
  MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
  browser.currentPhotoIndex = [_imgDataArr indexOfObject:cell.model];
//  browser.currentPhotoIndex = cell.model.photoIndex; // 弹出相册时显示的第一张图片是？
  browser.photos = photos; // 设置所有的图片
  browser.conversation =_conversation;
  [browser show];
}

#pragma mark --获取所有发送消息图片
- (NSArray *)getAllMessagePhotoImg {
  NSMutableArray *urlArr =[NSMutableArray array];
  for (NSInteger i=0; i<[_allmessageIdArr count]; i++) {
    NSString *messageId = _allmessageIdArr[i];
    JCHATChatModel *model = _allMessageDic[messageId];
    if (model.message.contentType == kJMSGContentTypeImage) {
      [urlArr addObject:((JMSGImageContent *)model.message.content)];
    }
  }
  return urlArr;
}
#pragma mark SendMessageDelegate

- (void)didStartRecordingVoiceAction {
  //DDLogVerbose(@"Action - didStartRecordingVoice");
  [self startRecord];
}

- (void)didCancelRecordingVoiceAction {
  //DDLogVerbose(@"Action - didCancelRecordingVoice");
  [self cancelRecord];
}

- (void)didFinishRecordingVoiceAction {
  //DDLogVerbose(@"Action - didFinishRecordingVoiceAction");
  [self finishRecorded];
}

- (void)didDragOutsideAction {
  //DDLogVerbose(@"Action - didDragOutsideAction");
  [self resumeRecord];
}

- (void)didDragInsideAction {
  //DDLogVerbose(@"Action - didDragInsideAction");
  [self pauseRecord];
}

- (void)pauseRecord {
  [self.voiceRecordHUD pauseRecord];
}

- (void)resumeRecord {
  [self.voiceRecordHUD resaueRecord];
}

- (void)cancelRecord {
  WEAKSELF
  [self.voiceRecordHUD cancelRecordCompled:^(BOOL fnished) {
    __strong __typeof(weakSelf)strongSelf = weakSelf;
    strongSelf.voiceRecordHUD = nil;
  }];
  [self.voiceRecordHelper cancelledDeleteWithCompletion:^{
    
  }];
}

#pragma mark - Voice Recording Helper Method
- (void)startRecord {
  //DDLogDebug(@"Action - startRecord");
  [self.voiceRecordHUD startRecordingHUDAtView:self.view];
  [self.voiceRecordHelper startRecordingWithPath:[self getRecorderPath] StartRecorderCompletion:^{
  }];
}

- (void)finishRecorded {
  //DDLogDebug(@"Action - finishRecorded");
  WEAKSELF
  [self.voiceRecordHUD stopRecordCompled:^(BOOL fnished) {
    __strong __typeof(weakSelf)strongSelf = weakSelf;
    strongSelf.voiceRecordHUD = nil;
  }];
  [self.voiceRecordHelper stopRecordingWithStopRecorderCompletion:^{
    __strong __typeof(weakSelf)strongSelf = weakSelf;
    [strongSelf SendMessageWithVoice:strongSelf.voiceRecordHelper.recordPath
                       voiceDuration:strongSelf.voiceRecordHelper.recordDuration];
  }];
}

#pragma mark - Message Send helper Method
#pragma mark --发送语音
- (void)SendMessageWithVoice:(NSString *)voicePath
               voiceDuration:(NSString*)voiceDuration {
  //DDLogDebug(@"Action - SendMessageWithVoice");
  
  if ([voiceDuration integerValue]<0.5 || [voiceDuration integerValue]>60) {
    if ([voiceDuration integerValue]<0.5) {
      //DDLogDebug(@"录音时长小于 0.5s");
    } else {
      //DDLogDebug(@"录音时长大于 60s");
    }
    return;
  }
  
  JMSGMessage *voiceMessage = nil;
  JCHATChatModel *model =[[JCHATChatModel alloc] init];
  JMSGVoiceContent *voiceContent = [[JMSGVoiceContent alloc] initWithVoiceData:[NSData dataWithContentsOfFile:voicePath]
                                                                 voiceDuration:[NSNumber numberWithInteger:[voiceDuration integerValue]]];
  
  voiceMessage = [_conversation createMessageWithContent:voiceContent];
  [_conversation sendMessage:voiceMessage];
  [model setChatModelWith:voiceMessage conversationType:_conversation];
  [JCHATFileManager deleteFile:voicePath];
  [self addMessage:model];
}

#pragma mark - RecorderPath Helper Method
- (NSString *)getRecorderPath {
  NSString *recorderPath = nil;
  NSDate *now = [NSDate date];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat = @"yy-MMMM-dd";
  recorderPath = [[NSString alloc] initWithFormat:@"%@/Documents/", NSHomeDirectory()];
  dateFormatter.dateFormat = @"yyyy-MM-dd-hh-mm-ss";
  recorderPath = [recorderPath stringByAppendingFormat:@"%@-MySound.ilbc", [dateFormatter stringFromDate:now]];
  return recorderPath;
}

#pragma mark - Key-value Observing
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
  if (self.barBottomFlag) {
    return;
  }

}


#pragma mark - UITextView Helper Method
- (CGFloat)getTextViewContentH:(UITextView *)textView {
  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
    return ceilf([textView sizeThatFits:textView.frame.size].height);
  } else {
    return textView.contentSize.height;
  }
}

#pragma mark - Layout Message Input View Helper Method

- (void)inputTextViewDidChange:(JCHATMessageTextView *)messageInputTextView {
  [[JCHATSendMsgManager ins] updateConversation:_conversation withDraft:messageInputTextView.text];
}

- (void)scrollToBottomAnimated:(BOOL)animated {
  if (![self shouldAllowScroll]) return;
  
  NSInteger rows = [self.messageTableView numberOfRowsInSection:0];
  
  if (rows > 0) {
    [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_allmessageIdArr count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
  }
}

#pragma mark - Previte Method

- (BOOL)shouldAllowScroll {
  return YES;
}

#pragma mark - Scroll Message TableView Helper Method

- (UIEdgeInsets)tableViewInsetsWithBottomValue:(CGFloat)bottom {
  UIEdgeInsets insets = UIEdgeInsetsZero;
  if ([self respondsToSelector:@selector(topLayoutGuide)]) {
    insets.top = 64;
  }
  insets.bottom = bottom;
  return insets;
}

#pragma mark - XHMessageInputView Delegate

- (void)inputTextViewWillBeginEditing:(JCHATMessageTextView *)messageInputTextView {
  _textViewInputViewType = JPIMInputViewTypeText;
}

- (void)inputTextViewDidBeginEditing:(JCHATMessageTextView *)messageInputTextView {
  if (!_previousTextViewContentHeight)
    _previousTextViewContentHeight = [self getTextViewContentH:messageInputTextView];
}

- (void)inputTextViewDidEndEditing:(JCHATMessageTextView *)messageInputTextView;
{
  if (!_previousTextViewContentHeight)
    _previousTextViewContentHeight = [self getTextViewContentH:messageInputTextView];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

// ---------------------------------- Private methods

@end
