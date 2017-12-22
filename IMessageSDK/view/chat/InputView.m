//
//  InputView.m
//  IMessageSDK
//
//  Created by JH on 2017/12/21.
//  Copyright © 2017年 JiangHai. All rights reserved.
//

#import "InputView.h"
#import "NSString+Extension.h"


//#define KInput_WIDTH   self.frame.size.width;
//#define KInputView_HEIGHT  self.frame.size.height;
@interface InputView ()
<
UITextViewDelegate
>
@property (nonatomic, strong) UIButton *voiceBTN;  /**语音**/
@property (nonatomic, strong) UIButton *faceBTN;  /**表情**/
@property (nonatomic, strong) UIButton *moreBTN;  /**更多**/
@property (nonatomic, strong) UITextView *contentTextView;  /**输入框**/



@property (nonatomic, strong) InputViewBlock aInputViewBlock;
@end



@implementation InputView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.voiceBTN = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [self addSubview:self.voiceBTN];
        [self.voiceBTN setImage:
         [[UIImage imageNamed:@"kaimen"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] forState:(UIControlStateNormal)];
        
        
        self.contentTextView = [[UITextView alloc] init];
        [self addSubview:self.contentTextView];
        self.contentTextView.layer.borderWidth = 1;
        self.contentTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.contentTextView.layer.cornerRadius = 4.0;
        self.contentTextView.layer.masksToBounds = YES;
        self.contentTextView.delegate = self;
        self.contentTextView.font = [UIFont systemFontOfSize:16.0];
//        self.contentTextView.layer.shadowOffset = CGSizeMake(10, 10);
//        self.contentTextView.layer.shadowColor = [UIColor blueColor].CGColor;
//        self.contentTextView.layer.shadowOpacity = 0.8;//阴影透明度，默认0
        self.contentTextView.keyboardType = UIKeyboardTypeDefault;
        self.contentTextView.returnKeyType = UIReturnKeySend;
        
        
        
        self.faceBTN = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [self addSubview:self.faceBTN];
        [self.faceBTN setImage:
         [[UIImage imageNamed:@"kaimen"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] forState:(UIControlStateNormal)];
        
        
        self.moreBTN = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [self addSubview:self.moreBTN];
        [self.moreBTN setImage:
         [[UIImage imageNamed:@"kaimen"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]
                      forState:(UIControlStateNormal)];
        
        
        CGFloat KWIDTH  = UIScreen.mainScreen.bounds.size.width;
        self.voiceBTN.frame = CGRectMake(5, 5, 40, 40);
        self.contentTextView.frame = CGRectMake(50, 8, KWIDTH-145, 35);
        self.faceBTN.frame = CGRectMake(KWIDTH-90, 5, 40, 40);
        self.moreBTN.frame = CGRectMake(KWIDTH-45, 5, 40, 40);
        
    }
    return self;
}


-(void)layoutSubviews {
    [super layoutSubviews];
    
    
    
}




#pragma mark - 代理：UITextView
- (void)textViewDidBeginEditing:(UITextView *)textView {
    
}
-(void)textViewDidChange:(UITextView *)textView{
    CGRect tempFrame = textView.frame;
    /**建议高度**/
    CGSize adviceSize = [textView sizeThatFits:CGSizeMake(tempFrame.size.width, MAXFLOAT)];
    /**高度差距**/
    CGFloat distanceHeight = adviceSize.height - tempFrame.size.height;
    CGFloat adviceY = tempFrame.origin.y - distanceHeight;
    CGFloat adviceHeight = tempFrame.size.height + distanceHeight;
    textView.frame =CGRectMake(tempFrame.origin.x, adviceY, tempFrame.size.width, adviceHeight);
}

//这个函数的最后一个参数text代表你每次输入的的那个字，所以：
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //判断输入的字是否是回车，即按下return
    if ([text isEqualToString:@"\n"]){
        //在这里做你响应return键的代码
        if (self.aInputViewBlock) {
            self.aInputViewBlock(textView.text);
            textView.text = @"";
        }
        //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
        return NO;
    }
    return YES;
}


-(void)startInputView:(InputViewBlock)aInputViewBlock {
    self.aInputViewBlock = aInputViewBlock;
}

@end
