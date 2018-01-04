//
//  LXChatBox.m
//  LXChatBox
//
//  Created by zlwl001 on 2017/3/7.
//  Copyright © 2017年 manman. All rights reserved.
//

#import "LXChatBox.h"

#import "LXEmotion.h"
#import "LXChatServerDefs.h"

#import "LTRecordHUD.h"

#import "UIConfig.h"

@interface LXChatBox()
<
UITextViewDelegate,
LXChatBoxMoreViewDelegate
>
{
    CGFloat keyboardY;
}

@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,strong)UIView *topContainer;//上侧容器
@property(nonatomic,strong)UIView *bottomCotainer;//下侧容器

@property(nonatomic,strong)LXChatBoxFaceView *faceView;
@property(nonatomic,strong)LXChatBoxMoreView *moreView;
/** chotBox的顶部边线 */
@property(nonatomic,strong)UIView *topLine;
/** 录音按钮 */
@property(nonatomic,strong)UIButton *voiceButton;
/** 表情按钮 */

@property(nonatomic,strong)UIButton *faceButton;
/** (+)按钮 */
@property(nonatomic,strong)UIButton *moreButton;
/** 按住说话 */
@property(nonatomic,strong)UIButton *talkButton;

@property (strong, nonatomic) LTRecordHUD *recordHUD;
@end











@implementation LXChatBox

#pragma mark - UI

-(void)setUpUI{
    
    [self addSubview:self.topContainer];
    [self addSubview:self.bottomCotainer];
    [self.topContainer addSubview:self.topLine];
    [self.topContainer addSubview:self.voiceButton];
    [self.topContainer addSubview:self.faceButton];
    [self.topContainer addSubview:self.moreButton];
    [self.topContainer addSubview:self.textView];
    [self.topContainer addSubview:self.talkButton];
    
    [self.bottomCotainer addSubview:self.faceView];
    [self.bottomCotainer addSubview:self.moreView];
    
    [self hiddenFaceViewMoreView];
    
    
    
}
//--设置是否有动画 （一体键盘）
-(void)setIsDisappear:(BOOL)isDisappear{
    _isDisappear = isDisappear;
}

- (void)changeFrame:(CGFloat)height{

    CGFloat maxH = 0;
    if (self.maxVisibleLine) {
       maxH = ceil(self.textView.font.lineHeight * (self.maxVisibleLine - 1) + self.textView.textContainerInset.top + self.textView.textContainerInset.bottom);
    }
    self.textView.scrollEnabled = height >maxH && maxH >0;
    if (self.textView.scrollEnabled) {
        height = 5+maxH;
    }else{
        height = height;
    }
    CGFloat textviewH = height;
    
    CGFloat totalH = 0;
    if (self.status == LTChatBoxStatusShowFace || self.status == LTChatBoxStatusShowMore) {
        totalH = height + BOXTEXTViewSPACE *2 +BOXOTHERH;
        if (keyboardY ==0) {
            keyboardY = KScreenH;
        }
        self.y = keyboardY - totalH;
        self.height = totalH;
        self.topContainer.height = height + BOXTEXTViewSPACE *2;
        self.bottomCotainer.y =self.topContainer.height;
        self.textView.y = BOXTEXTViewSPACE;
        self.textView.height = textviewH;
        
        self.talkButton.frame = self.textView.frame;
        self.moreButton.y =  self.faceButton.y = self.voiceButton.y  = totalH - BOXBTNBOTTOMSPACE- CHATBOX_BUTTON_WIDTH-BOXOTHERH;

    }else
    {
         totalH = height + BOXTEXTViewSPACE *2;
        self.y = keyboardY - totalH;
        self.height = totalH;
        self.topContainer.height = totalH;
        
        self.textView.y = BOXTEXTViewSPACE;
        self.textView.height = textviewH;
        self.bottomCotainer.y =self.topContainer.height;

        self.talkButton.frame = self.textView.frame;
        self.moreButton.y =  self.faceButton.y = self.voiceButton.y  = totalH - BOXBTNBOTTOMSPACE- CHATBOX_BUTTON_WIDTH;
    }
    
    if ([self.delegate respondsToSelector:@selector(changeStatusChat:)]) {
        [self.delegate changeStatusChat:self.y];
    }

    [self.textView scrollRangeToVisible:NSMakeRange(0, self.textView.text.length)];
}
-(void)setMaxVisibleLine:(NSInteger)maxVisibleLine{
    _maxVisibleLine = maxVisibleLine;
    
}
-(void)setDelegate:(id<LTChatBoxDelegate>)delegate{
    _delegate = delegate;
}
/**
 隐藏其它键盘，键盘向下移动
 **/
