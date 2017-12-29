//
//  LT_OrgManager.m
//  一点通
//
//  Created by Admin on 2017/4/27.
//  Copyright © 2017年 WiseUC. All rights reserved.
//

#import "LT_OrgManager.h"
#import "LTHttpTool.h"
#import "LTAFNetworkManager.h"
//#import "UserManager.h"
#import "Encrypt_Decipher.h"
#import "LT_Macros.h"
#import "LT_SSZipArchive.h"
#import "LT_GDataXMLNode.h"

#define kLOGIN_FORMAT_URL @"http://%@:14132/admin/user/login?wiseuc=%@"
@implementation LT_OrgManager
+ (void)getOrgVisibleRange:(OrgVisibleRangeBlock)orgVisibleRangeBlock
{
    NSString *orgVisibleRangeURL = [self getOrgVisibleRangeURL];
    [[AFNetworkManager new] getRequestWithURL:orgVisibleRangeURL andParameter:nil whenSuccess:^(id responseObject) {
        
        NSDictionary *orgVisibleDict = responseObject[@"9"];
        BOOL hasOrgVisibleRange = [orgVisibleDict[@"RangeId"] integerValue] > 1 ? YES : NO;
        NSArray *orgVisibleRangeArray = orgVisibleDict[@"deptId"];
        if ( hasOrgVisibleRange ) {
            if ( orgVisibleRangeBlock ) {
                orgVisibleRangeBlock(YES, orgVisibleRangeArray);
            }
        }
        else {
            if ( orgVisibleRangeBlock ) {
                orgVisibleRangeBlock(NO, nil);
            }
        }
        
    } orFail:^(NSError *error) {
        if ( orgVisibleRangeBlock ) {
            orgVisibleRangeBlock(NO, nil);
        }
    }];
}



+ (void)downloadOrgWithlocalVersion:(BOOL)isNeedLocalVersion
                          completed:(LT_OrgManagerDownloadBlock)aDownloadBlock {

    [LT_OrgManager clearOrgFile];
    NSString *orgDownloadURL = [self getOrgZipDownloadURL:isNeedLocalVersion];
    NSURL *url = [NSURL URLWithString:orgDownloadURL];
    
    // /var/mobile/Containers/Data/Application/46D9DF36-957D-419B-9E37-A6972F64E09D/Documents/wiseuc/OrgFilePath/Organize.zip
    //"/var/mobile/Containers/Data/Application/9ED4DF4B-231C-40CE-96F1-85BE614BB68A/Documents//wiseuc/organizeOrganize.zip"
    NSString *savePath = [kOrgFilePath stringByAppendingPathComponent:@"Organize.zip"];
    HttpTool *httpTool = [[HttpTool alloc] init];
    NSLog(@"组织架构保存地址：\n%@",savePath);
    NSLog(@"组织架构下载地址：\n%@",url);
    
    
    [httpTool downLoadFromURL:url
                     savePath:savePath
                progressBlock:nil
                   completion:^(id data, NSError *error) {
       
                       if (error)
                        {
                            LTError *error =
                            [LTError errorWithDescription:@"下载组织架构失败" code:(LTErrorLogin_OrgDownloadFailure)];
                            aDownloadBlock(error);
                        }else {
                            /**解压**/
                            BOOL ret = [SSZipArchive unzipFileAtPath:savePath toDestination:kOrgFilePath];
                            NSFileManager *fileManager = [NSFileManager defaultManager];
                            if ( [fileManager fileExistsAtPath:savePath] && ret){
                                [fileManager removeItemAtPath:savePath error:nil];
                            }
                            aDownloadBlock(nil);
                        }
                   }];
}





//+ (void)downloadAndParserOrgZipWithLocalOrgVersion:(BOOL)needLocalOrgVersion
//                                   completeHandler:(OrgCompleteHandler)complete {
//
//    [LT_OrgManager clearOrgFile];
//    NSString *orgDownloadURL = [self getOrgZipDownloadURL:needLocalOrgVersion];
//    NSURL *url = [NSURL URLWithString:orgDownloadURL];
//
//    // /var/mobile/Containers/Data/Application/46D9DF36-957D-419B-9E37-A6972F64E09D/Documents/wiseuc/OrgFilePath/Organize.zip
//    //"/var/mobile/Containers/Data/Application/9ED4DF4B-231C-40CE-96F1-85BE614BB68A/Documents//wiseuc/organizeOrganize.zip"
//    NSString *savePath = [kOrgFilePath stringByAppendingPathComponent:@"Organize.zip"];
//    HttpTool *httpTool = [[HttpTool alloc] init];
//
//    ///var/mobile/Containers/Data/Application/D9458423-BCB5-4E98-A5CD-71CAF9E19016/Documents/wiseuc/OrgFilePath/Organize.zip
////    JIANGHAI_LOG(@"%@",savePath);
////    JIANGHAI_LOG(@"%@",url);
//
//
//    [httpTool downLoadFromURL:url
//                     savePath:savePath
//                progressBlock:nil
//                   completion:^(id data, NSError *error) {
//
//                       if (error)
//                        {
//
//                        }else {
//                            /**解压**/
//                            NSFileManager *fileManager = [NSFileManager defaultManager];
//                            BOOL unzipRet = [SSZipArchive unzipFileAtPath:savePath toDestination:kOrgFilePath];
//                            BOOL fileExistRet = [fileManager fileExistsAtPath:savePath];
//                            if (unzipRet && fileExistRet) {
//                                [fileManager removeItemAtPath:savePath error:nil];
//                            }
//                        }
//                   }];
//}

