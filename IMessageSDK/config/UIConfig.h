//
//  UIConfig.h
//  IMessageSDK
//
//  Created by JH on 2017/12/13.
//  Copyright © 2017年 JiangHai. All rights reserved.
//


#import "AppDelegate.h"

//全局唯一的window
#define KEY_WINDOW  [[UIApplication sharedApplication] keyWindow]
//动态获取设备高度
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
//抽屉左滑边距
#define LeftDrawerWidth 75








#pragma mark - =================== 颜色 ========================

//设置颜色
#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//设置颜色与透明度
#define HEXCOLORAL(rgbValue, al) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:al]
#define COMMENT_COLOR [UIColor colorWithRed:69/255.f green:161/255.f blue:193/255.f alpha:1.0f]
#define THEAM_COLOR [UIColor colorWithRed:56/255.f green:155/255.f blue:62/255.f alpha:1.0f]
/**深绿色**/
#define kDarkGreenColor HEXCOLOR(0x107d22)
/**深蓝色**/
#define kDarkBlueColor HEXCOLOR(0x154d98)
//导航栏主题颜色
#define navbarColor  [UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:0.9f]
//主题颜色
#define kTintColor  HEXCOLOR(0x00d00d)
/**浅灰色背景颜色**/
#define kBackgroundColor  [UIColor colorWithRed:235/255.f green:235/255.f blue:235/255.f alpha:1]




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



// 应用程序托管
#define kAppDelegate   ((AppDelegate*)([UIApplication sharedApplication].delegate))
#define kMainVC        (kAppDelegate.mainvc)






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

