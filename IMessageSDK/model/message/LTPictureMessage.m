//
//  LTPictureMessage.m
//  IMessageSDK
//
//  Created by JH on 2018/1/5.
//  Copyright © 2018年 JiangHai. All rights reserved.
//

/**
 chat:
 
 <message
 xmlns="jabber:client"
 id="11673D749687483595F191397C2652E7"
 to="江海@duowin-server/IphoneIM"
 from="萧凡宇@duowin-server/IphoneIM"
 type="chat"
 UID="EFED945C81A643D4B1C69966F8494B0D"
 >
 
 <body>&lt;i@AD3E94689069470C8CD3D8AB9FE3B476.jpg&gt;</body>
 </message>
 
 
 groupchat:
 
 <message
 xmlns="jabber:client"
 id="8FDB29486B844F209ABD379C69770844"
 to="江海@duowin-server/IphoneIM"
 SenderJID="萧凡宇@duowin-server/IphoneIM"
 type="groupchat"
 UID="064B6804435B4DC4B7E734762A4E139D"
 from="447606038fe8402ea3e87bd108183228@conference.duowin-server/萧凡宇"
 name="他她不"
 >
 
 <body>&lt;i@2E9564492A0E4815BE9F07D973E8BFBB.jpg&gt;</body>
 <x xmlns="jabber:x:delay" from="447606038fe8402ea3e87bd108183228@conference.duowin-server" stamp="20180105T09:23:26"></x>
 </message>

 **/

#import "LTPictureMessage.h"

#import "UIConfig.h"
#import "AppUtility.h"

@implementation LTPictureMessage




#pragma mark - public

+ (void)saveImageToLocal:(UIImage *)aImage
           isCompression:(BOOL)isCompression
                complete:(void(^)(BOOL finished,NSString *localPath))complete {
    NSString *imageName = [AppUtility get_32Bytes_UUID];
    NSString *imageType = @"jpg";
    NSString *imagePath =
    [NSString stringWithFormat:@"%@/%@.%@",kPictureFilePath,imageName,imageType];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (  ![fileManager fileExistsAtPath:kPictureFilePath] ) {
        [fileManager createDirectoryAtPath:kPictureFilePath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
    }
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //FIXME: 压缩图片尺寸
        CGFloat targetWidth = 540;
        UIImage *zigImage = nil;
        if (isCompression) {
            zigImage = [weakSelf imageCompressForWidth:aImage targetWidth:targetWidth];
        }else{
            zigImage = aImage;
        }
        
        // 图片保存到本地
        NSData *data = UIImageJPEGRepresentation(zigImage, 0.7f);
        // [data writeToFile:imagePath atomically:YES];
        BOOL zigResult = [fileManager createFileAtPath:imagePath contents:data attributes:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (zigResult) {
                complete(zigResult,imagePath);
            }
        });
    });
}

// 给定目标宽度按比例压缩图片
+ (UIImage *) imageCompressForWidth:(UIImage *)sourceImage
                        targetWidth:(CGFloat)defineWidth {
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth, targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



@end
