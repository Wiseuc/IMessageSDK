//
//  IniHelper.m
//  WiseUC
//
//  Created by 吴林峰 on 16/1/25.
//  Copyright © 2016年 WiseUC. All rights reserved.
//

#import "LTIniHelper.h"
#import "LTSimpleIni.h"
#import "Base64.h"
#import "LTSDKFull.h"

@implementation IniHelper

+ (NSDictionary *)parseIniFile:(NSString *)savePath pragram:(NSDictionary *)dict
{
    CSimpleIniA ini;
    ini.SetUnicode();
    ini.LoadFile([savePath UTF8String]);
    // 离线文件
    const char * cFileArkServerIP = ini.GetValue("OffFileServer", "OffFileServerIP");
    const char * cFileArkServerPort = ini.GetValue("OffFileServer", "OffFileServerPort");
    // 登录方式
    const char * cLDAPAuthEnable = ini.GetValue("LDAP", "LDAPAuthEnable");
    const char * cMD5Enable = ini.GetValue("MD5Login", "MD5Enable");
    
    //app审核期[check] os=linux
    const char * cOS          = ini.GetValue("check", "os");
    const char * cAppstate    = ini.GetValue("check", "appstate");
    
    // 消息漫游服务器
    const char * cMsgServerConnAddr = ini.GetValue("MsgServer", "connAddr");
    const char * cAckEnable = ini.GetValue("Global", "ackEnable");
    
    //是否配置了os 和 check
    [LTINF.share updateINFWithIsDeploy:NO];
    if (cOS != nil || cAppstate != nil) {
        [LTINF.share updateINFWithIsDeploy:YES];
    }
    
    
    
    NSString *FileArkServerIP   = @"";
    NSString *FileArkServerPort = @"";
    NSString *LDAPAuthEnable    = @"";
    NSString *MD5Enable         = @"";
    
    NSString *os                = @"";
    NSString *appstate          = @"";
    
    if (cFileArkServerIP && cFileArkServerPort && cLDAPAuthEnable && cMD5Enable) {
        FileArkServerIP   = [NSString stringWithCString:cFileArkServerIP encoding:NSUTF8StringEncoding];
        FileArkServerPort = [NSString stringWithCString:cFileArkServerPort encoding:NSUTF8StringEncoding];
        LDAPAuthEnable    = [NSString stringWithCString:cLDAPAuthEnable encoding:NSUTF8StringEncoding];
        MD5Enable         = [NSString stringWithCString:cMD5Enable encoding:NSUTF8StringEncoding];
    }
    if (cOS && cAppstate) {
        os         = [NSString stringWithCString:cOS encoding:NSUTF8StringEncoding];
        appstate   = [NSString stringWithCString:cAppstate encoding:NSUTF8StringEncoding];
    }

    
    NSString *ackEnable = @"0";
    if ( cAckEnable != NULL ) {
        ackEnable = [NSString stringWithCString:cAckEnable encoding:NSUTF8StringEncoding];
    }
    
    NSString *ftpURLServerConfig = [NSString stringWithFormat:@"%@:%@",FileArkServerIP,FileArkServerPort];
    NSMutableDictionary *mDict =
    [NSMutableDictionary dictionaryWithDictionary:@{kLDAPAuthEnable:@([LDAPAuthEnable boolValue]),
                                                    kMD5Enable:@([MD5Enable boolValue]),
                                                    kFtpURLServerConfig:ftpURLServerConfig,
                                                    kAckEnable:@([ackEnable boolValue]),
                                                    kOS:os,
                                                    kappstate:appstate,
                                                    }];
    
    if ( cMsgServerConnAddr )
    {
        NSString *MsgServerConnAddr = [NSString stringWithCString:cMsgServerConnAddr encoding:NSUTF8StringEncoding];
        MsgServerConnAddr = [Base64 decodeBase64String:MsgServerConnAddr];
        if ( [MsgServerConnAddr hasPrefix:@"tcp"] ) {
            [mDict setValue:MsgServerConnAddr forKey:kMsgServerConnAddr];
        }
    }
    
    return mDict;
}

@end
