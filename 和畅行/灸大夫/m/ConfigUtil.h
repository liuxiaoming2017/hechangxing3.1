//
//  ConfigUtil.h
//  MoxaAdvisor
//
//  Created by wangdong on 15/4/10.
//  Copyright (c) 2015年 jiudaifu. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "UserItem.h"
//#import "ArrayPList.h"

#pragma mark broadcast

#define UNKNOWN_USER            @""

#define MAIN_BROADCAST_ACTION   @"jiudaifu.action.broadcast"
#define BROADCAST_LOGIN_OK      @"jiudaifu.LoginOK"
#define BROADCAST_LOGOUT        @"jiudaifu.Logout"
#define BROADCAST_REGIST_OK     @"jiudaifu.RefitsOK"
#define BROADCAST_GETPASSWD_OK  @"jiudaifu.GetPasswdOK"
#define BROADCAST_TREAT_INFO    @"jiudaifu.TreatInfo"
#define BROADCAST_PUSH_MSG      @"jiudaifu.PushMsg"
#define BROADCAST_RCV_REPLY     @"jiudaifu.RcvReply"
#define BROADCAST_WX_AUTHOR_OK  @"jiudaifu.WXAuthorOk"
#define BROADCAST_MOXA_SETTING  @"jiudaifu.MoxaSetting"
#define BROADCAST_BRINGFOREGROUND    @"jiudaifu.BringForeGround"
#define BROADCAST_BINDRECOMMENDER_OK  @"jiudaifu.BindRecommederOk"
#define BROADCAST_CONFIRM_ORDER_OK      @"jiudaifu.ConfirmOrderOk"
#define BROADCAST_SELARRESS_OK      @"jiudaifu.SelAddressOk"
#define BROADCAST_DELARRESS      @"jiudaifu.DelAddress"
#define BROADCAST_MODULE_SW      @"jiudaifu.ModuleSW"
#define BROADCAST_ASKDOCTOR_SEARCHBTN      @"jiudaifu.AskDoctorSearchBtn"
#define BROADCAST_SENDPASTE_OK   @"jiudaifu.SendPasteOk"
#define BROADCAST_PAGE_CHANGE   @"jiudaifu.pagechange"
#define BROADCAST_RCV_LECTURE_REPLY    @"jiudaifu.lectureRcvReply"
#define BROADCAST_RCV_SCREENINTER_DOCTORUNLINE    @"jiudaifu.screenInterrogationDoctorlineoff"
#define BROADCAST_RCV_MISSDIAG    @"jiudaifu.missdiag"
#define BROADCAST_RCV_DYNMIC_REPLY    @"jiudaifu.dynamicRcvReply"
#define BROADCAST_RCV_USERREVDOTOR_REPLY    @"jiudaifu.userRcvDoctorReply"
#define BROADCAST_RCV_MESSGE_REPLY    @"jiudaifu.messgeRcvReply"
#define BROADCAST_RCV_HEAL_MESSGE_REPLY    @"jiudaifu.healmessgeRcvReply"

#define BROADCAST_RCV_DIAGNOSIS_RECEPTION   @"jiudaifu.reception"           //接诊通知
#define BROADCAST_RCV_DIAGNOSIS_ENDRECEPTION    @"jiudaifu.end.reception"   //结诊通知
#define BROADCAST_RCV_DIAGNOSIS_RETURN_VISIT    @"jiudaifu.return.visit"    //复诊通知

#define BROADCAST_RCV_EXPERIENCE_REPLY      @"jiudaifu.experience.reply"    //体会评论的回复

#define SHARE_LOGIN_USERNAME    @"LoginName"
#define SHARE_LOGIN_MOBILE      @"LoginMobile"
#define SHARE_LOGIN_PASSWORD    @"LoginPasswd"
#define SHARE_LOGIN_OPENID      @"LoginOpenID"
#define SHARE_LOGIN_OPENTYPE    @"LoginOpenType"
#define SHARE_LOGIN_HEAD        @"LoginHead"
#define SHARE_LOGIN_REMEMBER_PASSWD @"RememberPasswd"
#define SHARE_AUTO_LOGIN        @"AutoLogin"

//#define BROADCAST_ACTIVATION_TOKEN  @"jiudaifu.activation_token"

#define SETTINGS_AUTO_CHECK_VERSION @"AutoCheckVersion"
#define SETTINGS_HABIT_HAND     @"habitHandsettings"
#define SETTINGS_GUIDE_USED     @"GuideUsed_"
#define SETTINGS_NEW_MSG_HINT   @"NewMsgHint"
#define SETTINGS_MSG_SOUND_HINT @"MsgSoundHint"
#define SETTINGS_MSG_VIBRATE_HINT   @"MsgVibrateHint"
#define SETTINGS_MOXA_VOICE     @"MoxaVoiceEn"
#define SETTINGS_SHOW_XWISB     @"ShowXWIsb"
#define SETTINGS_SHOW_XWTIP     @"ShowXWTip"

#define MOXA_MODULE_USE      @"moxa_mudule_use"

