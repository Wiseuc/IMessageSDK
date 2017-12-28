/*!
 @header
 @abstract 登录成功后可以获取到用户真实信息
 @author 江海（JiangHai）
 @version v5.2.0
 */

#import <Foundation/Foundation.h>
#import "LTError.h"
typedef void(^LTUser_queryPIDBlock)(NSDictionary *dict, LTError *error);

@interface LTUser : NSObject


/*!
 @method
 @abstract 初始化
 @discussion
 @result  登陆管理类
 */
+ (instancetype)share;



#pragma mark -=================

/*!
 @method
 @abstract 保存服务器返回的用户真实信息
 @discussion null
 */
- (NSDictionary *)queryUser;
- (void)deleteUser;
-(void)updateUserWithPID:(NSString *)PID
               AccountID:(NSString *)AccountID
                UserName:(NSString *)UserName
                 IsAdmin:(NSString *)IsAdmin
                     JID:(NSString *)JID

                   IMPwd:(NSString *)IMPwd
             AccountName:(NSString *)AccountName
                  Domain:(NSString *)Domain
            AssistantURL:(NSString *)AssistantURL
                    Host:(NSString *)Host

             FirstChanel:(NSString *)FirstChanel
          VisableChanels:(NSString *)VisableChanels
                   Email:(NSString *)Email
               Code_Type:(NSString *)Code_Type
              Session_ID:(NSString *)Session_ID

            PushOrgState:(NSString *)PushOrgState
               ServerVer:(NSString *)ServerVer
               HasAdvert:(NSString *)HasAdvert;




#pragma mark -=================Signature

/*!
 @method
 @abstract 更新签名
 @discussion null
 */
-(void)updateUserWithSignature:(NSString *)Signature;
/*!
 @method
 @abstract 查询签名
 @discussion null
 */
- (NSString *)querySignature;
/*!
 @method
 @abstract 删除签名
 @discussion null
 */
- (void)deleteSignature;


/*!
 @method
 @abstract 通过请求PID
 @discussion <#备注#>
 @param aJID
 @result  <#描述4#>
 */
- (void)sendRequestPidWithJid:(NSString *)aJID completed:(LTUser_queryPIDBlock)aBlock;



@end
