//
//  StackView.h
//  IMessageSDK
//
//  Created by JH on 2017/12/19.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^StackViewBackBlock)(void);
@interface StackView : UIView

-(void)showContent:(NSString *)content;

-(void)setBackAction:(StackViewBackBlock)aStackViewBackBlock;

@end