+ (BOOL)clearOrgFile
{
    NSString *orgXmlFilePath = [kOrgFilePath stringByAppendingPathComponent:@"Organize.xml"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ( [fileManager fileExistsAtPath:orgXmlFilePath] ){
        return [fileManager removeItemAtPath:orgXmlFilePath error:nil];
    }
    return YES;
}






+ (NSDictionary *)queryInformationByJid:(NSString *)aJID
{
    if ( aJID.length == 0) {
        return nil;
    }
    /**获取doc**/
    GDataXMLDocument *xmlDoc = nil;
    NSString *orgFilePath = [kOrgFilePath stringByAppendingPathComponent:@"Organize.xml"];
    NSString *dataString = [NSString stringWithContentsOfFile:orgFilePath encoding:NSUTF8StringEncoding error:nil];
    xmlDoc = [[GDataXMLDocument alloc] initWithXMLString:dataString options:0 error:nil];
    
    
    GDataXMLElement *xmlEle = [xmlDoc rootElement];
    NSString *xpath = [NSString stringWithFormat:@"//JID[translate(@JID,'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')='%@']",[aJID lowercaseString]];
    
    
    NSRange rangeName = [aJID rangeOfString:@"@"];
    NSString *UserName = [aJID substringToIndex:rangeName.location];
    
    NSString *xpathByName = [NSString stringWithFormat:@"//JID[@NAME='%@']",UserName];//xpath通过名字查找需要的值
    
    
    /**
    <
     JID ID="45"
     LoginName="萧凡宇"
     PID="10805"
     ITEMTYPE="2"
     NAME="萧凡宇"
     
     JID="萧凡宇@duowin-server"
     NICK="哈哈"
     MOBILE="18617354209"
     TELE="908"
     TelExt=""
     
     MOBEXT="0"
     EMAIL="xiaofanyu@wiseuc.com"
     title="iOS开发"
     sex="男"
     leader="0"
     
     indexs="661
     >
     **/
    NSArray *array = [xmlEle nodesForXPath:xpath error:nil];
    NSArray *arrayByName = [xmlEle nodesForXPath:xpathByName error:nil];
    GDataXMLElement *ele;
    if (array.count) {
        //通过jid查找
        ele = array[0];
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        [dictionary setObject:[[ele attributeForName:@"JID"] stringValue] forKey:@"JID"];
        [dictionary setObject:[[ele attributeForName:@"LoginName"] stringValue] forKey:@"LoginName"];
        [dictionary setObject:[[ele attributeForName:@"PID"] stringValue] forKey:@"PID"];
        [dictionary setObject:[[ele attributeForName:@"ITEMTYPE"] stringValue] forKey:@"ITEMTYPE"];
        [dictionary setObject:[[ele attributeForName:@"NAME"] stringValue] forKey:@"NAME"];
        
        [dictionary setObject:[[ele attributeForName:@"JID"] stringValue] forKey:@"JID"];
        [dictionary setObject:[[ele attributeForName:@"NICK"] stringValue] forKey:@"NICK"];
        [dictionary setObject:[[ele attributeForName:@"MOBILE"] stringValue] forKey:@"MOBILE"];
        [dictionary setObject:[[ele attributeForName:@"TELE"] stringValue] forKey:@"TELE"];
        [dictionary setObject:[[ele attributeForName:@"TelExt"] stringValue] forKey:@"TelExt"];
        
        [dictionary setObject:[[ele attributeForName:@"MOBEXT"] stringValue] forKey:@"MOBEXT"];
        [dictionary setObject:[[ele attributeForName:@"EMAIL"] stringValue] forKey:@"EMAIL"];
        [dictionary setObject:[[ele attributeForName:@"title"] stringValue] forKey:@"title"];
        [dictionary setObject:[[ele attributeForName:@"sex"] stringValue] forKey:@"sex"];
        [dictionary setObject:[[ele attributeForName:@"leader"] stringValue] forKey:@"leader"];
        
        [dictionary setObject:[[ele attributeForName:@"indexs"] stringValue] forKey:@"indexs"];
        
        return dictionary;
    }
    else if (arrayByName.count)
    {
        //通过name查找
        ele = arrayByName[0];
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        [dictionary setObject:[[ele attributeForName:@"JID"] stringValue] forKey:@"JID"];
        [dictionary setObject:[[ele attributeForName:@"LoginName"] stringValue] forKey:@"LoginName"];
        [dictionary setObject:[[ele attributeForName:@"PID"] stringValue] forKey:@"PID"];
        [dictionary setObject:[[ele attributeForName:@"ITEMTYPE"] stringValue] forKey:@"ITEMTYPE"];
        [dictionary setObject:[[ele attributeForName:@"NAME"] stringValue] forKey:@"NAME"];
        
        [dictionary setObject:[[ele attributeForName:@"JID"] stringValue] forKey:@"JID"];
        [dictionary setObject:[[ele attributeForName:@"NICK"] stringValue] forKey:@"NICK"];
        [dictionary setObject:[[ele attributeForName:@"MOBILE"] stringValue] forKey:@"MOBILE"];
        [dictionary setObject:[[ele attributeForName:@"TELE"] stringValue] forKey:@"TELE"];
        [dictionary setObject:[[ele attributeForName:@"TelExt"] stringValue] forKey:@"TelExt"];
        
        [dictionary setObject:[[ele attributeForName:@"MOBEXT"] stringValue] forKey:@"MOBEXT"];
        [dictionary setObject:[[ele attributeForName:@"EMAIL"] stringValue] forKey:@"EMAIL"];
        [dictionary setObject:[[ele attributeForName:@"title"] stringValue] forKey:@"title"];
        [dictionary setObject:[[ele attributeForName:@"sex"] stringValue] forKey:@"sex"];
        [dictionary setObject:[[ele attributeForName:@"leader"] stringValue] forKey:@"leader"];
        
        [dictionary setObject:[[ele attributeForName:@"indexs"] stringValue] forKey:@"indexs"];
        return dictionary;
    }
    return nil;
}

















#pragma mark - private

/**组织架构可视范围URL**/
+ (NSString *)getOrgVisibleRangeURL
{
    NSString *action = @"getDept";
    return [self getEncodeOrgURL:action];
}

/**组织架构zip文件URL**/
+ (NSString *)getOrgZipDownloadURL:(BOOL)needLocalOrgVersion
{
    NSString *orgVersionString = @"0";
    if ( needLocalOrgVersion ) {
    }
    NSString *action = [NSString stringWithFormat:@"getzip&version=%@",orgVersionString];
    return [self getEncodeOrgURL:action];
}

+ (NSString *)getEncodeOrgURL:(NSString *)action
{
    NSDictionary  *userDict = [LTUser.share queryUser];
    NSString *UserName = userDict[@"UserName"];
    NSString *JID = userDict[@"JID"];
    NSString *IMPwd = userDict[@"IMPwd"];
    NSDictionary  *loginDict = [LTLogin.share queryLastLoginUser];
    NSString *aIP = loginDict[@"aIP"];
    
    NSString *kString = [NSString stringWithFormat:@"%@%@%@", UserName, IMPwd, kKEYCODE];
    NSString *key = [kString md5];
    //http://192.168.1.199:14132/admin/user/login?wiseuc=dXNlcm5hbWU95rGf5rW3Jms9MjU1NjE1MTMyMWMzOTI4N2VhNDJhN2RiYTVmNzc4Mjkmdj1kZDFkM2M4MDkxMDg1MGY1NzBmMjJiNWFjNDViMDFjYiZhY3Rpb249Z2V0emlwJnZlcnNpb249MCZjbGllbnQ9My4w

    NSString *safeCode = [key substringFromIndex:key.length-9];
    NSString *val = [[NSString stringWithFormat:@"%@%@%@", UserName, kKEYCODE, safeCode] md5];

    NSString *beforeStr = [NSString stringWithFormat:@"username=%@&k=%@&v=%@&action=%@&client=3.0",UserName, key, val, action];
    NSString *base64Str = [Base64 encodeWithString:beforeStr];
    NSString *lastStr = [base64Str URLEncode];
    NSString *result = [NSString stringWithFormat:kLOGIN_FORMAT_URL,aIP,lastStr];
    return result;
}

@end
