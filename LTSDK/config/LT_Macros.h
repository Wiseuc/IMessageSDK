//
//  LT_Macros.h
//  WiseUC
//
//  Created by JH on 2017/12/5.
//  Copyright © 2017年 WiseUC. All rights reserved.
//


#import "AppDelegate.h"

#pragma mark -================ Notification ===================

#define Wiseuc_Notification_Logoff          @"Wiseuc_Notification_Logoff"  /**<注销退出*/
#define Wiseuc_Notification_LoginSuccess    @"Wiseuc_Notification_LoginSuccess"  /**<登录成功*/
#define Wiseuc_Notification_OrgDownloadAndOrgvisibleRange @"Wiseuc_Notification_OrgDownloadAndOrgvisibleRange"  /**<组织架构获取、权限获取*/
#define Wiseuc_Notification_NewMessage @"Wiseuc_Notification_NewMessage"  /**<新消息*/
#define Wiseuc_Notification_PresenceChange @"Wiseuc_Notification_PresenceChange"  /**<好友状态改变*/
#define Wiseuc_Notification_PhotoHash @"Wiseuc_Notification_PhotoHash"  /**<头像*/
#define Wiseuc_Notification_SessionReplace @"Wiseuc_Notification_SessionReplace"  /**<异地登录*/
#define Wiseuc_Notification_InvitationFromGroupOrRoom @"Wiseuc_Notification_InvitationFromGroupOrRoom"  /**<加入群组*/
#define Wiseuc_Notification_DealwithGetInToGroupRequest @"Wiseuc_Notification_DealwithGetInToGroupRequest"  /**<处理某人加群申请*/
#define Wiseuc_Notification_DidReceiveRefuseGetIntoGroupMessage @"Wiseuc_Notification_DidReceiveRefuseGetIntoGroupMessage"  /**<接收到拒绝入群消息*/
#define Wiseuc_Notification_DeleteFromGroupOrRoom @"Wiseuc_Notification_DeleteFromGroupOrRoom"  /**<群组删除或被踢*/
#define Wiseuc_Notification_DeleteFromGroupOrRoomRefresh @"Wiseuc_Notification_DeleteFromGroupOrRoomRefresh"  /**<群组删除或被踢刷新*/
#define Wiseuc_Notification_GetGroupOrRoomInfoComplete @"Wiseuc_Notification_GetGroupOrRoomInfoComplete"  /**<群组信息已请求完毕*/

#define Wiseuc_Notification_NewNotice @"Wiseuc_Notification_NewNotice"  /**<新通知公告消息*/
#define Wiseuc_Notification_NewNoticeRefresh @"Wiseuc_Notification_NewNoticeRefresh"  /**<新通知公告消息刷新*/
#define Wiseuc_Notification_ReadNoticeRefresh @"Wiseuc_Notification_ReadNoticeRefresh"  /**<读通知公告消息后刷新*/

#define Wiseuc_Notification_NewVoting @"Wiseuc_Notification_NewVoting"  /**<新投票消息*/
#define Wiseuc_Notification_DealwithFriendRequest @"Wiseuc_Notification_DealwithFriendRequest"    /**<处理好友添加请求*/
#define Wiseuc_Notification_RefuseAddYouToBeFriend @"Wiseuc_Notification_RefuseAddYouToBeFriend"  /**<对方拒绝添加好友*/
#define Wiseuc_Notification_AgreeAddYouToBeFriend @"Wiseuc_Notification_AgreeAddYouToBeFriend"    /**<对方同意添加好友*/
#define Wiseuc_Notification_NewVotingRefresh @"Wiseuc_Notification_NewVotingRefresh"  /**<新投票消息刷新*/

#define Wiseuc_Notification_NewApprove @"Wiseuc_Notification_NewApprove"  /**<新审批消息*/
#define Wiseuc_Notification_NewApproveRefresh @"Wiseuc_Notification_NewApproveRefresh"  /**<新审批消息刷新*/

#define Wiseuc_Notification_ReadAllMessage @"Wiseuc_Notification_ReadAllMessage"  /**<拖动红点阅读所有消息*/
#define Wiseuc_Notification_ClickCallMeeting @"Wiseuc_Notification_ClickCallMeeting"  /**<点击电话*/

