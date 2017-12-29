/*!
 @header
 @abstract INF配置文件类
 @author 江海（JiangHai）
 @version v5.2.0
 */
#import <Foundation/Foundation.h>






@interface LTINF : NSObject
/**
 os = linux,
 ackEnable = 0,
 appstate = check
 MD5Enable = 0,
 LDAPAuthEnable = 0,
 
 MsgServerConnAddr = tcp://112.74.74.80:5225,
 ftpURLServerConfig = im.lituosoft.cn:6100,
 **/





/*!
 @method
 @abstract 初始化
 @discussion
 @result  登陆管理类
 */
+ (instancetype)share;



/*!
 @method
 @abstract 更新INF配置
 @discussion
 */
-(void)updateINFWithIsDeploy:(BOOL)ret;
-(void)updateINFWithIsLinux:(BOOL)ret;
-(void)updateINFWithIsCheck:(BOOL)ret;
-(void)updateINFWithIsAckEnable:(BOOL)ret;
-(void)updateINFWithisMD5Enable:(BOOL)ret;
-(void)updateINFWithisLDAPAuthEnable:(BOOL)ret;
-(void)updateINFWithMsgServerConnAddr:(NSString *)ret;
-(void)updateINFWithFtpURLServerConfig:(NSString *)ret;



/*!
 @method
 @abstract 查询INF配置
 @discussion
 */
- (BOOL)queryIsDeploy;
- (BOOL)queryIsLinux;
- (BOOL)queryIsCheck;
- (BOOL)queryIsAckEnable;
- (BOOL)queryisMD5Enable;
- (BOOL)queryisLDAPAuthEnable;
- (NSString *)queryMsgServerConnAddr;
- (NSString *)queryFtpURLServerConfig;



/*!
 @method
 @abstract 删除INF配置
 @discussion
 */
- (void)deleteIsDeploy;
- (void)deleteIsLinux;
- (void)deleteIsCheck;
- (void)deleteIsAckEnable;
- (void)deleteisMD5Enable;
- (void)deleteisLDAPAuthEnable;
- (void)deleteMsgServerConnAddr;
- (void)deleteFtpURLServerConfig;






@end