-(void)hiddenFaceViewMoreView {
    
    self.voiceButton.selected = YES;
    self.faceButton.selected = NO;
    self.moreButton.selected = NO;
    self.status = LTChatBoxStatusNothing;
}









#pragma mark - private

-(void)voiceButtonDown:(UIButton *)button{
    
    button.selected = !button.selected;
    if (button.selected) {
        self.status = LTChatBoxStatusShowKeyboard;
    }else{
        self.status = LTChatBoxStatusShowVoLXe;
    }
}
-(void)faceButtonDown:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
        self.status = LTChatBoxStatusShowFace;
    }else{
        self.status = LTChatBoxStatusShowKeyboard;
    }
}
-(void)moreButtonDown:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
        self.status = LTChatBoxStatusShowMore;
    }else{
        self.status = LTChatBoxStatusShowKeyboard;
    }
}













#pragma mark - 触发：talkBTN
- (void)talkButtonDown:(UIButton *)sender
{
}
- (void)talkButtonUpInside:(UIButton *)sender
{
}
- (void)talkButtonUpOutside:(UIButton *)sender
{
}
- (void)talkButtonDragOutside:(UIButton *)sender
{
}
- (void)talkButtonDragInside:(UIButton *)sender
{
}
- (void)talkButtonTouchCancel:(UIButton *)sender
{
}

#pragma mark - 触发：talkBTN2

/*开始录音*/
- (void)startRecordVoice {
    
    self.recordHUD = [[LTRecordHUD alloc] initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH-49)];
    [self.recordHUD recordButtonTouchDown];
    int x = arc4random() % 100000;
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *fileName = [NSString stringWithFormat:@"%d%05d",(int)time,x];
    //NSLog(@"%@",fileName);
    [[EMCDDeviceManager sharedInstance] asyncStartRecordingWithFileName:fileName completion:^(NSError *error) {
        if (error) {
            NSLog(@"%@",error.domain);
        }
    }];
}
/*取消录音*/
- (void)cancelRecordVoice{
    [[EMCDDeviceManager sharedInstance] cancelCurrentRecording];
    [self.recordHUD recordButtonTouchUpOutside];
    [self destoryRecordHUD];
    
}
/*录音结束*/
- (void)confirmRecordVoice{
    [self.recordHUD recordButtonTouchUpInside];
    
    [[EMCDDeviceManager sharedInstance] asyncStopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
        if (error == nil && aDuration > 1.0)
        {
            if ([self.delegate respondsToSelector:@selector(chatBox:sendVoice:seconds:)])
            {
                [self.delegate chatBox:self sendVoice:recordPath seconds:aDuration];
            }
        }
        else if (aDuration <= 1.0)
        {
            [self.recordHUD recordError:@"录音时间太短"];
        }
        [self destoryRecordHUD];
    }];
}
/*手指移动到录音按钮外部*/
- (void)updateCancelRecordVoice{
    [self.recordHUD recordButtonDragOutside];
}
/**手指移动到录音按钮内部**/
- (void)updateContinueRecordVoice{
    [self.recordHUD recordButtonDragInside];
}

















