//
//  AddRGContactModel.h
//  IMessageSDK
//
//  Created by JH on 2018/1/15.
//  Copyright © 2018年 JiangHai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddRGContactModel : NSObject
/**用户名**/
@property (nonatomic, strong) NSString *username;

/**手机号**/
@property (nonatomic, strong) NSArray *phoneNumbers;
@end
