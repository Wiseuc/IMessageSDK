//
//  LTOrg.h
//  WiseUC
//
//  Created by JH on 2017/12/6.
//  Copyright © 2017年 WiseUC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTOrg : NSObject
//@property (nonatomic, copy) NSString *filePath;             //!<组织架构文件路径
//@property (nonatomic, copy) NSString *orgName;              //!<企业名称
//@property (nonatomic, strong) NSArray *orgVisibleRangeArray;//!<组织架构可视范围
//@property (nonatomic, strong) GDataXMLDocument *xmlDoc;





/*!
 @method
 @abstract 初始化
 @discussion
 @result  登陆管理类
 */
+ (instancetype)share;




/*!
 @method
 @abstract 更新组织架构
 @discussion
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
 @discussion
 @result  字典
 */
- (NSDictionary *)queryOrg;
    
    

/*!
 @method
 @abstract 删除组织架构
 @discussion
 */
- (void)deleteOrg;







/**获取组织架构可见范围**/
- (NSArray *)queryOrgVisibleRange ;





@end