#define Wiseuc_Notification_Linphone_GetUserPid         @"Linphone_GetUserPid"       /**<请求自己pid*/
#define Wiseuc_Notification_Linphone_GetOtherUserPid    @"Linphone_GetOtherUserPid"  /**<请求对方pid*/

#define Wiseuc_Notification_GetDigest    @"Wiseuc_Notification_GetDigest"  /**<第二次登录获取到Digest*/










#pragma mark -================ NSUserDefaults ===================

#define Wiseuc_NSUserDefaults_HasAccountNav @"HasAccountNav"    /**<用户引导页*/
#define Wiseuc_NSUserDefaults_HistoryAccount @"HistoryAccount"    /**<历史用户*/
#define Wiseuc_NSUserDefaults_LogForToday @"LogForToday"    /**<今天写日志状态*/
#define Wiseuc_NSUserDefaults_Friends @"Friends"
#define Wiseuc_NSUserDefaults_LastPresenceStatu @"LastPresenceStatu"    // 进入后台时的状态
#define kUSERDEFAULT_USER @"user"  //保存用户






#pragma mark -=================== XMPP ========================
#define kStringXMPPX                                @"x"
#define kStringXMPPXDelay                           @"jabber:x:delay"
#define kStringXMPPStamp                            @"stamp"
#define kStringXMPPTime                             @"time"

#define kStringXMPPElementIDRoster                  @"rosters"
#define kStringXMPPElementIDRoster4One              @"rstrone"
#define kStringXMPPElementIDRosterSet               @"rstrset"
#define kStringXMPPElementIDRosterGet               @"rstrget"
#define kStringXMPPElementIDGroups                  @"groups"
#define kStringXMPPElementIDChat                    @"chat"
#define kStringXMPPElementIDMembers                 @"members4grp"
#define kStringXMPPElementIDDeleteGroup             @"deleteGroup"
#define kStringXMPPElementIDDeleteGroupMember       @"deleteGroupMember"
#define kStringXMPPElementIDAddFriend               @"addFriend"         //请求添加好友
#define kStringXMPPElementIDAgreeAddFriend          @"agreeAddFriend"    //同意添加好友
#define kStringXMPPElementIDSearchAllGroups         @"searchAllGroups"   //搜索所有群
#define kStringXMPPElementIDGetPhotoHash            @"getPhotoHash"      //获取头像
#define kStringXMPPElementIDUpPhotoHash             @"upPhotoHash"       //上传头像
#define kStringXMPPElementIDRequestPid              @"jcl_54"            //请求Pid

//消息
#define kStringXMPPMessageType                      @"type"
#define kStringXMPPMessageNoticetype                @"noticetype"
#define kStringXMPPMessageNotify                    @"notify"
#define kStringXMPPMessageNotifyUserReplaced        @"sessionreplace"
#define kStringXMPPMessageTypeChat                  @"chat" //一对一聊天
#define kStringXMPPMessageTypeError                 @"error"//发送错误
#define kStringXMPPMessageTypeGroupChat             @"groupchat"
#define kStringXMPPMessageHeadline                  @"headline"
#define kStringXMPPMessageNormal                    @"normal"
#define kStringXMPPMessageConfirm                   @"confirm"
#define kStringXMPPMessageHashid                    @"hashid"

//查询
#define kStringXMPPIQ                               @"iq"
#define kStringXMPPIQQuery                          @"query"
#define kStringXMPPIQVCard                          @"vCard"
#define kStringXMPPIQPortrait                       @"PHOTO"
#define kStringXMPPIQItem                           @"item"
#define kStringXMPPIQItemAffiliation                @"affiliation"
#define kStringXMPPIQItemAffiliationMember          @"member"
#define kStringXMPPIQItemAffiliationAdministrator   @"admin"
#define kStringXMPPIQItemAffiliationOwner           @"owner"
#define kStringXMPPIQAccessAuth                     @"jabber:iq:access:auth"

