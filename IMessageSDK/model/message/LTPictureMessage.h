//
//  LTPictureMessage.h
//  IMessageSDK
//
//  Created by JH on 2018/1/5.
//  Copyright © 2018年 JiangHai. All rights reserved.
//

#import "Message.h"
#import <UIKit/UIKit.h>

@interface LTPictureMessage : Message


/*!
 @method
 @abstract 将图片写入本地沙盒
 @discussion <#备注#>
 @param aImage 图片
 @param complete 完成回调
 */
+ (void)saveImageToLocal:(UIImage *)aImage
                complete:(void(^)(BOOL finished,NSString *localPath))complete;

@end
