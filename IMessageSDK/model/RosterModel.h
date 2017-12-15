//
//  RosterModel.h
//  IMessageSDK
//
//  Created by JH on 2017/12/15.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RosterModel : NSObject


/**
 {
 FN = "\U5f20\U4ee3\U4f0d";
 group = "\U6211\U7684\U540c\U4e8b";
 jid = "\U5f20\U4ee3\U4f0d@duowin-server";
 
 name = "\U5f20\U4ee3\U4f0d";
 pinYin = ZDW;
 subscription = both;
 vcardver = 3;
 }
 **/

@property (nonatomic, strong) NSString *FN;           /**full name**/
@property (nonatomic, strong) NSString *group;        /**群组**/
@property (nonatomic, strong) NSString *jid;          /**jid**/
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *pinYin;
@property (nonatomic, strong) NSString *subscription;  /**订阅**/
@property (nonatomic, strong) NSString *vcardver;


@end