#define kStringXMPPIQType                           @"type"
#define kStringXMPPIQTypeChat                       @"chat"
#define kStringXMPPIQTypeChatGroup                  @"groupchat"


#pragma mark ---群组--------
#define kImageNameGroupButtonBack                   @"左上角-应用图标-1@2x"
#define kImageNameGroupButtonBackSelected           @"左上角-应用图标-2@2x"
#define kImageNameGroupBadge                        @"新的提醒@2x"
#define kImageNameGroupIconGroup                    @"discussionGroup"
#define kImageNameGroupSegment                      @"群组底色块@2x"
#define kImageNameGroupSegmentSelected              @"群组底色块-选中@2x"
#define kImageNameGroupIconCrowd                    @"groupIcon"
#define kImageNameGroupIconshuxing                  @"group_shuxing"

#pragma mark ---群成员列表--------
#define kImageNameMemberViewAdministrator           @"admin"
#define kImageNameMemberViewCreator                 @"creator"

#define kStringXMPPIQTypeGet                        @"get"
//test20150911
#define kStringXMPPIQTypeSet                        @"set"
#define kStringXMPPIQTypeResult                     @"result"
#define kStringXMPPIQTypeError                      @"error"


#define kStringXMPPPresenceList                     @"list"


#define kStringXMPPIQSubscription                   @"subscription"
#define kStringXMPPIQSubscriptionNone               @"none"
#define kStringXMPPIQSubscriptionTo                 @"to"
#define kStringXMPPIQSubscriptionFrom               @"from"
#define kStringXMPPIQSubscriptionBoth               @"both"

//在线状态
#define kStringXMPPPresence                         @"presence"
#define kStringXMPPPresenceSubscribed               @"subscribed"
#define kStringXMPPPresenceUnsubscribed             @"unsubscribed"
#define kStringXMPPPresenceAvailable                @"available"
#define kStringXMPPPresenceUnavailable              @"unavailable"
#define kStringXMPPPresenceShow                     @"show"
#define kStringXMPPPresenceShowAway                 @"away"
#define kStringXMPPPresenceShowChat                 @"chat"
#define kStringXMPPPresenceShowDontDisturb          @"dnd"
#define kStringXMPPPresenceShowAwayForALongTime     @"xa"
#define kStringXMPPPresenceStatus                   @"status"
#define kStringXMPPPresencePriority                 @"priority"
#define kStringXMPPPresenceType                     @"type"
#define kStringXMPPPresenceTypeState                @"state"
#define kStringXMPPPresenceTypeSubscribe            @"subscribe"      //订阅
#define kStringXMPPPresenceTypeUnsubscribed         @"unsubscribed"
#define kStringXMPPPresenceGroupType                @"ctype"
#define kStringXMPPPresenceGroupTypeEnter           @"enter"

//公共
#define kStringXMPPPicture                          @"picture"
#define kStringXMPPVoice                            @"voice"
#define kStringXMPPDuration                         @"duration"
#define kStringXMPPLocation                         @"location"
#define kStringXMPPWiseucoffline                    @"wiseucoffline"
#define kStringXMPPFile                             @"file"
#define kStringXMPPSubject                          @"subject"
#define kStringXMPPBody                             @"body"
#define kStringXMPPMessage                          @"message"
#define kStringXMPPTo                               @"to"
#define kStringXMPPFrom                             @"from"
#define kStringXMPPVersion                          @"ver"
#define kStringXMPPID                               @"id"
#define kStringXMPPVariable                         @"var"
#define kStringXMPPVariableSelf                     @"self"
#define kStringXMPPConference                       @"conference"
#define kStringXMPPSeccessed                        @"successed"
#define kStringXMPPUID                              @"UID"
#define kStringXMPPInvitation                       @"Invitation"
#define kStringXMPPAdress                           @"address"
#define kStringXMPPLatitude                         @"latitude"
#define kStringXMPPLongitude                        @"longitude"
#define kStringXMPPName                             @"name"

