/*!
 @header
 @abstract 错误类
 @author 江海（JiangHai）
 @version v5.2.0
 */
#import <Foundation/Foundation.h>
#import "LTErrorDef.h"


/*!
 @class
 @abstract 错误
 */
@interface LTError : NSObject


/*!
 @property
 @abstract 错误码
 */
@property (nonatomic) LTErrorCode code;

/*!
 @property
 @abstract 错误描述
 */
@property (nonatomic, strong) NSString *localDescription;




/*!
 @method
 @abstract 创建错误实例
 @discussion null
 @param aDescription 错误描述
 @param aCode 错误码
 */
+ (instancetype)errorWithDescription:(NSString *)aDescription
                                code:(LTErrorCode)aCode;


/*!
 @method
 @abstract 错误码描述
 @discussion null
 @param aCode 错误码
 @result  错误码描述
 */
+ (NSString *)errorDescriptionForErrorCode:(LTErrorCode)aCode;



@end
