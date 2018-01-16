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
 
 <
 JID ID="45"
 LoginName="萧凡宇"
 PID="10805"
 ITEMTYPE="2"
 NAME="萧凡宇"
 
 JID="萧凡宇@duowin-server"
 NICK="哈哈"
 MOBILE="18617354209"
 TELE="908"
 TelExt=""
 
 MOBEXT="0"
 EMAIL="xiaofanyu@wiseuc.com"
 title="iOS开发"
 sex="男"
 leader="0"
 
 indexs="661
 >
 */
+ (NSDictionary *)queryInformationByJid:(NSString *)aJID;



@end
