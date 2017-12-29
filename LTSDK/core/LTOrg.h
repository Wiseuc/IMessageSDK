/*!
 @header
 @abstract 组织架构管理类
 @author 江海（JiangHai）
 @version v5.2.0
 */

#import <Foundation/Foundation.h>
#import "LTSDKFull.h"
@class GDataXMLDocument;

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
 @abstract 获取组织架构可见范围
 @discussion <#备注#>
 @result  数组
 */
- (NSArray *)queryOrgVisibleRange ;


/*!
 @method
 @abstract 通过jid获取信息
 @discussion 查询本地组织架构
 @result  字典
 */
+ (NSDictionary *)queryInformationByJid:(NSString *)aJID;



@end
