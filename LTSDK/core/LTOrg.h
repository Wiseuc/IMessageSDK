//
//  LTOrg.h
//  WiseUC
//
//  Created by JH on 2017/12/6.
//  Copyright © 2017年 WiseUC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTSDKFull.h"
#import "LT_GDataXMLNode.h"

typedef void(^LTOrg_downloadOrgBlock)(GDataXMLDocument *doc, LTError *error);
@interface LTOrg : NSObject




/*!
 @method
 @abstract 初始化
 @discussion null
 @result  登陆管理类
 */
+ (instancetype)share;



/*!
 @method
 @abstract 下载组织架构
 @discussion 再次下载，旧数据会被覆盖，回调返回Document
 */
- (void)downloadOrg:(LTOrg_downloadOrgBlock)downloadOrgBlock;






/*!
 @method
 @abstract 更新个人在组织架构中的信息
 @discussion null
 */
-(void)updateOrgWithID:(NSString *)ID
             LoginName:(NSString *)LoginName
                   PID:(NSString *)PID
              ITEMTYPE:(NSString *)ITEMTYPE
                  NAME:(NSString *)NAME

                   JID:(NSString *)JID
                  NICK:(NSString *)NICK
                MOBILE:(NSString *)MOBILE
                  TELE:(NSString *)TELE
                TelExt:(NSString *)TelExt

                MOBEXT:(NSString *)MOBEXT
                 EMAIL:(NSString *)EMAIL
                 title:(NSString *)title
                   sex:(NSString *)sex
                leader:(NSString *)leader

                indexs:(NSString *)indexs;



/*!
 @method
 @abstract 查询组织架构
 @discussion null
 @result  字典
 */
- (NSDictionary *)queryOrg;
    
    

/*!
 @method
 @abstract 删除组织架构
 @discussion null
 */
- (void)deleteOrg;







/**获取组织架构可见范围**/
- (NSArray *)queryOrgVisibleRange ;





@end
