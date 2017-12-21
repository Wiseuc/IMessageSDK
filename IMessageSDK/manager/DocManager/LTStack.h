//
//  LTStack.h
//  IMessageSDK
//
//  Created by JH on 2017/12/19.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrgModel.h"
@interface LTStack : NSObject


/**进栈**/
-(void)push:(OrgModel *)model;

/**出栈**/
-(void)pop;

/**清栈**/
-(void)clear;

/**获取栈顶元素**/
-(OrgModel *)queryTopItem;

/**获取栈底元素**/
-(OrgModel *)queryBottomItem;

-(NSString *)queryStackDescription;

-(NSUInteger)queryStackCount;
@end
