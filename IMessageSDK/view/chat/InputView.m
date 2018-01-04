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
@property (nonatomic, strong) UIButton   *voiceInputBTN;    /**按着说话**/

@property (nonatomic, strong) InputViewBlock aInputViewBlock;
@end



@implementation InputView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        /**声音**/
        self.voiceBTN = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [self addSubview:self.voiceBTN];
        [self.voiceBTN setBackgroundImage: [[UIImage imageNamed:@"chat_voice"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]
                                 forState:(UIControlStateNormal)];
        [self.voiceBTN setBackgroundImage: [[UIImage imageNamed:@"chat_Keyboard"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]
                                 forState:(UIControlStateSelected)];
        self.voiceBTN.layer.borderWidth = 1;
        self.voiceBTN.layer.cornerRadius = 18;
        self.voiceBTN.layer.masksToBounds = YES;
        self.voiceBTN.layer.borderColor = [UIColor grayColor].CGColor;
        self.voiceBTN.tag = 1001;
        [self.voiceBTN addTarget:self action:@selector(buttonclick:) forControlEvents:(UIControlEventTouchUpInside)];
        
        
        
        
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
        
        
        
        /**按着说话**/
        self.voiceInputBTN = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [self addSubview:self.voiceInputBTN];
        [self.voiceInputBTN setBackgroundImage:[self imageWithColor:[UIColor greenColor]]
                                                           forState:(UIControlStateNormal)];
         [self.voiceInputBTN setBackgroundImage:[self imageWithColor:[[UIColor greenColor] colorWithAlphaComponent:0.5]]
                                                            forState:(UIControlStateSelected)];
        
        self.voiceInputBTN.layer.borderWidth = 1;
        self.voiceInputBTN.layer.cornerRadius = 4;
        self.voiceInputBTN.layer.masksToBounds = YES;
        self.voiceInputBTN.layer.borderColor = [UIColor grayColor].CGColor;
        self.voiceInputBTN.tag = 1004;
        [self.voiceInputBTN addTarget:self action:@selector(buttonclick:) forControlEvents:(UIControlEventTouchUpInside)];
        self.voiceInputBTN.hidden = YES;
        [self.voiceInputBTN setTitle:@"按着说话" forState:(UIControlStateNormal)];
        [self.voiceInputBTN setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        
        
        
        
        
        /**表情**/
        self.faceBTN = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [self addSubview:self.faceBTN];
        [self.faceBTN setBackgroundImage: [[UIImage imageNamed:@"chat_face"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]
                                 forState:(UIControlStateNormal)];
        [self.faceBTN setBackgroundImage: [[UIImage imageNamed:@"chat_Keyboard"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]
                                 forState:(UIControlStateSelected)];
        self.faceBTN.layer.borderWidth = 1;
        self.faceBTN.layer.cornerRadius = 18;
        self.faceBTN.layer.masksToBounds = YES;
        self.faceBTN.layer.borderColor = [UIColor grayColor].CGColor;
        self.faceBTN.tag = 1002;
        [self.faceBTN addTarget:self action:@selector(buttonclick:) forControlEvents:(UIControlEventTouchUpInside)];
        
        
        
        
        
        /**更多**/
        self.moreBTN = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [self addSubview:self.moreBTN];
        [self.moreBTN setBackgroundImage: [[UIImage imageNamed:@"chat_add2"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]
                                forState:(UIControlStateNormal)];
        self.moreBTN.layer.borderWidth = 1;
        self.moreBTN.layer.cornerRadius = 18;
        self.moreBTN.layer.masksToBounds = YES;
        self.moreBTN.layer.borderColor = [UIColor grayColor].CGColor;
        self.moreBTN.tag = 1003;
        [self.moreBTN addTarget:self action:@selector(buttonclick:) forControlEvents:(UIControlEventTouchUpInside)];
        
        
        
        
        
        
        CGFloat KWIDTH  = UIScreen.mainScreen.bounds.size.width;
        self.voiceBTN.frame = CGRectMake(5, 8, 36, 36);
        self.contentTextView.frame = CGRectMake(50, 8, KWIDTH-145, 36);
        self.voiceInputBTN.frame = CGRectMake(50, 8, KWIDTH-145, 36);
        self.faceBTN.frame = CGRectMake(KWIDTH-90, 8, 36, 36);
        self.moreBTN.frame = CGRectMake(KWIDTH-45, 8, 36, 36);
        
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    
}

-(void)showFaceView {
    
    
}

-(void)showMoreView {
    
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
        if (self.aInputViewBlock && textView.text.length > 0) {
            self.aInputViewBlock(InputViewActionType_sendMessage, textView.text);
            textView.text = @"";
            [self textViewDidChange:textView];
        }
        //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
        return NO;
    }
    return YES;
}


-(void)startInputView:(InputViewBlock)aInputViewBlock {
    self.aInputViewBlock = aInputViewBlock;
}










#pragma mark - private

-(void)buttonclick:(UIButton *)sender {
    
    switch (sender.tag) {
        case 1001:
        {
            /**将其它按钮置为NO**/
            self.voiceBTN.selected = !self.voiceBTN.selected;
            self.faceBTN.selected = NO;
            self.moreBTN.selected = NO;
            
            [self voiceBTNClick];
            [self faceBTNClick];
            [self moreBTNClick];
        }
            break;
            
        case 1002:
        {
            self.voiceBTN.selected = NO;
            self.faceBTN.selected = !self.faceBTN.selected;
            self.moreBTN.selected = NO;
            [self voiceBTNClick];
            [self faceBTNClick];
            [self moreBTNClick];
        }
            break;
            
        case 1003:
        {
            self.voiceBTN.selected = NO;
            self.faceBTN.selected = NO;
            self.moreBTN.selected = !self.faceBTN.selected;
            [self voiceBTNClick];
            [self faceBTNClick];
            [self moreBTNClick];
        }
            break;
        default:
            break;
    }
}

-(void)voiceBTNClick {
    
    BOOL flag = self.voiceBTN.selected;
    
    if (flag)
    {
        self.voiceInputBTN.hidden = NO;
    }
    else
    {
        self.voiceInputBTN.hidden = YES;
    }
}

-(void)faceBTNClick {
    
    BOOL flag = self.faceBTN.selected;
    
    if (flag)
    {
        if (self.aInputViewBlock) {
            self.aInputViewBlock(InputViewActionType_faceSelect, nil);
        }
    }
    else
    {
        
    }
    
}

-(void)moreBTNClick {
    
    
}







#pragma mark - Utility
- (UIImage *)imageWithColor:(UIColor*)color{
    
    CGRect rect = CGRectMake(0.0f,0.0f,1.0f,1.0f);UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context=UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage*theImage=UIGraphicsGetImageFromCurrentImageContext();UIGraphicsEndImageContext();
    
    return theImage;
}



@end
