//
//  AddRGBottomSelectMenu
//  WiseUC
//
//  Created by JH on 2017/7/3.
//  Copyright © 2017年 WiseUC. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AddRGBottomSelectMenuDelegate;



@interface AddRGBottomSelectMenu : UIView<AddRGBottomSelectMenuDelegate>
@property(nonatomic,weak) id delegate;
@end





@protocol AddRGBottomSelectMenuDelegate <NSObject>

-(void)addRGBottomSelectMenuDelegate:(AddRGBottomSelectMenu *)jhDropMenu didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end
