//
//  UploadFile.m
//  02.Post上传
//
//  Created by apple on 14-4-29.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "LTUploadFile2.h"
#import "Encrypt_Decipher.h"

@interface UploadFile2()<NSURLSessionTaskDelegate>{
    
    //下载
    UploadFile2HttpToolProgressBlock _dowloadProgressBlock;
    UploadFile2HttpToolCompletionBlock _downladCompletionBlock;
    NSURL *_downloadURL;
    
    
    //上传
    UploadFile2HttpToolProgressBlock _uploadProgressBlock;
    UploadFile2HttpToolCompletionBlock _uploadCompletionBlock;
    
}
@end

@implementation UploadFile2

#pragma mark - 私有方法

- (NSString *)generateBoundaryString
{
    return [NSString stringWithFormat:@"Boundary-%@", [[NSUUID UUID] UUIDString]];
}

- (NSData *)createBodyWithBoundary:(NSString *)boundary
                        parameters:(NSDictionary *)parameters
                          fileData:(NSData *)fileData
                      withFileName:(NSString *)imgSHA1Name
                         fieldName:(NSString *)fieldName
                 requireEncryption:(BOOL)requireEncryption
{
    NSMutableData *httpBody = [NSMutableData data];
    
    // add params (all params are strings)
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    NSData   *data      = fileData;
    NSString *mimetype  = @"image/jpeg";
    [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldName, imgSHA1Name] dataUsingEncoding:NSUTF8StringEncoding]];
    [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimetype] dataUsingEncoding:NSUTF8StringEncoding]];
    [httpBody appendData:data];
    
    //图片上传加密
    if ( requireEncryption ) {
//        [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[self encodingFileName:imgSHA1Name] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return httpBody;
}

- (NSString *)encodingFileName:(NSString *)fileName
{
    NSString *imageNameEncoding  = [Base64 encodeWithString:fileName];
    imageNameEncoding = [imageNameEncoding stringByAppendingString:@"wisucuppicture"];
    imageNameEncoding = [[imageNameEncoding md5] lowercaseString];
    return imageNameEncoding;
}

#pragma mark - 上传文件
- (void)FORM_UploadImgFile:(NSData *)imgData
              withFileName:(NSString *)imgSHA1Name
        targetServerURL:(NSString *)serverURL
      requireEncryption:(BOOL)requireEncryption
          progressBlock:(UploadFile2HttpToolProgressBlock)progressBlock
             completion:(UploadFile2HttpToolCompletionBlock)completionBlock
{
    NSURL *url = [NSURL URLWithString:serverURL];
    _uploadCompletionBlock = completionBlock;
    _uploadProgressBlock = progressBlock;
    
    NSDictionary *params = @{@"userName"     : @"rob",
                             @"userEmail"    : @"rob@email.com",
                             @"userPassword" : @"password"};
    
    NSString *boundary = [self generateBoundaryString];
    
    // configure the request
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    // set content type
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    
    NSData *httpBody = [self createBodyWithBoundary:boundary
                                         parameters:params
                                           fileData:imgData
                                       withFileName:imgSHA1Name
                                          fieldName:@"uploadFile"
                                  requireEncryption:requireEncryption];
    [request setHTTPBody:httpBody];
    
    // 3> 连接服务器发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (_uploadCompletionBlock) {
            _uploadCompletionBlock(request);
            
            _uploadProgressBlock = nil;
            _uploadCompletionBlock = nil;
        }
    }];

}

- (NSString *)upPictureBottomStringFileNameEncoding:(NSString *)fileName
{
    //    NSData * dataBase64Encoding = [data base64EncodedDataWithOptions:NSDataWritingAtomic];
    NSString *imageNameEncoding = nil;
    NSString *imageNameString = fileName;
    imageNameEncoding = [Base64 encodeWithString:imageNameString];
    NSMutableString *imageNameMutableString = [NSMutableString stringWithString:imageNameEncoding];
    imageNameEncoding = [imageNameMutableString stringByAppendingString:@"wisucuppicture"];
    //给文件名加密
    imageNameEncoding = [[imageNameEncoding md5] lowercaseString];
    return imageNameEncoding;
}

@end
