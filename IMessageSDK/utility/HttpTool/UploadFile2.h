//
//  UploadFile.h
//  02.Post上传
//
//  Created by apple on 14-4-29.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^UploadFile2HttpToolProgressBlock)(float progress);
typedef void (^UploadFile2HttpToolCompletionBlock)(NSString *data);

@interface UploadFile2 : NSObject

- (void)FORM_UploadImgFile:(NSData *)imgData
              withFileName:(NSString *)imgSHA1Name
           targetServerURL:(NSString *)serverURL
         requireEncryption:(BOOL)requireEncryption
             progressBlock:(UploadFile2HttpToolProgressBlock)progressBlock
                completion:(UploadFile2HttpToolCompletionBlock)completionBlock;

- (void)uploadFileWithURL:(NSURL *)url
                 fileName:(NSString *)fileName
                     data:(NSData *)data
            progressBlock:(UploadFile2HttpToolProgressBlock)progressBlock
               completion:(UploadFile2HttpToolCompletionBlock) completionBlock;

@end
