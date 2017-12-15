//
//  OrgManager.m
//  一点通
//
//  Created by Admin on 2017/4/27.
//  Copyright © 2017年 WiseUC. All rights reserved.
//

#import "OrgManager.h"
#import "LTHttpTool.h"
#import "LTAFNetworkManager.h"
//#import "UserManager.h"
#import "Encrypt_Decipher.h"
#import "LT_Macros.h"
#import "LT_SSZipArchive.h"

#define kLOGIN_FORMAT_URL @"http://%@:14132/admin/user/login?wiseuc=%@"
@implementation OrgManager
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
                          completed:(OrgManagerDownloadBlock)aDownloadBlock {

    [OrgManager clearOrgFile];
    NSString *orgDownloadURL = [self getOrgZipDownloadURL:isNeedLocalVersion];
    NSURL *url = [NSURL URLWithString:orgDownloadURL];
    
    // /var/mobile/Containers/Data/Application/46D9DF36-957D-419B-9E37-A6972F64E09D/Documents/wiseuc/OrgFilePath/Organize.zip
    //"/var/mobile/Containers/Data/Application/9ED4DF4B-231C-40CE-96F1-85BE614BB68A/Documents//wiseuc/organizeOrganize.zip"
    NSString *savePath = [kOrgFilePath stringByAppendingPathComponent:@"Organize.zip"];
    HttpTool *httpTool = [[HttpTool alloc] init];
    NSLog(@"组织架构保存地址：\n%@",savePath);
    NSLog(@"组织架构下载地址：\n%@",url);
    
    
    [httpTool downLoadFromURL:url savePath:savePath progressBlock:nil completion:^(id data, NSError *error) {
        if (error)
        {
            LTError *error = [LTError errorWithDescription:@"下载组织架构失败" code:(LTErrorLogin_OrgDownloadFailure)];
            aDownloadBlock(error);
        }else {
            /**解压**/
            BOOL ret = [SSZipArchive unzipFileAtPath:savePath toDestination:kOrgFilePath];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ( [fileManager fileExistsAtPath:savePath] ){
                [fileManager removeItemAtPath:savePath error:nil];
            }
            aDownloadBlock(nil);
        }
    }];
}





+ (void)downloadAndParserOrgZipWithLocalOrgVersion:(BOOL)needLocalOrgVersion completeHandler:(OrgCompleteHandler)complete
{
    [OrgManager clearOrgFile];
    
    NSString *orgDownloadURL = [self getOrgZipDownloadURL:needLocalOrgVersion];
    NSURL *url = [NSURL URLWithString:orgDownloadURL];
    
    // /var/mobile/Containers/Data/Application/46D9DF36-957D-419B-9E37-A6972F64E09D/Documents/wiseuc/OrgFilePath/Organize.zip
    //"/var/mobile/Containers/Data/Application/9ED4DF4B-231C-40CE-96F1-85BE614BB68A/Documents//wiseuc/organizeOrganize.zip"
    NSString *savePath = [kOrgFilePath stringByAppendingPathComponent:@"Organize.zip"];
    HttpTool *httpTool = [[HttpTool alloc] init];
    
    ///var/mobile/Containers/Data/Application/D9458423-BCB5-4E98-A5CD-71CAF9E19016/Documents/wiseuc/OrgFilePath/Organize.zip
//    JIANGHAI_LOG(@"%@",savePath);
//    JIANGHAI_LOG(@"%@",url);
    
    
    [httpTool downLoadFromURL:url savePath:savePath progressBlock:nil completion:^(id data, NSError *error) {
        
        if ( data ) {
            
            //  解压
//            BOOL ret = [SSZipArchive unzipFileAtPath:savePath toDestination:kOrgFilePath];
//            NSFileManager *fileManager = [NSFileManager defaultManager];
//            if ( [fileManager fileExistsAtPath:savePath] ){
//                [fileManager removeItemAtPath:savePath error:nil];
//            }
//            
//            if (complete) {
//                complete(ret);
//            }
        }
        else {
            if (complete) {
                complete(NO);
            }
        }
    }];
}

+ (BOOL)clearOrgFile
{
    NSString *orgXmlFilePath = [kOrgFilePath stringByAppendingPathComponent:@"Organize.xml"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ( [fileManager fileExistsAtPath:orgXmlFilePath] ){
        return [fileManager removeItemAtPath:orgXmlFilePath error:nil];
    }
    return YES;
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
