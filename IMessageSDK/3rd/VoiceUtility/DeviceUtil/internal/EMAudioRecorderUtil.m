//
//  EMAudioRecorderUtil.m
//  ChatDemo-UI2.0
//
//  Created by dujiepeng on 5/8/15.
//  Copyright (c) 2015 dujiepeng. All rights reserved.
//

#import "EMAudioRecorderUtil.h"

#define kAVSampleRateKey 11025.0    // 采样率必须要设为11025才能使转化成mp3格式后不会失真
#define kAVLinearPCMBitDepthKey 16  // 采样位数 默认 16
#define kAVNumberOfChannelsKey 2    // 录音通道数  1 或 2 ，要转换成mp3格式必须为双通道

static EMAudioRecorderUtil *audioRecorderUtil = nil;

@interface EMAudioRecorderUtil () <AVAudioRecorderDelegate> {
    NSDate *_startDate;
    NSDate *_endDate;
    
    void (^recordFinish)(NSString *recordPath);
}
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) NSDictionary *recordSetting;

@end

@implementation EMAudioRecorderUtil

#pragma mark - Public
// 当前是否正在录音
+(BOOL)isRecording{
    return [[EMAudioRecorderUtil sharedInstance] isRecording];
}

// 开始录音
+ (void)asyncStartRecordingWithPreparePath:(NSString *)aFilePath
                                completion:(void(^)(NSError *error))completion{
    [[EMAudioRecorderUtil sharedInstance] asyncStartRecordingWithPreparePath:aFilePath
                                                                  completion:completion];
}

// 停止录音
+(void)asyncStopRecordingWithCompletion:(void(^)(NSString *recordPath))completion{
    [[EMAudioRecorderUtil sharedInstance] asyncStopRecordingWithCompletion:completion];
}

// 取消录音
+(void)cancelCurrentRecording{
    [[EMAudioRecorderUtil sharedInstance] cancelCurrentRecording];
}

+(AVAudioRecorder *)recorder{
    return [EMAudioRecorderUtil sharedInstance].recorder;
}

#pragma mark - getter
- (NSDictionary *)recordSetting
{
    if (!_recordSetting) {
        // 录音设置 CAF转MP3格式，细节参数（采样率、通道数目）
        _recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                          [NSNumber numberWithFloat: kAVSampleRateKey],AVSampleRateKey, //采样率
                          [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                          [NSNumber numberWithInt:kAVLinearPCMBitDepthKey],AVLinearPCMBitDepthKey,//采样位数 默认 16
                          [NSNumber numberWithInt: kAVNumberOfChannelsKey], AVNumberOfChannelsKey,//通道的数目
                          [NSNumber numberWithInt:AVAudioQualityHigh],AVEncoderAudioQualityKey,     //录音的质量
                          nil];
    }
    
    return _recordSetting;
}

#pragma mark - Private
+(EMAudioRecorderUtil *)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        audioRecorderUtil = [[self alloc] init];
    });
    
    return audioRecorderUtil;
}

-(instancetype)init{
    if (self = [super init]) {
        
    }
    
    return self;
}

-(void)dealloc{
    if (_recorder) {
        _recorder.delegate = nil;
        [_recorder stop];
        [_recorder deleteRecording];
        _recorder = nil;
    }
    recordFinish = nil;
}

-(BOOL)isRecording{
    return !!_recorder;
}

// 开始录音，文件放到aFilePath下
- (void)asyncStartRecordingWithPreparePath:(NSString *)aFilePath
                                completion:(void(^)(NSError *error))completion
{
    NSError *error = nil;
    NSString *wavFilePath = [[aFilePath stringByDeletingPathExtension]
                             stringByAppendingPathExtension:@"caf"];
    NSURL *wavUrl = [[NSURL alloc] initFileURLWithPath:wavFilePath];
    _recorder = [[AVAudioRecorder alloc] initWithURL:wavUrl
                                            settings:self.recordSetting
                                               error:&error];
    
    if(!_recorder || error)
    {
        _recorder = nil;
        if (completion) {
            error = [NSError errorWithDomain:@"Failed to initialize AVAudioRecorder"
                                        code:EMErrorInitFailure
                                    userInfo:nil];
            completion(error);
        }
        return ;
    }
    _startDate = [NSDate date];
    _recorder.meteringEnabled = YES;
    _recorder.delegate = self;
    
    [_recorder record];
    if (completion) {
        completion(error);
    }
}

// 停止录音
-(void)asyncStopRecordingWithCompletion:(void(^)(NSString *recordPath))completion{
    recordFinish = completion;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self->_recorder stop];
    });
}

// 取消录音
- (void)cancelCurrentRecording
{
    _recorder.delegate = nil;
    if (_recorder.recording) {
        [_recorder stop];
    }
    _recorder = nil;
    recordFinish = nil;
}


#pragma mark - AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder
                           successfully:(BOOL)flag
{
    NSString *recordPath = [[_recorder url] path];
    if (recordFinish) {
        if (!flag) {
            recordPath = nil;
        }
        recordFinish(recordPath);
    }
    _recorder = nil;
    recordFinish = nil;
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder
                                   error:(NSError *)error{
    NSLog(@"audioRecorderEncodeErrorDidOccur");
}
@end