#pragma mark - 代理： textview
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if (self.status != LTChatBoxStatusShowKeyboard) {
        self.status = LTChatBoxStatusShowKeyboard;
        
    }
    [self changeFrame:ceilf([textView sizeThatFits:textView.frame.size].height)];
}
-(void)textViewDidChange:(UITextView *)textView{
    [self changeFrame:ceilf([textView sizeThatFits:textView.frame.size].height)];
    
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        if (self.textView.text.length >0) {
            if (self.delegate &&[self.delegate respondsToSelector:@selector(chatBox:sendText:)]) {
                [self.delegate chatBox:self sendText:self.textView.text];
            }
        }
        self.textView.text = @"";
        self.textView.height = HEIGHT_TEXTVIEW;
        [self textViewDidChange:self.textView];
        return NO;
    }
    return YES;
}
















#pragma mark - 代理； 点击moreview item

-(void)chatBoxMoreView:(LXChatBoxMoreView *)chatBoxMoreView didSelectItem:(LXChatBoxItem)itemType{
//    NSLog(@"%s",__func__);
    if ([self.delegate respondsToSelector:@selector(chatBoxDidSelectItem:)]) {
        [self.delegate chatBoxDidSelectItem:itemType];
    }
}




-(void)setStatus:(LTChatBoxStatus)status{
    if (_status == status) {
        return;
    }
    _status = status;
    switch (_status) {
        case LTChatBoxStatusNothing:
        {
            self.voiceButton.selected = YES;
            self.faceView.hidden = self.moreView.hidden = YES;
            [self.textView resignFirstResponder];
            [UIView animateWithDuration:0.3 animations:^{
                self.frame = CGRectMake(0, KScreenH - self.textView.height - 2 *BOXTEXTViewSPACE, KScreenW, self.textView.height + 2 *BOXTEXTViewSPACE);

            }];
        }
            
           
            break;
        case LTChatBoxStatusShowKeyboard:
        {
            self.faceView.hidden = self.moreView.hidden = YES;

            self.voiceButton.selected = YES;
            self.textView.hidden = NO;
            self.talkButton.hidden = YES;
            self.faceButton.selected= NO;
            
            [UIView animateWithDuration:0.3 animations:^{
                self.frame = CGRectMake(0, self.y, KScreenW, self.textView.height + 2 *BOXTEXTViewSPACE);
                
            }];
             [self.textView becomeFirstResponder];
        }
        break;
        case LTChatBoxStatusShowVoLXe:
        {
            self.faceView.hidden = self.moreView.hidden = YES;

            [self.textView resignFirstResponder];
            self.voiceButton.selected = NO;
            self.talkButton.hidden = NO;
            self.textView.hidden = YES;
            [UIView animateWithDuration:0.3 animations:^{
                [self voiceResetFrame];
            }];

        }
            
            break;
        case LTChatBoxStatusShowFace:
        {
            if (self.textView.isFirstResponder) {
                [self.textView resignFirstResponder];
            }
            

            self.voiceButton.selected = YES;
            self.moreView.hidden = YES;
            self.faceView.hidden = NO;
            
            self.height = self.textView.height+2 *BOXTEXTViewSPACE + BOXOTHERH;
            self.y = KScreenH - self.height;
            self.bottomCotainer.y = self.textView.height + 2 *BOXTEXTViewSPACE;

        }
            
            break;
        case LTChatBoxStatusShowMore:
        {
            

            if (self.textView.isFirstResponder) {
                [self.textView resignFirstResponder];
            }
            
            self.voiceButton.selected = YES;
            self.moreView.hidden = NO;
            self.faceView.hidden = YES;

            self.height = self.textView.height+2 *BOXTEXTViewSPACE + BOXOTHERH;
            self.y = KScreenH - self.height;
            self.bottomCotainer.y = self.textView.height + 2 *BOXTEXTViewSPACE;
        }
        default:
            break;
    }
    if ([self.delegate respondsToSelector:@selector(changeStatusChat:)]) {
        [self.delegate changeStatusChat:self.y];
    }
}
// --重置Frame ---
-(void)voiceResetFrame
{
    self.frame = CGRectMake(0, KScreenH -HEIGHT_TABBAR, KScreenW, HEIGHT_TABBAR);
    self.talkButton.frame = CGRectMake(CHATBOX_BUTTON_WIDTH+ BOXBTNSPACE, (HEIGHT_TABBAR - HEIGHT_TEXTVIEW)/2, KScreenW -3 * CHATBOX_BUTTON_WIDTH - 2 *BOXBTNSPACE, HEIGHT_TEXTVIEW);
    self.voiceButton.frame = CGRectMake(0, (HEIGHT_TABBAR - CHATBOX_BUTTON_WIDTH)/2, CHATBOX_BUTTON_WIDTH, CHATBOX_BUTTON_WIDTH);
    self.faceButton.frame =CGRectMake(KScreenW -2 *CHATBOX_BUTTON_WIDTH, (HEIGHT_TABBAR - CHATBOX_BUTTON_WIDTH)/2, CHATBOX_BUTTON_WIDTH, CHATBOX_BUTTON_WIDTH);
    self.moreButton.frame =CGRectMake(KScreenW - CHATBOX_BUTTON_WIDTH, (HEIGHT_TABBAR - CHATBOX_BUTTON_WIDTH)/2, CHATBOX_BUTTON_WIDTH, CHATBOX_BUTTON_WIDTH);
}
//--添加通知---
-(void)addNotification{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelected:) name:LXEmotionDidSelectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteBtnClicked) name:LXEmotionDidDeleteNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendMessage) name:LXEmotionDidSendNotification object:nil];
}
// 通知-选择表情
- (void)emotionDidSelected:(NSNotification *)notifi
{
    LXEmotion *emotion = notifi.userInfo[LXSelectEmotionKey];
    if (emotion.code) {
        [self.textView insertText:emotion.code.emoji];
    } else if (emotion.face_name) {
        [self.textView insertText:emotion.face_name];
    }
}
//-发送消息
- (void)sendMessage
{
    if (self.textView.text.length > 0) {     // send Text

        if (self.delegate && [self.delegate respondsToSelector:@selector(chatBoxSendTextMessage:)]) {
            [self.delegate chatBoxSendTextMessage:self.textView.text];
        }
    }
    [self.textView setText:@""];
    self.textView.height = HEIGHT_TEXTVIEW;
    [self textViewDidChange:self.textView];
}
//通知 --- 删除--回退--
- (void)deleteBtnClicked
{
    [self.textView deleteBackward];
}

