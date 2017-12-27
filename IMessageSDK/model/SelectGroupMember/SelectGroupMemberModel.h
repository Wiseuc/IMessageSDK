//
//  SelectGroupMemberModel.h
//  IMessageSDK
//
//  Created by JH on 2017/12/27.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectGroupMemberModel : NSObject
/**公共**/
@property (nonatomic, strong) NSString *ITEMTYPE;  /**1:SUBGROUP   2:JID**/
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *NAME;
@property (nonatomic, strong) NSString *PID;
@property (nonatomic, strong) NSString *indexs;
@property (nonatomic, strong) NSString *NAME_PINYIN; /**拼音**/





@property (nonatomic, strong) NSString *JID;
@end
