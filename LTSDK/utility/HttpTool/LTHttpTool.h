//
//  HttpTool.h
//  02-文件上传下载工具抽取
//
//  Created by Vincent_Guo on 14-6-9.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ProgressBlock)(float progress);
typedef void (^CompletionBlock)(id data, NSError *error);
//typedef void (^HttpToolCompletedBlock)(id data, NSError *error);

@interface HttpTool : NSObject

/*!
 @method
 @brief 表单上传
 @param localPath 准备上传文件的地址
 @param serverURL 服务器地址
 @param requireEncryption 是否需要加密
 @param progressBlock 进度回调
 @param completionBlock 结果回调
*/
- (void)FORM_UploadFile:(NSString *)localPath
        targetServerURL:(NSString *)serverURL
      requireEncryption:(BOOL)requireEncryption
          progressBlock:(ProgressBlock)progressBlock
             completion:(CompletionBlock)completionBlock;


/**
 下载数据
 */
- (void)downLoadFromURL:(NSURL *)url
              savePath:(NSString *)savePath
         progressBlock:(ProgressBlock)progressBlock
            completion:(CompletionBlock) completionBlock;

// 取消当前任务
- (void)cancel;




/**
 *GET请求：
 *
 *
 */
+(void)httptool_GET:(NSString *)urlstring
          paramters:(NSDictionary *)paramters
          completed:(CompletionBlock)block;



/**
 *POST请求：
 *
 *
 */
+(void)httptool_POST:(NSString *)urlstring
           paramters:(NSDictionary *)paramters
           completed:(CompletionBlock)block;
@end