-(void)keyboardWillChangeFrame:(NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //    NSLog(@"%@",NSStringFromCGRect(keyboardF));
    keyboardY = keyboardF.origin.y;
    //因为在 切换视图的时候，点击了表情按钮，或者更多按钮，输入框是，键盘弹出在textViewDidBeginEditing 这个方法调用之前就会调用，
//        self.height = self.textView.height + 2 *BOXTEXTViewSPACE;
    if (self.status == LTChatBoxStatusShowMore ||self.status == LTChatBoxStatusShowFace) {
        return;
    }
    
    // 执行动画
    if (!_isDisappear) {
        
        [UIView animateWithDuration:duration animations:^{
            // 工具条的Y值 == 键盘的Y值 - 工具条的高度
            
            if (keyboardF.origin.y > KScreenH) {
                self.y = KScreenH- self.height;
            }else
            {
                self.y = keyboardF.origin.y - self.height;
            }
            //            NSLog(@"%f",self.y);
        }];
        if ([self.delegate respondsToSelector:@selector(changeStatusChat:)]) {
            [self.delegate changeStatusChat:self.y];
        }

    }
    
    
}

-(void)keyboardDidChangeFrame:(NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    //    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //    NSLog(@"%@",NSStringFromCGRect(keyboardF));
    
   
    // 工具条的Y值 == 键盘的Y值 - 工具条的高度
    if (_isDisappear) {
        if (keyboardF.origin.y > KScreenH) {
            self.y = KScreenH- self.height;
        }else
        {
            self.y = keyboardF.origin.y - self.height;
        }
//        NSLog(@"%f",self.y);
    }
}


























#pragma mark - Init