#define kStringXMPPXmlns                            @"xmlns"
#define kStringXMPPXmlnsJabberClient                @"jabber:client"
#define kStringXMPPXmlnsRoster                      @"jabber:iq:roster"
#define kStringXMPPXmlnsGroups                      @"jabber:iq:browse"
#define kStringXMPPXmlnsGroup                       @"http://jabber.org/protocol/disco#info"
#define kStringXMPPXmlnsGroupMembers                @"http://jabber.org/protocol/muc#user"

#define kStringXMPPRosterItem                       @"item"
#define kStringXMPPRosterGroup                      @"group"

#define kStringXMPPRosterDepartment                 @"department"
#define kStringXMPPRosterXmlns                      @"xmlns"
#define kStringXMPPRosterJabberId                   @"jid"
#define kStringXMPPRosterConferenceType             @"conferencetype"
#define kStringXMPPRosterDescription                @"introduction"
#define kStringXMPPRosterCategory                   @"category"
#define kStringXMPPRosterCategoryGroup              @"conference"
#define kStringXMPPRosterOwner                      @"owner"
#define kStringXMPPRosterPassword                   @"password"
#define kStringXMPPRosterType                       @"type"
#define kStringXMPPRosterSubject                    @"subject"
#define kStringXMPPRosterBulletin                   @"Description"
#define kStringXMPPRosterCreatedTime                @"CreateDate"
#define kStringXMPPRosterVCardVersion               @"vcardver"
#define kStringXMPPRosterGroup                      @"group"
#define kStringXMPPRosterUsername                   @"username"         //用户名
#define kStringXMPPRosterDepartment                 @"department"       //部门
#define kStringXMPPRosterCompany                    @"company"          //企业

#define kStringXMPPRosterGroupIdentity              @"identity"         //
#define kStringXMPPRosterGroupField                 @"field"            //
#define kStringXMPPRosterGroupFieldLabel            @"label"
#define kStringXMPPRosterGroupFieldValue            @"value"
#define kStringXMPPRosterGroupName                  @"name"
#define kStringXMPPRosterGroupDescription           @"Introduction"     //描述
#define kStringXMPPRotserGroupSubject               @"Subject"          //主题
#define kStringXMPPRosterGroupPersistent            @"Persistent"       //是否是群，不是永久的是讨论组

#define kStringXMPPRosterCountry                    @"COUNTRY"          //国家
#define kStringXMPPRosterProvince                   @"REGION"           //省
#define kStringXMPPRosterCity                       @"LOCALITY"         //市区
#define kStringXMPPRosterStreet                     @"STREET"           //街道
#define kStringXMPPRosterPostCode                   @"PCODE"            //邮政编码

#define kStringXMPPRosterSignature                  @"PSIGN"            //个性签名
#define kStringXMPPRosterJobTitle                   @"TITLE"            //职位
#define kStringXMPPRosterName                       @"name"             //联系人.全名
#define kStringXMPPRosterNameFull                   @"FN"               //vCard.全名
#define kStringXMPPRosterNamePinYin                 @"pinYin"           //名字的拼音首字母
#define kStringXMPPRosterNameQuanPin                @"quanPin"          //名字的全拼
#define kStringXMPPRosterNameLogin                  @"LOGINNAME"        //登录名

#define kStringXMPPRosterNameNick                   @"NICKNAME"         //昵称
#define kStringXMPPRosterEmail                      @"EMAIL"            //邮箱
#define kStringXMPPRosterFax                        @"FAX"              //传真
#define kStringXMPPRosterPortrait                   @"PHOTOHASH"
#define kStringXMPPRosterMobile                     @"CELL"             //手机
#define kStringXMPPRosterMobileExt                  @"MOBILEEXT"        //短号
#define kStringXMPPRosterTelephone                  @"VOICE"            //工作电话
#define kStringXMPPRosterBirthday                   @"BDAY"             //生日
#define kStringXMPPRosterJobDescription             @"TITLEDESC"        //职位描述
#define kStringXMPPRosterSex                        @"GENDER"           //性别
#define kStringXMPPRosterWebpage4Organization       @"WORKURL"          //所在企业的网址
#define kStringXMPPRosterWebpage4Personal           @"URL"              //个人主页
//企业信息
#define kStringXMPPRosterOrganization               @"ORG"              //企业节点
#define kStringXMPPRosterOrganizationName           @"ORGNAME"          //企业名称
#define kStringXMPPRosterOrganizationUNIT           @"ORGUNIT"          ///TODO:母鸡
#define kStringXMPPRosterOrganizationDescription    @"DESC"             //企业描述
#define kStringXMPPRosterOrganizationSignature      @"PSIGN"            ///TODO:母鸡
//地址信息
//解析用
#define kStringXMPPRosterAddresses                  @"ADR"              //地址,dictinary
#define kStringXMPPRosterAddressTypeHome            @"HOME"             //家庭地址
#define kStringXMPPRosterAddressTypeOrganization    @"WORK"             //工作地址