#define FIRST_BIND_CARD     @"jdf_first_cardbind"
#define NET_LINK_HINT       @"jdf_net_link_hint"
#define APP_FIRST_RUN       @"jdf_app_first_run"
#define FIRST_RUN_MOXA      @"jdf_moxa_first_run"
#define UUID_PREF_KEY       @"jiudaifu_uuid"
#define VERSION_INFO_KEY    @"version_info"
#define ACUPOINT_DATAS_KEY  @"acupoint_datas"
#define HEALTHADVISOR_DATAS_KEY  @"healthadvisor_datas"
#define RECEPT_PLAN_DATAS_KEY  @"reciptplan_datas"
//#define FRIENDLIST_DATAS_KEY  @"friendlist_datas"
#define JINGLUO_DATA_ETAG   @"JingLuoDataETag"
#define ALIASNAME_ETAG   @"AliasnameETag"
#define LATESTRECIPEL       @"latestrecipel"
#define REMINDREGCOUNT      @"remindRegCount"
#define MESHNAME            @"meshName"
#define MOXIDEVICEMODE      @"moximode"

#define MAXJIULIAOVERSION   @"maxJiuliaoVersion"        //灸疗数据包版本号

#define USERINFO_PLIST  @"userinfo.plist"
#define MOXATREAT_PLIST @"moxatreat.plist"
#define CRASHLOG_PLIST  @"crashLog.plist"

#define PUSH_MSG_FMDB   @"pushmsg.db"
#define PUSH_MSG_TABLE  @"pushtable"

#define MOXA_DATAS_FMDB   @"moxadatas.db"
#define MOXA_DATAS_TABLE  @"moxadatatable"

#define MOXA_INF_FMDB   @"moxainf.db"
#define MOXA_INF_TABLE  @"moxainftable"

#define RECIPEL_FMDB   @"systemRecipel.db"
#define RECIPEL_TABLE  @"systemRecipeltable"

#define CUSTOMRECIPEL_FMDB   @"customRecipel.db"
#define CUSTOMRECIPEL_TABLE  @"customRecipeltable"

#define TEMPLATE_FMDB   @"templateData.db"
#define TEMPLATE_TABLE  @"templateDatatable"

#define SEARCHFRIEND_FMDB @"searchFriend.db"
#define SEARCHDRIEND_TABLE @"searchFriendtable"

#define WXMUSICLIST_FMDB @"wxmusicList.db"
#define WXMUSICLIST_TABLE @"wxmusicListtable"

#define LOGININF_FMDB @"loginInf.db"
#define LOGININF_TABLE @"loginInftable"

#define RECIPTPLAN_FMDB @"reciptplan.db"
#define RECIPTPLAN_TABLE @"recipetable"
#define RECIPTPLAN_ALAISNAME_TABLE @"recipe_aliasname_table"

#define CRIPTION_DATAS_KEY  @"cription_datas"

#define MODE_MESSGE  @"messge"
#define MODE_MOXIFRIEND  @"moxifriend"
#define MODE_MOXIBUS  @"moxibus"
#define MODE_FOUND  @"found"
#define MODE_MINE  @"mine"
#define MODE_HEALCONSULTANT  @"healconsultant"
#define MODE_AUDITORIUM  @"auditorium"
#define MODE_ZIXUN  @"zixun"
#define MODE_MYMESSGE  @"mymessge"
#define MODE_DYNAMIC  @"dynamic"
#define MODE_JIUGUSHI  @"jiugushi"
#define MODE_NEWMOXIFRIEND  @"newmoxifriend"
#define MODE_SHOP  @"shop"
#define MODE_ACUPOINT  @"acupoint"
#define MODE_AIJIUZHIBAIBIN  @"aijiuzhibaibin"
#define MODE_SERVICECENTER  @"servicecenter"
#define MODE_ALLGOODS  @"allgoods"
#define MODE_SHOPCONSULT @"shoppingconsult"
#define MODE_SHOPCART @"shoppingcart"
#define MODE_SHOPMINE @"shopmine"
#define MODE_SHOPDETAIL @"shopdetail"
#define MODE_WXMUSIC @"wxmusic"

#define MOXA_LASTTIME @"mxlastTime"
#define MOXA_LASTTEMP @"mxlastTemp"

#define BLANKSTR        @""

#define USE_MINA_FOR_MESSAGE    FALSE

#define ASKDOCTOR_FillSEX @"fillsex"
#define ASKDOCTOR_FillAGE @"fillage"

#define SEARCH_RECODE @"searchrecode"
#define HOTSEARCH @"hotsearch"

#define NEWASK_RECRPTION_FLAG   @"-"

#define YYCACHE_APICACHE    @"ApiCache"     //YYCache框架实现Api接口返回数据的本地缓存
#define YYCACHE_VIDEOCACHE  @"VideoCache"   //YYCache框架实现Video接口返回数据的本地缓存


@interface ConfigUtil : NSObject

+ (NSString *)getMoxaLastTime;
+ (void)setMoxaLastTime:(NSString *)time;
//
+ (NSString *)getMoxaLastTemp;
+ (void)setMoxaLastTemp:(NSString *)temp;

+ (NSString*)getLatestRecipel;
+ (void)setLatestRecipel:(NSString*)s;
//
+ (int)getRemindRegCount;
+ (void)setRemindRegCount:(int)count;

+ (NSString*)getLastConnectMesh;
+ (void)setConnectMesh:(NSString*)meshname;

@end



