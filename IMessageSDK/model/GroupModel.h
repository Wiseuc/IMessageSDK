//
//  GroupModel.h
//  IMessageSDK
//
//  Created by JH on 2017/12/15.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupModel : NSObject

/**
 {
 FN = "\U5927\U7897\U83dc-\U805a\U9910-20170519";
 category = conference;
 conferencetype = 1;
 introduction = "";
 jid = "d3e01480a5e24ae182d883ec29329216@conference.duowin-server";
 
 name = "\U5927\U7897\U83dc-\U805a\U9910-20170519";
 owner = "\U5218\U816e\U5b9d@duowin-server";
 password = 0;
 subject = "\U805a\U9910";
 type = public;
 },
 
 **/


@property (nonatomic, strong) NSString *FN;           /**full name**/
@property (nonatomic, strong) NSString *category;        /**群组**/
@property (nonatomic, strong) NSString *conferencetype;          /**jid**/
@property (nonatomic, strong) NSString *introduction;
@property (nonatomic, strong) NSString *jid;

@property (nonatomic, strong) NSString *name;  /**订阅**/
@property (nonatomic, strong) NSString *owner;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *subject;  /**订阅**/
@property (nonatomic, strong) NSString *type;

@end