//显示用
#define kStringXMPPRosterAddressFull4Home           @"address4Home"     //家庭详细地址
#define kStringXMPRRosterAddressFull4Organization   @"address4Organization"     //工作地址
#define kStringXMPPRosterAddressType                @"addressType"    //电话类型，目前只有家庭和公司两种

//联系方式
//解析用
#define kStringXMPPRosterTelephones                 @"TEL"              //电话
#define kStringXMPPRosterTelephoneTypeWork          @"WORK"             //工作性质的
#define kStringXMPPRosterTelephoneTypeHome          @"HOME"             //家庭电话性质
#define kStringXMPPRosterTelephoneCell              @"CELL"             //区号
#define kStringXMPPRosterTelephoneNumber            @"NUMBER"           //工作电话号码

// 扩展消息
#define kStringXMPPEXTMessageProtocolid             @"protocolid"// 通知公告
#define kStringXMPPEXTMessageBroadcast              @"broadcast"//
#define kStringXMPPEXTMessageVoting                 @"voting"// 电子投票
#define kStringXMPPEXTMessageApprove                @"approve"// 审批

#pragma mark --------------------文件路径-------------------------
#define kStringSeparatorString4User                 @"<#@.@#>"

#define kDirectoryDocuments                         [[WQCache sharedCache] pathFor:WQCachePathDirectoryDocuments]
#define kDirectoryDocumentsUsers                    [kDirectoryDocuments stringByAppendingPathComponent:@"users"]
#define kFileOfLatestUser                           [kDirectoryDocuments stringByAppendingPathComponent:@"lastestuser.info"]

#define kDirectoryCaches                            [[WQCache sharedCache] pathFor:WQCachePathDirectoryCaches]
#define kDirectoryCachesVcards                      [kDirectoryCaches stringByAppendingPathComponent:@"vcards"]
#define kDirectoryCachesOrganizations               [kDirectoryCaches stringByAppendingPathComponent:@"organizations"]
#define kDirectoryCachesGroups                      [kDirectoryCaches stringByAppendingPathComponent:@"groups"]
#define kDirectoryCachesRoster                      [kDirectoryCaches stringByAppendingPathComponent:@"roster"]

#define kDirectoryCachesOthers                      [[WQCache sharedCache] pathFor:WQCachePathDirectoryCachesOthers]
#define kDirectoryKeywords                          [kDirectoryCachesOthers stringByAppendingPathComponent:@"keywords"]

#define kDirectoryOuttimed                          [kDirectoryCachesOthers stringByAppendingPathComponent:@"outtimed"]

#define kFileNameContactsDepartment                 [[[WQCache sharedCache] pathFor:WQCachePathDirectoryCachesOthers] stringByAppendingPathComponent:@"department.contact"]
#define kFileNameGroupMembers                       @"groupmembers"


#define kFileNameLoginInfo                          @"login.info"
#define kFileNameSessionInfo                        @"session.info"
#define kFileNameSqliteMessage                      @"message.sqlite"
#define kFileNameGroupsInfo                         @"groups.info"
#define kFileNameRosterInfo                         @"roster.info"
#define kFileNameOrganizationsInfo                  @"organizations.info"
#define kFileNameOrganizationsPermissionInfo        @"organizations-permission.info"
#define kFileNameOrganizationsSimplifiedInfo4Person         @"organizations-simple-person.info"
#define kFileNameOrganizationsSimplifiedInfo4Organization   @"organizations-simple-organization.info"