-(UIView *)topContainer{
    if (!_topContainer) {
        _topContainer =[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, HEIGHT_TABBAR)];
        _topContainer.backgroundColor =[UIColor clearColor];
        
    }
    return _topContainer;
}
-(UIView *)bottomCotainer{
    if (!_bottomCotainer) {
        _bottomCotainer =[[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT_TABBAR, KScreenW, BOXOTHERH)];
        _bottomCotainer.backgroundColor =[UIColor clearColor];
        
    }
    return _bottomCotainer;
}
-(LXChatBoxFaceView *)faceView{
    if (!_faceView ) {
        _faceView =[[LXChatBoxFaceView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, BOXOTHERH)];
//        _faceView.backgroundColor =[UIColor purpleColor];
        
    }
    return _faceView;
}
-(LXChatBoxMoreView *)moreView{
    if (!_moreView ) {
        _moreView =[[LXChatBoxMoreView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, BOXOTHERH)];
        _moreView.hidden = YES;
        _moreView.delegate = self;
        // 创建Item
        LXChatBoxMoreViewItem *photosItem = [LXChatBoxMoreViewItem createChatBoxMoreItemWithTitle:@"照片"
                                                                                        imageName:@"sharemore_pic"];
        LXChatBoxMoreViewItem *takePictureItem = [LXChatBoxMoreViewItem createChatBoxMoreItemWithTitle:@"拍摄"
                                                                                             imageName:@"sharemore_video"];
        LXChatBoxMoreViewItem *videoItem = [LXChatBoxMoreViewItem createChatBoxMoreItemWithTitle:@"小视频"
                                                                                       imageName:@"sharemore_sight"];
        LXChatBoxMoreViewItem *docItem   = [LXChatBoxMoreViewItem createChatBoxMoreItemWithTitle:@"文件" imageName:@"sharemore_wallet"];
        
        NSMutableArray *arr =
        [[NSMutableArray alloc] initWithObjects:
         photosItem,
         takePictureItem,
         videoItem,
         docItem,
         nil];
        [_moreView setItems:arr];
//        _moreView.backgroundColor =[UIColor purpleColor];
    }
    return _moreView;
}

