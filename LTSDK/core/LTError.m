//
//  LTError.m
//  WiseUC
//
//  Created by JH on 2017/12/6.
//  Copyright © 2017年 WiseUC. All rights reserved.
//

#import "LTError.h"

@implementation LTError


- (instancetype)initWithDescription:(NSString *)aDescription code:(LTErrorCode)aCode {
    _localDescription = aDescription;
    _code = aCode;
    return self;
}

//+ (instancetype)errorWithDescription:(NSString *)aDescription code:(LTErrorCode)aCode
//{
//    return [[self alloc] initWithDescription:aDescription code:aCode];
//}

+ (NSString *)errorDescriptionForErrorCode:(LTErrorCode)aCode
{
    NSString *errorDescription = nil;
    
    switch ( aCode) {
            
        case LTErrorUnknownError:
            errorDescription = @"未知错误(严重)";
            break;
            
        case LTErrorFetchLoginConfig:
            errorDescription = @"登录配置获取失败";
            break;
            
        case LTErrorLoginTimeOut:
            errorDescription = @"登录超时";
            break;
            
        default:
            errorDescription = [NSString stringWithFormat:@"未知错误 %d",aCode];
            break;
    }
    return errorDescription;
}





@end