#define kDirectoryNameSessions                      @"sessions"
#define kDirectoryNameMessages                      @"messages"

#pragma mark --------------------soap请求-------------------------
#define kActionGetJabberId                          @"getjid"
#define kActionGetLogCfg                            @"readcfg"
#define kActionGetOrgTree                           @"getorg"
#define kActionGetPermission                        @"getDept"
#define kActionGetAppleVer                          @"GetAppleVer"

// 应用程序托管
#define AppDelegateInstance                         ((AppDelegate*)([UIApplication sharedApplication].delegate))

#pragma mark 用户
#define kUserId                                     @"id"               //用户id
#define kUserUsername                               @"username"         //用户名
#define kUserNickname                               @"nickname"         //昵称
#define kUserDomain                                 @"domain"           //用户http访问的域名，包括端口
#define kUserPasswordForLog                         @"password"         //密码
#define kUserHostForLog                             @"ip"               //登录用的服务器ip
#define kUserPortForLog                             @"port"             //登录用的端口
#define kUserAccountID                              @"AccountID"        //账号id
#define kUserPortrait                               @"portrait"         //用户头像
#define kUserJid                                    @"JID"              //通信id
#define kUserPid                                    @"PID"              //父id
#define kUserPasswordForIM                          @"IMPassword"       //通信密码
#define kUserHostForIM                              @"Host"             //通信处理服务器
#define kUserVersionRoster                          @"versionRoster"    //花名册版本
#define kUserVersionOrganizations                   @"versionOrganization"  //组织架构版本
#define kUserVersionGroups                          @"versionGroups"    //群组版本
#define kStringCountOfMessages                      @"countOfMessages"

//判断系统版本
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define IS_OS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IS_OS_9_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#define IS_OS_10_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)
//判断是否大于 IOS7
#define IS_IOS7 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")
//判断是否大于 IOS8
#define IS_IOS8  ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)
#define IS_IOS10 ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0)


//判断是否是iphone5
#define IS_WIDESCREEN                              ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - (double)568 ) < __DBL_EPSILON__ )

#define IS_IPHONE                                  ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPhone" ] || [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPhone Simulator" ])
#define IS_IPOD                                    ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPod touch" ] )
#define IS_IPAD                                  ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPad" ] || [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPad Simulator" ])
//#define IS_IPHONE_5                                ( IS_IPHONE && IS_WIDESCREEN )
//#define IS_IPAD2 (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//#define IS_IPOD  [UIDevice currentDevice]



#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))


#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5  (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6  (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_6_OR_LATER  (IS_IPHONE && SCREEN_MAX_LENGTH >= 667.0)



//判断字符串是否为空
#define IFISNIL(v)                                 (v = (v != nil) ? v : @"")
//判断NSNumber是否为空
#define IFISNILFORNUMBER(v)                        (v = (v != nil) ? v : [NSNumber numberWithInt:0])
//判断是否是字符串
#define IFISSTR(v)                                 (v = ([v isKindOfClass:[NSString class]]) ? v : [NSString stringWithFormat:@"%@",v])


//全局唯一的window
#define KEY_WINDOW  [[UIApplication sharedApplication] keyWindow]

//动态获取设备高度
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#define IPHONE_HEIGHT [UIScreen mainScreen].bounds.size.height
#define IPHONE_WIDTH [UIScreen mainScreen].bounds.size.width

//抽屉左滑边距
#define LeftDrawerWidth 75


#pragma mark - =================== 颜色 ========================

//设置颜色
#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//设置颜色与透明度
#define HEXCOLORAL(rgbValue, al) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:al]

#define COMMENT_COLOR [UIColor colorWithRed:69/255.f green:161/255.f blue:193/255.f alpha:1.0f]

#define THEAM_COLOR [UIColor colorWithRed:56/255.f green:155/255.f blue:62/255.f alpha:1.0f]

#define DarkGreenShemeColor HEXCOLOR(0x107d22)
#define DarkBlueShemeColor HEXCOLOR(0x154d98)
//导航栏主题颜色
#define navbarColor  [UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:0.9f]
//leftside 主题颜色
#define kLeftSideColor  HEXCOLOR(0xF2F2F2)



