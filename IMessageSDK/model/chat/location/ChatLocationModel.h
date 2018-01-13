//
//  ChatLocationModel.h
//  IMessageSDK
//
//  Created by JH on 2018/1/13.
//  Copyright © 2018年 JiangHai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapCommonObj.h>



@interface ChatLocationModel : NSObject

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

/** 是否被选择**/
@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, assign) NSString *title;

@property (nonatomic, assign) NSString *subtitle;




@end
