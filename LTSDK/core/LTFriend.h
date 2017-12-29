/*!
 @header
 @abstract 好友管理类
 @author 江海（JiangHai）
 @version v5.2.0
 */


#import <Foundation/Foundation.h>
#import "LTError.h"
typedef void (^LTFriend_queryRostersBlock)(NSMutableArray *rosters, LTError *error);
typedef void (^LTFriend_queryRosterVCardBlock)(NSDictionary *dict);
typedef void (^LTFriend_addFriendBlock)(NSDictionary *dict, LTError *error);
typedef void (^LTFriend_addFriendBehaviorObserver)(NSDictionary *dict);

/*!
 @class
 @abstract 好友管理类
 */
@interface LTFriend : NSObject


/*!
 @method
 @abstract 初始化
 @discussion null
 @result  登陆管理类
 */
+ (instancetype)share;



/*!
 @method
 @abstract 请求好友列表
 @discussion 回调返回好友列表
 */
- (void)queryRostersCompleted:(LTFriend_queryRostersBlock)queryRostersBlock;


/*!
 @method
 @abstract 通过JID获取资料
 @discussion 通过查询网络数据
 */
-(void)queryRosterVCardByJID:(NSString *)aJID
                   completed:(LTFriend_queryRosterVCardBlock)queryRosterVCardBlock;




/*!
 @method
 @abstract 请求添加好友
 @discussion <#备注#>
 @param aFriendJid 好友jid
 @param aFriendName 好友名字
 @param aBlock 回调
 */
- (void)sendRequestAddFriendWithFriendJid:(NSString *)aFriendJid
                               friendName:(NSString *)aFriendName
                                completed:(LTFriend_addFriendBlock)aBlock;


/*!
 @method
 @abstract 同意添加好友请求
 @discussion <#备注#>
 @param aFriendJid 好友jid
 @param aFriendName 好友名字
 */
- (void)acceptAddFriendJid:(NSString *)aFriendJid
                friendName:(NSString *)aFriendName;

/*!
 @method
 @abstract 拒绝添加好友请求
 @discussion <#备注#>
 @param aFriendJid 好友jid
 */
- (void)refuseAddFriendJid:(NSString *)aFriendJid;

/*!
 @method
 @abstract 删除好友
 @discussion <#备注#>
 @param aFriendJid 好友jid
 */
- (void)deleteFriendJid:(NSString *)aFriendJid;


/*!
 @method
 @abstract 添加好友行为监测
 @discussion 返回字典
 @param aBlock 行为回调
 */
-(void)addFriendBehaviorObserver:(LTFriend_addFriendBehaviorObserver)aBlock;





@end