#pragma mark - =================== 文件路径 ========================

#pragma  mark  --语音文件路径
#define kVoiceFilePath   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingString:@"/wiseuc/Voice"]

#pragma  mark  --图片文件路径
#define kPictureFilePath   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingString:@"/wiseuc/Pictures"]

#pragma  mark  --文件路径
#define kFilePath   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingString:@"/wiseuc/File"]

#pragma  mark  --数据库路径
#define kSqlitePath   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingString:@"/wiseuc/WiseucSqlite"]

#pragma  mark  --头像缓存路径
#define kHeadPicture   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingString:@"/wiseuc/HeadPicture"]

#pragma  mark  --组织架构文件路径
#define kOrgFilePath   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingString:@"/wiseuc/OrgFilePath"]

#pragma  mark  --ftp配置文件路径
#define kFtpConfigFile   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingString:@"/wiseuc/FtpConfigFile"]

#pragma  mark  --消息漫游文件
#define kRoamingMsgCacheFile   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingString:@"/wiseuc/RoamingMsgCacheFile/RoamingMsgCacheFile.plist"]


#pragma  mark  --wiseucSeting.Inf软件配置文件路径
#define kWiseucSettingPath   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingString:@"/wiseuc/wiseucSetting"]


#pragma mark –-


#pragma mark - =================== 网站 ========================
#define Wiseuc_Web_OfficialWebsite @"http://www.wiseuc.com" //官网
#define Wiseuc_Web_ProductDescription @"http://www.wiseuc.com/product.php" //产品说明
#define Wiseuc_Web_ProductFunctionDescription @"http://www.wiseuc.com/product_D.php" //功能介绍
#define Wiseuc_Web_Help @"http://www.wiseuc.com/helpcenter.php" //帮助


#pragma mark - =================== 共享 ========================

#define kOffline_Offices @"Offline_Offices"
#define kOffline_Groups @"offline_Groups"
#define kOffline_Rosters @"offline_Rosters"
#define kOffline_CurrentUser @"offline_CurrentUser"     //当前用户信息
#define kKEYCODE @"gzRN53VWRF9BYUXo"
#define Wiseuc_SingleChatHeadPicture  @"singleChat_online"









/**
 高德地图 key
 
 *汇讯企业版5cc9fc11d4e990859d20a10c4d2549c1
 *智会一点通baee87b87999f0bfa4370045d1c2de6b
 *汇讯国际版9ed2325dd9a556940cab7fe72afbe572
 *易支付7853ef224dcf0a0234d92d26b0aa4939
 */
#define AMapAPIKey  @"5cc9fc11d4e990859d20a10c4d2549c1"




#pragma mark ======================Linphone======================

#define kLinphone_TalkEnd              @"Linphone_TalkEnd"               //通话结束
#define kLinphone_SIPServiceRegisted   @"Linphone_SIPServiceRegister"    //是否注册
#define kNotification_GetAPNsToken     @"Notification_GetAPNsToken"      // 获取到了apnsToken
#define kNotification_GetVoIPToken     @"Notification_GetVoIPToken"      // 获取到了voipToken

#define LINPHONE_OTHERUSER_KEY_PID     @"otherUser_pid"                  // 对方pid
#define LINPHONE_USER_KEY_PID          @"user_pid"                       // 本人pid
#define LINPHONE_PASSWORD              @"666666"                         // 用户密码  123456
#define LINPHONE_TRANSPORT             @"tcp"                            // 连接方式  tcp
#define LINPHONE_AUTOREPLY             @"【快速回复】对不起！我现在正忙，稍后给您回信。"            // 自动回信内容
#define LINPHONE_STATE_SENDING         @"正在发送"
#define LINPHONE_STATE_SENDSUCCESS     @"发送成功"
#define LINPHONE_STATE_WAIT            @"等待对方接听"

#define kApi_KeyCode                   @"gzRN53VWRF9BYUXo"
//#define kApi_ServerIp                  @"192.168.1.168" //   @"demo.wiseuc.com:25060"