-(UIView *)topLine{
    if (!_topLine) {
        _topLine =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 0.5)];
        [_topLine setBackgroundColor:LBColor(165, 165, 165)];
    }
    return _topLine;
}
-(UIButton *)voiceButton{
    if (!_voiceButton) {
        _voiceButton =[[UIButton alloc]initWithFrame:CGRectMake(0, (HEIGHT_TABBAR - CHATBOX_BUTTON_WIDTH)/2, CHATBOX_BUTTON_WIDTH, CHATBOX_BUTTON_WIDTH)];
        [_voiceButton setImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:UIControlStateSelected];

         [_voiceButton setImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateNormal];
        
        [_voiceButton addTarget:self action:@selector(voiceButtonDown:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceButton;
}
-(UIButton *)faceButton{
    if (!_faceButton) {
        _faceButton =[[UIButton alloc]initWithFrame:CGRectMake(KScreenW -2 *CHATBOX_BUTTON_WIDTH, (HEIGHT_TABBAR - CHATBOX_BUTTON_WIDTH)/2, CHATBOX_BUTTON_WIDTH, CHATBOX_BUTTON_WIDTH)];
        [_faceButton setImage:[UIImage imageNamed:@"ToolViewEmotion"] forState:UIControlStateNormal];
        [_faceButton setImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateSelected];
        [_faceButton setImage:[UIImage imageNamed:@"ToolViewEmotionHL"] forState:UIControlStateHighlighted];
        [_faceButton addTarget:self action:@selector(faceButtonDown:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _faceButton;
}
-(UIButton *)moreButton{
    if (!_moreButton) {
        _moreButton =[[UIButton alloc]initWithFrame:CGRectMake(KScreenW - CHATBOX_BUTTON_WIDTH, (HEIGHT_TABBAR - CHATBOX_BUTTON_WIDTH)/2, CHATBOX_BUTTON_WIDTH, CHATBOX_BUTTON_WIDTH)];
        [_moreButton setImage:[UIImage imageNamed:@"TypeSelectorBtn_Black"] forState:UIControlStateNormal];
        [_moreButton setImage:[UIImage imageNamed:@"TypeSelectorBtn_Black"] forState:UIControlStateSelected];
        [_moreButton setImage:[UIImage imageNamed:@"TypeSelectorBtnHL_Black"] forState:UIControlStateHighlighted];
        [_moreButton addTarget:self action:@selector(moreButtonDown:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _moreButton;
}
-(UITextView *)textView{
    if (!_textView) {
        _textView =[[UITextView alloc]initWithFrame:CGRectMake(CHATBOX_BUTTON_WIDTH+ BOXBTNSPACE, (HEIGHT_TABBAR - HEIGHT_TEXTVIEW)/2, KScreenW -3 * CHATBOX_BUTTON_WIDTH - 2 *BOXBTNSPACE, HEIGHT_TEXTVIEW)];
        _textView.font = Font(16);
        _textView.layer. masksToBounds = YES;
        _textView.layer.cornerRadius = 4.0f;
        _textView.layer.borderWidth = 0.5f;
        _textView.layer.borderColor= self.topLine.backgroundColor.CGColor;
        _textView.scrollsToTop = NO;
        _textView.returnKeyType = UIReturnKeySend;
        _textView.delegate = self;
    }
    return _textView;
}
-(UIButton *)talkButton{
    if (!_talkButton) {
        _talkButton = [[UIButton alloc]initWithFrame:self.textView.frame];
        [_talkButton setTitle:@"按住 说话" forState:UIControlStateNormal];
        [_talkButton setTitle:@"松开 结束" forState:UIControlStateHighlighted];
        [_talkButton setTitleColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0] forState:UIControlStateNormal];
        [_talkButton setBackgroundImage:[UIImage gxz_imageWithColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.5]] forState:UIControlStateHighlighted];
        _talkButton.layer. masksToBounds = YES;
        _talkButton.layer.cornerRadius = 4.0f;
        _talkButton.layer.borderWidth = 0.5f;
        [_talkButton.layer setBorderColor:self.topLine.backgroundColor.CGColor];
        [_talkButton setHidden:YES];
        
        /**
        [_talkButton addTarget:self action:@selector(talkButtonDown:) forControlEvents:UIControlEventTouchDown];
        [_talkButton addTarget:self action:@selector(talkButtonUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_talkButton addTarget:self action:@selector(talkButtonUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
        [_talkButton addTarget:self action:@selector(talkButtonTouchCancel:) forControlEvents:UIControlEventTouchCancel];
        [_talkButton addTarget:self action:@selector(talkButtonDragOutside:) forControlEvents:UIControlEventTouchDragOutside];
        [_talkButton addTarget:self action:@selector(talkButtonDragInside:) forControlEvents:UIControlEventTouchDragInside];
        **/
        
        [_talkButton addTarget:self action:@selector(startRecordVoice) forControlEvents:UIControlEventTouchDown];
        [_talkButton addTarget:self action:@selector(cancelRecordVoice) forControlEvents:UIControlEventTouchUpOutside];
        [_talkButton addTarget:self action:@selector(confirmRecordVoice) forControlEvents:UIControlEventTouchUpInside];
        [_talkButton addTarget:self action:@selector(updateCancelRecordVoice) forControlEvents:UIControlEventTouchDragExit];
        [_talkButton addTarget:self action:@selector(updateContinueRecordVoice) forControlEvents:UIControlEventTouchDragEnter];
        
    }
    return _talkButton;
}
- (LTRecordHUD *)recordHUD {
    if ( !_recordHUD ) {
        _recordHUD = [[LTRecordHUD alloc] initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH)];
        _recordHUD.hidden = YES;
        [kAppDelegate.window addSubview:_recordHUD];
        [kAppDelegate.window bringSubviewToFront:_recordHUD];
        _recordHUD.alpha = 0.95;
    }
    return _recordHUD;
}
/**销毁RecordHUD**/
-(void)destoryRecordHUD{
    [self.recordHUD destory];
    self.recordHUD = nil;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = LBColor(241, 241, 248);
        //        self.backgroundColor =[UIColor redColor];
        
        self.status = LTChatBoxStatusNothing;
        [self.textView resignFirstResponder];
        [self setUpUI];
        [self addNotification];
        
        
    }
    
    return self;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
